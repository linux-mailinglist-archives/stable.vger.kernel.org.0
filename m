Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705D14A3211
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 22:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241490AbiA2VlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 16:41:01 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:45283 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352738AbiA2VlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 16:41:00 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20TLZeG6023909;
        Sat, 29 Jan 2022 16:40:58 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dw3c7g4eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 29 Jan 2022 16:40:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPBymY8F2cnvugu9qfNzDY90C37TEV33T2BJM2zTfWnOSccKFFvbvlZNLHZVYH03rPr9UYckvbpL0zGT/bWM/vk0RGlAAMqDGnxipwiZSBTla+L7dOmSLdiHI4QJLqZJTllWjaxc8LKCjoLGI9ZkgdTjdxFvTClf6WbVhgTHEe9KxoLU9xjynHuN6WaMNkjv48cRXnXwQkFSYe4UCRLDfop44HyEPrJiDa1xtEl87WXKzetkfy0OWhQgOt9W27lTDyjRZ0bed5IPdIhpwtVuLxrOm6kH6Tj89T8WHJATvDXXb0p15JW7TK1ys2bdEWPaKNbXvURm+eYS9KJtPvjixQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTGqfJmK1K7f0/VYuxeOhCdspPcxN3YX3R25sql61FU=;
 b=WpR+QYU/+NYumE+DnABsQ3GoHhJ8R6d8u+OLMlxbhWz5SIrHrYAmcQtlBjPFJ5B70ArocJ3hWFliY8JZf3AQ0VipMaEgkFcJ1jx+Lzh2/rYnxPJYMhfdj0dBEDBRec5fM9g3AGMmQ4bRXQGVctEzstf2sS0dHxGjtDCUQY20nbAkZg+ZfOllthtGjxN0/5AE7Ang9EpyL1G2XBmeokW4tciNyHpA1bfhRtr4GVbuBkcFU2+NrsB11iRfC5r31qJMJk+Le88zQkSJaB48mEyuDT3zFbXWdMGuTOPCalktFTsYiO6SqsNGcQDgwjbawb7qJYvA7S1OKM9NufvdFhqGEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTGqfJmK1K7f0/VYuxeOhCdspPcxN3YX3R25sql61FU=;
 b=NKFtt1p5pie1fvpXyy3kZL0CL9MHxViI2LrSq6tZQhKJgyz0lG8nD0YFXUr1casLnP4fTnUI3BosMgtDUwJAt1BSU1pz5uP07KERBlYqR2nGPnhi7VjV7wcZ9gcVuLVbP+s3RV1+OR2oydQInYWyAUDf3GYgwl0epT7pbc8y5Ac=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB4674.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:1d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Sat, 29 Jan
 2022 21:40:56 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%5]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 21:40:56 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Patch "usb: dwc3: xilinx: Skip resets and USB3 register settings
 for USB2.0 mode" has been added to the 5.16-stable tree
Thread-Topic: Patch "usb: dwc3: xilinx: Skip resets and USB3 register settings
 for USB2.0 mode" has been added to the 5.16-stable tree
