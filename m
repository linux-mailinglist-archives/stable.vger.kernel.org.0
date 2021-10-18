Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F07A431F15
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhJROPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:15:02 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:54497
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233473AbhJROO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:14:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Na3nsYZgHvJ/fvIUVbnJox9C8R2FvRTaH1FgS4cHlLgt6jy1V7ZzcZjjHokOxH41I1xToBLjb13MRTNlQccM92wkKmdui5qlMxqhKo/B8dJ+h714t+d9hNS+HQt0Ssvi2hupFAdv9RB3jVfS8xgldLAZLFG9DA+nG4PGgeqzxlNapplwgNZhgsJ6T20EBRZI81TaDP0LV7Ikpw7jY6Rr1ULg9H8ivMwrUulDl3GsPSxhqYhj4A8HxlzDUQ6eOTLsc0JyLVseXO1nOAjrk/wqtb1ocFIo6rsYkRZN3epU0jhgcXqkmUGWyj5WH0cg7zIzAvfPqx+86UHN7rWlAWk0nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2kXKh7bix7h2tyg8ShTWYQpgUSHobFWWnckCtVAqLs=;
 b=jtdwFuwMgWC8tCzH9d5JHKUH+odXpZyi2ID/vVS08rzcmtfk4H9EAPrDRgNos9BtARe1+tIpo8HepCOKQDqu90ALZgxrWA0tAr+cQvkV3LuGBKmeCRCRKrp9pBHG9J0Sfg4ONn4ujf1ohtjjCI2LRakYF37fmhsEEuDuUo0z6ngYFkbi5goTuxx1uMWYY/wq3yeJ4EM9B6C1sGzZeiiItnMAiGCEcSYDVtiz4+lpzjVasEBffo3bhyLKed2POWk5qsivfU2uwyG/mcBODCdsgmGAN1z8JfMikvkOiA/ouIFOGCk0k0Z/8/KGfvAfeJKeisAI2WSS38HIzAeFMsiEWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2kXKh7bix7h2tyg8ShTWYQpgUSHobFWWnckCtVAqLs=;
 b=DaQva/W7muhPw//OajiRKZTFWdxigjDyqssE1b4lvNYB2lIEzaR5SbLSlpwUkMRpVI6XeJrUjIhobs8nP3Z/HSnLw/8W/c1er6wVE28o3qVoPosC8/qMy77YRJjTfkgdaE19HJT0VnTADFOeNq/wTby3HRzUTu7dlvrGzbGI1OI=
