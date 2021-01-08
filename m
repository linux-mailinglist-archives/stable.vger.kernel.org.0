Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1712EED66
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 07:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbhAHGUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 01:20:36 -0500
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:21116
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726027AbhAHGUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 01:20:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDU2ETt4wLedu1BfA6+ZGf1gig6a65p2W0SaJ7ME3j3zHnd1HnyBVGV7n7MlQ+H6twrWja3AtWXPfTuFoxaDnH2gcFwGJDHpl+5zAuTZTDPIrxqRs8wGX4BeYevXaXD5d2pDrVN8Z5cJd3NDKFtSm2GpuugQvQh8xQxxgmHtUtkqNz5O2iLFxpLMzf7KXRqD6gpWASa7HpGqZ1PoNRHmMXrNuYAMhlfUy/JdimJCDcsioL7/eXitJ0VTtPtLDpSR8cugCuR2aMNo/uhgckcdAAq1XPABPhIXy7xoriztk70bdT0JKoOb4r6oH5xkAgtN1mr/IMAbYJsrE7SnZHZxSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wN3fwTmW8TwOS9Z/yMEUH2Frg1gJJnq78yZOpGesX/M=;
 b=ld3bAqT4QuP4erAzzY6NGtz72m1ERBWQBvzz3/UxgjPtZY+34J4zfjP1KttrEjCY6KC22c4b5+0PJbqcV+1fHvHLpOv/AKAepXxZLDVvrY+hESolFgPfIg0ELScRPBvIsun8vlAjPF7J3bxlHBZxPX2hsb14VtsPUBqxgVLh10OQRZCRUMpUvADGE3dbL7Czizq2g0rPcNnNCEa8OjuU+W80+ZYII3x4w0LzT1493OcHiOGvqeBTvYlCID0lUtlv1iFuWFjdLEuheYnT7nDXhTevAS11J40G1FRj3q/66cAPRxmT1/elA25Y2Nm9VeiEmOKHIAhP6MhTpWpJjxhi6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wN3fwTmW8TwOS9Z/yMEUH2Frg1gJJnq78yZOpGesX/M=;
 b=fhlbIBsCVEAH51hbpCK8R5TIiFi4WFXc2HrjPwRNCJjOZaO50VOGJWk44iHy89zn9PYiboMN3Az3Eh9OUQmu6KK+TwSEFv31z70XlDlV870yJRs+SpC+MocxkVEFxt8+xmMgd6jgLUYtFAzsdhBjtl1U/HbK8FTxiQ27FbItegQ=
