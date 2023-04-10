Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827446DC259
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 03:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjDJBf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Apr 2023 21:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDJBf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Apr 2023 21:35:28 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9A226B1;
        Sun,  9 Apr 2023 18:35:19 -0700 (PDT)
X-UUID: f2014a16d73f11eda9a90f0bb45854f4-20230410
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=MpR0107wz++IxNJzESTKwF7GyEMXstQC6OH2vm8udnA=;
        b=Y+I6+zLOySf2ot6sLWO2JRQOAHJaKH0DycbPd9BvufVtTcgOkv89PiW5P2p1HQFRL/8FwchXVzwlPtiFdfdToEvLHzH3BfbzX+5Q7m5LgJwJXXAAxI2Dk2k5p8PMy4HzV4OgCZym0C9/CaXnYXBOi++vjbRslCs2B8fyudchvIE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:9e6f0105-d705-4bfa-8f0a-2b6d5838bb60,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.22,REQID:9e6f0105-d705-4bfa-8f0a-2b6d5838bb60,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:120426c,CLOUDID:f2e73af8-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:230409203106PS8VH9S9,BulkQuantity:10,Recheck:0,SF:38|17|19|102,TC:ni
        l,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:
        0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: f2014a16d73f11eda9a90f0bb45854f4-20230410
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <tze-nan.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1026611867; Mon, 10 Apr 2023 09:35:16 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 10 Apr 2023 09:35:14 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Mon, 10 Apr 2023 09:35:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EslgvCDhzxcH6h44WKeGNgR+PvnIcDpDmhaMKZRMHDL+Y8fSvSMroCqtR7vz7rGcsijdzn7c0NtDwtzZg6FXoFsI5TrbVl9A3FRkuDuS8iO9LpZi35YXnvP9JW+gQEzwvEMj4V/c98BgNjo0hEytJX86DX5U2UxnG3w5zvHR0f1zIjlHvgz4SNNPblE2XYP+DIbN81TheNcQNMGUuftbSwikh/+XvJieqB8GHvLi3z57Hl3VJD4faivpSqTmenxToNqa4hH8+9p5NzF86HD9cYz8lCdFPk6Mu/Kwcuz2tWwZ+xkRkXvBT2+oIeU4T3kN4omiYcUC1KPW+bQnMfS/Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpR0107wz++IxNJzESTKwF7GyEMXstQC6OH2vm8udnA=;
 b=PW13FfSetF8yxdS41LGFfuJl8zncUEsDcxAcmpxZ8Gisiv9vLFUpIP8/EedbsCNDEeCQ9hG69O9CDEMeGhkwR+F9tXtiGNu5QXt9v5as6GGz+FCYsCJh1ZA81SxPa3sVKoCT0nOKmOeY3SRdLiSoGOooT14rdGGeiyhQZs7lQ4w0fuxCySvNaN6k0LqgKSlxVT9/T6N7kzRe5QAzwiKpcqW/pbCzB3fKHEVgjnJdLFkQQlowCYx8iVJfLK8xEGa3nhc261LGLnd2o9B4sMxnD5pa06mNnhOUdJeFO4w/1+I+zdQnaoQLZXHv64U0YQsrBHKV/7jweccshwYxMcfhIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpR0107wz++IxNJzESTKwF7GyEMXstQC6OH2vm8udnA=;
 b=jbmG5X/sDycRVFrkclMHkbXnZHOrUvFUYbxPCuucesPcnGcvIQyN/jmnAR+a2aq0Y+gRSwyBNZ1CtzPyYFqT5BMP96fezWXfaJ5xg8HHWwjd1mSClJm4oSMjRpbk/U0xRSCebHJPt15GrLvpbPsDkAX9bmQfsuvMTxBiDvA8Ems=
Received: from TYZPR03MB7183.apcprd03.prod.outlook.com (2603:1096:400:33a::11)
 by TYZPR03MB5566.apcprd03.prod.outlook.com (2603:1096:400:53::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 01:35:12 +0000
Received: from TYZPR03MB7183.apcprd03.prod.outlook.com
 ([fe80::ec58:cfe8:ee7e:e344]) by TYZPR03MB7183.apcprd03.prod.outlook.com
 ([fe80::ec58:cfe8:ee7e:e344%4]) with mapi id 15.20.6254.030; Mon, 10 Apr 2023
 01:35:12 +0000
From:   =?utf-8?B?VHplLW5hbiBXdSAo5ZCz5r6k5Y2XKQ==?= 
        <Tze-nan.Wu@mediatek.com>
To:     "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-trace-kernel@vger.kernel.org" 
        <linux-trace-kernel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?Q2hlbmctSnVpIFdhbmcgKOeOi+ato+edvyk=?= 
        <Cheng-Jui.Wang@mediatek.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        =?utf-8?B?Qm9idWxlIENoYW5nICjlvLXlvJjnvqkp?= 
        <bobule.chang@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v2] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
