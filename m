Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8D947100A
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 02:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345551AbhLKCDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 21:03:12 -0500
Received: from mail-dm6nam11on2042.outbound.protection.outlook.com ([40.107.223.42]:36320
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231702AbhLKCDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 21:03:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaiZQOg+fPE5fya2cT1FL3DITycRM80UY5ekImm2ndvcEg85/4+ni6BCnwFmWiwLLhoRxv0IQOKZEXh4mj8Eub8A4W6JWhVAvT/GDxindaEyIa4o+eTbdHkRsMFfrey9Rr2j3grLHvjOwSsnea5yGTTFDT8SyNqgrYsclrkfHwF07QNOrn9VXszXGC1cBfNaDnLhPA4vxPT0M2VYYBEKAn3q7TMO80dSBckRxwHKOdrB5NFCujtMHZOuppuSeaYXm3VFihaRv7d5sXXNWZZ7qhP/CQIXWTOManWPbZfctaZdWkTU3UDl4rl8drd6dHD+wcN0+Xy8UIcP5vSfVntwiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3ojWC+mpRKwKTFy2U42UWnxapl+LrDzPxi77SE7DCA=;
 b=JVM+MostJj6uPrsN/wl1HY8QtECq1IQN61WaHl+3Tov2zdVmYsnovTHVd2nfVt1Jn/41ubnKpvpI+agPSyt07mmbtjFErODf+V7OB8s/BjrrqBdc0HSXMor3B+o2z/uVVIZASpR+PbDWllTSDZz+RDDxtqbR1j2+2Fnfr0lv+t8FwpDRLKa8/5lZG5SV3zn2aXxZhhcQgxIrQ3T1CZ9HDmiqE3w0P4p/R6e+TEKRRF49ZlTh9Y+Jle5UyV9jT0lNoV+hzT5IownPCLuZF2W+PqGtnFfB/6opqcxjHuwLOJViOkHd8k7SQMjhSx9wq1kYXUBmAxUACJCLq4ojnUQBIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3ojWC+mpRKwKTFy2U42UWnxapl+LrDzPxi77SE7DCA=;
 b=ABpqAYPrWzrnpRcqAWS9RrS+S5R7wDZvSW1b0E55oWmBE1Mw6I4qZhXM5gna1xvem67UIG8jomYv58SwRC1KwXN/Mj6NYfsLA/qW+Yk8AvJmQYt4j2FC7nhFOS+wApxKvgBXPe+gqx352mkYVptyuGpFX6Lz+TCs4qaUFlNlRXg=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN6PR12MB4672.namprd12.prod.outlook.com (2603:10b6:805:12::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.24; Sat, 11 Dec
 2021 01:59:32 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::9481:9017:a6a:3028]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::9481:9017:a6a:3028%8]) with mapi id 15.20.4755.025; Sat, 11 Dec 2021
 01:59:32 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        "open list:X86 PLATFORM DRIVERS" 
        <platform-driver-x86@vger.kernel.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] platform/x86: amd-pmc: only use callbacks for suspend
Thread-Topic: [PATCH] platform/x86: amd-pmc: only use callbacks for suspend
Thread-Index: AQHX7dNQ2085SqBOX0e60K39daEx06wr8lWAgACXG9A=
Date:   Sat, 11 Dec 2021 01:59:32 +0000
Message-ID: <SA0PR12MB451089768E4F01F233071168E2729@SA0PR12MB4510.namprd12.prod.outlook.com>
References: <20211210143529.10594-1-mario.limonciello@amd.com>
 <5070829f-fe15-b7c7-f461-83122c0fa9c6@redhat.com>
