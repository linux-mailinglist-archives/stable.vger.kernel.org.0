Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB7F362CD9
	for <lists+stable@lfdr.de>; Sat, 17 Apr 2021 04:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbhDQC2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 22:28:22 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:45480 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231997AbhDQC2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 22:28:22 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8D9A6C0085;
        Sat, 17 Apr 2021 02:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618626476; bh=r+34E2mJ9zJT+EY4ffHlt8zhggatuE/Hj/qfhVfr2W8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=k58Lt0aniUk1sXruBHQQlJZp2LabKymfU1bjO2QHpiCz/+PlurEA6SBjvvX5Ser0y
         fCQl/ujrbqnGHcXSi+ttibAXBbuYoZQait5cSbqYLSaEZ74sA+C4LCB3r6qr20elPx
         e1USqIiKeA0hLy06pQhxJW/wE+1ShX3aQdPteewLngo8ph2UI0z5FCcNx1OhXBCI3h
         jFGDSw1nIE8dseooIY2Z2lmAqmx5mEv45w/uec0a9U4DQvMbW6w/aWiZkNw9lq/NjV
         L4gTbiLGFpw3w9SxOPAfhUvf48wqD+H5zvDeGyRwggMwvb6snxukvoqr2mzp4Wi1hp
         WIVX6IsQ8sVKg==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 74ADAA00A8;
        Sat, 17 Apr 2021 02:27:54 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 32709400CB;
        Sat, 17 Apr 2021 02:27:53 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="vjRh3O2R";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QirkMUyJzB1tklzcs69KIVmSIrASCz07RlOck09WEkzRAghZ99GpJPHPyS2fiW6LxOaLbPA8Bxagoqbw6iUjFBsvCuiZWAFSch5Bnd5q/oBpmixN0u78yN+MIftIAaaA0vDSkfLo5oPfSh4lh1OW5uaC95nVSG7LyIHe4bXnjTaEOx1KBX9gtr/3jebdLvgRQimO4GX3kro72Bs3dpNee3r26kDp3AVU5mffEe2tyLV6PgMnF/j2/A6N8vehnVNB1tPtj0jqRhZ4mqm6w6GetDE0nqls2wdTFRCca0zJ0UTLvlQStOcfy8wd2OtC1CQ56B7LfjSBHw1ecEeH95mfIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+34E2mJ9zJT+EY4ffHlt8zhggatuE/Hj/qfhVfr2W8=;
 b=AKHJB4nC4T5QSDlrVdEsWf3NDRy9zVfZlqc0myNLIjFOVoDbmZuzNzek+wxrPW9RID2KRTDbeK5Dw4QYaee1ptHNpg5j4i+dNLFzl3b6tTEaCMXjz0peOQjqKVEmeZlXXzeusXLMXBaH9Ic7jeXIG3hP0cP+/s+OScjNbatO7SQ0Zq2ZVtj1HCfZzpOzEnjbMHIPed+ye1LCP7IvIClWUz5FwBCmenqsvbuGJam1lDw/j7v2BPVkLDHnILNnOyy9kTjXvuom7VqeoL/CjaLxNwAiDWWzXqFvoE+TgCYSqhohL6TL/3AveO3RTniPcitUR2tyZ16Hr4FoYS8AihDrDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+34E2mJ9zJT+EY4ffHlt8zhggatuE/Hj/qfhVfr2W8=;
 b=vjRh3O2Rj1HB6LdJ+7gg868chKwD0Ey5NkhjDIWoSrkdM7WQC/xBhExTgzM0aJFTPSylVs8SNuHtnewX1N1SHhkAC4B4eCk1Mh9fDVGCswhZytexedibt9zRZlSe6niajkxBk19U421wcPKe40ES/8qOp76AQBv2xIfv5MoI0t0=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BYAPR12MB2904.namprd12.prod.outlook.com (2603:10b6:a03:137::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Sat, 17 Apr
 2021 02:27:50 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.020; Sat, 17 Apr 2021
 02:27:50 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Ferry Toth <fntoth@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        John Stultz <john.stultz@linaro.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Yu Chen <chenyu56@huawei.com>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
Thread-Topic: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
Thread-Index: AQHXMkWV7LsE5m94VkyJIYRuvRhHs6q2J2QAgAF/xoCAAFbPgA==
Date:   Sat, 17 Apr 2021 02:27:50 +0000
Message-ID: <1c1d8e4a-c495-4d51-b125-c3909a3bdb44@synopsys.com>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <d053b843-2308-6b42-e7ff-3dc6e33e5c7d@synopsys.com>
 <0882cfae-4708-a67a-f112-c1eb0c7e6f51@gmail.com>
In-Reply-To: <0882cfae-4708-a67a-f112-c1eb0c7e6f51@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac8f4921-b8e0-40ea-a18f-08d9014865aa
x-ms-traffictypediagnostic: BYAPR12MB2904:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB29048E6C239460B1DA3DCF3DAA4B9@BYAPR12MB2904.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I0dUgorM1M6AbhZ/6f4dAG45YyDsEbuijBaCuDKNyOJjWEQkK/2rfwpKkPvdmcemculhSkHshicOC07riR9+/oyu25CXPxggL2SJ4WskxqB62eAfWrjvG+6Q3K7KqBT1zyaSo6EQHuWBX3VTNKe6cU9sGUl+ljx2XMVfKAPctDXIXOg2bs7t98Su6ZPchZwj7gZzSNTY2lOaA1y6U5QN+HOg/5LIyKeyto8iJbRHZj42+Ccm+rRC6fENOo1Swlqbk/AKG2HY8uSzQnUzuhifmgsFU2E7g4uZ4njpH+70l0MmipZLbW5NYdGy/G0k71qrBugiKbXoZAr6aXFsF9LZRZvsLPXpDTBH5VMyJZ7AGvfj6SUiBrJBmGCnkZ566OuCdoIxygMYT+HhIk1jN7qfu7PdOoZC6CuxKXomLFgxU3668UsiCYjRa9cZAu0sH97v6oc3WzGfenuzYJJcpettiWPhne4ArvMHc89BSz+eljMm4/7DNjBEUSV7tgAUxoCtn9nrDCtK6xIfqVpUIPoxYEmEBpUJZnBywgDAsDRZGCiSIHhS7Y2C/qeyyoQKoIDBlrdoCNtyaH1i7L8TU9VMuIO9sQTsCPiiEfvhMcURxLnYCjne51cBg2IHERF9aQwbPcuPEHU81pSaKmXafBsPa7g6EPHNCwWrn2pkQt0KgzAYoEKRjTHY+b9GWguHmJsgZ94ovb22q/B/6nxMsSI1X0W894PGWRZGOPTls1S102SBuZcp2mHTnsc+0138ebAEKxSs2323ekBXlbNLM+UMgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(39860400002)(136003)(2616005)(5660300002)(76116006)(966005)(26005)(64756008)(66946007)(38100700002)(31686004)(31696002)(2906002)(66476007)(4326008)(478600001)(110136005)(6506007)(66446008)(71200400001)(122000001)(6486002)(83380400001)(6512007)(316002)(8936002)(66556008)(86362001)(54906003)(36756003)(186003)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?anRubGRtNnU4aWcyVzBsd2ZiK0JSbTBjMEVLai8ydzA0TENsSzFCdm1Tcnp6?=
 =?utf-8?B?U214Q0ttS1liUlh6eXFSR3hqY0NmQVNzc0QyWDNselFYK0lOWjdzNU5qRDNY?=
 =?utf-8?B?K3NEREYwbnZpbVhtTUtjaG9RZGlQVFpHNHZTbmptYlZNQVhzSWltT0c5UjF0?=
 =?utf-8?B?L1NaT3JXSTVUWU5QV2xrbTVFblIxZzRzc3lSdEdhM0pGL1dQanVBTjd3STFw?=
 =?utf-8?B?YndTb1JoUGdrRG41NmsxK21zQ0xuV0h4ZStyY0dFSC9GUmM2SWhqNG1ueEJx?=
 =?utf-8?B?WEE5VW5VMTdYeHJMbUF5QmdwTm9PeWt1S2lqVmtHNC9GdWU5ak9OdWY1OTlX?=
 =?utf-8?B?SG42S2c1MzdVcWdqQ1N4MlB4aG51cnA2NTJVOFBxbncyNUllcWdFZlpQSDUx?=
 =?utf-8?B?OWw3ZGR6eUJMbXJ3YW1iNUJDNzJpRDZVaURnL0FuZE9zZ3UzRnlPYll5aG9I?=
 =?utf-8?B?WUgrdkduRGJDYXNPcVBRMDFRckhHOG1GdFJNRzduZk1udnBIVXlZbHE3YjVI?=
 =?utf-8?B?dU16UjlPdU1tdFB0STVERkxUdGxibTk4UU1xR1FzSXVXdTBTVG5RY092djhw?=
 =?utf-8?B?cFMvRjRuaE1YT0VMYkZQL2NjS1RzbEc2MDRwUHk4bi9lM1VNeEFDY2xkV095?=
 =?utf-8?B?WmU4UUlQMDArZ0crS1BvZ1FtaXBLeGtlV0wrcGtuOFljYkdhMGpMZ2dCNWZr?=
 =?utf-8?B?QWlaYjRVTVRQR0VuUTZrNWsrOEwrWGdvK1dBc0NNTzVoeFgwOVR4QSsvclNR?=
 =?utf-8?B?M2NYMGZ2aVVleHQxUTZqcUdnUFdRYnlzaTdYQjlBcHpGSm1RSFhvbjZCK0Z1?=
 =?utf-8?B?S1FUV3RYM0d2T2NCL2ZUc3NWNzBqbjJPRmdRbWJadmF5TGlaQU9PVFZBUDZ5?=
 =?utf-8?B?c3BwK2ZLRklzeC81cWp0amxPVlcwWnRNMnVMZzcwaDFzQlIzLzB5QTZtVzQ2?=
 =?utf-8?B?ZW92b3VkOUJKeGJBalZCcXZGdEZkSXZBSVZaUVJoaW5SNkF6eW9uYWV6ZjQ2?=
 =?utf-8?B?OE15Y0dhY0ZOTHNndHZLYnJlcm9QVzc2Umx3aytnSkx5SVN3azRUaVdLditS?=
 =?utf-8?B?ZXgxTHlRVnNocXlFcnJ5bGtUWjkzL1crYTE1YWJpZGlCQUV1NkR0dURvYk1u?=
 =?utf-8?B?dk9WeTk5YUZaRFlZZk5vL3JLYjMzT0RSdGZVOXVrOGRmYVpiV3hjRm9uNmEr?=
 =?utf-8?B?K3BKamdRTWlzNHFHK0VPVUpSbUp6SytUdUg2MkdhUm9pVkdoelNMODUrTDlr?=
 =?utf-8?B?OGFYUFJ5YmF5dTFVSkJxQUxERVo4Snk5UTlkV0h6Q2ExOEJiSkpoMHFSM0d1?=
 =?utf-8?B?Q01IZkVFcXc5VHlDZ09JMHZKL0xTZlh5NS9hZnRMNG9uZm9iTWFSVTdKcUZR?=
 =?utf-8?B?cG5UckdFTThwUkN3SlVLSitXcjU2bjk2VFZxZVduNUNyZ0lBYjdPZTBkZ0ha?=
 =?utf-8?B?VURIcElZeE82TTdsYTloTnJ2TGo4Y1RjblNiY0cvMzQ3NGFRZG1NakFzV0ZX?=
 =?utf-8?B?bE9xaG1xalVMQWN1WGQzUzVSUW5TNERMd01BY3VpUGE1czlJU0NibnRHd1ZZ?=
 =?utf-8?B?eUJxTlIzQVhQNDgwbC9zYW1BVEhrUG5vTFNUanZXN2t0bFlxbkMvcTVKRWpn?=
 =?utf-8?B?VkpVQmQ5eVhDM1lIai8ybDJINGM4c21SMkxmL2Q0ODFpQkJDTHdFQnVVbUEz?=
 =?utf-8?B?NUt5Nkk0RGZXbytpMHBYVlpCK0s5SFp2WWRCQmJ5bjNjbzVMZ01aZ0J3YWRy?=
 =?utf-8?Q?BBRHTlLHvprW7/JoH+FLC3+Lps9r17hEiRPZDoT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <194889D09B55F24094E3FC7AB6D4A3D3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8f4921-b8e0-40ea-a18f-08d9014865aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2021 02:27:50.3090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QRdDHUbjxYPXyW3dZiaYc9UguJjbEGaCloTrPLUBdX/gTZW+y0/nNtYFpF9Qzm2vUCKSZnsE+/dC9M4CYZ7T+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2904
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RmVycnkgVG90aCB3cm90ZToNCj4gSGkNCj4gDQo+IE9wIDE2LTA0LTIwMjEgb20gMDA6MjMgc2No
cmVlZiBUaGluaCBOZ3V5ZW46DQo+PiBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+Pj4gRnJvbTogWXUg
Q2hlbiA8Y2hlbnl1NTZAaHVhd2VpLmNvbT4NCj4+PiBGcm9tOiBKb2huIFN0dWx0eiA8am9obi5z
dHVsdHpAbGluYXJvLm9yZz4NCj4+Pg0KPj4+IEFjY29yZGluZyB0byB0aGUgcHJvZ3JhbW1pbmcg
Z3VpZGUsIHRvIHN3aXRjaCBtb2RlIGZvciBEUkQgY29udHJvbGxlciwNCj4+PiB0aGUgZHJpdmVy
IG5lZWRzIHRvIGRvIHRoZSBmb2xsb3dpbmcuDQo+Pj4NCj4+PiBUbyBzd2l0Y2ggZnJvbSBkZXZp
Y2UgdG8gaG9zdDoNCj4+PiAxLiBSZXNldCBjb250cm9sbGVyIHdpdGggR0NUTC5Db3JlU29mdFJl
c2V0DQo+Pj4gMi4gU2V0IEdDVEwuUHJ0Q2FwRGlyKGhvc3QgbW9kZSkNCj4+PiAzLiBSZXNldCB0
aGUgaG9zdCB3aXRoIFVTQkNNRC5IQ1JFU0VUDQo+Pj4gNC4gVGhlbiBmb2xsb3cgdXAgd2l0aCB0
aGUgaW5pdGlhbGl6aW5nIGhvc3QgcmVnaXN0ZXJzIHNlcXVlbmNlDQo+Pj4NCj4+PiBUbyBzd2l0
Y2ggZnJvbSBob3N0IHRvIGRldmljZToNCj4+PiAxLiBSZXNldCBjb250cm9sbGVyIHdpdGggR0NU
TC5Db3JlU29mdFJlc2V0DQo+Pj4gMi4gU2V0IEdDVEwuUHJ0Q2FwRGlyKGRldmljZSBtb2RlKQ0K
Pj4+IDMuIFJlc2V0IHRoZSBkZXZpY2Ugd2l0aCBEQ1RMLkNTZnRSc3QNCj4+PiA0LiBUaGVuIGZv
bGxvdyB1cCB3aXRoIHRoZSBpbml0aWFsaXppbmcgcmVnaXN0ZXJzIHNlcXVlbmNlDQo+Pj4NCj4+
PiBDdXJyZW50bHkgd2UncmUgbWlzc2luZyBzdGVwIDEpIHRvIGRvIEdDVEwuQ29yZVNvZnRSZXNl
dCBhbmQgc3RlcCAzKSBvZg0KPj4+IHN3aXRjaGluZyBmcm9tIGhvc3QgdG8gZGV2aWNlLiBKb2hu
IFN0dWx0IHJlcG9ydGVkIGEgbG9ja3VwIGlzc3VlIHNlZW4NCj4+PiB3aXRoIEhpS2V5OTYwIHBs
YXRmb3JtIHdpdGhvdXQgdGhlc2Ugc3RlcHNbMV0uIFNpbWlsYXIgaXNzdWUgaXMgb2JzZXJ2ZWQN
Cj4+PiB3aXRoIEZlcnJ5J3MgdGVzdGluZyBwbGF0Zm9ybVsyXS4NCj4+Pg0KPj4+IFNvLCBhcHBs
eSB0aGUgcmVxdWlyZWQgc3RlcHMgYWxvbmcgd2l0aCBzb21lIGZpeGVzIHRvIFl1IENoZW4ncyBh
bmQgSm9obg0KPj4+IFN0dWx0eidzIHZlcnNpb24uIFRoZSBtYWluIGZpeGVzIHRvIHRoZWlyIHZl
cnNpb25zIGFyZSB0aGUgbWlzc2luZyB3YWl0DQo+Pj4gZm9yIGNsb2NrcyBzeW5jaHJvbml6YXRp
b24gYmVmb3JlIGNsZWFyaW5nIEdDVEwuQ29yZVNvZnRSZXNldCBhbmQgb25seQ0KPj4+IGFwcGx5
IERDVEwuQ1NmdFJzdCB3aGVuIHN3aXRjaGluZyBmcm9tIGhvc3QgdG8gZGV2aWNlLg0KPj4+DQo+
Pj4gWzFdDQo+Pj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xpbnV4LXVzYi8yMDIxMDEwODAxNTExNS4yNzkyMC0xLWpvaG4uc3R1bHR6QGxpbmFy
by5vcmcvX187ISFBNEYyUjlHX3BnIVBXOUpiczR3djRhX3pLR2daSE4wRllySXBmZWNQWDBPdXE5
VjNkMTZZei05LUdTSHFaV3NmQkFGLVdrZXFMaHpONGkzJA0KPj4+DQo+Pj4gWzJdDQo+Pj4gaHR0
cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXVz
Yi8wYmE3YTZiYS1lNmE3LTljZDQtMDY5NS02NGZjOTI3ZTAxZjFAZ21haWwuY29tL19fOyEhQTRG
MlI5R19wZyFQVzlKYnM0d3Y0YV96S0dnWkhOMEZZcklwZmVjUFgwT3VxOVYzZDE2WXotOS1HU0hx
WldzZkJBRi1Xa2VxR2VaU3R0NCQNCj4+Pg0KPj4+DQo+Pj4gQ2M6IEFuZHkgU2hldmNoZW5rbyA8
YW5keS5zaGV2Y2hlbmtvQGdtYWlsLmNvbT4NCj4+PiBDYzogRmVycnkgVG90aCA8Zm50b3RoQGdt
YWlsLmNvbT4NCj4+PiBDYzogV2VzbGV5IENoZW5nIDx3Y2hlbmdAY29kZWF1cm9yYS5vcmc+DQo+
Pj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4+IEZpeGVzOiA0MWNlMTQ1NmUxZGIg
KCJ1c2I6IGR3YzM6IGNvcmU6IG1ha2UgZHdjM19zZXRfbW9kZSgpIHdvcmsNCj4+PiBwcm9wZXJs
eSIpDQo+Pj4gU2lnbmVkLW9mZi1ieTogWXUgQ2hlbiA8Y2hlbnl1NTZAaHVhd2VpLmNvbT4NCj4+
PiBTaWduZWQtb2ZmLWJ5OiBKb2huIFN0dWx0eiA8am9obi5zdHVsdHpAbGluYXJvLm9yZz4NCj4+
PiBTaWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5jb20+
DQo+Pj4gLS0tDQo+Pj4gQ2hhbmdlcyBpbiB2MzoNCj4+PiAtIENoZWNrIGlmIHRoZSBkZXNpcmVk
IG1vZGUgaXMgT1RHLCB0aGVuIGtlZXAgdGhlIG9sZCBmbG93DQo+Pj4gLSBSZW1vdmUgY29uZGl0
aW9uIGZvciBPVEcgc3VwcG9ydCBvbmx5IHNpbmNlIHRoZSBkZXZpY2UgY2FuIHN0aWxsIGJlDQo+
Pj4gwqDCoCBjb25maWd1cmVkIERSRCBob3N0L2RldmljZSBtb2RlIG9ubHkNCj4+PiAtIFJlbW92
ZSByZWR1bmRhbnQgaHdfbW9kZSBjaGVjayBzaW5jZSBfX2R3YzNfc2V0X21vZGUoKSBvbmx5IGFw
cGxpZXMNCj4+PiB3aGVuDQo+Pj4gwqDCoCBod19tb2RlIGlzIERSRA0KPj4+IENoYW5nZXMgaW4g
djI6DQo+Pj4gLSBJbml0aWFsaXplIG11dGV4IHBlciBkZXZpY2UgYW5kIG5vdCBhcyBnbG9iYWwg
bXV0ZXguDQo+Pj4gLSBBZGQgYWRkaXRpb25hbCBjaGVja3MgZm9yIERSRCBvbmx5IG1vZGUNCj4+
Pg0KPj4+IMKgIGRyaXZlcnMvdXNiL2R3YzMvY29yZS5jIHwgMjcgKysrKysrKysrKysrKysrKysr
KysrKysrKysrDQo+Pj4gwqAgZHJpdmVycy91c2IvZHdjMy9jb3JlLmggfMKgIDUgKysrKysNCj4+
PiDCoCAyIGZpbGVzIGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKykNCj4+Pg0KPj4gSGkgSm9obiwN
Cj4+DQo+PiBJZiBwb3NzaWJsZSwgY2FuIHlvdSBydW4gYSB0ZXN0IHdpdGggdGhpcyB2ZXJzaW9u
IG9uIHlvdXIgcGxhdGZvcm0/DQo+Pg0KPj4gVGhhbmtzLA0KPj4gVGhpbmgNCj4+DQo+IEkgdGVz
dGVkIHRoaXMgb24gZWRpc29uLWFyZHVpbm8gd2l0aCB0aGlzIHBhdGNoIG9uIHRvcCBvZiB1c2It
bmV4dA0KPiAoNS4xMi1yYzcgKyAiaW5jcmVhc2UgQkVTTCBiYXNlbGluZSB0byA2IiB0byBwcmV2
ZW50IHRocm90dGxpbmciKS4NCj4gDQo+IE9uIHRoaXMgcGxhdGZvcm0gdGhlcmUgaXMgYSBwaHlz
aWNhbCBzd2l0Y2ggdG8gc3dpdGNoIHJvbGVzLiBXaXRoIHRoaXMNCj4gcGF0Y2ggSSBmaW5kOg0K
PiANCj4gLSBzd2l0Y2ggdG8gaG9zdCBtb2RlIGFsd2F5cyB3b3JrcyBmaW5lDQo+IA0KPiAtIHN3
aXRjaCB0byBnYWRnZXQgbW9kZSBJIG5lZWQgdG8gZmxpcCB0aGUgc3dpdGNoIDN4IChnYWRnZXQt
aG9zdC1nYWRnZXQpLg0KPiANCj4gQW4gZXJyb3IgbWVzc2FnZSBhcHBlYXJzIG9uIHRoZSBnYWRn
ZXQgc2lkZSAiZHdjMyBkd2MzLjAuYXV0bzogdGltZWQgb3V0DQo+IHdhaXRpbmcgZm9yIFNFVFVQ
IHBoYXNlIiBhcHBlYXJzLCBidXQgdGhlbiB0aGUgZGV2aWNlIGNvbm5lY3RzIHRvIG15IFBDLA0K
PiBubyB0aHJvdHRsaW5nLg0KPiANCj4gLSBhbHRlcm5hdGl2ZWx5IEkgY2FuIHN3aXRjaCB0byBn
YWRnZXQgMXggYW5kIHRoZW4gdW5wbHVnL3JlcGx1ZyB0aGUgY2FibGUuDQo+IA0KPiBObyBlcnJv
ciBtZXNzYWdlIGFuZCBjb25uZWN0cyBmaW5lLg0KPiANCj4gLSBpZiBJIGZsaXAgdGhlIHN3aXRj
aCBvbmx5IG9uY2UsIG9uIHRoZSBQQyBzaWRlIEkgZ2V0Og0KPiANCj4gwqAga2VybmVsOiB1c2Ig
MS01OiBuZXcgaGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAxOCB1c2luZyB4aGNpX2hjZA0K
PiDCoCBrZXJuZWw6IHVzYiAxLTU6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0xZDZi
LA0KPiDCoCBpZFByb2R1Y3Q9MDEwNCwgYmNkRGV2aWNlPSAxLjAwIGtlcm5lbDogdXNiIDEtNTog
TmV3IFVTQiBkZXZpY2UNCj4gwqAgc3RyaW5nczogTWZyPTEsIFByb2R1Y3Q9MiwgU2VyaWFsTnVt
YmVyPTMga2VybmVsOiB1c2IgMS01OiBQcm9kdWN0Og0KPiDCoCBVU0JBcm1vcnkgR2FkZ2V0IGtl
cm5lbDogdXNiIDEtNTogTWFudWZhY3R1cmVyOiBVU0JBcm1vcnkga2VybmVsOg0KPiDCoCB1c2Ig
MS01OiBTZXJpYWxOdW1iZXI6IDAxMjM0NTY3ODlhYmNkZWYga2VybmVsOiB1c2IgMS01OiBjYW4n
dCBzZXQNCj4gwqAgY29uZmlnICMxLCBlcnJvciAtMTEwDQoNClRoZSBkZXZpY2UgZmFpbGVkIGF0
IHNldF9jb25maWd1cmF0aW9uKCkgcmVxdWVzdCBhbmQgdGltZWQgb3V0LiBJdA0KcHJvYmFibHkg
dGltZWQgb3V0IGZyb20gdGhlIHN0YXR1cyBzdGFnZSBsb29raW5nIGF0IHRoZSBkZXZpY2UgZXJy
IHByaW50Lg0KDQo+IA0KPiBUaGVuIGlmIEkgd2FpdCBsb25nIGVub3VnaCBvbiB0aGUgZ2FkZ2V0
IHNpZGUgSSBnZXQ6DQo+IA0KPiDCoCByb290QHl1bmE6fiMgaWZjb25maWcNCj4gDQo+IMKgIHVz
YjA6IGZsYWdzPS0yODYwNTxVUCxCUk9BRENBU1QsUlVOTklORyxNVUxUSUNBU1QsRFlOQU1JQz4g
bXR1IDE1MDANCj4gwqAgaW5ldCAxNjkuMjU0LjExOS4yMzkgbmV0bWFzayAyNTUuMjU1LjAuMCBi
cm9hZGNhc3QgMTY5LjI1NC4yNTUuMjU1DQo+IMKgIGluZXQ2IGZlODA6OmE4YmI6Y2NmZjpmZWRk
OmVlZjEgcHJlZml4bGVuIDY0IHNjb3BlaWQgMHgyMDxsaW5rPg0KPiDCoCBldGhlciBhYTpiYjpj
YzpkZDplZTpmMSB0eHF1ZXVlbGVuIDEwMDAgKEV0aGVybmV0KSBSWCBwYWNrZXRzIDQ5MDQyNA0K
PiDCoCBieXRlcyA3MzUxNDY1NzggKDcwMS4wIE1pQikgUlggZXJyb3JzIDAgZHJvcHBlZCAxOTEg
b3ZlcnJ1bnMgMCBmcmFtZQ0KPiDCoCAwIFRYIHBhY2tldHMgMzUyNzkgYnl0ZXMgMjUzMjc0NiAo
Mi40IE1pQikgVFggZXJyb3JzIDAgZHJvcHBlZCAwDQo+IMKgIG92ZXJydW5zIDAgY2FycmllciAw
IGNvbGxpc2lvbnMgMA0KPiANCj4gKGNvcnJlY3Qgd291bGQgYmU6IGluZXQgMTAuNDIuMC4yMjEg
bmV0bWFzayAyNTUuMjU1LjI1NS4wIGJyb2FkY2FzdA0KPiAxMC40Mi4wLjI1NSkNCj4gDQo+IFNv
IG11Y2ggaW1wcm92ZWQgbm93LCBidXQgaXQgc2VlbXMgSSBhbSBzdGlsbCBtaXNzaW5nIHNvbWV0
aGluZyBvbiBwbHVnLg0KPiANCg0KVGhhdCdzIGdyZWF0ISBXZSBjYW4gbG9vayBhdCBpdCBmdXJ0
aGVyLiBDYW4geW91IGNhcHR1cmUgdGhlIHRyYWNlcG9pbnRzDQpvZiB0aGUgaXNzdWUuIEFsc28s
IGNhbiB5b3UgdHJ5IHdpdGggbWFzc19zdG9yYWdlIGdhZGdldCB0byBzZWUgaWYgdGhlDQpyZXN1
bHQgaXMgdGhlIHNhbWU/DQoNClRoYW5rcywNClRoaW5oDQo=
