Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31502E905E
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 07:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbhADGPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 01:15:32 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:24207 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbhADGPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 01:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609740930; x=1641276930;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wZrhL8OOm3DlV2oHO+KDGYEm21kr+kUKZpbxJ7dJELA=;
  b=SyM4tbcMiAzI3/e/N91Q3q/JkBhPDFuc9syU9/tXqZ9p9Es5Qvo5uZr6
   JBm94baMleHN5noVvANYE9AAgx5tvuGGVqYHa0Fx8rMl8hfvjrJCvwstx
   T1rgmn406maWE6+Apz7D3derOTQwxvhVijP4cyxhYHE1AZ6a4DYwhfRq7
   IwopPMxB/3ccMegR1hGSygmb2O+2p3AwR4AUDk4KhlqFWiLeibu7sEIJG
   TLe4GjTdL6o3seEux9pvjwX+kFeXHhSNuEeVJ1q+GE56I3GpQZSSMyLnz
   JRyqVunyyqxV6PheRymln0+uKMergi2rQWjO1SmNMQZzb0rn9Nn5zzz5Q
   g==;
IronPort-SDR: nnL073Yy2gl3b9Ug0nt7h+onv/oRK5ODLUNv5QekY+3W4UdTJkPbxUGmpM52Myfdl4KHa1V45Z
 nBSAzz9Psi+cEYEEDIiQ0yxaytbyPTv7RdXS429+ks1x88FEXjFnb9VkwuwYc/n0oKLI+H6NrU
 ggmJZBS1NN6sUDeukolNQxDBQuWa6RZEPG1BXoQflO/+Is2fi3Bxj5klnEhIP5bYaV7u7sLLBn
 cJO2bbDqt3pI2snIK4jxy4R0wk6mNhookEHLA21kpIxlqmxJ+2U0rqGzXbLKRJNTbXd6c3T5FE
 zaY=