In-Reply-To: <5070829f-fe15-b7c7-f461-83122c0fa9c6@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-12-11T01:59:30Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=f92a05e5-d177-4109-abfc-f57376cd2c68;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2021-12-11T01:59:30Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 329dfb9f-9135-4614-ba9a-65b4f346024d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbff2b0f-7382-4d65-082c-08d9bc49dff8
x-ms-traffictypediagnostic: SN6PR12MB4672:EE_
x-microsoft-antispam-prvs: <SN6PR12MB4672FD74F27FC574C66C6E1EE2729@SN6PR12MB4672.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zrcwfNDokfCfkm63IZV8wi1leGsE6UhF5fE50UQfNuiRynVeZcal3NcfLcUimJ8iCzb0OQpBp4O+J1EAa4+a2qzGG/5/o8/pQBnhmvJO0ym5lB+r1s1WFJHsJvqTy34emOqOFsawmTL7LfY6TzwsSWRhqmb/tLyqXU43rYEEuHn0+nsV2xpHXj8JgzV5jSCJ9wLy8HzfOPTJmHBBqNleo6yPSP8kRx4odt18EsoTbjsVxY+P68H2hQBhadt3MzDpo1iKOZtr4CiiHG8u38ZKO59l25p+DJpefy0Ji7UbIH6f45PClhpaqom4Y92duqfDoQhs6LS9PVqYGm/l/DBIxsOAHugeOrv19SH80NBbsO/BbSXHb8zrjIyFN5eFnbPXQtsRoo69ysK9KazVLQber+q4SY9hlDzF7j1X2q+uUQggF/Tr5L82Pd3yyU+4ntCMvC6FgYAur/zzjgu33i8SZGqtM9O04iTQO5FPAXxyxFKB36UyGCfUM/GugcRtH5lrIualvuQuAzsoCYjtZ/17LSJR6tuZxbYQYkAuhhrpLQW99ZzkvBELxgKb7L10KPGr/ZIsZ5APSls8li0+Ss7iwIHw8B/c0M2F51ziHYceVkdyYnHbuc8/hoOawo6iP1Yz2NFgpj7JrUceJTHv2N/emOw7H0NoSDaOSSy52/W19oJQqu12F79rbEBS3m4D7JIQ00SEqbPF6LRQhfVe/wY+Og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6636002)(8936002)(76116006)(9686003)(86362001)(8676002)(6506007)(53546011)(66446008)(66476007)(110136005)(66946007)(7696005)(508600001)(316002)(64756008)(122000001)(186003)(83380400001)(2906002)(38070700005)(71200400001)(15650500001)(4326008)(66556008)(5660300002)(38100700002)(33656002)(52536014)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NlVwUHh3cU9saW40VmJZUzhycjRRei82bmxzQlBGTlR0Ym51RnRIVWY1U3Aw?=
 =?utf-8?B?MWtHZnZ4TlY1NGptUE5hL20xVGhXbkNKelJXVWRRend6UGZ6dFV6YW4xenJh?=
 =?utf-8?B?Yy9BdXExaVV5L0J4WWcvN0VhR3E2MElkQ0R3Tk5qaGNaVFkxUGF2dUZVUGNm?=
 =?utf-8?B?OEtMZUFwbG9iUUtvemlOYy84bzlGZnlGMHFKMXJFRXk5MHUyUkNRbVg4UGlH?=
 =?utf-8?B?NjFGaVFsNTdxVGlaeTFlVFF5Z3dYZW55b3YvTnROZXBPdnp3eVRLTFoybnZU?=
 =?utf-8?B?eHNMWVZzRGlQQU92SURUcFIvbGQ5aU1obDJrYklicEdvRzQ5MTdwNk50OTNI?=
 =?utf-8?B?R3VzdjA0dWZoaDVyK0R6ZkRmaEc0VmNjVC9UYnVMRCtweXRiK2ZtQ1FNdWta?=
 =?utf-8?B?YU0vbEJ1RDRKSFBmZ2RkUHVRb05EVlUrYXZIK1FxMTQrTEF5b29EVHNKTTBh?=
 =?utf-8?B?bzdNempKR2tiU3RnaWQ4azZRYkh3Sit2OXFWNFAyc2ZvdlRkell0ZnR4bitp?=
 =?utf-8?B?bDA4Q1ZNZ0YwQU9UdDJidE9wRXdGcVkrVms2TlVXTXB3OHlhcFRmQ2dVaTBj?=
 =?utf-8?B?c3crTldyZUxmb1pjLzUyTDNBNjFyeU9vL3NuckE2c1JhYUIvWTBNZjFEMXBQ?=
 =?utf-8?B?M05keFEzSmx2dlplS3kxWkNJWFhrTXh0WW4zNXBRbExrMFhEWGlHdGhpdnNt?=
 =?utf-8?B?WVFHUXVWdFpkd2Qyb0xnQjNIUE1uRXhSREE3dVJKUjVxVjRUa0RnQU9mUmJR?=
 =?utf-8?B?NW9JdEdlWkJuY0tWQWM4ZUtjU1R2VTVmSUZQRkV0ZGhLTmZPL1pTcXBQdWdv?=
 =?utf-8?B?allLK0pBWVFIa0FNWC9lOGJYYW5YR1ptcGc5bGtMQmh1NzBONUM5NTVUY1hQ?=
 =?utf-8?B?QkVhU1IyWjIvbVRCL3BNaDlCdFU0SFNvN2pybmhLMUZPWjFjM2luODVTbjBa?=
 =?utf-8?B?NEdqWndCVndpS0dTR2U1di9wWnpsTTJuV0hVR2QyTnlRVk9rRnRPMlFmV25F?=
 =?utf-8?B?UW44eTlHUmtPd25vejBzaGFZS2JoZC9tdkUwYkVSZCtPdkNncytuLzRFZW9V?=
 =?utf-8?B?Q1pySytYY2dsK0VUdXFKZHRPSWlIK01YVjVuYTlMdHBEUHhxdGJJVVRNWmpk?=
 =?utf-8?B?QVkveG5OMkVOY3NtQXA1QWVTRmN5NVM3djh0bkNSVWVKQW1FT3NvY1lIL2Nm?=
 =?utf-8?B?WGhhMXNKNGhJaVlmb2t3cUtzamlJbHFVYlhUQ09QMm5TYTA5WTRXUjVWekZC?=
 =?utf-8?B?RU9PT0Yxd2dLK1VENFRCdGJUWG1DZDZRRmdNWmxySlpXUEpPL0t6czZlWEdY?=
 =?utf-8?B?Zk5zRW5iRGxzS0NodEFFQXNyVVhNNW5RL1hXeTNEZzUweU1BeTFmVjFtMDk4?=
 =?utf-8?B?RGkyTUF6NURTWExxT2F5ZTVWemd0S3o0NmRGL0RvbUt5YUlGK1hDRFhEM0JB?=
 =?utf-8?B?K2hDQ2diMUNiMEpMTnVLSUNDQzRiMWJrejBRTXRMRWM4eU8xdFVMT1UrNW16?=
 =?utf-8?B?ZHo3VFkza1I0QzE5U1ltRk02QTJQWnNXY1ZYVkVRQVk4RHNDZVV6MHZIdjJz?=
 =?utf-8?B?VTV6L2FUUTA2cGtjSDNNNDJaRWQzZmxDbnB2a2txKzFkeU5OWmNESlg0Smtr?=
 =?utf-8?B?ckpQcmV3NFpZTXZTSXl1bE9XOGxVM3ZucFMxUEpwTXNRVnZyb2I1bkhMZi9u?=
 =?utf-8?B?aFoxeDNjcUNwSHVYT3ZTOVA4K1pjOFBCMktmMmdLcGdHdDlDUDBYQnJpd3ZY?=
 =?utf-8?B?UTBmMUFlSldNYTJEN0RUNnFWTUVOS3gzT1BDbjN5Ky9Fc1BLUHVhdGU0UFRk?=
 =?utf-8?B?NDViQ3BxdDNiU2l5OS9UcE1mMkg2ZXM5ZHV1NjVucHJOR3QyL043YVp3K2pw?=
 =?utf-8?B?Y3NtSUVmZkUyd3RsSU9Ea3hlYTVMcHB4RFZmc3ljMEkxMTJlNzJBOXV1NHor?=
 =?utf-8?B?OGI1Y1owNU9yNmJ0OFhEeGlQODlWZ0pHeFZpanVkVitkcmFwc25wUUpQbFVx?=
 =?utf-8?B?b3dsanZnMUNxUGpkVG10N2RvTlczU3N5ZEIwRXBZQmJuYkt3czZDOHlJYUt4?=
 =?utf-8?B?azF0T251R2ZSeUViY1VWMlZsaDNwSGM0UzNIWVJwMEY2Uy9zdU9SZlllUGg2?=
 =?utf-8?B?MTgzeVhITUpORXRQOHBLVm04Q2VmZ1hLMndZRVRvc2pHbWlUVE85bHZtWXJv?=
 =?utf-8?B?QVZxRUpRakxqbXp0RW5md0JhSEZIbHBpYTZTWjVXbDRPS2paZjZHZFdBRi9M?=
 =?utf-8?B?YmN0N3p2cHNLQWc5ZCtGbDhXcDVRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbff2b0f-7382-4d65-082c-08d9bc49dff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2021 01:59:32.3992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3sfvxCbFdTYlByxEeKqy+ywygWt6G5963/hzgVe+Srp34PxIGRI43gXX1XE9/6WsaVB4WVcREn9AucfYJUGLYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4672
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIYW5zIGRl
IEdvZWRlIDxoZGVnb2VkZUByZWRoYXQuY29tPg0KPiBTZW50OiBGcmlkYXksIERlY2VtYmVyIDEw
LCAyMDIxIDEwOjU3DQo+IFRvOiBMaW1vbmNpZWxsbywgTWFyaW8gPE1hcmlvLkxpbW9uY2llbGxv
QGFtZC5jb20+OyBNYXJrIEdyb3NzDQo+IDxtZ3Jvc3NAbGludXguaW50ZWwuY29tPjsgb3BlbiBs
aXN0Olg4NiBQTEFURk9STSBEUklWRVJTIDxwbGF0Zm9ybS1kcml2ZXItDQo+IHg4NkB2Z2VyLmtl
cm5lbC5vcmc+OyBTLWssIFNoeWFtLXN1bmRhciA8U2h5YW0tc3VuZGFyLlMta0BhbWQuY29tPg0K
PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBwbGF0
Zm9ybS94ODY6IGFtZC1wbWM6IG9ubHkgdXNlIGNhbGxiYWNrcyBmb3Igc3VzcGVuZA0KPiANCj4g
SGkgTWFyaW8sDQo+IA0KPiBPbiAxMi8xMC8yMSAxNTozNSwgTWFyaW8gTGltb25jaWVsbG8gd3Jv
dGU6DQo+ID4gVGhpcyBkcml2ZXIgaXMgaW50ZW5kZWQgdG8gYmUgdXNlZCBleGNsdXNpdmVseSBm
b3Igc3VzcGVuZCB0byBpZGxlDQo+ID4gc28gY2FsbGJhY2tzIHRvIHNlbmQgT1NfSElOVCBkdXJp
bmcgaGliZXJuYXRlIGFuZCBTNSB3aWxsIHNldCBPU19ISU5UDQo+ID4gYXQgdGhlIHdyb25nIHRp
bWUgbGVhZGluZyB0byBhbiB1bmRlZmluZWQgYmVoYXZpb3IuDQo+ID4NCj4gPiBDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KPiA+IFNpZ25lZC1vZmYtYnk6IE1hcmlvIExpbW9uY2llbGxvIDxt
YXJpby5saW1vbmNpZWxsb0BhbWQuY29tPg0KPiANCj4gSSBub3RpY2UgdGhhdCB0aGVyZSBhcmUg
bm8gW0J1Z11MaW5rIHRhZ3MgaGVyZSA/ICBJdCB3b3VsZCBiZSBoZWxwZnVsDQo+IHRvIGhhdmUg
c29tZSBsaW5rcyB0byB0aWNrZXRzIC8gZm9ydW0tcG9zdHMgZnJvbSBwZW9wbGUgd2hvIGFyZSBh
Y3R1YWxseQ0KPiBoaXR0aW5nIGlzc3VlcyBiZWNhdXNlIG9mIHRoaXMuIEJvdGggc28gdGhhdCBw
ZW9wbGUgd2l0aCBzaW1pbGFyIGlzc3Vlcw0KPiBjYW4gdGhlbiBjb21wYXJlIHRoZSBzeW1wdG9t
cyBhcyBkZXNjcmliZWQgaW4gdGhlIGxpbmtzLCBhcyB3ZWxsIGFzIGZvcg0KPiBtZSB0byBnZXQg
YW4gaWRlYSBvZiBob3cgdXJnZW50IG9mIGEgZml4IHRoaXMgaXMuDQoNCkl0IHdhcyB0aGUgcmVz
dWx0IG9mIGFuIGludGVybmFsIHRlc3RpbmcgdGhhdCB0aGlzIGlzc3VlIHdhcyByYWlzZWQuICBJ
dCBoYXNuJ3QNCnlldCBiZWVuIGhpdCBpbiB0aGUgd2lsZCB0aGF0IEknbSBhd2FyZSBvZi4gIEhv
d2V2ZXIgaW4gdGhlIGNpcmN1bXN0YW5jZXMNCnRoYXQgbGVhZCB0byB0aGlzIGZhaWx1cmUgaXQg
d2FzIGFwcHJveGltYXRlbHkgYSA4MyUgZmFpbHVyZSByYXRlIHdoZW4gaXQNCm9jY3VycmVkIGZy
b20gdGhpcyBwcm9ibGVtLg0KDQoNCj4gDQo+IFJlZ2FyZHMsDQo+IA0KPiBIYW5zDQo+IA0KPiAN
Cj4gDQo+IA0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3BsYXRmb3JtL3g4Ni9hbWQtcG1jLmMgfCAz
ICsrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9wbGF0Zm9ybS94ODYvYW1kLXBtYy5jIGIv
ZHJpdmVycy9wbGF0Zm9ybS94ODYvYW1kLQ0KPiBwbWMuYw0KPiA+IGluZGV4IDg0MWM0NGNkNjRj
Mi4uMjMwNTkzYWU1ZDZkIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvcGxhdGZvcm0veDg2L2Ft
ZC1wbWMuYw0KPiA+ICsrKyBiL2RyaXZlcnMvcGxhdGZvcm0veDg2L2FtZC1wbWMuYw0KPiA+IEBA
IC01MDgsNyArNTA4LDggQEAgc3RhdGljIGludCBfX21heWJlX3VudXNlZCBhbWRfcG1jX3Jlc3Vt
ZShzdHJ1Y3QNCj4gZGV2aWNlICpkZXYpDQo+ID4gIH0NCj4gPg0KPiA+ICBzdGF0aWMgY29uc3Qg
c3RydWN0IGRldl9wbV9vcHMgYW1kX3BtY19wbV9vcHMgPSB7DQo+ID4gLQlTRVRfTk9JUlFfU1lT
VEVNX1NMRUVQX1BNX09QUyhhbWRfcG1jX3N1c3BlbmQsDQo+IGFtZF9wbWNfcmVzdW1lKQ0KPiA+
ICsJLnN1c3BlbmRfbm9pcnEgPSBhbWRfcG1jX3N1c3BlbmQsDQo+ID4gKwkucmVzdW1lX25vaXJx
ID0gYW1kX3BtY19yZXN1bWUsDQo+ID4gIH07DQo+ID4NCj4gPiAgc3RhdGljIGNvbnN0IHN0cnVj
dCBwY2lfZGV2aWNlX2lkIHBtY19wY2lfaWRzW10gPSB7DQo+ID4NCg==
