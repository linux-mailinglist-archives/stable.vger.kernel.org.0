Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A0D3248E4
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 03:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbhBYCdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 21:33:22 -0500
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:62784
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234012AbhBYCdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 21:33:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUINbJktJyktuwDqNHHaN7eJ0hGX5OEiHbD257YYAJZQ8GEtVd3CpQd4TPKR29hD73Vu+Ka9OgVmJDNADKzxh+RMf0MkuEtsfZYCTZjPpcum0seNLqA+qfrVBJ0wRQ+xtUhvSUQLT1lL28FwXd4ODAT75f5XvSYoW9ARlmLfXvkdFffDGv32o028D+BT5YOZ9/CXGgaY9j8kim5HGx87PxBWqUrOiNKIrQdEg/ovfNgQG2bg9jkE2ANyXSwCtkSM43tu6qQy6Oaxej/ws7QeWoixb/JZLWABvD6EbrC6KTkLm5oSxxWZ8QH3deamfmECCJ+fvxE6/bbfI8X+CHrMBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrGacAg2KMSeLERA18QjLBOzjT4L7F1WNi5Z1BGhyaI=;
 b=M47PnxQtC008jBZ/OH56Qyc1w19YhE62fr7MsW1D44mehaGpSln1/s87bdmhYhICJ4PYK8vWPyef5rElSLS7Ux7eTR6BlTit1OdqEsouXbsfhHmdOYIA2nIJYgdezEru09RM7LpIv86geBZZ0LkwCeAWkDSmXz/2PfVVWwtIpmsEe6E5QIFPn6cxAGtdHqlm7SJWTvFgM4qS7U8fV7B3g2MH014GHO3LG4ATInD/LNwEs37vqqdi51XC0ddH2LYp87Oozqn6UIhYSVihOyDHpjqotyEqS+7NdWM8JqgNHpBUuTdKV/Jh81AZV8nC2+nY7xAEHV3Fl+PXlWDitVQBIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrGacAg2KMSeLERA18QjLBOzjT4L7F1WNi5Z1BGhyaI=;
 b=Nx0LWy1rXQvpag5pdEVAKkiluW54ZqGSTH/xf9w8SA8GZlv+Agr6MzLd6/x9boUh3gGYpZEKJrxl97GwfuxA2nQnlqxgHNVhYYKEdXqtb2i/Zamu5r0lE7mtQYwaBYshJ62991grST8l6WDcSXO+PxSsjeWCjVNxk/hw66bIFkk=