Received: from BN6PR1201MB0084.namprd12.prod.outlook.com
 (2603:10b6:405:57::22) by BN8PR12MB3364.namprd12.prod.outlook.com
 (2603:10b6:408:40::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Mon, 18 Oct
 2021 14:12:42 +0000
Received: from BN6PR1201MB0084.namprd12.prod.outlook.com
 ([fe80::dc6f:56bf:4457:147e]) by BN6PR1201MB0084.namprd12.prod.outlook.com
 ([fe80::dc6f:56bf:4457:147e%11]) with mapi id 15.20.4608.018; Mon, 18 Oct
 2021 14:12:42 +0000
From:   "Li, Roman" <Roman.Li@amd.com>
To:     "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/amd/display: Fully switch to dmub for all dcn21 asics
Thread-Topic: [PATCH] drm/amd/display: Fully switch to dmub for all dcn21
 asics
Thread-Index: AQHXwhSZKFPMMRvdk0Wzn/vCdRWTM6vYx5EAgAAEZ4CAAAQQkA==
Date:   Mon, 18 Oct 2021 14:12:42 +0000
Message-ID: <BN6PR1201MB0084B6A5C3AD41992733A1C289BC9@BN6PR1201MB0084.namprd12.prod.outlook.com>
References: <1634337100-12682-1-git-send-email-Roman.Li@amd.com>
 <7076d49f-b450-d500-fdea-2ec3e59cbf80@amd.com>
 <e80eeccc-86e0-932a-da29-3bb58cc29518@amd.com>
In-Reply-To: <e80eeccc-86e0-932a-da29-3bb58cc29518@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=5f97165d-d325-40bb-a843-f9b7bb0244cc;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP
 2.0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-10-18T14:12:01Z;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebd6fe2b-123e-4db9-3501-08d9924159a7
x-ms-traffictypediagnostic: BN8PR12MB3364:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB336446AAC39456430BC4724789BC9@BN8PR12MB3364.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GT7vt46nPHjXY60A3oHCZrzXhajvkqNh3rHJ18ahVSgeFG0S/2JTf6wK4pQpo0q2usq0qoFKsKh4d79GZ+lZAuiWynqQD+pEltZJ13EmYqEFtFVroWXIUS5zulfDuUPT91YlU04KC8J8tG6/VBupgJy81EQQl0AIwOq+s1TW0eSZMraqz/wmIzu1FpqxlUh/jtio1yngozC/ES4hpJaHQ02/jnS16VnwFFxTpM7yjWxPq5Nzrs8aqlxbYBzJ37EZ3Iukrao9xfvlre46wHYOcfBt0+7kFi3uu1mwZpRMlWJWJ0Xp1/mb/8O5HLF775br+4tFiDhKLZRcORxinwNYR4+uKWnbhxG7YfKo+eqfoCEM0mdwn90tnkSQSkFR5z6QJiuusLHpn/mOOBGBaU37k75lxPQPVbMehe+J8jKbRSvW4Fv083vaVCY22B/sxZLgVWCiMS/jjDYfodNdmu8BTfQ6Qj8VrB+kJPXJ9/5K/yqvQrZbK5sz06EqHrHSTATLHJ7XfELiHycNEH7gDNjAuMJqvdtWAdszYjfxzC6RKqRtYNvy5BeS5WNvOA020PTx4ZY9FrXj0jWkQJu+kSKUtyH7EtJONf/v5zWGrYDrI2dK8G+LqWbId/yQjnHrRCCaiJMbxOnGIrU52zUlvAZWjHKKfxrVBddUAOdWyhZ1DKvtl+aLGY8+WjD8WjMxQHKfFUbSDceyACrXPpOAihUl+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1201MB0084.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6506007)(53546011)(66446008)(64756008)(66476007)(26005)(71200400001)(66556008)(316002)(110136005)(4001150100001)(508600001)(2906002)(38070700005)(76116006)(122000001)(33656002)(966005)(83380400001)(4326008)(8936002)(38100700002)(5660300002)(186003)(86362001)(7696005)(8676002)(6636002)(9686003)(55016002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1lYNWRqV2dsUkkrZVp2c1VtMGdrSGxDRVZEbXFpSWRrRTB6Q3MzWUhWV2tt?=
 =?utf-8?B?Qmx2cWsxTTJaQXFaL2daZDRxZ3UvODlieDVvVmlUaTdWYW12UDdud0NsNlpa?=
 =?utf-8?B?d2Y0N1FOdEduQVk2R0tqWDNxVlFGa3ZDdkw1S3hBMnB4NkFFdWJMUTZEZlpy?=
 =?utf-8?B?aFdaUmExWXVocWtkL1V5M2RaVXhpOVFCN0c5VEw5S2xLZTlRMTZOTHpIWGU5?=
 =?utf-8?B?dzBwTmEwQlJxRWpTZ052V1JqQ0Y5WWk0L3JYbnEvY2srbmNHNGVTQkpjUXg5?=
 =?utf-8?B?WFlNVXBFSHVVeEdqaEpLUEVrMFNTeHVidnQvb2c1N3RsMlh1UlpLRDdKZVNX?=
 =?utf-8?B?YjNqR3pJVHNRcytWbnA1VTFUQ01oZDJTd0F1Ym1DNHFkK3IwUjFRSzdhYXFa?=
 =?utf-8?B?REJ1MmllTzQ0QkQvNGFSQXRiZkpIR3BERDJwdTY0NHY2cWNQY0xEUFU2UnBE?=
 =?utf-8?B?ZEhyRm1vM1daQlp3RG1pMkdkVnpaZ1RCa3d6WEhiMUppekR4MXNuaEJ6Z2NW?=
 =?utf-8?B?K2dTN2NoY1JsYkRnbnJrUmJIZ0F6cmhiK2xoNTJueHBRb0Fid1VKSTMxRWYz?=
 =?utf-8?B?WWQzVHozNytFMm9mUjhQUHZzUzRkQTBaNXVCbGJVMnZ3OTMzN2NiYU1DcHRO?=
 =?utf-8?B?YVQyWmN6bFhVSjBpeHpxdlVQNE8zWDIzclo1OTN6aDhiUVQ3R3hNOWNCWEgw?=
 =?utf-8?B?RFM1OTcvWUUySjJUeDRQT3RhalJLbU9jYVhmcFNKTFQrVXd2dExWbTJTenpk?=
 =?utf-8?B?OWVRSGFnWFRnY2JYWGVjenBQRmRLU2lrNVZKR1BodkcwdWppR0p0aGs1VTF5?=
 =?utf-8?B?VFpDbTk1QXVZR0lqcHlzS3hUMFZhbEE5MkNyZmpCVTByL1pNdEZvWFZJZ3Rr?=
 =?utf-8?B?NlFLZlk3WVNSVGNlaUN3Qjl5bHNkaTd3bkNQMFpVdGh6aTQyU2U1NWpJcGsr?=
 =?utf-8?B?STNMeWl4N3hJOXo0Vk1ab1NzS0RIVGF3aCtOSW9HV0pDUnZtSTdIMTNOVEhM?=
 =?utf-8?B?ejBPTjZDT2dzSWFPRTZVM0RwMjBldGVNZkN0dzFxcVdhNmhUdWo4bTV0Smwz?=
 =?utf-8?B?SXFvUllJZ0lvNDNwVEQvaFpMMFdMZHUzUWpFYm56VThiNmcvWjkrcHBLVUFn?=
 =?utf-8?B?WjM4cWlGUHNSS3c5UmVKMUliQ05OUi9IdUtteWhjOTZVbHYyNGxCZFB0c0I1?=
 =?utf-8?B?cnNQYzVsK1NsN3pLeitUNTVFRXJodksrTmM1RURIQzc3OWRWdVdhQjVNaFcw?=
 =?utf-8?B?cGF0SjJ1dzZvWEwrdTRjNnVWYUNNYzdTeTI5M1FMVThrSTRNTS9aTkpCS2lY?=
 =?utf-8?B?ZHlQUkcvRTlTTWthc0k2djV1dk4xVVBUWmdYWkRPOTBaSklUb1FwaEkxZTJJ?=
 =?utf-8?B?ZnNNOFhVY0FMekIweWxVN1dnQlYrR3BZbHZ1RXlKU0Nja3pieTByblIwK0VE?=
 =?utf-8?B?U2I1ODlFSVBRQmllb29UOWxBNzkvQ3d2bFRhQTB0WG9hNFBmWDVrSFR1VFJo?=
 =?utf-8?B?YlozNWRZN2U5TWY3TWZUWHAvbE1SaFM2ZDdvMkErckpaZ1puMzZaZGRPcFJS?=
 =?utf-8?B?cmhWTGZrOUdHTFAzMkkyVGJXM3hIbGtnT1o3T3RpWW9yNXdDNGU1d2gvV2ZX?=
 =?utf-8?B?MUlVcFlrWm9ndnQ1dEo2UGUzZlVWa2dkT1VjT0tYSWhKc21DcHJ1bzlaQkdI?=
 =?utf-8?B?cm9idGg3VDFXVVdHOGl6VURhYk1QQ3VoODBEQWJJVVhJNngvU1puNFFKN1FG?=
 =?utf-8?Q?bvO2ZmgGPnXXdFsIvF2QSqEAeo3Gl92kExSzFGq?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1201MB0084.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd6fe2b-123e-4db9-3501-08d9924159a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 14:12:42.0677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qHHAtquBvYgizVYmXba+01FhTqAPLIt71PrUxj42fk/aaNNUaxXdQ8xwJAlmO1nY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3364
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBXZW50bGFu
ZCwgSGFycnkgPEhhcnJ5LldlbnRsYW5kQGFtZC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgT2N0b2Jl
ciAxOCwgMjAyMSA5OjU3IEFNDQo+IFRvOiBMaW1vbmNpZWxsbywgTWFyaW8gPE1hcmlvLkxpbW9u
Y2llbGxvQGFtZC5jb20+OyBMaSwgUm9tYW4NCj4gPFJvbWFuLkxpQGFtZC5jb20+OyBhbWQtZ2Z4
QGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsgRGV1Y2hlciwgQWxleGFuZGVyDQo+IDxBbGV4YW5kZXIu
RGV1Y2hlckBhbWQuY29tPjsgU2lxdWVpcmEsIFJvZHJpZ28NCj4gPFJvZHJpZ28uU2lxdWVpcmFA
YW1kLmNvbT4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSF0gZHJtL2FtZC9kaXNwbGF5OiBGdWxseSBzd2l0Y2ggdG8gZG11YiBmb3IgYWxsIGRjbjIx
IGFzaWNzDQo+DQo+DQo+DQo+IE9uIDIwMjEtMTAtMTggMDk6NDEsIExpbW9uY2llbGxvLCBNYXJp
byB3cm90ZToNCj4gPiBPbiAxMC8xNS8yMDIxIDE3OjMxLCBSb21hbi5MaUBhbWQuY29tIHdyb3Rl
Og0KPiA+PiBGcm9tOiBSb21hbiBMaSA8Um9tYW4uTGlAYW1kLmNvbT4NCj4gPj4NCj4gPj4gW1do
eV0NCj4gPj4gT24gcmVub2lyIHVzYi1jIHBvcnQgc3RvcHMgZnVuY3Rpb25pbmcgb24gcmVzdW1l
IGFmdGVyIGYvdyB1cGRhdGUuDQo+ID4+IE5ldyBkbXViIGZpcm13YXJlIGNhdXNlZCByZWdyZXNz
aW9uIGR1ZSB0byBjb25mbGljdCB3aXRoIGRtY3UuDQo+ID4+IFdpdGggbmV3IGRtdWIgZi93IGRt
Y3UgaXMgc3VwZXJzZWRlZCBhbmQgc2hvdWxkIGJlIGRpc2FibGVkLg0KPiA+Pg0KPiA+PiBbSG93
XQ0KPiA+PiAtIERpc2FibGUgZG1jdSBmb3IgYWxsIGRjbjIxLg0KPiA+Pg0KPiA+PiBDaGVjayBk
bWVzZyBmb3IgZG11YiBmL3cgdmVyc2lvbi4NCj4gPj4gVGhlIG9sZCBmaXJtd2FyZSAoYmVmb3Jl
IHJlZ3Jlc3Npb24pOg0KPiA+PiBbZHJtXSBETVVCIGhhcmR3YXJlIGluaXRpYWxpemVkOiB2ZXJz
aW9uPTB4MDAwMDAwMDEgQWxsIG90aGVyDQo+ID4+IHZlcnNpb25zIHJlcXVpcmUgdGhhdCBwYXRj
aCBmb3IgcmVub2lyLg0KPiA+Pg0KPiA+PiBCdWc6IGh0dHBzOi8vZ2l0bGFiLmZyZWVkZXNrdG9w
Lm9yZy9kcm0vYW1kLy0vaXNzdWVzLzE3MzU+Pj4gQ2M6DQo+ID4+IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCj4gPg0KPiA+IFRoaXMgd29uJ3QgYmFja3BvcnQgY2xlYW5seSB0byBzdGFibGUgNS4x
NSBhbmQgZWFybGllciBkb24ndCB1c2UgSVAgdmVyc2lvbiB0bw0KPiBkZXRlY3QgdGhlIGNoaXAu
DQo+ID4NCj4gPiBBbHNvIC0gYSBxdWVzdGlvbjogKnNob3VsZCogdGhpcyBnbyB0byBzdGFibGU/
ICBJZiBhIHVzZXIgaGFzIHRoZSBvbGRlciBGVyB3aGF0DQo+IGhhcHBlbnMgd2l0aCB0aGlzIGNo
YW5nZT8NCj4gPg0KPg0KPiBHb29kIHBvaW50LiBNaWdodCBiZSBiZXR0ZXIgb2Ygd2UgZHJvcCBD
Yzogc3RhYmxlIGZyb20gdGhpcyBwYXRjaA0KPg0KPiBIYXJyeQ0KDQpJIHdpbGwgZHJvcCAgQ2M6
IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcsIHRoYW5rIHlvdSBNYXJpbyBhbmQgSGFycnkuDQotIFJv
bWFuDQoNCj4gPj4gU2lnbmVkLW9mZi1ieTogUm9tYW4gTGkgPFJvbWFuLkxpQGFtZC5jb20+DQo+
ID4+IC0tLQ0KPiA+PiAgIGRyaXZlcnMvZ3B1L2RybS9hbWQvZGlzcGxheS9hbWRncHVfZG0vYW1k
Z3B1X2RtLmMgfCAzICstLQ0KPiA+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MiBkZWxldGlvbnMoLSkNCj4gPj4NCj4gPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9h
bWQvZGlzcGxheS9hbWRncHVfZG0vYW1kZ3B1X2RtLmMNCj4gPj4gYi9kcml2ZXJzL2dwdS9kcm0v
YW1kL2Rpc3BsYXkvYW1kZ3B1X2RtL2FtZGdwdV9kbS5jDQo+ID4+IGluZGV4IGZmNTQ1NTAuLmU1
NmY3M2UgMTAwNjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvZGlzcGxheS9hbWRn
cHVfZG0vYW1kZ3B1X2RtLmMNCj4gPj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2FtZC9kaXNwbGF5
L2FtZGdwdV9kbS9hbWRncHVfZG0uYw0KPiA+PiBAQCAtMTM1Niw4ICsxMzU2LDcgQEAgc3RhdGlj
IGludCBhbWRncHVfZG1faW5pdChzdHJ1Y3QgYW1kZ3B1X2RldmljZQ0KPiA+PiAqYWRldikNCj4g
Pj4gICAgICAgICAgIHN3aXRjaCAoYWRldi0+aXBfdmVyc2lvbnNbRENFX0hXSVBdWzBdKSB7DQo+
ID4+ICAgICAgICAgICBjYXNlIElQX1ZFUlNJT04oMiwgMSwgMCk6DQo+ID4+ICAgICAgICAgICAg
ICAgaW5pdF9kYXRhLmZsYWdzLmdwdV92bV9zdXBwb3J0ID0gdHJ1ZTsNCj4gPj4gLSAgICAgICAg
ICAgIGlmIChBU0lDUkVWX0lTX0dSRUVOX1NBUkRJTkUoYWRldi0+ZXh0ZXJuYWxfcmV2X2lkKSkN
Cj4gPj4gLSAgICAgICAgICAgICAgICBpbml0X2RhdGEuZmxhZ3MuZGlzYWJsZV9kbWN1ID0gdHJ1
ZTsNCj4gPj4gKyAgICAgICAgICAgIGluaXRfZGF0YS5mbGFncy5kaXNhYmxlX2RtY3UgPSB0cnVl
Ow0KPiA+PiAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+PiAgICAgICAgICAgY2FzZSBJUF9WRVJT
SU9OKDEsIDAsIDApOg0KPiA+PiAgICAgICAgICAgY2FzZSBJUF9WRVJTSU9OKDEsIDAsIDEpOg0K
PiA+Pg0KPiA+DQoNCg==
