Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C5A646988
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 08:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiLHHD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 02:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiLHHD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 02:03:26 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB91C8DFC6;
        Wed,  7 Dec 2022 23:03:20 -0800 (PST)
X-UUID: 28accc112d054eecbdf32d48c50da224-20221208
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=hGNTG58ufeA7MEE8dctSgo3tCWPZgPgtNpOEnb50JOc=;
        b=eb+ZH5hfzvLwYebVXIuVYd5pSPrmBp73Kk5FJFJ0t+8enlBI2QWmwWNdDpFX2ovM+YdbURRvprWK4AA1MgMVI0P7dUh7/oM1vH/Ma7x7FSGcsQ20ysoUYIXC7H6ETqWzp4IyE0+JOCogqHZDrRGrrWOxcRVtVPAV02tmAEo02Fk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:c95d1777-4f0c-4a8f-89ad-3c380659a68e,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:dcaaed0,CLOUDID:8ee1aa24-4387-4253-a41d-4f6f2296b154,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 28accc112d054eecbdf32d48c50da224-20221208
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1481623492; Thu, 08 Dec 2022 15:03:15 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 8 Dec 2022 15:03:14 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Thu, 8 Dec 2022 15:03:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNCLwlbIjyQwtTFIWJC3YbqYRkfLEIQogK+MYKoQ3SjorabDcw04TcimyjBMyg8rPO7VjbcrjUjLe4kX9gaOFrZVS1xeZrD+R9XE+DqimrneW3oCtvYCsOWZHAxMaH4Pvd1eVnRyVBdJKL0c1IYEGRpIfCmxgUij4vio62b1LqzWb5fd3uI9t9hhm4GoABnr5QenG72PQ5Qvb1EAB2INSdKHpoN9ntSei9tNoV1R1CP9zAQQURGkxpk8vb1PqE4hPvWfnCVzyWCKeqGdv4UBYCWsyGS1bgaDuQYDRZDXoskADi610YLZhifdhPCOrVw2I6+GcILM5CBNJXdse4NomQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGNTG58ufeA7MEE8dctSgo3tCWPZgPgtNpOEnb50JOc=;
 b=PJRa9moHiAfdQUKazV+a8r3pLE+ogSe1nGkSsrZ5fY8gGwFZsPxS4CDs2Cv+L1AxyoTp/Rq3taRpFuSqvS+8vsQ8vcdYRWFzAtQehQysZ14z61vZ11oOybLhj+GIPCvrpOpA5vT7vZdd72Hqh1B/1lVwcOQSd170audIwLqpmGgdqpRB1ZjXFDjbK4xw7/Fw+BIE+af8rrKpJ9RZDQW4tqqGFi3uj1bhFvFKTnqt1/MhGTYX0SxNq6tkhf3MB9G5I9vdF+6x098tO785Qywuz0xz00Kl2JOlQyvxAdZWDEwsKU2OJJf56KnBn2XKGlrpwFAswg1AOief0oZjDXPlsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGNTG58ufeA7MEE8dctSgo3tCWPZgPgtNpOEnb50JOc=;
 b=vu0eu4p74yk4dJcJw5gRNCH3rXxkgDTvgx3o4y1DVv8nYX/eNRX076XevCHA6ER2asHWSp2NcFmErvU0BpQtjt5nIqqbb5C6ADUu2XaNXNwBzbD2Wu+UH5WVzImK5ItSuhFT+17QUubwyNeqO5L/DT4wKoJgPhwzHRiFCh+H6a0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB5490.apcprd03.prod.outlook.com (2603:1096:820:5f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 07:03:07 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 07:03:07 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
        =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v5] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Topic: [PATCH v5] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Index: AQHZCsvObcK4QVxcvEyvyZKxE987Fq5jir2AgAAF5wA=
Date:   Thu, 8 Dec 2022 07:03:07 +0000
Message-ID: <1c5f2847e7237e3e12bcdf8d2d981d5c161d35f9.camel@mediatek.com>
References: <20221208061037.24313-1-peter.wang@mediatek.com>
         <ce72f874-f403-82cf-115e-55d08532bd66@intel.com>
