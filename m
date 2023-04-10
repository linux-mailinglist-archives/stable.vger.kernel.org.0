Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8C46DCB7D
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 21:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjDJTWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 15:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDJTWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 15:22:44 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C5F19A7
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 12:22:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aa6+hSEB7RcKitF7qIqJ8Cemd1ScUeabs4mKyGBMU4yu7FaVKSPXNT+PLkyOfMpxr3fdZUdBj0fb7mh+B7iN1Nd5nNMowD/T/ggWbjnqDk84OKUtt7UnCvrDLPQcc/Zc1Nv9SEqs2JgaXZramOaVZt6dX06XF14lyjamcKmbltB/Zawc6WZcRsPQUBrFAHImHWAgHkk/MYyKJzN90zZp7BLlMfs9y8/kZvN/SNRviURGM5cNP6hgwrPEhzey5ZvaesaCZMGzzhar0D3qamFS9OHIcB2Uo2O+LJQuAXexC7Jw4zXVW2OInGVu13PTjTJph31kWKbVL1yijghfBQsvhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0QQ/Ih9RP8bDUsqtsGxf1HGfj8WF6rvI1qRBl0dWs4=;
 b=QzEazzS/bEm6G07Rd+rEHN3ivWre32kTR9Nb6fZYefIFHkUyk68sCv+IVo1W/DDzLYOm/dETPO1HPXm7jr349kxEHAFb7xAKOf1ly6yPbRE2cBZNzoH0k0WzDoU/pmL7Izmhf0jr8L3+5SEIc/Iu2493o7BgP9CgHUahkqs2KtZnPMKm96Zd8L3mMPO7CgQ+n4P2i8e5yR76CU2ONORZCrV5vkcj5s1PdKip6HPLmDDn5rhEwTZdYVlTyorYT7bWkra9O5iz87ScL7x4fePSpbauYFzWYeLG6zKr/6hsFXhgwUpNLjGTY0Ce5+qY/E2WmrNxMjuUHcskeUChjEIYig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0QQ/Ih9RP8bDUsqtsGxf1HGfj8WF6rvI1qRBl0dWs4=;
 b=e359+iS4Iyk1/vLtkEbsqYKDN/X7JDkWCDeexMxqioUy/sPXfpl+pqC0P/HlLWbBYAYIGCzCdLHl71rAXUrUeuE3VZOsqmvdjd2o/yEMNCvGUOm3MAnKqS3Su/H8SZs92w9MH2hlsQfEuWunYeJjE8DzJrB/NxOs+AglnWq0M0g=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL1PR12MB5803.namprd12.prod.outlook.com (2603:10b6:208:393::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 19:22:40 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6277.036; Mon, 10 Apr 2023
 19:22:40 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Veronika Schwan <veronika@pisquaredover6.de>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: Regression in 6.2.10 monitors connected via MST hub stay black
Thread-Topic: Regression in 6.2.10 monitors connected via MST hub stay black
Thread-Index: AQHZa+Cxi1GUd0tPvUObubuBqZQb/68k6ecAgAABzzA=
Date:   Mon, 10 Apr 2023 19:22:40 +0000
Message-ID: <MN0PR12MB61011B4C8FF79D3035963095E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <8e90142e-cdc3-a4a0-754a-4c7a2388940b@pisquaredover6.de>
 <MN0PR12MB61014AE52F7F84A86F909717E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
In-Reply-To: <MN0PR12MB61014AE52F7F84A86F909717E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-10T19:22:38Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=6ea63383-ae29-4270-8cb7-59a77b25fcd4;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-04-10T19:22:38Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 07690ca4-81aa-46f4-b7b1-8e85ee0b936d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|BL1PR12MB5803:EE_
x-ms-office365-filtering-correlation-id: a4d59fbb-a1c3-436d-a1cf-08db39f8f3a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GjcrvQI0jPxk38nAuf1cROKF8c95qwx6v60nVZFq+wMSu0fK05QmKF49+jzTfOwxpXLGU9U76S57FniQySBsW0/J28TY5IMwHC2EekEv5iG/z91pEB3SqA5JSX59WW4CnJFsNebn1upEpTEzu8fIJQ4fOskNUHp49bnsQju2gdt56oHMOg8L7FhBig7YLjKvHLBMNd+4xw+UMdgOBy6i0affeoHffpqGVDXm6Bo2DXBWUjUNkqUC6KUxMzMxiel35yt5bGTXFd9qJDjDDuswwuyy/U+XB7uGhMWDyEiXbKeG5lsHp+1sD71pfw+k2GLDnc3BZ6R+kJPiK6tHBmiBt0DCYKTQ43EE2FQ3QcbJp+nQsApmnNddRNRZMuun5qzvJSd2xGHFLTLJGOGMnbsDgjedvWuljAyzkORqjN+O17L0zjAKUnDgLIo4rPfNoesULSG0unhaZscM1zDsZuQdILo21Fh3Nb0Zn2E8dFDPDymnd6LkzrIrqobo8V/MB1NRuwGWDLkj1oEwWTeXCfOmn7aLZmohFx6PTwXO6dKYUNwkDvIBbnma01hUv7xiMgBx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199021)(55016003)(8936002)(52536014)(7696005)(966005)(5660300002)(86362001)(66556008)(66476007)(66446008)(64756008)(76116006)(66946007)(8676002)(4326008)(478600001)(33656002)(38100700002)(38070700005)(110136005)(316002)(122000001)(6636002)(83380400001)(2906002)(53546011)(71200400001)(6506007)(9686003)(186003)(41300700001)(2940100002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkFMcTJCcDkrTzJYOFNtTnNvTWhKd0tiOEYraEFzUFhCbHJHOStqOExXbjMw?=
 =?utf-8?B?d24vVGhieEl6RnlGczVNVi9ReGhCbDNiVEs2ME9PMGNGaEhEbjFzV09OMzJJ?=
 =?utf-8?B?Y2liZEVzODJFc3dyZ1dtRkgrZGN6aWJpK05haWl4UUtTSUptVzlFY1BMUlI1?=
 =?utf-8?B?d0c0aDlWZmNUd2JHZmhrVS9lSlNWbGN6VlZpUlZjajBrdDkxekhzYzRzbmFY?=
 =?utf-8?B?RVhybjBxS2xtam1GNFFpNDFNWHh0dVk3NlZCSEJPQmJJRThNSTNINHJ5ZThK?=
 =?utf-8?B?d3ZUTDhJK3d1RFhQYmt3eFVDWnRjaTdDUE9adUZxVXVnaTFrTVR3S3NraUVZ?=
 =?utf-8?B?S2s4NkVuY0hCTDdrYm5KODZ6V3NwSENHOVp3M2pScW5sVFpmV0w0K3l5Q0pD?=
 =?utf-8?B?UFd3U1h3WS8xVUxOVGNSNDVkZFhkZ1RQOTlDMHdMWXdaR0s5Y2VlcnVGVzVT?=
 =?utf-8?B?YnZHZ2tiMTdQRkFDS3VWL043cWF6MzE5VGxVRTlpdzVLWCswN1ZqOU5DeTVS?=
 =?utf-8?B?dVdNelZhR2o4NHdBZ1Z6K0J2MXdGZ1lQbmR2OTQ4cXJERUZvZTVzcGFJeVh0?=
 =?utf-8?B?TDVtKzBOWFRNTWtiNUZTUlltWGdMQndqZzZCbExhaE80dFB6R3dPeE52Sndm?=
 =?utf-8?B?WTB2RUpNZnY4OER5VFhQZk0zNnE0N1RYeWNFV3JKTmoyK25OcW1zcEJzd0sv?=
 =?utf-8?B?cDBpdi9IbGtkK0lJMGZXNkZYNE80dG1nOGxKR3JBZGtqeVdsNnVOQ25YYTVB?=
 =?utf-8?B?cFhWcjZ0Uk1sOFlPYU1KSnpQaGFJdzRxbHdpK1N6ejNOK09UdURuODFKMTdu?=
 =?utf-8?B?YUVydzBMMk54NkpsMklHTy9hRGlpUEkzWWk5QUt4RktSSDAvOFBJSWFNMkpL?=
 =?utf-8?B?MkQwWGN0RHR4REpiL0pRR1JDNkVSeVNFdnQ5Z3gwMzdZbHRiWDYvQlF3d0F6?=
 =?utf-8?B?aFBtb2Q4RGdqTyswdHlYaTBVT1pKVGovUUtuS0YwUERybkNHM3ROcVZBeWdZ?=
 =?utf-8?B?OFE5ckpkNWlpMFpXYjQydjZqNE81ZEJ2cTluVGdoNmRrSEoraXU5M3lqMzdU?=
 =?utf-8?B?NXRpL05OeDJndTMwMG9OeFJHN3NsVFB4VGVqNWlFN1NrRjEwVnorVlJSNm5G?=
 =?utf-8?B?amM3VXovM3F6cjFPVEpQbi81R0VTaDlSWTlXZjRQRm9JZWM4a0VZK2pTYnZ2?=
 =?utf-8?B?Vllsb2dsd0szSW9BZDdYTVZuVUlHSVdaRjY2ZTR2K3JQM2J3STZ2QVJSemxa?=
 =?utf-8?B?eUd2cnowckdZd0N6SkdPdXFjOVQ5S1RWNFJtRnlENnBxR3Q0U3pYZTVYN2No?=
 =?utf-8?B?UkFOSzRFVDJIY3FRY3YrdHl0QmVCMFFFdStsMkFkaGxTOVh1UVYycHpFYUxE?=
 =?utf-8?B?RE1wM1dHU1p1dGptTGhkYncvaHlPbE1jU1Q1ZHV5RjhsR2VFL2c2YnFNOEhO?=
 =?utf-8?B?SkFqVGVYTGMzWERGNG5xZ29jbUdOcVg3NkV2b05BaUtWSTgyY0pFaXlMQ0N6?=
 =?utf-8?B?WHVxVGx5MGtyTUo0Z205WjJWQlk0M084YjU0cE5BMHJFRWhiSjV1L0NHQitY?=
 =?utf-8?B?RTB5WnNadjRsV3lYMEZsQUlZdytOMjUxVEhEUk1qVVE3aVkvREV6NThtcnVr?=
 =?utf-8?B?S1R3TCtLVjM2YkM5dEM4dnpuWmZwNEltRTNBTVk1cEk4WWdJMVNyZ2paZHU2?=
 =?utf-8?B?UFFIbytNcjVZSVpZZHVJM1FoS3daM2J1Mk41Y0t6alNTUDFpWk5iMXpoY29Y?=
 =?utf-8?B?dE9MNmlKK1RUOXh0VTZSbVdjUWEzQ0QxTWFnU2hzTmp0L1ZMdXlhWGNRQnhq?=
 =?utf-8?B?OTlRMGxKZUhVTi9kVkpyUWJIckh4U2Q5WEY4MlBQa3hWWDViTDVsRmxBME4x?=
 =?utf-8?B?SVc0N2lHYWlDNkxoTFluc1Y2Yk5UZGZraHloaHI1Nnc1cWF2WjgzbGpKbmRl?=
 =?utf-8?B?L2VnR2lOWVB3cVZ2ZW9zNkdaQTVFdS9qM0dJZTJjRHZwUDM2RTRBK0xVZ1NN?=
 =?utf-8?B?U3BKemN1SkxlUEF0aTIwSnYvc01rTHhoWFE0eXBqeUxyb1NJMmw1eWpoUlhN?=
 =?utf-8?B?c1A4ci9BdVJlU2VLT2RwK0JlRlNENkpDM1dkKytsVElyM3R4cERFenhEMU50?=
 =?utf-8?Q?V6AY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d59fbb-a1c3-436d-a1cf-08db39f8f3a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 19:22:40.5096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5/YWmA6IyzXQbDzFf2ovJ6eBIJWH33lczoS4by7wgw1WwOPMeSNzWaBtqpf1eo2cljP6uCY/6FsUgQhrUm2rQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5803
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KQW5kIGlmIDYuMy1yYzYgZmFpbHMgdGhlIHNhbWUgd2F5LCBwbGVhc2Ugb25l
IG1vcmUgY2hlY2sgd2l0aCA2LjMtcmM2ICsgdGhpcyBjb21taXQ6DQpodHRwczovL2dpdGxhYi5m
cmVlZGVza3RvcC5vcmcvYWdkNWYvbGludXgvLS9jb21taXQvYzdjNGZlNWQwYjBhDQoNCj4gSGks
DQo+IA0KPiBDYW4geW91IGJ5IGNoYW5jZSBjcm9zcyByZWZlcmVuY2UgNi4zLXJjNj8NCj4gSXQn
cyBxdWl0ZSBwb3NzaWJsZSB3ZSdyZSBtaXNzaW5nIHNvbWUgb3RoZXIgY29tbWl0cyB0byBiYWNr
cG9ydCBhdCB0aGUgc2FtZQ0KPiB0aW1lLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+IEZyb206IFZlcm9uaWthIFNjaHdhbiA8dmVyb25pa2FA
cGlzcXVhcmVkb3ZlcjYuZGU+DQo+ID4gU2VudDogTW9uZGF5LCBBcHJpbCAxMCwgMjAyMyAxNDox
NQ0KPiA+IFRvOiBadW8sIEplcnJ5IDxKZXJyeS5adW9AYW1kLmNvbT4NCj4gPiBDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZzsgTGltb25jaWVsbG8sIE1hcmlvDQo+ID4gPE1hcmlvLkxpbW9uY2ll
bGxvQGFtZC5jb20+DQo+ID4gU3ViamVjdDogUmVncmVzc2lvbiBpbiA2LjIuMTAgbW9uaXRvcnMg
Y29ubmVjdGVkIHZpYSBNU1QgaHViIHN0YXkgYmxhY2sNCj4gPg0KPiA+IEkgZm91bmQgYSByZWdy
ZXNzaW9uIHdoaWxlIHVwZGF0aW5nIGZyb20gNi4yLjkgdG8gNi4yLjEwIChBcmNoIExpbnV4KS4N
Cj4gPiBBZnRlciB1cGdyYWRpbmcgdG8gNi4yLjEwLCBteSBleHRlcm5hbCBtb25pdG9ycyBzdG9w
cGVkIHdvcmtpbmcgKG5vDQo+ID4gaW5wdXQpIHdoZW4gc3RhcnRpbmcgbXkgZGlzcGxheSBtYW5h
Z2VyLg0KPiA+IE15IGhhcmR3YXJlOg0KPiA+IExlbm92byBUMTRzIEFNRCBnZW4gMQ0KPiA+IExl
bm92byBVU0ItQyBEb2NrIEdlbiAyIDQwQVMgKGZpcm13YXJlIHVwIHRvIGRhdGU6IDEzLjI0KQ0K
PiA+IDIgbW9uaXRvcnMgY29ubmVjdGVkIHZpYSBkb2NrIGFuZCB0aHVzIHZpYSBhbiBNU1QgaHVi
DQo+ID4NCj4gPiBSZXZlcnRpbmcgY29tbWl0IGQ3YjU2MzhiZDMzNzRhNDdmMGIwMzg0NDkxMThi
MTJkOGQ2ZTM5MWMgZml4ZXMgdGhlDQo+ID4gaXNzdWUuDQo+ID4NCj4gPiBCZXN0IHJlZ2FyZHMs
DQo+ID4gVmVyb25pa2ENCg==
