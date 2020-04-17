Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22531AE487
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 20:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbgDQSMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 14:12:23 -0400
Received: from mail-bn7nam10on2076.outbound.protection.outlook.com ([40.107.92.76]:6113
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730323AbgDQSMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 14:12:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GsHG0MbyRBEFQF5AFmc7pCEBsUGEnlkvet4fqKNcWpYMnwBOkN7MgdNxSLKBnmQPWjoU7ASQnO8rY3fvYHC9G3r5Ui7kDwpFx4kJTP5S2q0xAgXxmnbxJgHM1n4rpPr+sqwhWJR2CyfZpfx7AUwmLWOZnWZdM0buFf25VIq2WEq0Be9JkvJNZ0WNLHQ8jnk60c+YsBOqINj8OsY4RmC4/X4kshqSBqyxuX8Ma25mfodCkPuSgVMuFXjukflewB2MlerO6AQEdhxNmfPKQG0rsK8WzCphUshbQ6DIfRMKL81+iXA1eONCZ2iV7uT04H8AnPIIap0o9T50VyhudrzjHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAMYeLDTn6vdMcYYxeInCQr06iHt9XfYyBXWDbJDKIo=;
 b=IqJUNxhWBIlgrZ4WxtqD3e0gDzExhdxRjdYaNcRR6oC7RC5I4O7s76bXrxm/Bqu/kKRR6dbclK+e+XxEHCV+pq9+G2mlZMbmzUrLMpgVSvW8vGbb2fe7ZhHGoULLz5mTkc5kAP+HB3unIEk0zzhmBb6zzBHH+Xcpd++IXrF0PgWRHKjFgs3CYE8OWLhxUqrH6jxhR+SN/W2oYdJnFty4WwR9fRj/QaviM9+xsWZ6j4Hk4G+tAk8Zn6bVsf4guY5ATwGwkqRBkakzoDztS62/jNCw7hNowFUsnvBR+4kJDCCCx46HKWX5+otDU5NfjMDHnirarnutMePD33UWfuiATA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAMYeLDTn6vdMcYYxeInCQr06iHt9XfYyBXWDbJDKIo=;
 b=azSi1kqEbM2ko2zCV6c+RzmRccZYKtfz3JHZCVrBpfeSPfA2a4KZJFV2pDYN3uoqpYEnC9ML7tNh6r2ehrIg8g8AkNicmIKgrGbJVcrhKVHLZare21UuwB9igLa4s5J6fQIfWoRPCXRPOV9qj5ljyetVEvLS/clUougDiV6aDKc=
Received: from MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19)
 by MN2PR12MB3727.namprd12.prod.outlook.com (2603:10b6:208:15a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Fri, 17 Apr
 2020 18:12:17 +0000
Received: from MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::5868:c9cf:2687:6e03]) by MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::5868:c9cf:2687:6e03%2]) with mapi id 15.20.2900.028; Fri, 17 Apr 2020
 18:12:17 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernelnorg>,
        "Liang, Prike" <Prike.Liang@amd.com>,
        stable <stable@vger.kernel.org>
