Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2523E540918
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349854AbiFGSFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351890AbiFGSCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD6C1312AD;
        Tue,  7 Jun 2022 10:46:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XluE4twAe4fX8ltriW92alA3wm5NUQl1pZ8rQkBG9xw1JFn/BNYfIyPW302G0JgX3nGkvjJK1fG6/qeF3eH8yt5NBObrFSKXVyUawRK6lpYtdl6CWiCFpZPQxFKLpJh40j/bQ8PNdc/H7ZI/UXGmVCvJ4p3IbPvo4lSj1ZLcTyX2hxt6bqQtxIOcn/fbielPf1/T7dNm4hceS7QLMFuzzX2yeKbo+jeitHxNwA8c3UcOjTNY1zpRvH6Bze4Zomuqgazh+YEMFabPb/9Ed0EpcxzwRMdwnI4EVPBnKj2T5Qu+j89Gb9wgRynWKDCMjuwTCWXj5sRIqvNaRAbs1Y75vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQXIAlGBxXpS+sOpK6Fbbz1rZ1scRfdEHbwfEVMBp1M=;
 b=ITS2DSZ1c6r0KlZZ+tp+uaEatEKWBom59v0WxmFqv53oc7dMgpCypOBFh41FhEz3/A1qGDz+tTeS5ftianm+ZS3hh4vpLyIP10xO7X20BesTESWfFTrAUDZD/Ow99Y3GJ5DudXGg68iPGPGr7bJOKptq6ZeGjoVtZuiNs5E7+iYA7bGxax+m479qR2FKSiDFs6g3njzIgr2/cLP1xB9MrL074aLdSl6DxGBXz6vaJqD3Xa5xFa0tjWgx/zZFyKMI81t/ogfcvlplHP6drkzJGbWBVpfvOA7QQeQeRwDR7QgxD580gcIrtoUUhw/mdxSMP7yy1hNpFHfJXdrTOyNtgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQXIAlGBxXpS+sOpK6Fbbz1rZ1scRfdEHbwfEVMBp1M=;
 b=u9deS1JKI7vJaTbpQMULOc1lX8EQwxpOMTotflicnxtv4pwI1szSm+DDSl7BuMXkZKwM6+0GcgQPCo/XuU/EcSO+h9Na6TiTFIjyoMUSDgfkDWMxvp+JyENwKq5qEm/jn5zElUTagep1byIPHrWWLiuwTeNFkRhSn+Ef0JTC2RE=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM6PR12MB4467.namprd12.prod.outlook.com (2603:10b6:5:2a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Tue, 7 Jun
 2022 17:46:01 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::589b:a1f6:9c87:a8ba]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::589b:a1f6:9c87:a8ba%6]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 17:46:01 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wong, Alice" <Shiwei.Wong@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.10 065/452] drm/amdgpu/ucode: Remove firmware load type
 check in amdgpu_ucode_free_bo
Thread-Topic: [PATCH 5.10 065/452] drm/amdgpu/ucode: Remove firmware load type
 check in amdgpu_ucode_free_bo
Thread-Index: AQHYepL5pPxigf4tn0SR4uYAIkKWz61EM4DAgAAEEwA=
Date:   Tue, 7 Jun 2022 17:46:01 +0000
Message-ID: <BL1PR12MB51449BEDB5E2D3C27F300EC1F7A59@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20220607164908.521895282@linuxfoundation.org>
 <20220607164910.488356562@linuxfoundation.org>
 <BL1PR12MB5144C45C376EA576CE8A4744F7A59@BL1PR12MB5144.namprd12.prod.outlook.com>