Thread-Index: AQHYFS0DmwqDq1pEi027VwxXixcmO6x6h2+A
Date:   Sat, 29 Jan 2022 21:40:56 +0000
Message-ID: <8e6827b335e07010ca97faf1c98657434ec8b341.camel@calian.com>
References: <1643473458172238@kroah.com>
In-Reply-To: <1643473458172238@kroah.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02310bf7-c85d-42b5-184a-08d9e3700841
x-ms-traffictypediagnostic: YQXPR01MB4674:EE_
x-microsoft-antispam-prvs: <YQXPR01MB4674A63296E8730E42A244F7EC239@YQXPR01MB4674.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fin+1+z5ONPU/p9mrfuNEcWJj3KxcaG7zXvU2FFNntuYXzD1M4fgdEEiZrGLITZEEiM+VcXfC0/VEyUX6/ZSxPX690YucBZJ7sWwXprGhLNeQOT+DG5MAOcT09VZeQaZ/BmfFbaRGycP/z1UmV9HMNcxUhT+mfh1n/U9ZFM5XxDlRQoeciUt2DQxYSvoSkSizIJe49AWbiIuVj0Zx74LjQIufPn+nEtf1QOE0Jy//aAn5v/u4T6nq3SFwZ4pQnWXeWFOkCgsYYd8KBLUVCf+Sv9wT5mzQsxltPQI/2XU5JnBpjyE50FZe21oTWtbbFE51ftiKL4xyxUQaiAYvmp1dGgc0NnunI5hNsj2lC1vvGzVhnJdIpG/H/UBC0+2hVM80E9nh33Ll07JvUuJRpvNJEoTcv09R93A3OrdRAIy5F7Gs9AzNd3i75ujwnTF8DnHshreymoPUPX7J0ZfSHnGA0v4srbNVFmec+3S2uZqhC5jxzD4DYzsuws+wUn5IYobIub8B68xHhfGeh3KCV1kowZ7TR0PcltcTxswzwg7GcCPQ3Aow16ks8vMpBW6pHotl0Ym9WTlrxMR4vxcAHO9iyQ2EDUfEBRYtH1lThB3D2LSvYqdFSe7vcLj+Q5RMVyHzZ1aXQmEjZf9FFf9J4eM01vs3Wly6SxQ0vdZuay0FWdax31DkToBIcKQF4ezXzc37bzN5x3C3beeUlFfK6rW/pIfj3bqx2JWowqXe2QnAUY3C9epihjvrmPruRvG1GLgTG28Z1YVsqHojwDjixQj+mF51wmDODkYtBGlnmnzq0jM+/xKmC1hH6emvw07sDnS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(44832011)(2906002)(26005)(122000001)(186003)(83380400001)(38070700005)(8936002)(966005)(66446008)(53546011)(36756003)(5660300002)(71200400001)(6486002)(6506007)(508600001)(4326008)(66946007)(316002)(66556008)(8676002)(6916009)(91956017)(76116006)(38100700002)(6512007)(66476007)(86362001)(64756008)(99106002)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDJIUDNXV29RVnVOS0hQUk9IbUJNZU1zaDFNcnRqbkk3eEltalY1dCtFdVlC?=
 =?utf-8?B?VGw5VmRCaE1mRStkUlNnYUhiZWpzSDkxc0theUhzTjZOSmlaZU41NFgvSzdF?=
 =?utf-8?B?akNVT1J5MVRsVUlKS1dBempFTkwwREZZZTVrUm83aVFmU2FLQXowNWpYNGxP?=
 =?utf-8?B?UnQ4L0RwcWZ3MnFGZnpKQ2xuRi9MdHFSOXlINE5haU1JS1ZhTE5LZS90VTZO?=
 =?utf-8?B?WStqL0dPTmxqQlUvRElCcDFIdU4vZDlRMG9uSlEwQklLRTJrQythYndpeGdx?=
 =?utf-8?B?RDl2bXVSY3llLzJybk9jRGd3STVvcGJXL0dFZkxyK0E3MGJyL1dEdXlpS1dD?=
 =?utf-8?B?RFNSL1JDSXB2WUw1Wmw0QU45UlpyVW4yWkQ0Z2VSaS9yNTQ4L3VqVlBSWVlr?=
 =?utf-8?B?VzhOUmU2TXZ2MDVkRGd3QW1QUDI5U0RxSWVpTGwyak1yMGtvem9nV0hTRlUw?=
 =?utf-8?B?Nm8zMFVaemV5OUQzN3FsZlNCY3RPaldXSXhORnVVS0tOdnpYc2s3WFBIdDlD?=
 =?utf-8?B?OU5TL2h6d29QNzFydFRsaHZWSXJMNGlaZ2IwcXZzQm43QlBlUzJhN0hQamdt?=
 =?utf-8?B?UHVaZVdVc0I5VFBhU2FWc3RmNlVlaHVJQ1c1VnhOcXJwbGtpNFZTTTFmalJQ?=
 =?utf-8?B?YXhUZXJVVXpRT3NWci8xZGt0Umlpem0vZ3I0VU9qdjk1Tk13UGlyRElDNmxE?=
 =?utf-8?B?emgweWhoQ3llZTVocnZ1MEdQQWlMM1JXbEZaSThONmM5R1NpQkY3R2drdlpQ?=
 =?utf-8?B?YnhCd2wyV29JcFVaVS94Yk9DZytETXpHWXh5US94MENDb0dQVEN4am42bTdO?=
 =?utf-8?B?cmRacmZLUHZIdm0zNjNkdkdtMHVGSGdwU3kzdVdOQ3ZrazdhdkdveThpd0dQ?=
 =?utf-8?B?UDNGbVVyQmJQSVhHS2pmKzg2S1IyeUZVakRGNDh1SzlaM1NOUm0zWXhNYzdh?=
 =?utf-8?B?c3FRSmhtVm83d0Q1ZDEvN3ZJd0l1SnNnZDVDd0VRRlR6cmVMdXAweUVqOGp0?=
 =?utf-8?B?dWZqcTFJOVNuQnFvTHNzTWhnVjZDWmo1aUxCN24vSVUrZXJrcGlLa1o4NmMx?=
 =?utf-8?B?b1EwajArcENrYzNWZTVoR1ZPdEhOVTVGaWc1d3JXaTMxbEtweFI2dDdDL3pC?=
 =?utf-8?B?NGtWcktqRGJBcysva2ErVjNiRW8waXdNYU1PTUU4TVBjV1dRdHBsQmFzNnRh?=
 =?utf-8?B?Y0dLOTU5UlZuT0xLbzM3a1k4NGZrQ0k2WkxET3dRZXhvV0YzM0M3MlJOdjVz?=
 =?utf-8?B?dTZYNTdjSVduY1RmWG1JRmNtSmlGZFR0ZjFPUWpCVHFnbUhOWVZtdDRDRUdP?=
 =?utf-8?B?NGhQRktmVS9sVWV0TmZPb3BoS0dHQXV5Q2oyRE9kNzllMG1YVi9oSEJRZFBo?=
 =?utf-8?B?UjJnajFUbVF1NTQ4QUlaV1hmNGRKR3UrRTQwNGNiYUdpVE9Ud0oxQUN2Yy9h?=
 =?utf-8?B?dzN3UER1Q1V2L2NsSTFpenJ3c1hTUWxhRFZ0eXlwakdsV2dBSjFjMU1XNEhs?=
 =?utf-8?B?L2dzNk5JQWlnU1dWZ0lweU5xUlZNeXFEcVQ2VnFMZzExRUROMVZuMzhCSCsw?=
 =?utf-8?B?VlhpWlRiSVJtamhNQzhpNzB6UmthMkJNblhUdFhLalFXNUU3SjJTL25pQXpJ?=
 =?utf-8?B?SUVDOTNHcGRzUDNDenR0Tm1YNGJTOFZwYUUrdkV3UkwzQS81c0ZweEZrMmRh?=
 =?utf-8?B?NFZQUGMyNTlzZnBTak8yNzN1MjRQb25VSDZpOUQvbFdnMUpFY3Z2clRUbzEx?=
 =?utf-8?B?ZjZ6WlhPZjBGSXJEeDNkU2pNN25keG50T1RweEwrNjY2bUlmQUE4dkx1TXE2?=
 =?utf-8?B?cUR4Z3V0V2w4WWt1Q3dNNXNJV3FGQ0FhejY3YllTeHpuZGFyNHZ2SitaelhV?=
 =?utf-8?B?L2VER2M5Z09PdDV6MnlUZkVYRWZyNHVVUVRJSGx1U0V6R0dFYWY2TGx1NGxO?=
 =?utf-8?B?UysvaFFrdEVYaTRnUXc1V0l3S2x2bVhISWhXUDVvazJBaXFxNENESGNJd09y?=
 =?utf-8?B?ZEs5Q2dpeGNOQkNoZGt3RUhqVXJ5RzZnWVJBQitqcTRFd1hOdnpXNlBQSnFw?=
 =?utf-8?B?a1hMLzlNdnpJL1FiWXl3ZHlHdHhCS3ZPSDhPUXNnVGExZjdFU0pyb1R3MytR?=
 =?utf-8?B?KzBGNXF0KzhpcTlnK3JLdG9UY01xL1hYRzF5Y3I4MVczbmxZa0I1N05MR0ww?=
 =?utf-8?B?dmMxcTlYQnU4QWlqN09BMVNkTk5weFFPdnZIZXRHT09nVFhlMjJyR09XTDF0?=
 =?utf-8?Q?eLr/7BZWDRKyJxRUs9gpsvYZnPdvPLaFlF15s+tSNg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <527DF9D3D3B90A4A99FB1B7AA4E26412@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 02310bf7-c85d-42b5-184a-08d9e3700841
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2022 21:40:56.3167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RCDt/mhZLNxP0jQPD2e9E8OB1bt51axOUPnawhABCBGt0bQKr2W+SCCBq/y2uCjNccwuZaFcgUCMs9bbLyRTupd9y18O8xMM+5HDDiLdJw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB4674
X-Proofpoint-ORIG-GUID: ERqeKTR2WvKbBD3BQUgTsjhU4reApqqq
X-Proofpoint-GUID: ERqeKTR2WvKbBD3BQUgTsjhU4reApqqq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-29_12,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 adultscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201290143
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU2F0LCAyMDIyLTAxLTI5IGF0IDE3OjI0ICswMTAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gVGhpcyBpcyBhIG5vdGUgdG8gbGV0IHlvdSBrbm93IHRoYXQgSSd2ZSBq
dXN0IGFkZGVkIHRoZSBwYXRjaCB0aXRsZWQNCj4gDQo+ICAgICB1c2I6IGR3YzM6IHhpbGlueDog
U2tpcCByZXNldHMgYW5kIFVTQjMgcmVnaXN0ZXIgc2V0dGluZ3MgZm9yIFVTQjIuMCBtb2RlDQo+
IA0KPiB0byB0aGUgNS4xNi1zdGFibGUgdHJlZSB3aGljaCBjYW4gYmUgZm91bmQgYXQ6DQo+ICAg
ICANCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHA6Ly93d3cua2VybmVsLm9yZy9n
aXQvP3A9bGludXgqa2VybmVsKmdpdCpzdGFibGUqc3RhYmxlLXF1ZXVlLmdpdDthPXN1bW1hcnlf
XztMeTh2THchIUlPR29zMGshemY5UUp2WTg0RXRxVXBkaTZWZmxrSXAxQ0pxbm5DYVFvaUdHdlo4
S09SeXNqaU00NGhRZWNZalZ5U3hzdUQ2T2paQSQNCj4gIA0KPiANCj4gVGhlIGZpbGVuYW1lIG9m
IHRoZSBwYXRjaCBpczoNCj4gICAgICB1c2ItZHdjMy14aWxpbngtc2tpcC1yZXNldHMtYW5kLXVz
YjMtcmVnaXN0ZXItc2V0dGluZ3MtZm9yLXVzYjIuMC0NCj4gbW9kZS5wYXRjaA0KPiBhbmQgaXQg
Y2FuIGJlIGZvdW5kIGluIHRoZSBxdWV1ZS01LjE2IHN1YmRpcmVjdG9yeS4NCj4gDQo+IElmIHlv
dSwgb3IgYW55b25lIGVsc2UsIGZlZWxzIGl0IHNob3VsZCBub3QgYmUgYWRkZWQgdG8gdGhlIHN0
YWJsZSB0cmVlLA0KPiBwbGVhc2UgbGV0IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiBrbm93IGFi
b3V0IGl0Lg0KDQpIaSBHcmVnLA0KDQpUaGlzIHBhdGNoIHNob3VsZCBsaWtlbHkgb25seSBnbyBp
bnRvIHN0YWJsZSBhbG9uZyB3aXRoIHRoZSBmb2xsb3ctdXAgcGF0Y2ggSQ0KcG9zdGVkIChvciBz
b21ldGhpbmcgZXF1aXZhbGVudCk6DQoNCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJv
amVjdC9saW51eC11c2IvcGF0Y2gvMjAyMjAxMjcyMjE1MDAuMTc3MDIxLTEtcm9iZXJ0LmhhbmNv
Y2tAY2FsaWFuLmNvbS8NCg0KT3RoZXJ3aXNlIGl0IHdpbGwgY2F1c2UgYSByZWdyZXNzaW9uLg0K
DQo+IA0KPiANCj4gRnJvbSA5Njc4ZjMzNjFhZmMyN2EzMTI0Y2QyODI0YWVjMDIyNzczOTk4NmZi
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KPiBGcm9tOiBSb2JlcnQgSGFuY29jayA8cm9iZXJ0
LmhhbmNvY2tAY2FsaWFuLmNvbT4NCj4gRGF0ZTogVHVlLCAyNSBKYW4gMjAyMiAxODowMjo1MCAt
MDYwMA0KPiBTdWJqZWN0OiB1c2I6IGR3YzM6IHhpbGlueDogU2tpcCByZXNldHMgYW5kIFVTQjMg
cmVnaXN0ZXIgc2V0dGluZ3MgZm9yIFVTQjIuMA0KPiBtb2RlDQo+IA0KPiBGcm9tOiBSb2JlcnQg
SGFuY29jayA8cm9iZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCj4gDQo+IGNvbW1pdCA5Njc4ZjMz
NjFhZmMyN2EzMTI0Y2QyODI0YWVjMDIyNzczOTk4NmZiIHVwc3RyZWFtLg0KPiANCj4gSXQgYXBw
ZWFycyB0aGF0IHRoZSBQSVBFIGNsb2NrIHNob3VsZCBub3QgYmUgc2VsZWN0ZWQgd2hlbiBvbmx5
IFVTQiAyLjANCj4gaXMgYmVpbmcgdXNlZCBpbiB0aGUgZGVzaWduIGFuZCBubyBVU0IgMy4wIHJl
ZmVyZW5jZSBjbG9jayBpcyB1c2VkLg0KPiBBbHNvLCB0aGUgY29yZSByZXNldHMgYXJlIG5vdCBy
ZXF1aXJlZCBpZiBhIFVTQjMgUEhZIGlzIG5vdCBpbiB1c2UsIGFuZA0KPiB3aWxsIGJyZWFrIHRo
aW5ncyBpZiBVU0IzIGlzIGFjdHVhbGx5IHVzZWQgYnV0IHRoZSBQSFkgZW50cnkgaXMgbm90DQo+
IGxpc3RlZCBpbiB0aGUgZGV2aWNlIHRyZWUuDQo+IA0KPiBTa2lwIGNvcmUgcmVzZXRzIGFuZCBy
ZWdpc3RlciBzZXR0aW5ncyB0aGF0IGFyZSBvbmx5IHJlcXVpcmVkIGZvcg0KPiBVU0IzIG1vZGUg
d2hlbiBubyBVU0IzIFBIWSBpcyBzcGVjaWZpZWQgaW4gdGhlIGRldmljZSB0cmVlLg0KPiANCj4g
Rml4ZXM6IDg0NzcwZjAyOGZhYiAoInVzYjogZHdjMzogQWRkIGRyaXZlciBmb3IgWGlsaW54IHBs
YXRmb3JtcyIpDQo+IENjOiBzdGFibGUgPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+IFNpZ25l
ZC1vZmYtYnk6IFJvYmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiBM
aW5rOiANCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL3IvMjAyMjAxMjYwMDAyNTMuMTU4Njc2MC0yLXJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb21f
XzshIUlPR29zMGshemY5UUp2WTg0RXRxVXBkaTZWZmxrSXAxQ0pxbm5DYVFvaUdHdlo4S09SeXNq
aU00NGhRZWNZalZ5U3hzTUk2eUJqNCQNCj4gIA0KPiBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2Fo
LUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMv
dXNiL2R3YzMvZHdjMy14aWxpbnguYyB8ICAgMTMgKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNo
YW5nZWQsIDEzIGluc2VydGlvbnMoKykNCj4gDQo+IC0tLSBhL2RyaXZlcnMvdXNiL2R3YzMvZHdj
My14aWxpbnguYw0KPiArKysgYi9kcml2ZXJzL3VzYi9kd2MzL2R3YzMteGlsaW54LmMNCj4gQEAg
LTExMCw2ICsxMTAsMTggQEAgc3RhdGljIGludCBkd2MzX3hsbnhfaW5pdF96eW5xbXAoc3RydWN0
DQo+ICAJCXVzYjNfcGh5ID0gTlVMTDsNCj4gIAl9DQo+ICANCj4gKwkvKg0KPiArCSAqIFRoZSBm
b2xsb3dpbmcgY29yZSByZXNldHMgYXJlIG5vdCByZXF1aXJlZCB1bmxlc3MgYSBVU0IzIFBIWQ0K
PiArCSAqIGlzIHVzZWQsIGFuZCB0aGUgc3Vic2VxdWVudCByZWdpc3RlciBzZXR0aW5ncyBhcmUg
bm90IHJlcXVpcmVkDQo+ICsJICogdW5sZXNzIGEgY29yZSByZXNldCBpcyBwZXJmb3JtZWQgKHRo
ZXkgc2hvdWxkIGJlIHNldCBwcm9wZXJseQ0KPiArCSAqIGJ5IHRoZSBmaXJzdC1zdGFnZSBib290
IGxvYWRlciwgYnV0IG1heSBiZSByZXZlcnRlZCBieSBhIGNvcmUNCj4gKwkgKiByZXNldCkuIFRo
ZXkgbWF5IGFsc28gYnJlYWsgdGhlIGNvbmZpZ3VyYXRpb24gaWYgVVNCMyBpcyBhY3R1YWxseQ0K
PiArCSAqIGluIHVzZSBidXQgdGhlIHVzYjMtcGh5IGVudHJ5IGlzIG1pc3NpbmcgZnJvbSB0aGUg
ZGV2aWNlIHRyZWUuDQo+ICsJICogVGhlcmVmb3JlLCBza2lwIHRoZXNlIG9wZXJhdGlvbnMgaW4g
dGhpcyBjYXNlLg0KPiArCSAqLw0KPiArCWlmICghdXNiM19waHkpDQo+ICsJCWdvdG8gc2tpcF91
c2IzX3BoeTsNCj4gKw0KPiAgCWNyc3QgPSBkZXZtX3Jlc2V0X2NvbnRyb2xfZ2V0X2V4Y2x1c2l2
ZShkZXYsICJ1c2JfY3JzdCIpOw0KPiAgCWlmIChJU19FUlIoY3JzdCkpIHsNCj4gIAkJcmV0ID0g
UFRSX0VSUihjcnN0KTsNCj4gQEAgLTE4OCw2ICsyMDAsNyBAQCBzdGF0aWMgaW50IGR3YzNfeGxu
eF9pbml0X3p5bnFtcChzdHJ1Y3QNCj4gIAkJZ290byBlcnI7DQo+ICAJfQ0KPiAgDQo+ICtza2lw
X3VzYjNfcGh5Og0KPiAgCS8qDQo+ICAJICogVGhpcyByb3V0ZXMgdGhlIFVTQiBETUEgdHJhZmZp
YyB0byBnbyB0aHJvdWdoIEZQRCBwYXRoIGluc3RlYWQNCj4gIAkgKiBvZiByZWFjaGluZyBERFIg
ZGlyZWN0bHkuIFRoaXMgdHJhZmZpYyByb3V0aW5nIGlzIG5lZWRlZCB0bw0KPiANCj4gDQo+IFBh
dGNoZXMgY3VycmVudGx5IGluIHN0YWJsZS1xdWV1ZSB3aGljaCBtaWdodCBiZSBmcm9tIA0KPiBy
b2JlcnQuaGFuY29ja0BjYWxpYW4uY29tIGFyZQ0KPiANCj4gcXVldWUtNS4xNi9zZXJpYWwtODI1
MC1vZi1maXgtbWFwcGVkLXJlZ2lvbi1zaXplLXdoZW4tdXNpbmctcmVnLW9mZnNldC0NCj4gcHJv
cGVydHkucGF0Y2gNCj4gcXVldWUtNS4xNi91c2ItZHdjMy14aWxpbngtc2tpcC1yZXNldHMtYW5k
LXVzYjMtcmVnaXN0ZXItc2V0dGluZ3MtZm9yLXVzYjIuMC0NCj4gbW9kZS5wYXRjaA0KPiBxdWV1
ZS01LjE2L3VzYi1kd2MzLXhpbGlueC1maXgtZXJyb3ItaGFuZGxpbmctd2hlbi1nZXR0aW5nLXVz
YjMtcGh5LnBhdGNoDQo=