X-IronPort-AV: E=Sophos;i="5.78,473,1599494400"; 
   d="scan'208";a="156483722"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 14:14:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+amjCmydbYdh14yUm/7uU+rSmAGd8Z8PLP27Vahohj7YsZhy0I4Mhi+cft0TIdQYZwg/Q4x4iHhHnibUmEvhwzqlQCpDMTp26vGLEd8nVY8kG7EQxGzYfYZhP4RZo1BC1ao85yhLSDBpca3+cbnnZxAGBcim4H4NhG2oRp7SELxiyvsYDXEWIMN561b/9e0dLbEK8zu5SbWDr60pBTFhKitwnBtY2K9V75R6bJjoQ32X65gIGfIdPjpY0J7lNZsuRxdTPG21hmlj5xUgKYpP6oe4JpEV7MTxBH+7gZJvb0YTBudbngOpjHrwWE5rwy/MgBNujtRLA8SjU1+NdpgFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZrhL8OOm3DlV2oHO+KDGYEm21kr+kUKZpbxJ7dJELA=;
 b=lCd6c19FpSeWPAwqfaU9CNzCQCQb4f9hyAJ2wHSUxfTxcYvo/KVEc2rGM2ux9EoYtzk23gX7pzTfO3+49AM33EFaaO9UOaBj2On2fzhXeTYVyE4v+NJstN9ON216cVTyu5ZKFFqTfFYGzRXn6lzptLgwOvgb6nCo/rkN1f4lyZSmhJ/JnP1ib1MXG4nkY99Kgm2KTT7KqCRR/b7qbz8WmRppJn7GAqqW7SwFZEDMTvPOt7umshfJvlF7AZAdzgEMsLLeDn2dm6Jh2vQ4Hz2CKx7Knz+DMPfAj083d2wQS4PgYynrSUFua0Zl7dA820/vEPWs9GH3Go6N4atBSkIIHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZrhL8OOm3DlV2oHO+KDGYEm21kr+kUKZpbxJ7dJELA=;
 b=wNC+CcBRHy7Ddgq9HyXwwQrKPXwDsOwQ7vvCVPoC+/xeujQZw446dF6OszvvNXkV07mrpRH/mA3YUUZ0O3RsQocigGcCOrr8ZL5dn8qsWIhd0BBWfRLkJsjKt3wQxGfKnRUNM6rENMccYPLs4KNP5IbkXKLVNoX3SRVC4en6Hvs=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6701.namprd04.prod.outlook.com (2603:10b6:208:1ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.21; Mon, 4 Jan
 2021 06:14:41 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 06:14:41 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@lst.de" <hch@lst.de>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] null_blk: Fix zone size initialization"
 failed to apply to 4.19-stable tree
Thread-Topic: FAILED: patch "[PATCH] null_blk: Fix zone size initialization"
 failed to apply to 4.19-stable tree
Thread-Index: AQHW3Q9XO4No/1edTEqYNnXZ6UdbJaoXB6YA
Date:   Mon, 4 Jan 2021 06:14:41 +0000
Message-ID: <02237e37253bfffdc9f88dd72a7eccaf301a5b02.camel@wdc.com>
References: <160915617556175@kroah.com>
In-Reply-To: <160915617556175@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2 (3.38.2-1.fc33) 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:8d3e:27aa:85c2:44b5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5032a081-ce60-40e1-1d58-08d8b0780621
x-ms-traffictypediagnostic: MN2PR04MB6701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB670127AE58537B57072A52BDE7D20@MN2PR04MB6701.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ofEY7SAkDN23qhVDCQ4N7vEjBNPViuciOj0oB/C2Ungj6bktxMoo3O5PDISwk37sja2xKvA1PBcSsm+jQyaXKvLC8KCf9jMtiNPmWtzrnLoq7R2efAfkQzl7aY9tJjGyVEHoynIon/SJ0DTDuQ6bucDNJJyVsasb4A4HOtHgT9LspEvgkJwE5BXaHE1Uq5sLMQbqcKx3GP95S4J7Lww2xe4aNcP/+vN55kNzOmeSlVPaghoUppdsA52TJ/MtpR2RN7wcv3kaVhc0b5HuN8mmO6NQqT9CFrP4oucAK74WGRB6W8IWxx9m6vXi9+pJ0q0TDpAE+AP7B8sEnTX8PuBxktVFxWWnllpYaR4ZVAxgVDfzCNTraUhnSymhlGV9fL/QN63Kuc4Ao5A0NPwELvQK1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(6512007)(86362001)(478600001)(6486002)(186003)(2616005)(76116006)(91956017)(66446008)(64756008)(66476007)(4001150100001)(6506007)(66556008)(4326008)(66946007)(53546011)(2906002)(8936002)(71200400001)(110136005)(316002)(36756003)(6636002)(83380400001)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TWVvYnUzOUVxdkp0Mk0wOVd1eHlmUmNJWlpsWGEwT2xpRHBVQjdXRTlJTkUr?=
 =?utf-8?B?cEZ4RUZVcldHV0lhSE9LT2wxMCt3MWlad0RmeW43czg1MTMrRERsOHltUm9q?=
 =?utf-8?B?Zmhwc0QySWRsVHJORnZOMUtsaUtwbGpLVGNKMGFTVlYxa0FUcGt6bVliaUI0?=
 =?utf-8?B?S08zSkxoZ3lXbGhXUC9KalpxVW43SUZXbitxdGlxZXc5b0ZtQWhadGwwOEFh?=
 =?utf-8?B?UmZFcTA4QnBlYWtXV0NSYzVKK3pJbXM1TlRPOHpZZm9UeHJyK0QvMXFpdFFZ?=
 =?utf-8?B?akxpamdyeVI3dTZTWThZTWhGd2pVVUdKRnY0aHFzUU9BdFJLYlNSQWgrb1ZT?=
 =?utf-8?B?ZDN6MFdlQ0VrSFJzOVFabWc5TWs5UmVwQmFxaGVBUUpXUXAxc2o5bjZQVzBv?=
 =?utf-8?B?TjRucUZIUUZDR0VmcGNwOVVHVHhjTTdxSnNscG85bk5XckNKc0drd29uZ254?=
 =?utf-8?B?OTdDcCtmWVhLL2lUZjdNRjE5QVNMbENFMmM5Tmc3VXhxeXg3MThKVWdDd1NJ?=
 =?utf-8?B?c0dIWCthbXg5dUx4WVlXa0xlYTNwWUgycmJNalFUQ1pJekZFNS9wTjBCWGQv?=
 =?utf-8?B?NjJlM0oyM3lydDAzbXlCSTVzdURsWFYvZytETTVCcVpqZXNrbEpNWUtCOWxw?=
 =?utf-8?B?aStWMjg5UlVnVjc0RnhoRTZtcFdCN3FsYmRuRmUxWWhDdk5oNTRYV1ZKaHFQ?=
 =?utf-8?B?bUpjZlhzWmthWFNlcnJWVFNWOWVHVHlnVlV3dE0xSFY1Q05FMGc2dXo2ekxa?=
 =?utf-8?B?Q0p1OUJDcC9mV3UxaEt3Z0FKblFMV2xOVFJNaWZJZnlMOXBmak1lN3FBT1NY?=
 =?utf-8?B?M1IyTVBCUTk1M3h6Tk55YkxUdzExSndVamtWNkFXb2NQSVRmR2VVZS9uS091?=
 =?utf-8?B?dGtXbTdjeUtJS3NXeTJkajdKbUxIQVpZY2Z3WHBQYlM1dzJNc0xIN0NCZDVP?=
 =?utf-8?B?SlB6MTFDZnBNWUorTWV0STBRTkZmS1BhYlh5ZzJxWDJOMDdQaTFsR2xoVkl0?=
 =?utf-8?B?Y2R6Umw1Q1l4ZHJrckxocHdLN0dudUdmZXBQbTB2eDY4cHdPYzc3c0p3WnY2?=
 =?utf-8?B?L01DMnZ3ZHl1dkVCcFNmaWlrK1c1aFdzWlE3Wm1QZy9CaFc0S3RUcm1qdGE4?=
 =?utf-8?B?K1F4ZVExbGhDSnF3cTg4MktHb05TQjdPeDB1blYvb1ZkVG05Uno3ODZwSTkv?=
 =?utf-8?B?bU9RYjk0ek5nV1d6cmxQRzFZQUducEdyTzlRWDc2cHgwOXZMdGVyajVqWmlK?=
 =?utf-8?B?T29Hc3QvNWxVOGw4WFNvYXVtVmhRVDVKR2xvU3VjVGVWalUzNHhhK1pKSFpL?=
 =?utf-8?B?YVJNVXBwamJWdEpEdE9MUE43SVN6c3ZzV3RKQWxWaEJlRVdBK0V6dmxtSnM5?=
 =?utf-8?B?ZmxPbmllaEhsZnBZYmc1L21rUWt3aFlsVzNHLy9MSDBLc2wyTkpoSGxPVDd0?=
 =?utf-8?Q?cj/w9x6j?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <608603C72BA31E49B4C1114A95E71C12@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5032a081-ce60-40e1-1d58-08d8b0780621
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 06:14:41.6928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2/7g3uPcvrtrTFyDU/qlDeO3Zpru23zzwxTi5rzSojuM7uvW78ZuShWg09l+BC/2+N1VPqRy7P6nKpFdkiJ1wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6701
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIwLTEyLTI4IGF0IDEyOjQ5ICswMTAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gVGhlIHBhdGNoIGJlbG93IGRvZXMgbm90IGFwcGx5IHRvIHRoZSA0LjE5
LXN0YWJsZSB0cmVlLg0KPiBJZiBzb21lb25lIHdhbnRzIGl0IGFwcGxpZWQgdGhlcmUsIG9yIHRv
IGFueSBvdGhlciBzdGFibGUgb3IgbG9uZ3Rlcm0NCj4gdHJlZSwgdGhlbiBwbGVhc2UgZW1haWwg
dGhlIGJhY2twb3J0LCBpbmNsdWRpbmcgdGhlIG9yaWdpbmFsIGdpdCBjb21taXQNCj4gaWQgdG8g
PHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+Lg0KPiANCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBrLWgN
Cg0KSGkgR3JlZywNCg0KSSBzZW50IGEgYmFja3BvcnRlZCBwYXRjaCBmb3IgNC4xOS1zdGFibGUg
aW4gcmVwbHkgdG8geW91ciBlbWFpbC4gVGhlIGJhY2twb3J0DQppcyBpZGVudGljYWwgdG8gdGhl
IG9uZSBJIHNlbnQgc2VwYXJhdGVseSBmb3IgdGhlIDUuNC1zdGFibGUgdHJlZS4NCg0KVGhhbmtz
Lg0KDQoNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLSBvcmlnaW5hbCBjb21taXQgaW4gTGludXMn
cyB0cmVlIC0tLS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gRnJvbSAwZWJjZGQ3MDJmNDlhZWIwYWQy
ZTJkODk0ZjhjMTI0YTBhY2M2ZTIzIE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KPiBGcm9tOiBE
YW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMuY29tPg0KPiBEYXRlOiBGcmksIDIwIE5v
diAyMDIwIDEwOjU1OjExICswOTAwDQo+IFN1YmplY3Q6IFtQQVRDSF0gbnVsbF9ibGs6IEZpeCB6
b25lIHNpemUgaW5pdGlhbGl6YXRpb24NCj4gDQo+IEZvciBhIG51bGxfYmxrIGRldmljZSB3aXRo
IHpvbmVkIG1vZGUgZW5hYmxlZCBpcyBjdXJyZW50bHkgaW5pdGlhbGl6ZWQNCj4gd2l0aCBhIG51
bWJlciBvZiB6b25lcyBlcXVhbCB0byB0aGUgZGV2aWNlIGNhcGFjaXR5IGRpdmlkZWQgYnkgdGhl
IHpvbmUNCj4gc2l6ZSwgd2l0aG91dCBjb25zaWRlcmluZyBpZiB0aGUgZGV2aWNlIGNhcGFjaXR5
IGlzIGEgbXVsdGlwbGUgb2YgdGhlDQo+IHpvbmUgc2l6ZS4gSWYgdGhlIHpvbmUgc2l6ZSBpcyBu
b3QgYSBkaXZpc29yIG9mIHRoZSBjYXBhY2l0eSwgdGhlIHpvbmVzDQo+IGVuZCB1cCBub3QgY292
ZXJpbmcgdGhlIGVudGlyZSBjYXBhY2l0eSwgcG90ZW50aWFsbHkgcmVzdWx0aW5nIGlzIG91dA0K
PiBvZiBib3VuZHMgYWNjZXNzZXMgdG8gdGhlIHpvbmUgYXJyYXkuDQo+IA0KPiBGaXggdGhpcyBi
eSBhZGRpbmcgb25lIGxhc3Qgc21hbGxlciB6b25lIHdpdGggYSBzaXplIGVxdWFsIHRvIHRoZQ0K
PiByZW1haW5kZXIgb2YgdGhlIGRpc2sgY2FwYWNpdHkgZGl2aWRlZCBieSB0aGUgem9uZSBzaXpl
IGlmIHRoZSBjYXBhY2l0eQ0KPiBpcyBub3QgYSBtdWx0aXBsZSBvZiB0aGUgem9uZSBzaXplLiBG
b3Igc3VjaCBzbWFsbGVyIGxhc3Qgem9uZSwgdGhlIHpvbmUNCj4gY2FwYWNpdHkgaXMgYWxzbyBj
aGVja2VkIHNvIHRoYXQgaXQgZG9lcyBub3QgZXhjZWVkIHRoZSBzbWFsbGVyIHpvbmUNCj4gc2l6
ZS4NCj4gDQo+IFJlcG9ydGVkLWJ5OiBOYW9oaXJvIEFvdGEgPG5hb2hpcm8uYW90YUB3ZGMuY29t
Pg0KPiBGaXhlczogY2E0YjJhMDExOTQ4ICgibnVsbF9ibGs6IGFkZCB6b25lIHN1cHBvcnQiKQ0K
PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBEYW1pZW4gTGUg
TW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMuY29tPg0KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhl
bGx3aWcgPGhjaEBsc3QuZGU+DQo+IFJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpv
aGFubmVzLnRodW1zaGlybkB3ZGMuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxh
eGJvZUBrZXJuZWwuZGs+DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay9udWxsX2Js
a196b25lZC5jIGIvZHJpdmVycy9ibG9jay9udWxsX2Jsa196b25lZC5jDQo+IGluZGV4IGJlYjM0
YjRmNzZiMC4uMWQwMzcwZDkxZmU3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2Jsb2NrL251bGxf
YmxrX3pvbmVkLmMNCj4gKysrIGIvZHJpdmVycy9ibG9jay9udWxsX2Jsa196b25lZC5jDQo+IEBA
IC02LDggKzYsNyBAQA0KPiDCoCNkZWZpbmUgQ1JFQVRFX1RSQUNFX1BPSU5UUw0KPiDCoCNpbmNs
dWRlICJudWxsX2Jsa190cmFjZS5oIg0KPiDCoA0KPiANCj4gDQo+IA0KPiAtLyogem9uZV9zaXpl
IGluIE1CcyB0byBzZWN0b3JzLiAqLw0KPiAtI2RlZmluZSBaT05FX1NJWkVfU0hJRlQJCTExDQo+
ICsjZGVmaW5lIE1CX1RPX1NFQ1RTKG1iKSAoKChzZWN0b3JfdCltYiAqIFNaXzFNKSA+PiBTRUNU
T1JfU0hJRlQpDQo+IMKgDQo+IA0KPiANCj4gDQo+IMKgc3RhdGljIGlubGluZSB1bnNpZ25lZCBp
bnQgbnVsbF96b25lX25vKHN0cnVjdCBudWxsYl9kZXZpY2UgKmRldiwgc2VjdG9yX3Qgc2VjdCkN
Cj4gwqB7DQo+IEBAIC0xNiw3ICsxNSw3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IG51
bGxfem9uZV9ubyhzdHJ1Y3QgbnVsbGJfZGV2aWNlICpkZXYsIHNlY3Rvcl90IHNlY3QpDQo+IMKg
DQo+IA0KPiANCj4gDQo+IMKgaW50IG51bGxfaW5pdF96b25lZF9kZXYoc3RydWN0IG51bGxiX2Rl
dmljZSAqZGV2LCBzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSkNCj4gwqB7DQo+IC0Jc2VjdG9yX3Qg
ZGV2X3NpemUgPSAoc2VjdG9yX3QpZGV2LT5zaXplICogMTAyNCAqIDEwMjQ7DQo+ICsJc2VjdG9y
X3QgZGV2X2NhcGFjaXR5X3NlY3RzLCB6b25lX2NhcGFjaXR5X3NlY3RzOw0KPiDCoAlzZWN0b3Jf
dCBzZWN0b3IgPSAwOw0KPiDCoAl1bnNpZ25lZCBpbnQgaTsNCj4gwqANCj4gDQo+IA0KPiANCj4g
QEAgLTM4LDkgKzM3LDEzIEBAIGludCBudWxsX2luaXRfem9uZWRfZGV2KHN0cnVjdCBudWxsYl9k
ZXZpY2UgKmRldiwgc3RydWN0IHJlcXVlc3RfcXVldWUgKnEpDQo+IMKgCQlyZXR1cm4gLUVJTlZB
TDsNCj4gwqAJfQ0KPiDCoA0KPiANCj4gDQo+IA0KPiAtCWRldi0+em9uZV9zaXplX3NlY3RzID0g
ZGV2LT56b25lX3NpemUgPDwgWk9ORV9TSVpFX1NISUZUOw0KPiAtCWRldi0+bnJfem9uZXMgPSBk
ZXZfc2l6ZSA+Pg0KPiAtCQkJCShTRUNUT1JfU0hJRlQgKyBpbG9nMihkZXYtPnpvbmVfc2l6ZV9z
ZWN0cykpOw0KPiArCXpvbmVfY2FwYWNpdHlfc2VjdHMgPSBNQl9UT19TRUNUUyhkZXYtPnpvbmVf
Y2FwYWNpdHkpOw0KPiArCWRldl9jYXBhY2l0eV9zZWN0cyA9IE1CX1RPX1NFQ1RTKGRldi0+c2l6
ZSk7DQo+ICsJZGV2LT56b25lX3NpemVfc2VjdHMgPSBNQl9UT19TRUNUUyhkZXYtPnpvbmVfc2l6
ZSk7DQo+ICsJZGV2LT5ucl96b25lcyA9IGRldl9jYXBhY2l0eV9zZWN0cyA+PiBpbG9nMihkZXYt
PnpvbmVfc2l6ZV9zZWN0cyk7DQo+ICsJaWYgKGRldl9jYXBhY2l0eV9zZWN0cyAmIChkZXYtPnpv
bmVfc2l6ZV9zZWN0cyAtIDEpKQ0KPiArCQlkZXYtPm5yX3pvbmVzKys7DQo+ICsNCj4gwqAJZGV2
LT56b25lcyA9IGt2bWFsbG9jX2FycmF5KGRldi0+bnJfem9uZXMsIHNpemVvZihzdHJ1Y3QgYmxr
X3pvbmUpLA0KPiDCoAkJCUdGUF9LRVJORUwgfCBfX0dGUF9aRVJPKTsNCj4gwqAJaWYgKCFkZXYt
PnpvbmVzKQ0KPiBAQCAtMTAxLDggKzEwNCwxMiBAQCBpbnQgbnVsbF9pbml0X3pvbmVkX2Rldihz
dHJ1Y3QgbnVsbGJfZGV2aWNlICpkZXYsIHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxKQ0KPiDCoAkJ
c3RydWN0IGJsa196b25lICp6b25lID0gJmRldi0+em9uZXNbaV07DQo+IMKgDQo+IA0KPiANCj4g
DQo+IMKgCQl6b25lLT5zdGFydCA9IHpvbmUtPndwID0gc2VjdG9yOw0KPiAtCQl6b25lLT5sZW4g
PSBkZXYtPnpvbmVfc2l6ZV9zZWN0czsNCj4gLQkJem9uZS0+Y2FwYWNpdHkgPSBkZXYtPnpvbmVf
Y2FwYWNpdHkgPDwgWk9ORV9TSVpFX1NISUZUOw0KPiArCQlpZiAoem9uZS0+c3RhcnQgKyBkZXYt
PnpvbmVfc2l6ZV9zZWN0cyA+IGRldl9jYXBhY2l0eV9zZWN0cykNCj4gKwkJCXpvbmUtPmxlbiA9
IGRldl9jYXBhY2l0eV9zZWN0cyAtIHpvbmUtPnN0YXJ0Ow0KPiArCQllbHNlDQo+ICsJCQl6b25l
LT5sZW4gPSBkZXYtPnpvbmVfc2l6ZV9zZWN0czsNCj4gKwkJem9uZS0+Y2FwYWNpdHkgPQ0KPiAr
CQkJbWluX3Qoc2VjdG9yX3QsIHpvbmUtPmxlbiwgem9uZV9jYXBhY2l0eV9zZWN0cyk7DQo+IMKg
CQl6b25lLT50eXBlID0gQkxLX1pPTkVfVFlQRV9TRVFXUklURV9SRVE7DQo+IMKgCQl6b25lLT5j
b25kID0gQkxLX1pPTkVfQ09ORF9FTVBUWTsNCj4gwqANCj4gDQo+IA0KPiANCj4gDQoNCi0tIA0K
RGFtaWVuIExlIE1vYWwNCldlc3Rlcm4gRGlnaXRhbA0K