In-Reply-To: <BL1PR12MB5144C45C376EA576CE8A4744F7A59@BL1PR12MB5144.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-07T17:32:52Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=3d095b12-2a38-45ef-a760-58edf76ed3ed;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-07T17:45:59Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 3cafb836-c187-4de5-9736-ce0568b09e47
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65a2e97b-1ca3-40b3-26c4-08da48ad961f
x-ms-traffictypediagnostic: DM6PR12MB4467:EE_
x-microsoft-antispam-prvs: <DM6PR12MB44670ED32794469A25699966F7A59@DM6PR12MB4467.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gbFKj/XbpS+72IUxMGB9WC0kAdLHcDfcUKXG0UpFVMDhjDMq8ltwDNkaD/wVQy41AupYK/i7k7i0gY6Rc17L/98iJ2XgsAwlGwRZwh5drBjLEwIHApbEPxB+6g/w6D8So/1gKpERiUSurNxqqM0G/JSufErNKL58tQyZspE0+lY10Ih7uDQ3XYzsmmd/dBm2IPPzBgvvHBk4WSX/rW1jO5sez3jJS8ZBj4o8RZr2VwBRLMr86B9s+9fvoj4PtklIv3P11luPgDs32oMkWKOkr2zZvG3O66z51ZLvhl8nseBQ+LYlae1a3ktD2zNJPtTqDkL7jY/rU1YoSkNEHXu/53aG+DdVyea4/s64zr8qr3tF3wiupTc/4RGv9qJo8aptY4sMYmFON+zHvMBFJ2WvVurJCx2jF+6IPk/UQlpt5l6IRIuFpwl8pDmv+cVczvHlOjQMw4VF1OHC2knH3Z7YP0+W0b8TVznWPtOlEss9i9H3cC+LkF1rvJ2c302VHUnndYM0qU9PrC8L2Nc0h6DTyUfET8p5AyQ2lENUPJQa9xLuOxTJHQw1Sltmtx1XqacpmQu0m5g6c8Guxx2/uxg4SjSelsKMNLnPHnY1OO+YlHu4p3PzL3WoJk+wKC6j+kwTRT5zNnO6Vx5dsvI7SArl0UFxnscBv9/b2zcgCxNfGtmKFm8cb1LW5aFWLGa+kLwbmBScxo/YJm5q++tGnWJ7wQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(6506007)(26005)(7696005)(86362001)(5660300002)(508600001)(8936002)(33656002)(38100700002)(52536014)(122000001)(110136005)(71200400001)(54906003)(186003)(2906002)(83380400001)(316002)(9686003)(2940100002)(76116006)(4326008)(55016003)(8676002)(64756008)(66476007)(66446008)(38070700005)(66556008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bENRSVRHWlVhZmQrYVQ5YmYvQmdZT1g2VnJFdCtoM2lXWlBTclVmbXBhVFBm?=
 =?utf-8?B?c0Jhb0w5dHFPdGdvVlpieW1zTEtPR2xUbDFVQllpUXR2WmNFT2xPczRuMUZ2?=
 =?utf-8?B?R0IvMWhuN3M0bXlibW82cHd3T1lDQTdrdXEvNFh3eGtWOXhSellORjZGTDNN?=
 =?utf-8?B?QWR6SHZmUTdMeFBNQkZ3UEZBNnZKMGVxZUlmZk9lbjd2aHo3b0l2djZPM0ll?=
 =?utf-8?B?V082ZXdVbzRnc3hzZTVvNFFZV1JyMVV0c3luWXN1MDhDOGpXdTB0MEFDNENl?=
 =?utf-8?B?WlFpejdML1o0R1kxNDlwSTFnZU53am85YThkNUxtcXZqeUhkSWFrd3BoZUZy?=
 =?utf-8?B?Y2lPUnUzelBBMmQ4SE1tMTZscXA5eDBQUStZeklEVmttYzVPTW1FRUxwb2cx?=
 =?utf-8?B?QkZFZ1d2QWRXK2dIYzdOQ0JrRG5ZZE45Q0xQRG1zb0R3Z0hUTHFocnRQQmtm?=
 =?utf-8?B?eHpEQmxSOS9Ha3J1TnpIOC81SUNaTEVOM2NONE5Wd2hSRk1LQUFlOEdkcGM3?=
 =?utf-8?B?RWJkUSs3a3JzUlErY3gzWkVVUnFzSW44SGEwSC9lMnExcjdUU0FkbEdoMVBJ?=
 =?utf-8?B?T0EwcUtPSWFoWmpwNHhnejlWRDFxY0FTTGRpaGR1NU9SS2s3UnYrVHBmeVV6?=
 =?utf-8?B?cDRQTTZTRzdnREpIT2t6Q0c4Wkp5MXpPTE9MODAzQXlwSWNwbis5Y21OeEFS?=
 =?utf-8?B?dk5LWWU2WWJNenBtWkFDSHlNMHlpWlkxVmRMQVZBOW5rZXk5VyszZUF5ekhu?=
 =?utf-8?B?V3VsV1J4cm0vTTBsVkFDc1FJNTJwaFdXMVpXREhMdGNSMW00UWdOalo1RWVT?=
 =?utf-8?B?VnpZQlZxbVlLbzlrdnVTUXB5UXVmUGloYW5oVVVxRmlMZHhpT2xydnd4Y2ZJ?=
 =?utf-8?B?NlZjeTFELy9XelNWQXd1Nkw2Ukt1cWFFbVlhalpzdk5uU1Q3S3JLOVV1RXNr?=
 =?utf-8?B?T3oraHdFcnlXNHkzYkNFVnJUSlM3V1lRVE5GRlRqdUlnVlhidVVtQXQvOHZ2?=
 =?utf-8?B?TWxsc3FPMW9ldmZsUFFrTE9tazFENkdqM2N3Ui84OG9YNHhSTWJ1OEQxSytB?=
 =?utf-8?B?U3d1RDRaVEtORnRGUFBjWmovNFl4d0xmb0hDaHYyZUk4UVZlTmN2TE42MkVu?=
 =?utf-8?B?YVNoMlFqODBNQVZSTHVHVE85L0tBUWxmQm5LaW96Q3RpY3FSdWdOZS9ubDkr?=
 =?utf-8?B?a0FnQVhlRlZvQWpUMHAvN01YWGVvNFd3S2dtRFY1TThoYjlDUlVtYjNnOW1v?=
 =?utf-8?B?emJpWjJSYWVYck81Rnd6b3ZySmJ0QlJtR21udE9LVkJPOWpMQVRTMjI5RnR4?=
 =?utf-8?B?NFowYkZLaEtxcjZIazNhYnhBK3pWMC9NT25KQ0hNUzduQnVxamZJdnlYRDJT?=
 =?utf-8?B?RlVEbFFMMGt1SktnRVNtZ0FOdEpzalN6NlcrU2tIcVJuZGNVa0Eyak5YSXpC?=
 =?utf-8?B?a2lUSlNCV1ltdXRDb3I0eWx0cmYyUVh1V09rcFMzUFpCeXBBSU5CNkFaWHNi?=
 =?utf-8?B?eVhjWmg5VVZjcUpQekU3TzdzWERkZWVxaGd5Uk1XNTdmTk1peVVwdWdYRnhK?=
 =?utf-8?B?dnI0UnFUa3hwUWw4TUQzd2JzYWkvYnJvVForM3VScUR5U0M4RmVRSnppUVlw?=
 =?utf-8?B?OGR3OEtwZWxReWZ2YWljUmNoSUptcitxSCt4Ly9ObDBPL3FoTkpZNFE0ajJk?=
 =?utf-8?B?Uml3MHJmVlAzYldFekhYMm1sbTJFdFloUXNLMGRQK0JDbitweE9SNnZyVlFo?=
 =?utf-8?B?MHVSeS9TS2lXWm1BVEZCOWpXVmxGRDZUdTMvcUR0YlZrcC9iN1BDS2E5Wkdq?=
 =?utf-8?B?NTlQb2UyYVNTWmFaQ0s0YW9JV0RnMVM0aWZTdUJkbVdjTVpxRE9JM0doalht?=
 =?utf-8?B?dGg2MVB1VEdrdkppOHRHTlpsK21KdXpBdGJYMFI4WVU0UnlYMWQ2MzFtS214?=
 =?utf-8?B?NW11TE9xd3VvbEtFcVpBaFRQWWJGWFY3alBnWENvK3NFbTRYbTB2V3hiK2xK?=
 =?utf-8?B?d3NIQ2FYNVkwdXo1cUtsalRXWFcvNHVlQzhwR2VPRVdQZko5QU8xditJYzM5?=
 =?utf-8?B?eThIdkQvMldRajdTME4yOU5Va2xhV3VpKzRVRmtEdDZTMGxvTTdFd2hFWExP?=
 =?utf-8?B?NytkZlVtSk8wK0Juc3FManlhVVFXek5nNW9COGR4VG9YV2RNMUpXWG4zVDll?=
 =?utf-8?B?dWc0bGI4eTRCVjRMZG83YjhBWEh4WmVlaERLQUlkUnBSdzlNY1lXcC9xa3p1?=
 =?utf-8?B?Q0d3YWF3S1JWVU5IeTlqR05TNzAwdHJ2Unh4WVN2VjE3eEN0UE5zOHFBaDFh?=
 =?utf-8?B?dU5xb2xNRSsvYXo0dUZJREFuY2dOZHRjcGR6RGU5UG5iVzZuMmRkUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65a2e97b-1ca3-40b3-26c4-08da48ad961f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 17:46:01.1355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QOthO2HgMcY3XCnhbhpROwK1TulPXQq5+Flq9iZY2OxnXvpaRY8XSUkA1L6iSMNr4wZRvH8QWLOGOLm7LeQimg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4467
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEZXVjaGVy
LCBBbGV4YW5kZXINCj4gU2VudDogVHVlc2RheSwgSnVuZSA3LCAyMDIyIDE6MzMgUE0NCj4gVG86
IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBsaW51eC0N
Cj4ga2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZzsg
V29uZywgQWxpY2UgPFNoaXdlaS5Xb25nQGFtZC5jb20+OyBTYXNoYQ0KPiBMZXZpbiA8c2FzaGFs
QGtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggNS4xMCAwNjUvNDUyXSBkcm0vYW1k
Z3B1L3Vjb2RlOiBSZW1vdmUgZmlybXdhcmUNCj4gbG9hZCB0eXBlIGNoZWNrIGluIGFtZGdwdV91
Y29kZV9mcmVlX2JvDQo+IA0KPiBbUHVibGljXQ0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KPiA+IEZyb206IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRh
dGlvbi5vcmc+DQo+ID4gU2VudDogVHVlc2RheSwgSnVuZSA3LCAyMDIyIDEyOjU5IFBNDQo+ID4g
VG86IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBDYzogR3JlZyBLcm9haC1IYXJ0
bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47DQo+ID4gc3RhYmxlQHZnZXIua2VybmVs
Lm9yZzsgV29uZywgQWxpY2UgPFNoaXdlaS5Xb25nQGFtZC5jb20+OyBEZXVjaGVyLA0KPiA+IEFs
ZXhhbmRlciA8QWxleGFuZGVyLkRldWNoZXJAYW1kLmNvbT47IFNhc2hhIExldmluDQo+IDxzYXNo
YWxAa2VybmVsLm9yZz4NCj4gPiBTdWJqZWN0OiBbUEFUQ0ggNS4xMCAwNjUvNDUyXSBkcm0vYW1k
Z3B1L3Vjb2RlOiBSZW1vdmUgZmlybXdhcmUgbG9hZA0KPiA+IHR5cGUgY2hlY2sgaW4gYW1kZ3B1
X3Vjb2RlX2ZyZWVfYm8NCj4gPg0KPiA+IEZyb206IEFsaWNlIFdvbmcgPHNoaXdlaS53b25nQGFt
ZC5jb20+DQo+ID4NCj4gPiBbIFVwc3RyZWFtIGNvbW1pdCBhYjBjZDRhOWFlNWI0Njc5YjcxNGQ4
ZGJmZWRjMDkwMWZlY2RjZTlmIF0NCj4gPg0KPiA+IFdoZW4gcHNwX2h3X2luaXQgZmFpbGVkLCBp
dCB3aWxsIHNldCB0aGUgbG9hZF90eXBlIHRvDQo+ID4gQU1ER1BVX0ZXX0xPQURfRElSRUNULg0K
PiA+IER1cmluZyBhbWRncHVfZGV2aWNlX2lwX2ZpbmksIGFtZGdwdV91Y29kZV9mcmVlX2JvIGNo
ZWNrcyB0aGF0DQo+ID4gbG9hZF90eXBlIGlzIEFNREdQVV9GV19MT0FEX0RJUkVDVCBhbmQgc2tp
cHMgZGVhbGxvY2F0aW5nIGZ3X2J1Zg0KPiA+IGNhdXNpbmcgbWVtb3J5IGxlYWsuDQo+ID4gUmVt
b3ZlIGxvYWRfdHlwZSBjaGVjayBpbiBhbWRncHVfdWNvZGVfZnJlZV9iby4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEFsaWNlIFdvbmcgPHNoaXdlaS53b25nQGFtZC5jb20+DQo+ID4gUmV2aWV3
ZWQtYnk6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+DQo+ID4g
U2lnbmVkLW9mZi1ieTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiANCj4gDQo+
IEkgZG9uJ3QgdGhpbmsgdGhpcyBwYXRjaCBpcyByZWxldmFudCBmb3Iga2VybmVscyBvbGRlciB0
aGFuIDUuMTkuICBJIHNob3VsZG4ndCBodXJ0DQo+IGFueXRoaW5nIGhvd2V2ZXIuDQoNCk5ldmVy
bWluZCwgSSBzZWUgdGhhdCBTYXNoYSBiYWNrcG9ydGVkIHRoZSBlbnRpcmUgc2VyaWVzIHRoYXQg
dGhpcyBwYXRjaCBkZXBlbmRzIG9uLg0KDQpBbGV4DQoNCj4gDQo+IEFsZXgNCj4gDQo+ID4gLS0t
DQo+ID4gIGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV91Y29kZS5jIHwgMyArLS0N
Cj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV91Y29k
ZS5jDQo+ID4gYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfdWNvZGUuYw0KPiA+
IGluZGV4IGIzMTNjZTRjM2U5Ny4uMzAwMDVlZDgxNTZmIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV91Y29kZS5jDQo+ID4gKysrIGIvZHJpdmVycy9n
cHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1X3Vjb2RlLmMNCj4gPiBAQCAtNjI1LDggKzYyNSw3IEBA
IGludCBhbWRncHVfdWNvZGVfY3JlYXRlX2JvKHN0cnVjdA0KPiBhbWRncHVfZGV2aWNlDQo+ID4g
KmFkZXYpDQo+ID4NCj4gPiAgdm9pZCBhbWRncHVfdWNvZGVfZnJlZV9ibyhzdHJ1Y3QgYW1kZ3B1
X2RldmljZSAqYWRldikgIHsNCj4gPiAtCWlmIChhZGV2LT5maXJtd2FyZS5sb2FkX3R5cGUgIT0g
QU1ER1BVX0ZXX0xPQURfRElSRUNUKQ0KPiA+IC0JCWFtZGdwdV9ib19mcmVlX2tlcm5lbCgmYWRl
di0+ZmlybXdhcmUuZndfYnVmLA0KPiA+ICsJYW1kZ3B1X2JvX2ZyZWVfa2VybmVsKCZhZGV2LT5m
aXJtd2FyZS5md19idWYsDQo+ID4gIAkJJmFkZXYtPmZpcm13YXJlLmZ3X2J1Zl9tYywNCj4gPiAg
CQkmYWRldi0+ZmlybXdhcmUuZndfYnVmX3B0cik7DQo+ID4gIH0NCj4gPiAtLQ0KPiA+IDIuMzUu
MQ0KPiA+DQo+ID4NCg==