Received: from BN8PR12MB4770.namprd12.prod.outlook.com (2603:10b6:408:a1::30)
 by BN8PR12MB3362.namprd12.prod.outlook.com (2603:10b6:408:44::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Thu, 25 Feb
 2021 02:32:28 +0000
Received: from BN8PR12MB4770.namprd12.prod.outlook.com
 ([fe80::2054:faac:dec5:d93]) by BN8PR12MB4770.namprd12.prod.outlook.com
 ([fe80::2054:faac:dec5:d93%6]) with mapi id 15.20.3868.033; Thu, 25 Feb 2021
 02:32:28 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     "lyude@redhat.com" <lyude@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>, "Brol, Eryk" <Eryk.Brol@amd.com>,
        "Zhuo, Qingqing" <Qingqing.Zhuo@amd.com>
Subject: RE: [PATCH v2 0/2] Set CLEAR_PAYLOAD_ID_TABLE as broadcast request
Thread-Topic: [PATCH v2 0/2] Set CLEAR_PAYLOAD_ID_TABLE as broadcast request
Thread-Index: AQHXCpY0DEYRJMD5VUGE2cXXmPgsRqpnmwMAgACLtQA=
Date:   Thu, 25 Feb 2021 02:32:27 +0000
Message-ID: <BN8PR12MB4770EFCCD1B4D0D363B95FC9FC9E9@BN8PR12MB4770.namprd12.prod.outlook.com>
References: <20210224101521.6713-1-Wayne.Lin@amd.com>
 <10aa57cb1a982cbc07195319580bc9604961f186.camel@redhat.com>
In-Reply-To: <10aa57cb1a982cbc07195319580bc9604961f186.camel@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=0dbf33d4-f1d5-48d8-935b-3e78014334bf;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-02-25T02:29:21Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [165.204.134.249]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f8846ce0-ea59-457c-2cc5-08d8d9359809
x-ms-traffictypediagnostic: BN8PR12MB3362:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB336284557FDEF715B1EF9EC8FC9E9@BN8PR12MB3362.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xm/xzY19GPRwI6kRBS4LyUJqdP9WLKWlt7GAYaCxMXPxXMG0VkHYyBAaIJMcXi2+YnO1akysJ57tNC4DKtCFdDt90zpRJVj7IfRVHBFS4ZIzUOcqcFPAruJKcg7X3FrycY+3/QcuSQBunRSEyq9qDHhbbFFw1Oqeb8MA1G0XatzigOg5kz3eZmuNhqFz/LInGOWdpDAYY0cU7uZ/yAw7X6qCbAWOfOPxQ5CmQZ4iMskVzVHMTSeayNCNlpSgIZGXuilz5rS3jD3f/1QeY98lzxAHfMa/grimIZIKrfWco7QBzq9n73Xm75G0a8LvmS6LBmhPfngE/gyrHRzUMmAXh+QoLBem51Kb8S6m3hRlT7gk98PVfhDOPLk6m3Tr7Mp6snfAAVa7AHBQRhbLqXOXd6NkM2O5SgElbZsdMAK5wkZTeVLtrEUWA20yjziMA/3ORKt2AqBvkZKN1n6NlEGiFYQkAgJIDHtd7mA3HnoZvfv2Bgr9COmDxbNrnN8SnIKymQlmgG0sDNgwB2FMdygDrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB4770.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(55016002)(83380400001)(66476007)(76116006)(66946007)(4326008)(52536014)(110136005)(33656002)(9686003)(316002)(64756008)(7696005)(71200400001)(478600001)(86362001)(66446008)(54906003)(66556008)(5660300002)(8936002)(6506007)(53546011)(2906002)(186003)(26005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QWFXd29vTDhMZ3d6RlNRQUpNYUZlZkYxSjFUZ3hlMUQwWlpuRTNicnM2aGZV?=
 =?utf-8?B?UHhPLzlsMWdwQzg1T0RSVXN6dEVLZ3piSG5ZT1pnOFpueEVuT0RlbmthbmNP?=
 =?utf-8?B?aE1wNG12bURRYktYNEN0ZE9wazJydkx3WHIyL00rQWNhZHhTMStLUXNwSUxM?=
 =?utf-8?B?eHdNNEVMdlBGRFZXdUgxVElRaE9SZnBxWEE1dWZ1NEN2RnIrTjZJZ3A2akY2?=
 =?utf-8?B?b1RpM29qakpLNTVuUGd4N3pmb3VnNUpady9vaWlGTnErSlJyTFJLSlA0WDlx?=
 =?utf-8?B?emZ3MEh4eW9qRm9idm52dkFYV3hmS2ExUEg2MUg3YmtVbm5DVm1WeStXQ1hN?=
 =?utf-8?B?M2JVd0VQMHNzeGZocGZtS1U0QTlpVWY0UDBDQW1YTDE0WWZtamIvSHJmUW1W?=
 =?utf-8?B?QjVqTEUyZU1nQ3ZlOUpPcmtBZ3hGUTlrVExkWlgyWXZLczBxbjQ3Z2lBWDR3?=
 =?utf-8?B?c1NtN1hJbnlMYlZySVZ1VStXRllNQ2ZOZ2Z3NnVMZXFjNEpDQVlhMlQwcUpO?=
 =?utf-8?B?Yll6QzZRSzVDcEhOUENxbHkvK0s1RVdYd0FHd2dxTVFhL1R6QW9rS1N0cHFw?=
 =?utf-8?B?ektkSHNPaldQNlVzcjVKUzc4N1FlQ2wvTWlFcjhvUGRtS0lsRmQvaUM1dkZt?=
 =?utf-8?B?Y2hZcWlQSlRVNzBJeEVpRFI3ZTdYd1A1UjNDSCs0UEhUZ0VsZEJUczE1eDFU?=
 =?utf-8?B?RFZFdDNIdUNxWlhTaVB3WTFCUEYzcjNvV3NJbVBkb201QXlYeGxnUDAwalNL?=
 =?utf-8?B?NFFMeEFlR2hYZFVNM1VDSkVQQzQ5NmtySk8xNVQzUHkwaEZDcDRRcU9jR3Jp?=
 =?utf-8?B?d0FxeFIxdW10anp1cDVuOW9OS2o4d1JPUE9yYnI5VmN4WGxZTXd0K1RQQjFJ?=
 =?utf-8?B?Uzg0L0MxWHdZcW5pZk5wZXg1VEVTOGJqYWpkc0RSRDVrMVNmSzZUMGYzc01k?=
 =?utf-8?B?eU95TW1KYmpzSzJzRjBXK3FVRmY2V3NiT1FjWEpleGVjVzR5dWQ1b0VZREhy?=
 =?utf-8?B?d0xlczd6OVd3TFJRRkdMR3duQnB5Y2JyQ083UWRUTlBwY0lOWXRtZ3BoVEdy?=
 =?utf-8?B?Y1VyR1QvZitCSXFLV1JScWIvR2ZjWlpHNUJpRzJYY2ZZbGQ2UHlwOURKUEF4?=
 =?utf-8?B?WXVSV01rbGM4amNYYXVmSjgrSGtTVG96SFU4VmpXSnVvbkNOam9sS1Uyb3pL?=
 =?utf-8?B?S0k4emJ5a3RsS2J2b2pPQ3I0YWJyOENkYU9iYXV2UENPcmNMdWN0U3MvSVFx?=
 =?utf-8?B?c0VzZVpSRXllaHJ1UUJ5ZEticGpueitCK1RzY2RqeEF5dkFiand1MldSQzZL?=
 =?utf-8?B?ZGpQRGFCZXFKVDExL0c5MzRXMzVWOWU3a0E3aEtYQmJqelJUVDRTZnUzbHUw?=
 =?utf-8?B?aEZuUlE2b2NxSDE4OVlxM3ZkQllZOUI0dVV2bUsyZ0JSL2VaWEUwUG4rRzJE?=
 =?utf-8?B?aXR6ckU3UTNkU080ZmFwSk9VeFRxR1RrRnlxSWltcTVhUStPUnhDVzRVZXk3?=
 =?utf-8?B?d0JQKy9LTDN4MGhtZ3lmb0N0YUhvSkFVUVRpNmVjSE1GQSt2VVlOQVlWajlC?=
 =?utf-8?B?L2NCNmE2RDROL0o3b0t6cS9uTHFSTmFodkVoRDVZUkRPTkY3Y3p4T1FzNFhD?=
 =?utf-8?B?ZnZQdlR3aXFGbTBFNjJLb3ZZdEFoQzdoYzBRVThRZ1ZUeFhQclYrbEhUTkRF?=
 =?utf-8?B?VDVSdlZ2NWtmQzE5bGZ3WHQwN044eGlncnJKUWpGSjFQNThvMGpXL296MGZa?=
 =?utf-8?Q?KA8TsC89Ckq5OEbGSzQ7vYjBeRC5EvfzQUm3qhf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB4770.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8846ce0-ea59-457c-2cc5-08d8d9359809
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 02:32:27.9087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6HVBd5Jsgnc9VHljJB+rQywT5chL0fmxhPkFvocNYluW4ce7Ejul4FcKVLhNIXVQJD6Km/UNgMZ2ySlc85NXYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3362
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBQdWJsaWMgVXNlXQ0KDQpUaGFua3MgTHl1ZGUhDQoNClJlZ2FyZHMsDQpXYXluZQ0KDQo+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEx5dWRlIFBhdWwgPGx5dWRlQHJl
ZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBGZWJydWFyeSAyNSwgMjAyMSAyOjA5IEFNDQo+
IFRvOiBMaW4sIFdheW5lIDxXYXluZS5MaW5AYW1kLmNvbT47IGRyaS1kZXZlbEBsaXN0cy5mcmVl
ZGVza3RvcC5vcmcNCj4gQ2M6IHZpbGxlLnN5cmphbGFAbGludXguaW50ZWwuY29tOyBzdGFibGVA
dmdlci5rZXJuZWwub3JnOyBLYXpsYXVza2FzLCBOaWNob2xhcyA8TmljaG9sYXMuS2F6bGF1c2th
c0BhbWQuY29tPjsgV2VudGxhbmQsIEhhcnJ5DQo+IDxIYXJyeS5XZW50bGFuZEBhbWQuY29tPjsg
WnVvLCBKZXJyeSA8SmVycnkuWnVvQGFtZC5jb20+OyBCcm9sLCBFcnlrIDxFcnlrLkJyb2xAYW1k
LmNvbT47IFpodW8sIFFpbmdxaW5nDQo+IDxRaW5ncWluZy5aaHVvQGFtZC5jb20+DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjIgMC8yXSBTZXQgQ0xFQVJfUEFZTE9BRF9JRF9UQUJMRSBhcyBicm9h
ZGNhc3QgcmVxdWVzdA0KPg0KPiBhbHNvIC0gSSBtZWFudCB0byByZXBseSB0byB2Miwgbm90IHYx
IDopLiBKdXN0IHNvIHlvdSBkb24ndCB3b3JyeSB0aGF0IEkgcHVzaGVkIHRoZSB3cm9uZyBwYXRj
aCBzZXJpZXMgdmVyc2lvbg0KPg0KPiBPbiBXZWQsIDIwMjEtMDItMjQgYXQgMTg6MTUgKzA4MDAs
IFdheW5lIExpbiB3cm90ZToNCj4gPiBXaGlsZSB0ZXN0aW5nIE1TVCBob3RwbHVnIGV2ZW50cyBv
biBkYWlzeSBjaGFpbiBtb25pdG9ycywgZmluZCBvdXQNCj4gPiB0aGF0IENMRUFSX1BBWUxPQURf
SURfVEFCTEUgaXMgbm90IGJyb2FkY2FzdGVkIGFuZCBwYXlsb2FkIGlkIHRhYmxlIGlzDQo+ID4g
bm90IHJlc2V0LiBEaWcgaW4gZGVlcGVyIGFuZCBmaW5kIG91dCB0d28gcGFydHMgbmVlZGVkIHRv
IGJlIGZpeGVkLg0KPiA+DQo+ID4gMS4gTGlua19Db3VudF9Ub3RhbCAmIExpbmtfQ291bnRfUmVt
YWluaW5nIG9mIEJyb2FkY2FzdCBtZXNzYWdlIGFyZQ0KPiA+IGluY29ycmVjdC4gU2hvdWxkIHNl
dCBsY3Q9MSAmIGxjcj02IDIuIENMRUFSX1BBWUxPQURfSURfVEFCTEUgcmVxdWVzdA0KPiA+IG1l
c3NhZ2UgaXMgbm90IHNldCBhcyBwYXRoIGJyb2FkY2FzdCByZXF1ZXN0IG1lc3NhZ2UuIFNob3Vs
ZCBmaXggdGhpcy4NCj4gPg0KPiA+IENoYW5nZXMgc2luY2UgdjE6DQo+ID4gKlJlZmVyIHRvIHRo
ZSBzdWdnZXN0aW9uIGZyb20gVmlsbGUgU3lyamFsYS4gV2hpbGUgcHJlcGFyaW5nIGhkci1yYWQs
DQo+ID4gdGFrZSBicm9hZGNhc3QgY2FzZSBpbnRvIGNvbnNpZGVyYXRpb24uDQo+ID4NCj4gPiBX
YXluZSBMaW4gKDIpOg0KPiA+ICAgZHJtL2RwX21zdDogUmV2aXNlIGJyb2FkY2FzdCBtc2cgbGN0
ICYgbGNyDQo+ID4gICBkcm0vZHBfbXN0OiBTZXQgQ0xFQVJfUEFZTE9BRF9JRF9UQUJMRSBhcyBi
cm9hZGNhc3QNCj4gPg0KPiA+ICBkcml2ZXJzL2dwdS9kcm0vZHJtX2RwX21zdF90b3BvbG9neS5j
IHwgMTcgKysrKysrKysrKysrLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlv
bnMoKyksIDUgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiAtLQ0KPiA+IDIuMTcuMQ0KPiA+DQo+DQo+
IC0tDQo+IFNpbmNlcmVseSwNCj4gICAgTHl1ZGUgUGF1bCAoc2hlL2hlcikNCj4gICAgU29mdHdh
cmUgRW5naW5lZXIgYXQgUmVkIEhhdA0KPg0KPiBOb3RlOiBJIGRlYWwgd2l0aCBhIGxvdCBvZiBl
bWFpbHMgYW5kIGhhdmUgYSBsb3Qgb2YgYnVncyBvbiBteSBwbGF0ZS4gSWYgeW91J3ZlIGFza2Vk
IG1lIGEgcXVlc3Rpb24sIGFyZSB3YWl0aW5nIGZvciBhIHJldmlldy9tZXJnZSBvbiBhDQo+IHBh
dGNoLCBldGMuIGFuZCBJIGhhdmVuJ3QgcmVzcG9uZGVkIGluIGEgd2hpbGUsIHBsZWFzZSBmZWVs
IGZyZWUgdG8gc2VuZCBtZSBhbm90aGVyIGVtYWlsIHRvIGNoZWNrIG9uIG15IHN0YXR1cy4gSSBk
b24ndCBiaXRlIQ0KDQo=
