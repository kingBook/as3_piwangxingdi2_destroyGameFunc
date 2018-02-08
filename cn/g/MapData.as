package g {
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-13 9:07
	 */
	public class MapData {
		
		public function MapData() {
			
		}
		
		
		public static function getMapConfigObj(gameLevel:int):* {
			var arr:Array=[];
			
			arr[1]={size:{ width:1500, height:600 }, wall: { name: "Wall_mc", frame: 1 }, hit: { name: "Hit_mc", frame: 1}, items: { name: "_Items01", frame: 1}, bg: { name: "Bg_mc", frame: 1}, bgMid: {name: "BgMid_mc", frame: 1}, bgEff: { name:"BgEff_mc", frame:1}, wallEff: { name: "WallEff_mc", frame:1}, wallMask: { name:"WallMask_mc", frame:1}};
			arr[2]={size:{ width:2000, height:600 }, wall: { name: "Wall_mc", frame: 2 }, hit: { name: "Hit_mc", frame: 2}, items: { name: "_Items02", frame: 1}, bg: { name: "Bg_mc", frame: 2}, bgMid: {name: "BgMid_mc", frame: 2}, bgEff: { name:"BgEff_mc", frame:2}, wallEff: { name: "WallEff_mc", frame:2}, wallMask: { name:"WallMask_mc", frame:2}};
			arr[3]={size:{ width:2000, height:600 }, wall: { name: "Wall_mc", frame: 3 }, hit: { name: "Hit_mc", frame: 3}, items: { name: "_Items03", frame: 1}, bg: { name: "Bg_mc", frame: 3}, bgMid: {name: "BgMid_mc", frame: 3}, bgEff: { name:"BgEff_mc", frame:3}, wallEff: { name: "WallEff_mc", frame:3}, wallMask: { name:"WallMask_mc", frame:3}};
			arr[4]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 4 }, hit: { name: "Hit_mc", frame: 4}, items: { name: "_Items04", frame: 1}, bg: { name: "Bg_mc", frame: 4}, bgMid: {name: "BgMid_mc", frame: 4}, bgEff: { name:"BgEff_mc", frame:4}, wallEff: { name: "WallEff_mc", frame:4}, wallMask: { name:"WallMask_mc", frame:4}};
			arr[5]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 5 }, hit: { name: "Hit_mc", frame: 5}, items: { name: "_Items05", frame: 1}, bg: { name: "Bg_mc", frame: 5}, bgMid: {name: "BgMid_mc", frame: 5}, bgEff: { name:"BgEff_mc", frame:5}, wallEff: { name: "WallEff_mc", frame:5}, wallMask: { name:"WallMask_mc", frame:5}};
			
			arr[6]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 6 }, hit: { name: "Hit_mc", frame: 6}, items: { name: "_Items06", frame: 1}, bg: { name: "Bg_mc", frame: 6}, bgMid: {name: "BgMid_mc", frame: 6}, bgEff: { name:"BgEff_mc", frame:6}, wallEff: { name: "WallEff_mc", frame:6}, wallMask: { name:"WallMask_mc", frame:6}};
			arr[7]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 7 }, hit: { name: "Hit_mc", frame: 7}, items: { name: "_Items07", frame: 1}, bg: { name: "Bg_mc", frame: 7}, bgMid: {name: "BgMid_mc", frame: 7}, bgEff: { name:"BgEff_mc", frame:7}, wallEff: { name: "WallEff_mc", frame:7}, wallMask: { name:"WallMask_mc", frame:7}};
			arr[8]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 8 }, hit: { name: "Hit_mc", frame: 8}, items: { name: "_Items08", frame: 1}, bg: { name: "Bg_mc", frame: 8}, bgMid: {name: "BgMid_mc", frame: 8}, bgEff: { name:"BgEff_mc", frame:8}, wallEff: { name: "WallEff_mc", frame:8}, wallMask: { name:"WallMask_mc", frame:8}};
			arr[9]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 9 }, hit: { name: "Hit_mc", frame: 9}, items: { name: "_Items09", frame: 1}, bg: { name: "Bg_mc", frame: 9}, bgMid: {name: "BgMid_mc", frame: 9}, bgEff: { name:"BgEff_mc", frame:9}, wallEff: { name: "WallEff_mc", frame:9}, wallMask: { name:"WallMask_mc", frame:9}};
			arr[10]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 10 }, hit: { name: "Hit_mc", frame: 10}, items: { name: "_Items10", frame: 1}, bg: { name: "Bg_mc", frame: 10}, bgMid: {name: "BgMid_mc", frame: 10}, bgEff: { name:"BgEff_mc", frame:10}, wallEff: { name: "WallEff_mc", frame:10}, wallMask: { name:"WallMask_mc", frame:10}};
			
			arr[11]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 11 }, hit: { name: "Hit_mc", frame: 11}, items: { name: "_Items11", frame: 1}, bg: { name: "Bg_mc", frame: 11}, bgMid: {name: "BgMid_mc", frame: 11}, bgEff: { name:"BgEff_mc", frame:11}, wallEff: { name: "WallEff_mc", frame:11}, wallMask: { name:"WallMask_mc", frame:11}};
			arr[12]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 12 }, hit: { name: "Hit_mc", frame: 12}, items: { name: "_Items12", frame: 1}, bg: { name: "Bg_mc", frame: 12}, bgMid: {name: "BgMid_mc", frame: 12}, bgEff: { name:"BgEff_mc", frame:12}, wallEff: { name: "WallEff_mc", frame:12}, wallMask: { name:"WallMask_mc", frame:12}};
			arr[13]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 13 }, hit: { name: "Hit_mc", frame: 13}, items: { name: "_Items13", frame: 1}, bg: { name: "Bg_mc", frame: 13}, bgMid: {name: "BgMid_mc", frame: 13}, bgEff: { name:"BgEff_mc", frame:13}, wallEff: { name: "WallEff_mc", frame:13}, wallMask: { name:"WallMask_mc", frame:13}};
			arr[14]={size:{ width:2200, height:600 }, wall: { name: "Wall_mc", frame: 14 }, hit: { name: "Hit_mc", frame: 14}, items: { name: "_Items14", frame: 1}, bg: { name: "Bg_mc", frame: 14}, bgMid: {name: "BgMid_mc", frame: 14}, bgEff: { name:"BgEff_mc", frame:14}, wallEff: { name: "WallEff_mc", frame:14}, wallMask: { name:"WallMask_mc", frame:14}};
			arr[15]={size:{ width:1000, height:600 }, wall: { name: "Wall_mc", frame: 15 }, hit: { name: "Hit_mc", frame: 15}, items: { name: "_Items15", frame: 1}, bg: { name: "Bg_mc", frame: 15}, bgMid: {name: "BgMid_mc", frame: 15}, bgEff: { name:"BgEff_mc", frame:15}, wallEff: { name: "WallEff_mc", frame:15}, wallMask: { name:"WallMask_mc", frame:15}};
			
			arr[16]={size:{ width:1000, height:600 }, wall: { name: "Wall_mc", frame: 16 }, hit: { name: "Hit_mc", frame: 16}, items: { name: "_Items16", frame: 1}, bg: { name: "Bg_mc", frame: 16}, bgMid: {name: "BgMid_mc", frame: 16}, bgEff: { name:"BgEff_mc", frame:16}, wallEff: { name: "WallEff_mc", frame:16}, wallMask: { name:"WallMask_mc", frame:16}};
			arr[17]={size:{ width:1000, height:600 }, wall: { name: "Wall_mc", frame: 17 }, hit: { name: "Hit_mc", frame: 17}, items: { name: "_Items17", frame: 1}, bg: { name: "Bg_mc", frame: 17}, bgMid: {name: "BgMid_mc", frame: 17}, bgEff: { name:"BgEff_mc", frame:17}, wallEff: { name: "WallEff_mc", frame:17}, wallMask: { name:"WallMask_mc", frame:17}};
			arr[18]={size:{ width:1000, height:600 }, wall: { name: "Wall_mc", frame: 18 }, hit: { name: "Hit_mc", frame: 18}, items: { name: "_Items18", frame: 1}, bg: { name: "Bg_mc", frame: 18}, bgMid: {name: "BgMid_mc", frame: 18}, bgEff: { name:"BgEff_mc", frame:18}, wallEff: { name: "WallEff_mc", frame:18}, wallMask: { name:"WallMask_mc", frame:18}};
			arr[19]={size:{ width:1000, height:600 }, wall: { name: "Wall_mc", frame: 19 }, hit: { name: "Hit_mc", frame: 19}, items: { name: "_Items19", frame: 1}, bg: { name: "Bg_mc", frame: 19}, bgMid: {name: "BgMid_mc", frame: 19}, bgEff: { name:"BgEff_mc", frame:19}, wallEff: { name: "WallEff_mc", frame:19}, wallMask: { name:"WallMask_mc", frame:19}};
			arr[20]={size:{ width:1000, height:600 }, wall: { name: "Wall_mc", frame: 20 }, hit: { name: "Hit_mc", frame: 20}, items: { name: "_Items20", frame: 1}, bg: { name: "Bg_mc", frame: 20}, bgMid: {name: "BgMid_mc", frame: 20}, bgEff: { name:"BgEff_mc", frame:20}, wallEff: { name: "WallEff_mc", frame:20}, wallMask: { name:"WallMask_mc", frame:20}};

				
			
			return arr[gameLevel];
		}
		
	}

}