Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB96DCB77
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 21:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjDJTRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 15:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjDJTRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 15:17:51 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2051.outbound.protection.outlook.com [40.107.100.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFA51984
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 12:17:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IlaME0JtWEHqRoM6eA7G27rQVhXrJGTOQt8wPtN6xWZTHEi0qBYlXTmoXal8K6WqmJB3ozcSgpwZAaewT7kxHGED7Hdr5SYk/mq7IU7d7EnuDcXuWKQa4MTHwOcwESevsenJmm8QIw6TzgeH+JFWKWs5QhXx9C4Ng50RhB8Z2hIjUSXL4dLbT2GxnGCABc9VO1eQId2aEF1pxzPeOrtipqNTYmnqLR+pZr8GTWOq+4CVY4r4lj4WKegHTBVoBVOnS92LpGU/E/kEKJ8M1oIGwXuHjVbdYNka0GXD8dL8eZtUUinHbixnq/ta/Ta5VHc3/Vpp1mKU9SlvFjO/TVfDtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fuzdXwxEeHDoy+b6NdVCJ/8LHEqvUX1+8fZ43yU8Ec=;
 b=PcFfKGRR4R51jQ8eaxkO9CSKRsVtrQQDutcXrmZrxyhY2FC/QwHfBueHQRfefwl1Q+t4W0q4xuoaPslJ95Yr2wAsb9dswNzGZ0GlzQ/uLlFytoToeRAtgs5DTlSus5xCb2OqWyUOREW6oGUbX2aFk+Xd0JOOwpH6gg3x39eBU82rCeIe9n3ddtQ5kpLoUNyxLkwwnXbJyv3hnyKdnu8F+p5en4BKEiICRaE8Inn5Rm/6NcGMj1hviLvFr1E/urNEcdbQA3dCycm1BkIuXNtr67kLBiyAgAwfxEJu5ZdyvSxM6Sbvc+NZnrCo0ZZzoZXG6JkOsc9szlpaafdGQilRLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fuzdXwxEeHDoy+b6NdVCJ/8LHEqvUX1+8fZ43yU8Ec=;
 b=FyuJdAJ67iFS8+ml50fr4WaBNIzgPbctZ5nPdnQn7eKkh2R9IbKByZjdIT2FKhA1ZPL6c2HK8Tbkmcy4VEpXlTnxk24fUfhSkm2uimeEYU7a0I3i12A8DJa5U44aH0K7g2Yf/7b1h6AFOcynEH085eysnU0Re4VD14I8T0KJezo=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SJ0PR12MB6783.namprd12.prod.outlook.com (2603:10b6:a03:44e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Mon, 10 Apr
 2023 19:17:47 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6277.036; Mon, 10 Apr 2023
 19:17:47 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Veronika Schwan <veronika@pisquaredover6.de>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: Regression in 6.2.10 monitors connected via MST hub stay black
Thread-Topic: Regression in 6.2.10 monitors connected via MST hub stay black
Thread-Index: AQHZa+Cxi1GUd0tPvUObubuBqZQb/68k6ecA
Date:   Mon, 10 Apr 2023 19:17:47 +0000
Message-ID: <MN0PR12MB61014AE52F7F84A86F909717E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <8e90142e-cdc3-a4a0-754a-4c7a2388940b@pisquaredover6.de>
In-Reply-To: <8e90142e-cdc3-a4a0-754a-4c7a2388940b@pisquaredover6.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-04-10T19:17:46Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=f24a788d-8ced-42e4-a87d-ede531b63f00;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2023-04-10T19:17:46Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 68e38f97-009f-4bf4-8ba3-bee2708e1590
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|SJ0PR12MB6783:EE_
x-ms-office365-filtering-correlation-id: b53fe86b-0a39-41ee-5d48-08db39f8451d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uKBQ/B/i9P2nSvx5Y8XtUD0yZZ4hA5ajh/N9yvSaOpiQFeIRy3Zwzb/T3h14IeRnUoJu5voSqcdkFhHjwrglvDm14f5p+tUDtSxhFRgU+0K1ZlTpMSVsenQBccxxdHxI6ErymlZwwZl8vPPyEdb2EkfEZexBttXT6+I8E8dwCcK153R8ErizWaMmwlcUGHCTbnl3mTGrZWh4OkSeXYSB8HL+vGB/0oTcC/TzuVfxPs2pYyPuAQYoQZJ9UJMt68stm2CydnbYoMSBNVnGJozANIxmBONE+G/pEkKbA9ZNObrEyCEn5ba78E7C60ZyQNlbEWvrv/MGT6lKWWkf0EtNODj0rtTwnJdpNFkqMINNViq06yls4BJrNhSZIuAJjZzwAwfLOg2lXguLEtZqOV7NXIvA6pcnHRcz5zPu3mSchhxj0HJ0OWezGbcP7+RqjBGeyKYyU4i5SA1MBaCVjcUR4rRUaW+5TT1cBdGsGo30MZ7A5nOemh9a8D82HKZKmxy3eeymf4J9ZfHsSP/NzZLzYPbZxPjb+l284aLZhU0xCuLRrmx+vPNxcAVQL+ymOoVEWi/WcjY4BB5pZ2YVvL1BnVtvatnNPLUmijKOLWCxxnpu2Tuw1JQavB9wr7oeuBX7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199021)(122000001)(53546011)(316002)(6506007)(186003)(83380400001)(110136005)(26005)(4744005)(6636002)(5660300002)(2906002)(9686003)(38100700002)(4326008)(52536014)(8936002)(38070700005)(7696005)(86362001)(71200400001)(41300700001)(33656002)(66446008)(8676002)(64756008)(66476007)(76116006)(66946007)(66556008)(55016003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVphMUpBS3NZWjY2VFY3ZmtGdG9nSW85a3Y1dkg4NDFxZkRPY3hQSCt2bStr?=
 =?utf-8?B?WC9yQ0hKTGorWldDM0w5UEd1NWlFcG1xVzZEUDRxQUxTZDJXM0s1VFdhYUpD?=
 =?utf-8?B?dEpUYWlUVVNIdjArQ1VlUTZueWdqM29OY2JzdVUvS25WSklsR2Rpb1N2dlJw?=
 =?utf-8?B?K09BNjRsZ1BXSDBYY21MbE8yNHFIKzI3NGZvZnZOTllBM2gvRUpwcG5ZcE5L?=
 =?utf-8?B?b3dPVGFrVWNZaFNKa0NBVGN3TlJRejZWTE9kLzhTcjJwVDNWSHJhZ0pXZW5n?=
 =?utf-8?B?bnllSHlUdW81Z1pNUFRndjQvNlFqbkdjOTAvQ3pneEk2a0NKcms1eTBRRXhX?=
 =?utf-8?B?aXA2dG9ZUWIxWTZHZEhCQitxVmdjdDlsQndETjlDME82TXRwRWo2M2YzZFJL?=
 =?utf-8?B?c3NMbUJyNzcxaHVET0prRWVkd01JRkRkYy96TzFmNVMwOXV2ZVYrZDRHNHVx?=
 =?utf-8?B?OXY5a3BKQ2JGSUx2UDI0WThyb3pDb1cvN01qeGZaeGtNYWdLamNoSUptU3li?=
 =?utf-8?B?Zk9BTEVSY0dBTXFFNGdpbnVTV0NrenRxTUNsMkdnYWUwSVdXL0Vja29BaWZC?=
 =?utf-8?B?Sk5YdWhyUkhPSXZQb0dBWkNiSFpUK0k4b0ZUVVk2OUJvOXAvU3ppK1lkYm8w?=
 =?utf-8?B?cHpkWTl3c1ZVUnRPdkJjTmZHZW9tajhFS1FUUVZTZ0dySEZxaGNsOFd6dU5n?=
 =?utf-8?B?NVpCNnRZRGlUMUVXWVpyMGNnVk9JTU56clNHUU1PTVU1TDlIV1VISm9CS2ZQ?=
 =?utf-8?B?VmdOOGxjc2dTbHFFcVVqWkJMTVFwbGx3RTIyb0FFcTU1bWJjcXo2Wnp3QWdr?=
 =?utf-8?B?dVhEd3R2bzh5N29EY1ZWblRpaUFzQThiSVllSzkwdnYyWTUvUm1Wenl2clcz?=
 =?utf-8?B?aDZ4YlFORU9sYkVRSStwVHVsYmYwa0wvUVcxckJBaFZhbXMzL2RxV3ZUT1lr?=
 =?utf-8?B?TnpTcE9rS2tacXVOSVlNdlZ2YWhkSTRzMlRTUmNIK3lzVklhMjd3Sm1PZXEw?=
 =?utf-8?B?UkdPMCtyRmdCc1pjem4yMDRTRURjSjhVZm42SThGdWNDUkQ0YlpPQmpoM0Rx?=
 =?utf-8?B?Zk9EYjhOTjVCTDVFalhnN1FhdllkdnZWOHVHM3RKMld1QlA5UWJvZjNwSDJs?=
 =?utf-8?B?dUxqbTgvWXFOYjJrN3RPU0xYbjJMUVZPMXZzeGJYOXdnUDBUUjA4OTBwT1pU?=
 =?utf-8?B?cTEvenBJaHhYYVl3enRiYU81UlZSeHBMbGJoU2NDNWJORzh3andrdjlicURq?=
 =?utf-8?B?R0VYWVFOMzg0TklVMVdDZkYzYzVYUnJzYU5IVk9wb0JNL2wxUXdzR3BaNkc2?=
 =?utf-8?B?RmhIYzJUNUNvSkR1NTFOTE11VDg3WVUzdGU5cVBPQnFFYStZM2VuSmZHc3N6?=
 =?utf-8?B?R3dGcENyd3R4Qzl1QW9Wc2t6UjljdTNvUytLNzZTMFJKYzFHTzN1UXhnVDVo?=
 =?utf-8?B?bnBGZUhjSUwxWmVKYVd0WnpiUzBxSHl0Vmo5YWk5VkkreFFhQ2JxWVZYR1A0?=
 =?utf-8?B?L2lwYWUzcjk0dEE2Nm53bFVXOXYzMWkrQzNFWlBSaGdUZ1NvWm1OaHRIWkEx?=
 =?utf-8?B?RFU2SkRYMTNJQVNZOHVabFdyRFhHNTNuNEtOVkxmNm1MQ1RvSzdhUFhWSU1F?=
 =?utf-8?B?OTFGUVFuUUpkSEJHcFloZC8rcEN0d3V6WndPRSsrME1oK0lWek5yZ25EaUw2?=
 =?utf-8?B?UEZwWkpIUXhrY1dza0cvRGliK2ptMGt2T1lJY3JsQS90NEk4Z3RWQllTbVI3?=
 =?utf-8?B?c1lYanhBclg5eHpVdEdLS2thakRMemxlb3ZETlVwYkluMU0zUk5FUW9FODdO?=
 =?utf-8?B?VFZTVDVoMjA5T3VvM3MvU0c5OFhtenpLZXVTQWxqay9TUk44RnlzRUlzam1D?=
 =?utf-8?B?YkcrSm8xL3J5Z0xQVkdzVE9JNDZOMWZ6aFpuT1JLU2IzalRiU2pmdXhsRWUx?=
 =?utf-8?B?UWtGcnRVMkdhTHhlVXRzcGowSjhxSCtTZ0svY3Q0YzY4QzlpM1NJV3dCenBT?=
 =?utf-8?B?bHMxRkxaanpWWklpTVk2OXFRREZyT1RtT3JBSng2V0NhTndLaHp6QkcyL3Uy?=
 =?utf-8?B?TWhQZ2cydjRaZmoxV2NXM09lUVQwb0k5cGk2REZrV0toRE0vSjBFYWJmc2VU?=
 =?utf-8?Q?LH88=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b53fe86b-0a39-41ee-5d48-08db39f8451d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 19:17:47.7211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GoL4ajzB8r4tzKahqLCwXX+m+nVLf22r2rtqxdEu1ZhArRRvviiO4oIsyxdCDh5FP2dcpwyRdEWaY/Ub6vzScg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6783
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhpLA0KDQpDYW4geW91IGJ5IGNo
YW5jZSBjcm9zcyByZWZlcmVuY2UgNi4zLXJjNj8NCkl0J3MgcXVpdGUgcG9zc2libGUgd2UncmUg
bWlzc2luZyBzb21lIG90aGVyIGNvbW1pdHMgdG8gYmFja3BvcnQgYXQgdGhlIHNhbWUgdGltZS4N
Cg0KVGhhbmtzLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFZlcm9u
aWthIFNjaHdhbiA8dmVyb25pa2FAcGlzcXVhcmVkb3ZlcjYuZGU+DQo+IFNlbnQ6IE1vbmRheSwg
QXByaWwgMTAsIDIwMjMgMTQ6MTUNCj4gVG86IFp1bywgSmVycnkgPEplcnJ5Llp1b0BhbWQuY29t
Pg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgTGltb25jaWVsbG8sIE1hcmlvDQo+IDxN
YXJpby5MaW1vbmNpZWxsb0BhbWQuY29tPg0KPiBTdWJqZWN0OiBSZWdyZXNzaW9uIGluIDYuMi4x
MCBtb25pdG9ycyBjb25uZWN0ZWQgdmlhIE1TVCBodWIgc3RheSBibGFjaw0KPiANCj4gSSBmb3Vu
ZCBhIHJlZ3Jlc3Npb24gd2hpbGUgdXBkYXRpbmcgZnJvbSA2LjIuOSB0byA2LjIuMTAgKEFyY2gg
TGludXgpLg0KPiBBZnRlciB1cGdyYWRpbmcgdG8gNi4yLjEwLCBteSBleHRlcm5hbCBtb25pdG9y
cyBzdG9wcGVkIHdvcmtpbmcgKG5vDQo+IGlucHV0KSB3aGVuIHN0YXJ0aW5nIG15IGRpc3BsYXkg
bWFuYWdlci4NCj4gTXkgaGFyZHdhcmU6DQo+IExlbm92byBUMTRzIEFNRCBnZW4gMQ0KPiBMZW5v
dm8gVVNCLUMgRG9jayBHZW4gMiA0MEFTIChmaXJtd2FyZSB1cCB0byBkYXRlOiAxMy4yNCkNCj4g
MiBtb25pdG9ycyBjb25uZWN0ZWQgdmlhIGRvY2sgYW5kIHRodXMgdmlhIGFuIE1TVCBodWINCj4g
DQo+IFJldmVydGluZyBjb21taXQgZDdiNTYzOGJkMzM3NGE0N2YwYjAzODQ0OTExOGIxMmQ4ZDZl
MzkxYyBmaXhlcyB0aGUNCj4gaXNzdWUuDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IFZlcm9uaWth
DQo=