Received: from DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10)
 by DM6PR12MB3017.namprd12.prod.outlook.com (2603:10b6:5:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 06:19:42 +0000
Received: from DM6PR12MB4388.namprd12.prod.outlook.com
 ([fe80::84e9:dd44:12cf:bdb3]) by DM6PR12MB4388.namprd12.prod.outlook.com
 ([fe80::84e9:dd44:12cf:bdb3%6]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 06:19:42 +0000
From:   "Chatradhi, Naveen Krishna" <NaveenKrishna.Chatradhi@amd.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        David Arcari <darcari@redhat.com>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>
CC:     Jean Delvare <jdelvare@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] hwmon: (amd_energy) fix allocation of hwmon_channel_info
 config
Thread-Topic: [PATCH] hwmon: (amd_energy) fix allocation of hwmon_channel_info
 config
Thread-Index: AQHW5QQZdSyCjckTx0WGIHiGz4uxF6odMEOAgAARggCAAAA3EA==
Date:   Fri, 8 Jan 2021 06:19:42 +0000
Message-ID: <DM6PR12MB4388E1D56BA6983DE71D2750E8AE0@DM6PR12MB4388.namprd12.prod.outlook.com>
References: <20210107144707.6927-1-darcari@redhat.com>
 <DM6PR12MB4388220A9F55F5DDC984B91FE8AE0@DM6PR12MB4388.namprd12.prod.outlook.com>
 <aac56718-c757-6bfd-7932-b18cf7d4254d@roeck-us.net>
In-Reply-To: <aac56718-c757-6bfd-7932-b18cf7d4254d@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Enabled=true;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_SetDate=2021-01-08T06:19:21Z;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Method=Privileged;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Name=Internal Use Only -
 Restricted;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_ActionId=3cdc936c-14e0-4965-9393-000012209c06;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_ContentBits=1
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_enabled: true
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_setdate: 2021-01-08T06:19:01Z
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_method: Standard
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_name: Internal Use Only -
 Unrestricted
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_actionid: a3f24948-8fee-4c6c-ad85-000029a35e32
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_contentbits: 0
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_enabled: true
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_setdate: 2021-01-08T06:19:38Z
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_method: Privileged
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_name: Internal Use Only -
 Restricted
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_actionid: 9a7cb523-f813-4f47-9f8c-0000b89639dd
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_contentbits: 0
dlp-product: dlpe-windows
dlp-version: 11.5.0.60
dlp-reaction: no-action
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=amd.com;
x-originating-ip: [175.101.104.147]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aa38195e-09e0-4bd9-d888-08d8b39d62f1
x-ms-traffictypediagnostic: DM6PR12MB3017:
x-microsoft-antispam-prvs: <DM6PR12MB3017BAB4814CBAF453324618E8AE0@DM6PR12MB3017.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z2whSWOtvob4EYLIOyRTN5DrotEBfbDKOfxkrvfbTcU+rekC0ZbOfoFx9l5aNk5M7skfH2DijBIpbfzezAai5MSeUr71sC8QhOGqsqPI+N9oD1qLFeOZQF48g8kVM/HU48lvv7/83UrmpvQT0Y7dCAngy+Y67YJmjXCtKPnQ1tHKDDA+Y9jIEgK5HClY0CUA9pJlTFAl6yiQgPVKyTyO+TUL+Nfrh0SIaTf+UK2HWakEQ5wjMmVYfc7IYllIsyHyZKTC3v1z6JjU0++1URFfLCh1RShOwAlFAO812EZZEXpyQO7LynEdrm8h5rLReqTLU7SD6jyuulodk+Md6GAGi+8u2LsVv8WcaxSwbgTVxGJVCxiQFoFMRnVojnKv5hi7BqDfZwQdBo9q05JMpWGYCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4388.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(66946007)(66446008)(76116006)(53546011)(66556008)(71200400001)(5660300002)(66476007)(64756008)(54906003)(6506007)(8936002)(110136005)(2906002)(52536014)(478600001)(7696005)(9686003)(55016002)(8676002)(33656002)(4326008)(26005)(86362001)(83380400001)(186003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UkpsY1F2VkZranM4MzVLZVBvd3hJelZyWVVwUUVPbWpFK3FwUy9ic3dvNWg5?=
 =?utf-8?B?T2FBWnZiaC9pVkRROUpEZmRJeUF6RStpNk5uZ3pWek1vNTQ3czMrSVFWSXdF?=
 =?utf-8?B?SmZIMmpDUzdNYjVDSlJRVHB2Ly9LRTlOa01QdG1DcDBaM29lYlJwYlJTWXNr?=
 =?utf-8?B?ZHZsV3QwdnFPWTdNbU1uNzNleXJMQ2JTQXVqaElob1ppNUtPSmt0RGlKVTFC?=
 =?utf-8?B?UkVqUUJvV1RrVW5vYXFWNGd1a0tZSk1XV2Y4bmlsTGJWa3FUd0dsR0prWEJm?=
 =?utf-8?B?ZGxZeitpV0Zkeks0OWZXKzlVamMweEN2OUZPcXUxRk1wRWJPZ0xRUmdjWVZt?=
 =?utf-8?B?Ukl6NVpYcENrejN6NzJIMUUxMUI3eTF1d2pBWm50UUpwNzUxN3E4NDlzM0V2?=
 =?utf-8?B?RFhTMmZnTHR0ZWRKa3BPV3RSMnJVajFVak1tV1hNOE9hL2JzcmdON1Fjb2to?=
 =?utf-8?B?QXBVZEgvak9PNEpwY0d2RkdqWnR2ckQ3bnl3eG5rWmkzR09Pc3BKek9pV0lI?=
 =?utf-8?B?SjdERFdRbEF3STdKTThDajJrQkFGNmVsd3JPUTVTbTR2b28zQnhFZ2Q5TXFi?=
 =?utf-8?B?ZEZJd1JCSXNqM0tUeVlTcHo4djhFYkZsV2lxY2t4bmpWWEtaM3dQR1Bwa2tU?=
 =?utf-8?B?MGVxelp2cTd3RndQemxmZFZGSW5lS2lVUmhzZTZRY2dSdnUrcUxMT2x4blNm?=
 =?utf-8?B?a04zTDBPZ2EwajVYZFpVQUtGQmY2STFVMG1FbGNpczFxZ3BVOFZLRXZuY0k3?=
 =?utf-8?B?UkVRNXpHY3N6Rk5IanBTaXBoQWdXcXdleVZpMTdGSkxSdlRpMjF4bmJXSmRO?=
 =?utf-8?B?d0xLYTN5a0tzbnZ4SDBtY3VHd2NGWUZ1dkVsV3g0RFBxcC9DYVJPaHNMOTJk?=
 =?utf-8?B?c0Z4UjY3NGNpVlJ1b09IYVlxUTk1L2YyN2FoVlRuUmpIazZhcmhuUDhBUGFp?=
 =?utf-8?B?dXNJUDRsWkx4Z3lPc3hGSEV6NW1ScW9rOUtOSGExWjR3bVhiN3hFL1Mxc2pp?=
 =?utf-8?B?OWNsQk9Qdm5KZ3VkRUZpd1pjMmg2NzF2YUUwa2Y1YVVGc2ZIZHVXTUxBbFZ5?=
 =?utf-8?B?Ykt5SldOTWtUSjBkMXp5Q2Z0amYya0luS0VlWkFLbkhNR2NPS1oxZnR0M0Q4?=
 =?utf-8?B?NUowZldPeXdwZWF3bi9CcCtSRUlTWUhtaFAzaExoT2VJR05yNVRveXdwbG84?=
 =?utf-8?B?VjZaUlNDY01uemZXdkx3THVVUks1ajI3VysxakxCbFhKTUZUUE5ySUhhY1pM?=
 =?utf-8?B?RUMxUHVGbEVpWERJaFJILzJEYURiTFEyVkZGT3EyOGRpK20vYlhIaG94UzRC?=
 =?utf-8?Q?oXw8RoU38LPPQ=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4388.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa38195e-09e0-4bd9-d888-08d8b39d62f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2021 06:19:42.2705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H4rRx+n3UXZwRBQDB4KDuKoVJ55HOyqqwaf28R5KqnzN1Z8Y1Ud4GSMxpD4SNGkLweROpLDY25lKBmQ2fPZ3ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3017
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFwcHJvdmVkIGZvciBFeHRlcm5hbCBVc2VdDQoNCkhp
IEd1ZW50ZXIsDQoNCj4+IE5vLCBiZWNhdXNlIHlvdSBhcmUgbm90IGluIHRoZSBhcHByb3ZhbCBw
YXRoICh5b3UgZGlkIG5vdCBzZW5kIHRoZSBwYXRjaCB0byBtZSkuIFJldmlld2VkLWJ5OiBvciBB
Y2tlZC1ieTogd291bGQgYmUgbW9yZSBhcHByb3ByaWF0ZS4NCg0KR290IGl0LCBteSBtaXN0YWtl
LCBwbGVhc2UgdXNlIA0KQWNrZWQtYnk6IE5hdmVlbiBLcmlzaG5hIENoYXRyYWRoaSA8bmNoYXRy
YWRAYW1kLmNvbT4NCg0KUmVnYXJkcywNCk5hdmVlbmsNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCkZyb206IEd1ZW50ZXIgUm9lY2sgPGdyb2VjazdAZ21haWwuY29tPiBPbiBCZWhhbGYg
T2YgR3VlbnRlciBSb2Vjaw0KU2VudDogRnJpZGF5LCBKYW51YXJ5IDgsIDIwMjEgMTE6NDcgQU0N
ClRvOiBDaGF0cmFkaGksIE5hdmVlbiBLcmlzaG5hIDxOYXZlZW5LcmlzaG5hLkNoYXRyYWRoaUBh
bWQuY29tPjsgRGF2aWQgQXJjYXJpIDxkYXJjYXJpQHJlZGhhdC5jb20+OyBsaW51eC1od21vbkB2
Z2VyLmtlcm5lbC5vcmcNCkNjOiBKZWFuIERlbHZhcmUgPGpkZWx2YXJlQHN1c2UuY29tPjsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KU3ViamVj
dDogUmU6IFtQQVRDSF0gaHdtb246IChhbWRfZW5lcmd5KSBmaXggYWxsb2NhdGlvbiBvZiBod21v
bl9jaGFubmVsX2luZm8gY29uZmlnDQoNCltDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbF0NCg0KT24g
MS83LzIxIDk6NDkgUE0sIENoYXRyYWRoaSwgTmF2ZWVuIEtyaXNobmEgd3JvdGU6DQo+IFtBTUQg
T2ZmaWNpYWwgVXNlIE9ubHkgLSBBcHByb3ZlZCBmb3IgRXh0ZXJuYWwgVXNlXQ0KPg0KPiBIaSBE
YXZpZCwNCj4NCj4gVGhhbmsgeW91IGZvciBub3RpY2luZyBhbmQgc3VibWl0dGluZyBhIGZpeC4g
WW91IG1heSB1c2UNCj4gU2lnbmVkLW9mZi1ieTogTmF2ZWVuIEtyaXNobmEgQ2hhdHJhZGhpIDxu
Y2hhdHJhZEBhbWQuY29tPg0KPg0KDQpObywgYmVjYXVzZSB5b3UgYXJlIG5vdCBpbiB0aGUgYXBw
cm92YWwgcGF0aCAoeW91IGRpZCBub3Qgc2VuZCB0aGUgcGF0Y2ggdG8gbWUpLiBSZXZpZXdlZC1i
eTogb3IgQWNrZWQtYnk6IHdvdWxkIGJlIG1vcmUgYXBwcm9wcmlhdGUuDQoNCkdlbnRlcg0KDQo+
IFJlZ2FyZHMsDQo+IE5hdmVlbmsNCj4NCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
RnJvbTogRGF2aWQgQXJjYXJpIDxkYXJjYXJpQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5
LCBKYW51YXJ5IDcsIDIwMjEgODoxNyBQTQ0KPiBUbzogbGludXgtaHdtb25Admdlci5rZXJuZWwu
b3JnDQo+IENjOiBEYXZpZCBBcmNhcmkgPGRhcmNhcmlAcmVkaGF0LmNvbT47IENoYXRyYWRoaSwg
TmF2ZWVuIEtyaXNobmEgDQo+IDxOYXZlZW5LcmlzaG5hLkNoYXRyYWRoaUBhbWQuY29tPjsgSmVh
biBEZWx2YXJlIDxqZGVsdmFyZUBzdXNlLmNvbT47IA0KPiBHdWVudGVyIFJvZWNrIDxsaW51eEBy
b2Vjay11cy5uZXQ+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyANCj4gc3RhYmxlQHZn
ZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0hdIGh3bW9uOiAoYW1kX2VuZXJneSkgZml4
IGFsbG9jYXRpb24gb2YgDQo+IGh3bW9uX2NoYW5uZWxfaW5mbyBjb25maWcNCj4NCj4gW0NBVVRJ
T046IEV4dGVybmFsIEVtYWlsXQ0KPg0KPiBod21vbiwgc3BlY2lmaWNhbGx5IGh3bW9uX251bV9j
aGFubmVsX2F0dHJzLCBleHBlY3RzIHRoZSBjb25maWcgYXJyYXkgaW4gdGhlIGh3bW9uX2NoYW5u
ZWxfaW5mbyBzdHJ1Y3R1cmUgdG8gYmUgdGVybWluYXRlZCBieSBhIHplcm8gZW50cnkuICBhbWRf
ZW5lcmd5IGRvZXMgbm90IGhvbm9yIHRoaXMgY29udmVudGlvbi4gIEFzIHJlc3VsdCwgYSBLQVNB
TiB3YXJuaW5nIGlzIHBvc3NpYmxlLiAgRml4IHRoaXMgYnkgYWRkaW5nIGFuIGFkZGl0aW9uYWwg
ZW50cnkgYW5kIHNldHRpbmcgaXQgdG8gemVyby4NCj4NCj4gRml4ZXM6IDhhYmVlOTU2NmI3ZSAo
Imh3bW9uOiBBZGQgYW1kX2VuZXJneSBkcml2ZXIgdG8gcmVwb3J0IGVuZXJneSANCj4gY291bnRl
cnMiKQ0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBBcmNhcmkgPGRhcmNhcmlAcmVkaGF0LmNv
bT4NCj4gQ2M6IE5hdmVlbiBLcmlzaG5hIENoYXRyYWRoaSA8bmNoYXRyYWRAYW1kLmNvbT4gW25h
dmVlbms6XSANCj4gU2lnbmVkLW9mZi1ieTogTmF2ZWVuIEtyaXNobmEgQ2hhdHJhZGhpIDxuY2hh
dHJhZEBhbWQuY29tPg0KPiBDYzogSmVhbiBEZWx2YXJlIDxqZGVsdmFyZUBzdXNlLmNvbT4NCj4g
Q2M6IEd1ZW50ZXIgUm9lY2sgPGxpbnV4QHJvZWNrLXVzLm5ldD4NCj4gQ2M6IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQo+
ICBkcml2ZXJzL2h3bW9uL2FtZF9lbmVyZ3kuYyB8IDMgKystDQo+ICAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2h3bW9uL2FtZF9lbmVyZ3kuYyBiL2RyaXZlcnMvaHdtb24vYW1kX2VuZXJneS5jIA0KPiBpbmRl
eCA5YjMwNjQ0OGI3YTAuLjgyMmMyZTc0Yjk4ZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9od21v
bi9hbWRfZW5lcmd5LmMNCj4gKysrIGIvZHJpdmVycy9od21vbi9hbWRfZW5lcmd5LmMNCj4gQEAg
LTIyMiw3ICsyMjIsNyBAQCBzdGF0aWMgaW50IGFtZF9jcmVhdGVfc2Vuc29yKHN0cnVjdCBkZXZp
Y2UgKmRldiwNCj4gICAgICAgICAgKi8NCj4gICAgICAgICBjcHVzID0gbnVtX3ByZXNlbnRfY3B1
cygpIC8gbnVtX3NpYmxpbmdzOw0KPg0KPiAtICAgICAgIHNfY29uZmlnID0gZGV2bV9rY2FsbG9j
KGRldiwgY3B1cyArIHNvY2tldHMsDQo+ICsgICAgICAgc19jb25maWcgPSBkZXZtX2tjYWxsb2Mo
ZGV2LCBjcHVzICsgc29ja2V0cyArIDEsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgc2l6ZW9mKHUzMiksIEdGUF9LRVJORUwpOw0KPiAgICAgICAgIGlmICghc19jb25maWcpDQo+
ICAgICAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsNCj4gQEAgLTI1NCw2ICsyNTQsNyBAQCBz
dGF0aWMgaW50IGFtZF9jcmVhdGVfc2Vuc29yKHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgc2NucHJpbnRmKGxhYmVsX2xbaV0sIDEwLCAiRXNvY2tldCV1Iiwg
KGkgLSBjcHVzKSk7DQo+ICAgICAgICAgfQ0KPg0KPiArICAgICAgIHNfY29uZmlnW2ldID0gMDsN
Cj4gICAgICAgICByZXR1cm4gMDsNCj4gIH0NCj4NCj4gLS0NCj4gMi4xOC4xDQo+DQo=