Subject: RE: Linux 5.7-rc1 reboot/poweroff hangs
Thread-Topic: Linux 5.7-rc1 reboot/poweroff hangs
Thread-Index: AQHWFOLUGXQZ/t95ZEu/Ud0JcsF7Oah9nQ+Q
Date:   Fri, 17 Apr 2020 18:12:17 +0000
Message-ID: <MN2PR12MB44883C67DC09CE3487F29166F7D90@MN2PR12MB4488.namprd12.prod.outlook.com>
References: <b8eaee2b-21dd-c0de-f522-d58bb9ae31da@linuxfoundation.org>
In-Reply-To: <b8eaee2b-21dd-c0de-f522-d58bb9ae31da@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Enabled=true;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SetDate=2020-04-17T18:12:15Z;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Method=Standard;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Name=Internal Use Only -
 Unrestricted;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ActionId=c8c6c179-bc3e-4d7a-8684-0000d5d3e653;
 MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ContentBits=1
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_enabled: true
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_setdate: 2020-04-17T18:12:15Z
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_method: Standard
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_name: Internal Use Only -
 Unrestricted
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_actionid: 6a3fa457-cef7-4e83-916e-000067b1ee5c
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_contentbits: 0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Alexander.Deucher@amd.com; 
x-originating-ip: [172.58.187.145]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 432fdfc4-5505-433e-c4cd-08d7e2fadd13
x-ms-traffictypediagnostic: MN2PR12MB3727:|MN2PR12MB3727:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB3727BFFCF7873819DD50B7D0F7D90@MN2PR12MB3727.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4488.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(5660300002)(9686003)(186003)(33656002)(4326008)(76116006)(53546011)(478600001)(66946007)(2906002)(71200400001)(7696005)(81156014)(8676002)(316002)(6506007)(66556008)(66476007)(26005)(66446008)(64756008)(86362001)(55016002)(966005)(54906003)(110136005)(52536014)(8936002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uktcpTgefxbc0SElViAjS6WoSYoAoWzysY3r+AUXREqrFQwItoutZTCr0YUMBaDQLKfRLf2dUUvXD1i6h2Pnbx278YCOxkFd9GYHvnex+PiUxy3aeXYGZtQsVUSIQSoaSMvH+Mc8B4DRM8LQLGuQVKFFRYcP+BMjTvU0bDnpIkNSQ8GfaDR0i2RqHW3WVzdM4IpPQajyMeSWGqWFjsN/7dw5cZ3DGOLRi9jSOgeOEZMkA2R5Zb3mThPsYr/oOLwtgFwMLfJ0os/fK6dNGXqpL9Wim+uPffzR15AkkoFcvnCyH9FhXsqzbnhQM6AwrKXpUmv+u77T+HFDczto9Sjxm1rcnfR+O39oUljeiOukKsBrIswoxkKozHXTpoojcjRyz6OCV2vPfrk5nLpTAcBFczG2NSipuNjasS+PaIlyMImctJMzdKV3lXvKwsMw9/tmukQVPcfuESr+jL4ICVKyy990WV6gzOighksIJq+bsG0=
x-ms-exchange-antispam-messagedata: v6DmH+6VgCN5fdQlHwoyNffS2PQ3GMG7tVDNGzUYyPHX4GMTMCEpF8FopEvpDBoQ7jyqvsjOrQwmWb2Zq8YuugQhd6ehlLl2AQFoa8uTAtRjSYDLzPR5hWvlCCBchH5bI1Idb3FH7LMsQYC58l7cbQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 432fdfc4-5505-433e-c4cd-08d7e2fadd13
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 18:12:17.2536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y6KXtn2yD5lrKNBEAW78bFc+wNz+0Fqz7BahgEwrIDohFfNOHQbs+ogIqiRTL/MH9G2HoAsrYVXTaGcU5ItS9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3727
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEludGVybmFsIERpc3RyaWJ1dGlvbiBPbmx5XQ0KDQo+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNodWFoIEtoYW4gPHNraGFuQGxp
bnV4Zm91bmRhdGlvbi5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgQXByaWwgMTcsIDIwMjAgMjowNiBQ
TQ0KPiBUbzogTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0K
PiBDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47IFNo
dWFoIEtoYW4NCj4gPHNraGFuQGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBMS01MIDxsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWxub3JnPjsNCj4gTGlhbmcsIFByaWtlIDxQcmlrZS5MaWFuZ0BhbWQuY29t
PjsgRGV1Y2hlciwgQWxleGFuZGVyDQo+IDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPjsgc3Rh
YmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBMaW51eCA1LjctcmMxIHJl
Ym9vdC9wb3dlcm9mZiBoYW5ncw0KPiANCj4gSGkgTGludXMsDQo+IA0KPiBMaW51eCA1LjctcmMx
IHJlYm9vdC9wb3dlcmVvZmYgaGFuZ3Mgb24gQU1EIFJ5emVuIDUgUFJPIDI0MDBHRSBzeXN0ZW0u
DQo+IA0KPiBJIGlzb2xhdGVkIHRoZSBjb21taXQgdG86DQo+IA0KPiBSZXZlcmluZyB0aGUgZm9s
bG93aW5nIGNvbW1pdCBmaXhlcyB0aGUgcHJvYmxlbS4NCg0KVGhlIGZpeCBpcyBhbHJlYWR5IHNl
bnQgb3V0IGluIG15IC1maXhlcyBwdWxsIGZvciB0aGlzIHdlZWs6DQpodHRwczovL2NnaXQuZnJl
ZWRlc2t0b3Aub3JnL35hZ2Q1Zi9saW51eC9jb21taXQvP2g9ZHJtLWZpeGVzLTUuNyZpZD1iMmE3
ZTk3MzVhYjI4NjQzMzBiZTlkMDBkN2YzOGM5NjFjMjhkZTVkDQoNCkFsZXgNCg0KPiANCj4gY29t
bWl0IDQ4N2VjYTExYTMyMWVmMzNiY2Y0Y2E1YWRiM2MwYzQ5NTRkYjFiNTgNCj4gQXV0aG9yOiBQ
cmlrZSBMaWFuZyA8UHJpa2UuTGlhbmdAYW1kLmNvbT4NCj4gRGF0ZTogICBUdWUgQXByIDcgMjA6
MjE6MjYgMjAyMCArMDgwMA0KPiANCj4gICAgICBkcm0vYW1kZ3B1OiBmaXggZ2Z4IGhhbmcgZHVy
aW5nIHN1c3BlbmQgd2l0aCB2aWRlbyBwbGF5YmFjayAodjIpDQo+IA0KPiAgICAgIFRoZSBzeXN0
ZW0gd2lsbCBiZSBoYW5nIHVwIGR1cmluZyBTMyBzdXNwZW5kIGJlY2F1c2Ugb2YgU01VIGlzDQo+
ICAgICAgcGVuZGluZyBmb3IgR0Mgbm90IHJlc3Bvc2UgdGhlIHJlZ2lzdGVyIENQX0hRRF9BQ1RJ
VkUgYWNjZXNzDQo+ICAgICAgcmVxdWVzdC5UaGlzIGlzc3VlIHJvb3QgY2F1c2Ugb2YgYWNjZXNz
aW5nIHRoZSBHQyByZWdpc3RlciB1bmRlcg0KPiAgICAgIGVudGVyIEdGWCBDR0dQRyBhbmQgY2Fu
IGJlIGZpeGVkIGJ5IGRpc2FibGUgR0ZYIENHUEcgYmVmb3JlIHBlcmZvcm0NCj4gICAgICBzdXNw
ZW5kLg0KPiANCj4gICAgICB2MjogVXNlIGRpc2FibGUgdGhlIEdGWCBDR1BHIGluc3RlYWQgb2Yg
UkxDIHNhZmUgbW9kZSBndWFyZC4NCj4gDQo+ICAgICAgU2lnbmVkLW9mZi1ieTogUHJpa2UgTGlh
bmcgPFByaWtlLkxpYW5nQGFtZC5jb20+DQo+ICAgICAgVGVzdGVkLWJ5OiBNZW5nYmluZyBXYW5n
IDxNZW5nYmluZy5XYW5nQGFtZC5jb20+DQo+ICAgICAgUmV2aWV3ZWQtYnk6IEh1YW5nIFJ1aSA8
cmF5Lmh1YW5nQGFtZC5jb20+DQo+ICAgICAgU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxh
bGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPg0KPiAgICAgIENjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnDQo+IA0KPiANCj4gSSBkaWQgdGhlIGJpc2VjdCBvbiBMaW51eCA1LjYuNS1yYzENCj4gDQo+
IGdpdCBiaXNlY3Qgc3RhcnQNCj4gIyBnb29kOiBbMGEyN2EyOTQ5NjA2MDg0M2FlM2E4ZmU3OGFh
ZWMwMDYyY2JkNWRmYV0gTGludXggNS42LjQgZ2l0IGJpc2VjdA0KPiBnb29kIDBhMjdhMjk0OTYw
NjA4NDNhZTNhOGZlNzhhYWVjMDA2MmNiZDVkZmENCj4gIyBiYWQ6IFs1NzZhYTM1Mzc0NGNlNWYx
Mjc5MDcxMzYzZTRhNTVlOTdmNDg2ZjM5XSBMaW51eCA1LjYuNS1yYzEgZ2l0DQo+IGJpc2VjdCBi
YWQgNTc2YWEzNTM3NDRjZTVmMTI3OTA3MTM2M2U0YTU1ZTk3ZjQ4NmYzOQ0KPiAjIGdvb2Q6IFs3
NTA5ZGI1ZDExMWE1NzYzYTE5OTkwMjA1MmVlY2M0ODBlMGVjNzI0XSB4ODYvdHNjX21zcjogTWFr
ZQ0KPiBNU1IgZGVyaXZlZCBUU0MgZnJlcXVlbmN5IG1vcmUgYWNjdXJhdGUgZ2l0IGJpc2VjdCBn
b29kDQo+IDc1MDlkYjVkMTExYTU3NjNhMTk5OTAyMDUyZWVjYzQ4MGUwZWM3MjQNCj4gIyBnb29k
OiBbMTVmMWVhZDdkNzk2NmQwODczNTJiYTJjZjgxYTE3NTliMjVhZDE2M10gc2NzaTogbHBmYzog
Rml4IGJyb2tlbg0KPiBDcmVkaXQgUmVjb3ZlcnkgYWZ0ZXIgZHJpdmVyIGxvYWQgZ2l0IGJpc2Vj
dCBnb29kDQo+IDE1ZjFlYWQ3ZDc5NjZkMDg3MzUyYmEyY2Y4MWExNzU5YjI1YWQxNjMNCj4gIyBn
b29kOiBbOWU1MmI0YWI1ZmFkZDgwM2M4YzJlNjE3YWE4YzE1MTcyMDc1N2ZiMV0gczM5MC9kaWFn
OiBmaXggZGlzcGxheQ0KPiBvZiBkaWFnbm9zZSBjYWxsIHN0YXRpc3RpY3MgZ2l0IGJpc2VjdCBn
b29kDQo+IDllNTJiNGFiNWZhZGQ4MDNjOGMyZTYxN2FhOGMxNTE3MjA3NTdmYjENCj4gIyBnb29k
OiBbM2UxZTY5MDM5MjRmZDZjOTVkYjdlNDZjNWJhYTQxZGZhMGY0NmZkYl0NCj4gcG93ZXJwYy9o
YXNoNjQvZGV2bWFwOiBVc2UgSF9QQUdFX1RIUF9IVUdFIHdoZW4gc2V0dGluZyB1cCBodWdlDQo+
IGRldm1hcCBQVEUgZW50cmllcyBnaXQgYmlzZWN0IGdvb2QNCj4gM2UxZTY5MDM5MjRmZDZjOTVk
YjdlNDZjNWJhYTQxZGZhMGY0NmZkYg0KPiAjIGdvb2Q6IFswMzQ0ZTBmZWUyZjkwNGViY2UxZDU4
YmVjOGFjZTNlZTljZjVmNzc3XSBkcm0vZHBfbXN0OiBGaXgNCj4gY2xlYXJpbmcgcGF5bG9hZCBz
dGF0ZSBvbiB0b3BvbG9neSBkaXNhYmxlIGdpdCBiaXNlY3QgZ29vZA0KPiAwMzQ0ZTBmZWUyZjkw
NGViY2UxZDU4YmVjOGFjZTNlZTljZjVmNzc3DQo+ICMgYmFkOiBbMTM2ODgxYzA0MjBiYjUyZDVm
MjFmNzU2ODhmNWFlZTFjZjQwMTczN10gcGVyZi9jb3JlOiBVbmlmeQ0KPiB7cGlubmVkLGZsZXhp
YmxlfV9zY2hlZF9pbigpDQo+IGdpdCBiaXNlY3QgYmFkIDEzNjg4MWMwNDIwYmI1MmQ1ZjIxZjc1
Njg4ZjVhZWUxY2Y0MDE3MzcNCj4gIyBiYWQ6IFswZDkyOGI0MjRiOTljZmUwZTc4MDZjNTMwZjYw
MzlhMDUzZDUwODJkXSBkcm0vaTkxNS9nZ3R0OiBkbyBub3QNCj4gc2V0IGJpdHMgMS0xMSBpbiBn
ZW4xMiBwdGVzIGdpdCBiaXNlY3QgYmFkDQo+IDBkOTI4YjQyNGI5OWNmZTBlNzgwNmM1MzBmNjAz
OWEwNTNkNTA4MmQNCj4gIyBiYWQ6IFthNjU1YTk5YzlmNmExZDgxOWQ2OTVmY2E2ZDQ4YjQ1MDQ0
OWY0NWVlXSBkcm0vYW1kZ3B1OiBmaXggZ2Z4DQo+IGhhbmcgZHVyaW5nIHN1c3BlbmQgd2l0aCB2
aWRlbyBwbGF5YmFjayAodjIpIGdpdCBiaXNlY3QgYmFkDQo+IGE2NTVhOTljOWY2YTFkODE5ZDY5
NWZjYTZkNDhiNDUwNDQ5ZjQ1ZWUNCj4gIyBmaXJzdCBiYWQgY29tbWl0OiBbYTY1NWE5OWM5ZjZh
MWQ4MTlkNjk1ZmNhNmQ0OGI0NTA0NDlmNDVlZV0NCj4gZHJtL2FtZGdwdTogZml4IGdmeCBoYW5n
IGR1cmluZyBzdXNwZW5kIHdpdGggdmlkZW8gcGxheWJhY2sgKHYyKQ0KPiANCj4gDQo+IHRoYW5r
cywNCj4gLS0gU2h1YWgNCg==