In-Reply-To: <ce72f874-f403-82cf-115e-55d08532bd66@intel.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB5490:EE_
x-ms-office365-filtering-correlation-id: 68bc3409-ce9f-4d5a-112c-08dad8ea4232
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m0SkB+ZB++XYiDb5TxfnASbwXg6p7YIgCL01L7SbOJtBLSzT3DfX3kBsgi41dUwv8S/vLBNbmFeRcNtlNYTjNBbeGymhYmCWu9LyyYhS0kf9YWsGthxv3i8u/zonEU3c1UWgHNf7MnRn2564XTPKglM0B/qQs9rAS4fupoyLBdG01hU5sEqR9ed0aGwG6Laelsj5VouuCfRiosCCaCbejeAlAyiFTQRU/1l/kqdnADhTI4zhGdqOz58s8GePpRZ1NUXbWbrPNNi/FwZo4nBMeB/4ztnB3jadxdbLj9Vs4XU5wOUjwmt89eUKi7gIJOa083sj3zme3qZIpZTe0ayE/anEyTFOn9SjhSzFyD+SSaob9bbosR+o2duGVYdkWcF90pHYm3QMKPXQ+27A5H0/5+L7LkXUk3FwAnDApQpnS4yB0z2cjw9WWCNlD6sh6CMzOzlG0kG4sY5mHriasQDPH3eyTV2r2LpXzPy9mamg4YeYRA1l4VvqFTB9lCZVA0s8NdweM1pbB87dDL+Fs/JiO7bay3qZ8ZXFYl3fZ94FHV6kLCBCxgYpx2tI/QMarivVSCtNO/jf6z95ONHEuVMS+w/+L4tvwujH6OG8Soz7/iN4jginfBFWp/sMq79o+rnklJ6ynAGThwzWNE4KFkQyons/F2e3ZgX6xEIoohVi6vEmEMi0xM0jf1lHmeruOPn93r6vQ+VzoJ0Mz88IEqULLE7Bu+gChir7EkzNGpF0amI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199015)(8676002)(85182001)(71200400001)(38100700002)(36756003)(478600001)(15650500001)(4326008)(122000001)(6486002)(107886003)(8936002)(316002)(2906002)(38070700005)(54906003)(76116006)(64756008)(66556008)(66446008)(66946007)(66476007)(91956017)(110136005)(2616005)(5660300002)(66899015)(83380400001)(41300700001)(53546011)(6506007)(6512007)(86362001)(186003)(26005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2xyNVozRDZHbmJOY2RUZXB1cDJzMHByZ1hjbjAxSkt6M2pEcmkxTkxWYWFS?=
 =?utf-8?B?TytFRFEvWXhLTzIyTUlNU0VRRC90M3VyUjNqbklQcmJiMlZzVkRtWnE3RVlp?=
 =?utf-8?B?WFozMnJIazhMQXJvWWtJM2U4SWxZZ1NYaXkwV2I1QjAyVU1FV2xEWmEzWGJE?=
 =?utf-8?B?OE14Um0yejdvSnRDdUtiaCtzTHNMaVRSaXVFbmFWeDJsWU5xeU9NK3AvNUpG?=
 =?utf-8?B?SUxDaHFMVTNzUE9BMW5nWU9IcW44cENHNU5qUU1BSG9uOTZXdDIwcHk0bUl4?=
 =?utf-8?B?bkYwR2FhNjlrWXRRdkJaQWIrZFlGZjZEK1Q0WWZOQzE5c1pDK2dDTGkvWitC?=
 =?utf-8?B?SGxCOS9TZGQwaCtYbXROMURVaVB0UHNoeUpvK2oySzhMMFA5YTFkdngxbkZK?=
 =?utf-8?B?Wm14dzRxcHRTejNVeU1kS2l5TzNSOXVLSkREYXlCb0VGTVNZZlpPeUlhblRK?=
 =?utf-8?B?SnpTS3F5WG56MmhmVHFtSjRaVUEzb2NFc3BjOFdMem11RHF6YVc2dFIwb3Nh?=
 =?utf-8?B?M3BXOU52dU5mSHhJazQrQ3JndndJY0ZhazIwbWFQQUNHVGl0ZURIMzI2Szgr?=
 =?utf-8?B?SlpCWEFDeXhqOXNlb0QzaXpZYzJJMktCOVJLdmFFcmQ5U1Y3SlgxRmdrK2tu?=
 =?utf-8?B?S0h1Wm5WMWF2ZWVYRnB0NEsvWkhRbHIyY2NyU0ljZjRMeFNndG5lUHJRQWgr?=
 =?utf-8?B?L2JVTjhBSE5QQ0RaRUdqa0paMWNqYnphWGpmdzdUK0VoaXNmV29BSnhCWVUw?=
 =?utf-8?B?NEI1bmc0QmxUVVNjclNRN0FUUEpNL3J6VTZ1NE9FcmFiK0ZnRHAyc0FRclIr?=
 =?utf-8?B?djVJalpta0FDdmNqME45STNFMmNqN2JmUXBzcWY2N1l0RGZQL2FQOHpuM1Bq?=
 =?utf-8?B?SFdBMldIdDJEUzVtbnBDWmNpK0ZpSVhPWXVQWXJzSERLS2IvMGEwZ2RQREZz?=
 =?utf-8?B?MkJPSXFWLytwL1hXSlBiODczWGpqdHY5d0xIUXBadERlcjZFUFNwT1Jaazkx?=
 =?utf-8?B?Q0hNTys1ZmlSa3NUeWlBaWZwOUZMRXJIcHVuWDVOQUxpS3JKb0Y5REt2T2Fr?=
 =?utf-8?B?aDNNTVk0TGpjbnlIYVVrdWpFTmdkR2VXbkRtVUc0cS91TnVGcUZFYzA3eE1M?=
 =?utf-8?B?aWRrRGJjU2thSEltQXJrcUNYTVRIb1Brak1RY0NrbVFlMnNKK2FoWGM4UXc3?=
 =?utf-8?B?YWMwYUVrcmI1eEhPeDNMM2FtNWdXRFMwa1kzSmlXTEg0b1EwQVVHWEUrSjV4?=
 =?utf-8?B?UHJQU2pPOVpQYStnbmI0dHJPc3p6czVDOGc0a3J4RHVTT1pVWlBHc080NmVG?=
 =?utf-8?B?TlA0T0haSkdvcmF4aWxjVisrVGdtVERDSVBjL01Sd1ZnUkd5KzZvVThRS29h?=
 =?utf-8?B?a1NhR1dXVkl3VndzcXhRRm1PbXhzT0s3VjBrQWVCR3FoVHgwaThOaVY1bmk1?=
 =?utf-8?B?R2tpMkhGcTMwajhwR3A1dzdWa3RUa3dPbWU1T3R3UnFYUDBMYU52bThOSURS?=
 =?utf-8?B?Z0hLRU45TGhGcDZGU0VoNXFSMWlrQXBDamtOWHBlRkhock9PQzdjWXJianpG?=
 =?utf-8?B?WTEvbzJlUXduL2c2SUsreXZYOTZuNzBrU0lKanQ4L1ZGV0dTN0RlYTNvTDdG?=
 =?utf-8?B?Sm1acjIraTlZcDRhZThxUmZJN01aK3dsNjNsczBtYTlybzc4YThjMnNoa3pM?=
 =?utf-8?B?bHpqMUh1WGNHTmxVc2dBVlpZNTlXTk5LSmRxZkl3UG1SUEpqdHlXTWZHUldx?=
 =?utf-8?B?RUo2WEpDNEY2SFhTeGZaUTJQTytjMHpidEp0VWxJZ1JTZHdkdks0T2tuZWJk?=
 =?utf-8?B?UEhKOHNRUVpvYTZWVEUraWZ1NWxUQTNQMzI1Yjc0cUthMElxVE5aMXJDMjVy?=
 =?utf-8?B?bG9vejl1NnVIamdIMmZKNTFHUm1ibzk1aVU3eG1mbW9mNWFmSGVOQnpCamcx?=
 =?utf-8?B?QUw2TnFDV2QweU1mR3FZVVdvbi9FVWRyUVZCMVBOS2ozcm1tRUdLL0JVaktO?=
 =?utf-8?B?enBSdG5Gc2prU3M3aXlGU2JNYktOcUExd3p6Zkh3ZFhjRndzZlZBWkc1M1hu?=
 =?utf-8?B?aG9XdklsYWpJUmFjSk1UU3h1ZytoaGFkcFdGdGhwVFkxenU4bUFwdWxYUENG?=
 =?utf-8?B?KzVidHBPeEFkT1VZb2lzWjdWWUpaUGFZeEEwNWVINFlHUTlLaWkxTTY3VXVO?=
 =?utf-8?B?bmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <852BF613812B40488A98A50C198534B9@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68bc3409-ce9f-4d5a-112c-08dad8ea4232
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 07:03:07.0402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atx2wx2HraN+99PG993wDrxoXJ+YUyDido2PzrMKd3v0EL/i9aAOlTsiLn5lA9ae1W28vDz2u72qhAHDB5FBow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB5490
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTA4IGF0IDA4OjQxICswMjAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBPbiA4LzEyLzIyIDA4OjEwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNvbSB3cm90ZToNCj4gPiBG
cm9tOiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gPiANCj4gPiBXaGVu
IFNTVS9lbnRlciBoaWJlcm44IGZhaWwgaW4gd2x1biBzdXNwZW5kIGZsb3csIHRyaWdnZXIgZXJy
b3INCj4gPiBoYW5kbGVyIGFuZCByZXR1cm4gYnVzeSB0byBicmVhayB0aGUgc3VzcGVuZC4NCj4g
PiBJZiBub3QsIHdsdW4gcnVudGltZSBwbSBzdGF0dXMgYmVjb21lIGVycm9yIGFuZCB0aGUgY29u
c3VtZXIgd2lsbA0KPiA+IHN0dWNrIGluIHJ1bnRpbWUgc3VzcGVuZCBzdGF0dXMuDQo+ID4gDQo+
ID4gRml4ZXM6IGIyOTRmZjNlMzQ0OSAoInNjc2k6IHVmczogY29yZTogRW5hYmxlIHBvd2VyIG1h
bmFnZW1lbnQgZm9yDQo+ID4gd2x1biIpDQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4N
Cj4gPiAtLS0NCj4gPiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDI1ICsrKysrKysrKysr
KysrKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKykNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMv
dWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBpbmRleCBiMWY1OWE1ZmU2MzIuLmM5MWQ1OGQxNDg2YSAx
MDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gKysrIGIvZHJp
dmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+IEBAIC0xMDYsNiArMTA2LDEzIEBADQo+ID4gIAkJ
ICAgICAgIDE2LCA0LCBidWYsIF9fbGVuLA0KPiA+IGZhbHNlKTsgICAgICAgICAgICAgICAgICAg
ICAgICBcDQo+ID4gIH0gd2hpbGUgKDApDQo+ID4gIA0KPiA+ICsjZGVmaW5lIHVmc2hjZF9mb3Jj
ZV9lcnJvcl9yZWNvdmVyeShoYmEpIGRvDQo+ID4geyAgICAgICAgICAgICAgICAgICAgICAgICAg
IFwNCj4gPiArCXNwaW5fbG9ja19pcnEoaGJhLT5ob3N0LQ0KPiA+ID5ob3N0X2xvY2spOyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKwloYmEtPmZvcmNlX3Jlc2V0ID0NCj4gPiB0
cnVlOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKwl1ZnNo
Y2Rfc2NoZWR1bGVfZWhfd29yayhoYmEpOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICANCj4gPiAgXA0KPiA+ICsJc3Bpbl91bmxvY2tfaXJxKGhiYS0+aG9zdC0NCj4gPiA+aG9zdF9s
b2NrKTsgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiArfSB3aGlsZSAoMCkNCj4gDQo+
IFRoYW5rcyBmb3Igc2VwYXJhdGluZyBpdCBvdXQsIGJ1dCB0aGVyZSBpcyBubyByZWFzb24gdG8g
bWFrZSB0aGlzDQo+IGEgbWFjcm8sIHNvIGl0IHNob3VsZCBiZSBhIGZ1bmN0aW9uLCBiZWNhdXNl
IGZ1bmN0aW9ucyBvZmZlciBuaWNlcg0KPiBzdHJ1Y3R1cmUgYW5kIGxlc3MgY2hhbmNlIG9mIHN1
cnByaXNlcy4gSXQgbmVlZCBub3QgYmUgYW4gaW5saW5lDQo+IGZ1bmN0aW9uIGVpdGhlciBiZWNh
dXNlIHRoZSBjb21waWxlciBjYW4gZGV0ZXJtaW5lIHRoYXQsIGFuZCB0aGlzDQo+IGlzIG5vdCBh
IGhvdCBwYXRoLiBpLmUuDQo+IA0KPiBzdGF0aWMgdm9pZCB1ZnNoY2RfZm9yY2VfZXJyb3JfcmVj
b3Zlcnkoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gew0KPiAJc3Bpbl9sb2NrX2lycShoYmEtPmhv
c3QtPmhvc3RfbG9jayk7DQo+IAloYmEtPmZvcmNlX3Jlc2V0ID0gdHJ1ZTsNCj4gCXVmc2hjZF9z
Y2hlZHVsZV9laF93b3JrKGhiYSk7DQo+IAlzcGluX3VubG9ja19pcnEoaGJhLT5ob3N0LT5ob3N0
X2xvY2spOw0KPiB9DQo+IA0KDQpIaSBBZHJpYW4sDQoNCk9rYXksIHdpbGwgY2hhbmdlIHRvIHN0
YXRpYyBmdW5jdGlvbiBuZXh0IHZlcnNpb24sIA0KVGhhbmsgeW91IHZlcnkgbXVjaC4gOikNCg0K
UGV0ZXINCg0KDQo+ID4gKw0KPiA+ICBpbnQgdWZzaGNkX2R1bXBfcmVncyhzdHJ1Y3QgdWZzX2hi
YSAqaGJhLCBzaXplX3Qgb2Zmc2V0LCBzaXplX3QNCj4gPiBsZW4sDQo+ID4gIAkJICAgICBjb25z
dCBjaGFyICpwcmVmaXgpDQo+ID4gIHsNCj4gPiBAQCAtOTA0OSw2ICs5MDU2LDE1IEBAIHN0YXRp
YyBpbnQgX191ZnNoY2Rfd2xfc3VzcGVuZChzdHJ1Y3QNCj4gPiB1ZnNfaGJhICpoYmEsIGVudW0g
dWZzX3BtX29wIHBtX29wKQ0KPiA+ICANCj4gPiAgCQlpZiAoIWhiYS0+ZGV2X2luZm8uYl9ycG1f
ZGV2X2ZsdXNoX2NhcGFibGUpIHsNCj4gPiAgCQkJcmV0ID0gdWZzaGNkX3NldF9kZXZfcHdyX21v
ZGUoaGJhLA0KPiA+IHJlcV9kZXZfcHdyX21vZGUpOw0KPiA+ICsJCQlpZiAocmV0ICYmIHBtX29w
ICE9IFVGU19TSFVURE9XTl9QTSkgew0KPiA+ICsJCQkJLyoNCj4gPiArCQkJCSAqIElmIHJldHVy
biBlcnIgaW4gc3VzcGVuZCBmbG93LCBJTw0KPiA+IHdpbGwgaGFuZy4NCj4gPiArCQkJCSAqIFRy
aWdnZXIgZXJyb3IgaGFuZGxlciBhbmQgYnJlYWsNCj4gPiBzdXNwZW5kIGZvcg0KPiA+ICsJCQkJ
ICogZXJyb3IgcmVjb3ZlcnkuDQo+ID4gKwkJCQkgKi8NCj4gPiArCQkJCXVmc2hjZF9mb3JjZV9l
cnJvcl9yZWNvdmVyeShoYmEpOw0KPiA+ICsJCQkJcmV0ID0gLUVCVVNZOw0KPiA+ICsJCQl9DQo+
ID4gIAkJCWlmIChyZXQpDQo+ID4gIAkJCQlnb3RvIGVuYWJsZV9zY2FsaW5nOw0KPiA+ICAJCX0N
Cj4gPiBAQCAtOTA2MCw2ICs5MDc2LDE1IEBAIHN0YXRpYyBpbnQgX191ZnNoY2Rfd2xfc3VzcGVu
ZChzdHJ1Y3QNCj4gPiB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wKQ0KPiA+ICAJ
ICovDQo+ID4gIAljaGVja19mb3JfYmtvcHMgPSAhdWZzaGNkX2lzX3Vmc19kZXZfZGVlcHNsZWVw
KGhiYSk7DQo+ID4gIAlyZXQgPSB1ZnNoY2RfbGlua19zdGF0ZV90cmFuc2l0aW9uKGhiYSwgcmVx
X2xpbmtfc3RhdGUsDQo+ID4gY2hlY2tfZm9yX2Jrb3BzKTsNCj4gPiArCWlmIChyZXQgJiYgcG1f
b3AgIT0gVUZTX1NIVVRET1dOX1BNKSB7DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBJZiByZXR1cm4g
ZXJyIGluIHN1c3BlbmQgZmxvdywgSU8gd2lsbCBoYW5nLg0KPiA+ICsJCSAqIFRyaWdnZXIgZXJy
b3IgaGFuZGxlciBhbmQgYnJlYWsgc3VzcGVuZCBmb3INCj4gPiArCQkgKiBlcnJvciByZWNvdmVy
eS4NCj4gPiArCQkgKi8NCj4gPiArCQl1ZnNoY2RfZm9yY2VfZXJyb3JfcmVjb3ZlcnkoaGJhKTsN
Cj4gPiArCQlyZXQgPSAtRUJVU1k7DQo+ID4gKwl9DQo+ID4gIAlpZiAocmV0KQ0KPiA+ICAJCWdv
dG8gc2V0X2Rldl9hY3RpdmU7DQo+ID4gIA0KPiANCj4gDQo=