Thread-Topic: [PATCH v2] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
Thread-Index: AQHZao1/Mf4qpac2UUqOCphUUkR7sq8i6SSAgADbIQA=
Date:   Mon, 10 Apr 2023 01:35:11 +0000
Message-ID: <797dd294ecd62b97647ad598058f158c50808f09.camel@mediatek.com>
References: <20230408052226.25268-1-Tze-nan.Wu@mediatek.com>
         <20230409024616.31099-1-Tze-nan.Wu@mediatek.com>
         <b05d80ab-fd72-1346-f5d9-b80ae9b5cd1a@gmail.com>
In-Reply-To: <b05d80ab-fd72-1346-f5d9-b80ae9b5cd1a@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB7183:EE_|TYZPR03MB5566:EE_
x-ms-office365-filtering-correlation-id: 0b1cd824-3436-475c-52fa-08db3963d38e
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DjiFnSFRtZM98fDZ9eNzqPC6y1i2S73RcZvpzV0wUy7gRA5fsv8l8Ca3YF6e4AFdNNxM3hy1pf7zpxgyfiCTJCGSzyAfSc57Mnc+AiaVY3lvy/5/5PtSJLCWgbkuzK9yrdqo6GkhWEZou2sSeWR6Lwtnp18reUvYDWVz6Ew1kuxJPLvF045ubo30IDsjJLcI0A1+v+61nm3HeRJ+Gdgw1oZ6uUs9Qjq2IfK/YUQcNi5GicpLvkPYB1Q/KO/IEbnIAz7U2fiKxN9kY8jGTYrzr9BdFFmoCmYRjX9+BvmDRFgbFT+zrGrG96N3vZzgJldMZaXvox1Mi/b9hwW/vKzXrTfo8XLOzS3C1amneO/7/rnmKCURCaaqY/y64ioYu0bWBRIdRB0KWT8aJJc8uD3jwfbkadgliF/qfiYkNmjaCHfXlQr1d3n8Bp3xtQcuRKErvuqvnCbJN4deGeEABw1f5P3OKb/1qXMwWc7BaEBXK+Qf/m+T49PDMvRURHRCWGEVrNT+2Zup6656n1kf5gllSldkiJLTps680fLgzDqPXhkojo5SG/9oZkTjbcOHdSBsIvI9sfmNI3/z2gKviZtToMX+Xw34og4YHV+KgNJ3RPHVUpZ3XMfzlQBx+0Kcr83WF3LwtewknE5n9BP+pYVrTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB7183.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39850400004)(366004)(376002)(396003)(451199021)(86362001)(85182001)(36756003)(110136005)(316002)(41300700001)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(966005)(6486002)(54906003)(478600001)(71200400001)(5660300002)(8936002)(2906002)(38070700005)(38100700002)(122000001)(186003)(53546011)(6512007)(6506007)(26005)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejJWV2grMkg3LzJ0aDZTdVh0UkQxRVlyZU1GeHdDMmYwcGZ0d29iWDNtMWp2?=
 =?utf-8?B?SmsyOVJEVkZ4UHZ6dnhvbHQ5RzNBWlhITVM0MXlLL2FWOTNYTG5XakpBVUM3?=
 =?utf-8?B?ZTFGRGtBaVlVWjJEQlBOV3A0bTFOMlBSbm9kMmtySGx4NFQxQTc2TUtFcTFZ?=
 =?utf-8?B?VVdoVzVMWFoydWJnbG1NTVFSbmJMSnJXblJidzdBdzRRYTNzV29UaGlnQVBG?=
 =?utf-8?B?akREeDhmVVV1c2FzTmQ5ZjZOczhJUzRYeWdsaitHSlpzZHY5UGgwNkt5OS84?=
 =?utf-8?B?cmNzd0ZiYmJqNERNaWhSMVlZZG9CdEYwaUs5SnhHYklZY0UrMk16bERzR3Fw?=
 =?utf-8?B?U0lpTE80M2hUbWswdlVmamtRaU9ZR2trWFY1MUkzekl3eHVPTmxId0ltc3l5?=
 =?utf-8?B?MkpVRzFJV2JBVnVZUVZna1gwYWZEZzUycVJDb3pHamF3ckZpaitYMS9XK2Va?=
 =?utf-8?B?ZmtFVkY1QzQrQS9sM0FCeFBqQnorU0grQjJITGhlOXhHeGV0SUhCc1BheDhU?=
 =?utf-8?B?SEVkaGYremtFbnRIRU16bmlnT0dwKzliSmdOeU1FWWtkeWgyeVRzMXd3WVZW?=
 =?utf-8?B?VUNUWFVjdG02QWg2UWY5VUxocUhIZmtQQTJHNndVWjRkMytaa01ac0YySTVh?=
 =?utf-8?B?NWkvaUFIYzRYMm9FZjJsV296K0lac0dYZDRwQjFGMVBhZ1l6V0NhRTU3MS9p?=
 =?utf-8?B?aHZleHBVNkVkLzNiRXFYYlpOdUZCdmNBTkFZUFVBSGdWdXJ5aVpWNmRtQ0Nx?=
 =?utf-8?B?VWs4Qnozb2dCMGlIdEkvTDV2bVVJelp0a3dIMGx5cmF3NG0wYk9wQkRrY1B1?=
 =?utf-8?B?Q2puV1ZVNDlObG40dW1wdmlWNWtYUUJ4M0cxWHFWby9NYXZ4ZmF3dVBwOGJ2?=
 =?utf-8?B?NkhKVVNDS1BWMmFxamc0ZXQ4NW1NWVRKVTNJR2pVUkllSWxNTE1FN005WWJG?=
 =?utf-8?B?ZlpRb2ptM0xtRjZMNUpuOG5uWmRaWDVFSkVTeUhhZFg0c2RwZW4rbGtkUzNM?=
 =?utf-8?B?YXZQVG15ek54em9OUVg5eWJiK0lPOXg2WW5QV0FFVG1IWHdZWVFoUExtdVVD?=
 =?utf-8?B?K0dKaGpUeUF0L0hybEhpbUc0d1dhTWdCaEJDZlh2eVpUbk5JdENtVVlUWm5I?=
 =?utf-8?B?Mm9RbU12REM2YjQ5Q3dWWVVvcFp1b0t2WFZtMW50WU9TYkI2OWdwVXhZSVY1?=
 =?utf-8?B?ZlJlVmp0dTZwYjAvZ0p4bWF4bEx2akhGS1lHcTU5V0ErbkFDTTdnVWxXcTlj?=
 =?utf-8?B?bUlreHZSS1Y4M3BsRmVIcXIxbEdRcmV6ZnFMZUpqeE1SenpVc2JBN201S2M2?=
 =?utf-8?B?TmdzN2wyUmdFRk5lcWxKWlRqOUxsR0x2OGNNR205T2t3eFhreW5ydTdHT255?=
 =?utf-8?B?WnhoMzJPMTA4UEs0bkFSVlpoYTdzd0FVV0dCcGZWMUdvUDRVTVJTdGgvbllz?=
 =?utf-8?B?dG9vOW45bS9IVWt5SHZLdjVieS9DK1RpWGwxcmVDbzA5WGZKQzhLTTBtZHBj?=
 =?utf-8?B?V0JKMjhORnA4WnQ1NzJ3QkVqMjJIM0FBalg4S2J4OFZjNWJYdVlPeUNDSDZ0?=
 =?utf-8?B?VjZMTmtQZWR5b3NBeWRKQ3U0bTQyZnhkU0kxK2ZHRDUvMzc2eTZhQ085U05z?=
 =?utf-8?B?eUdENkwzdFNoQXhvTlhmcWdOQXhNWjFmaks4bmsxTlRZNFRhcU9VMDZEdDJi?=
 =?utf-8?B?MUpSdCtGeGJ2bW4ybHFDZDFyQWovYlk5emE2T25YUHpSaXMyTTVnT01UKzhI?=
 =?utf-8?B?S1Q0bFhadm5LcE43aVl4QkNXRFZSWStrV3V2OWVnalFXNVVVUlRzWnZzcmQx?=
 =?utf-8?B?Y0lBOEpFOW9tQmtuT3oyS3E5SWxjZkdwc1MrRU11OFFMaThONVJTT1EvdTdQ?=
 =?utf-8?B?TWFuUFBYZFREcW9GSHljUVJRTjluY0hrV3RQMzJQWnpqT1dGcy9CcDVtVTcw?=
 =?utf-8?B?YUxEMGNNYWVOQUVlL1dMOHQ5V0JkRXUyNFUrV0ZzdjhWTEZZMDdsN1N3eWY4?=
 =?utf-8?B?RVdGeUNleDJVQWxrZ0duS3l2elRuMzNUUEgvWWJ6eXJvaVp4RUF4OUNJWTkr?=
 =?utf-8?B?VVBpbE1uSHFkYkRQZEd4dUJNZWlrQ2lOeW9mL2dGRUM1MDhtN0x3aEZMZEZE?=
 =?utf-8?B?SEtiTy9qWnBwcnd4RGdweHkvQ29kWVJuNGhURHhyeEc5RnlWaVJzdCtIT3FW?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F04F6568E0F8DF43819092A5B553E8C8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB7183.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b1cd824-3436-475c-52fa-08db3963d38e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 01:35:11.6684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mx8FP9itberYL4pomGTQjDO89+62ZMwHK5poI0JpvpDPHR5xMa1qAoTdNr8JrCNx6ia+Nstghqt61s9bkZxfng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB5566
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQmFnYXMsDQoNCk9uIFN1biwgMjAyMy0wNC0wOSBhdCAxOTozMCArMDcwMCwgQmFnYXMgU2Fu
amF5YSB3cm90ZToNCj4gDQo+IE9uIDQvOS8yMyAwOTo0NiwgVHplLW5hbiBXdSB3cm90ZToNCj4g
PiBUaGlzIGlzc3VlIGNhbiBiZSByZXByb2R1Y2VkIGJ5ICJlY2hvIDAgPiB0cmFjZSIgYW5kIGhv
dHBsdWcgY3B1IGF0DQo+ID4gdGhlDQo+ID4gc2FtZSB0aW1lLiBBZnRlciByZXByb2R1Y2luZyBz
dWNjZXNzLCB3ZSBjYW4gZmluZCBvdXQNCj4gPiBidWZmZXJfc2l6ZV9rYg0KPiA+IHdpbGwgbm90
IGJlIGZ1bmN0aW9uYWwgYW55bW9yZS4NCj4gPiANCj4gDQo+IERvIHlvdSBtZWFuIGRpc2FibGlu
ZyB0cmFjaW5nIHdoaWxlIGhvdHBsdWdnaW5nIENQVT8gT3IgZGlzYWJsaW5nDQo+IGJvdGgNCj4g
dHJhY2luZyBhbmQgaG90cGx1ZyBDUFU/DQo+IA0KICBJIG1lYW4gZGlzYWJsaW5nIHRyYWNpbmcg
d2hpbGUgaG90cGx1Z2dpbmcgQ1BVLCBzb3JyeSBmb3IgdGhlDQpjb25mdXNpb24gaGVyZS4NCg0K
PiA+IFRoaXMgcGF0Y2ggdXNlcyBjcHVzX3JlYWRfbG9jaygpIHRvIHByZXZlbnQgY3B1X29ubGlu
ZV9tYXNrIGJlaW5nDQo+ID4gY2hhbmdlZA0KPiA+IGJldHdlZW4gdHdvIGRpZmZlcmVudCAiZm9y
X2VhY2hfb25saW5lX2J1ZmZlcl9jcHUiLg0KPiA+IA0KPiANCj4gIlVzZSBjcHVfcmVhZF9sb2Nr
KCkgdG8gcHJldmVudCAuLi4iDQo+IA0KICBUaGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uIA0KDQo+
ID4gQ2hhbmdlcyBpbiB2MjoNCj4gPiAgIFVzZSBjcHVzX3JlYWRfbG9jaygpIGluc3RlYWQgb2Yg
Y29weWluZyBjcHVfb25saW5lX21hc2sgYXQgdGhlDQo+ID4gZW50cnkgb2YNCj4gPiAgIGZ1bmN0
aW9uDQo+ID4gDQo+IA0KICBTaW5jZSBJIGNoYW5nZSB0byBmaXggdGhlIGlzc3VlIGJ5IHVzaW5n
IGNwdXNfcmVhZF9sb2NrKCksIHdlIGRvbid0DQpuZWVkIGEgY29weSBvZiBjcHVfb25saW5lX21h
c2sgYW55bW9yZSwgaGVuY2UgdGhlIHR3byB3YXJuaW5ncyB3aWxsIG5vdA0KbWVldCBpbiB0aGUg
djIgcGF0Y2guDQoNCj4gVG8gcmVzb2x2ZSBrZXJuZWwgdGVzdCByb2JvdCB3YXJuaW5ncyAoWzFd
IGFuZCBbMl0pPyBPciBoYXZlIHRoZXkNCj4gYmVlbiBmaXhlZD8NCj4gDQo+IFsxXTogDQo+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL3N0YWJsZS8yMDIzMDQwODE2MTUuZWlhcXBiVjgtbGtwQGlu
dGVsLmNvbS8NCj4gWzJdOiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvc3RhYmxlLzIwMjMw
NDA4MjA1MS5EcDUwdXBmUy1sa3BAaW50ZWwuY29tLw0KPiANCj4gVGhhbmtzLg0KPiANCj4gLS0N
Cj4gQW4gb2xkIG1hbiBkb2xsLi4uIGp1c3Qgd2hhdCBJIGFsd2F5cyB3YW50ZWQhIC0gQ2xhcmEN
Cj4gDQo=
