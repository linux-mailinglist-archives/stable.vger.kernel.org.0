Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF0A66CF85
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 20:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbjAPT1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 14:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbjAPT1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 14:27:09 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B4F2B28A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 11:27:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfZAP1KbEbng92uWZBwGUKI97pV7BtOTbZ23llG3dy0SAm9SolKtcisILPA+Y39eac3CWanMrV8P8kIz2vsbFmgczcXqaNYYxzUTwA7jL+FL/L68Ds0gKpIueFX+/LLoNrouVUXe5PxyxdetSAiP3xDPxzUmFp+WVoVeAItcz6NwoVXxuWGwoQ0idIJpN3Kq1RVHWj8QhJYxhYWUeCxDnvMm70Y9nJAfkh/JI4VekLStfDHjOE9lV6wuxTTUsnF7EftOhMlKxWvH1YJVpLyw48mr0npm2t23bSkKQB3aimj366cvb96CufffmcG5m7HJE9ARglb24lAOIzfLfdAQqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1hBiXe+wNxfuLOkxK5bGTiD//VEdbmU2lNsntJEmD0=;
 b=jSqPgkQbVIwx+cqS56AOj76RqWbTj9mZgKcUDjEoWy5eDuECXJf/F2u+UmOiw96ai+7RPIHT9Z8RCWCJBUgD0XdtIVMp4yPZb+3y84UAhazTmIo5pRZJaBHaW3q+Mo8E/VFRQp7p9qzDXAL7uVujhiOhvyLHG/kZD0XkKW40B9rrRLK114PpcbRmBVEusCiAhWb0GHL2l5BCIaKg5o8N2Sm5SYfF1JZPhfU1dmTC1iSfNNYjYwtl4R2jRd+A7oNxH+1+WzEZlA432+oxOamJuCSt0jSY62MfY+Snwuy8HOviTwViMSuatTeYSVcx2vdpMctz/tpKWy26qdeshB5FrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1hBiXe+wNxfuLOkxK5bGTiD//VEdbmU2lNsntJEmD0=;
 b=tUB6i0a/YBTjRkMkWuiI5mmLrApgpo3LrUjwHMupoYuDgfbVHNwTFw9mD2usMcY+BFBjXtKf+r8pZxrQcsoSCdp44agjwhQNURSwMEhiv39lmnPSR+FGACrihiolADDORCIMHzzl1P9rqVWYo0t/OBuZaInmybdW44rmLEJA9uA=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH8PR12MB6748.namprd12.prod.outlook.com (2603:10b6:510:1c4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 19:27:05 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%8]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 19:27:05 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Gong, Richard" <Richard.Gong@amd.com>
Subject: Minor changes for supporting products with GC 11.0.4
Thread-Topic: Minor changes for supporting products with GC 11.0.4
Thread-Index: Adkp4IOprinj+G+QRTa+xGNq2js50g==
Date:   Mon, 16 Jan 2023 19:27:05 +0000
Message-ID: <MN0PR12MB61011CBAC4D256484D291A8BE2C19@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-01-16T19:27:04Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=73ceda5e-9826-4703-aeed-df039714b055;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-01-16T19:27:04Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 54f08e73-d968-4f1d-9571-23079f4e9e5a
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|PH8PR12MB6748:EE_
x-ms-office365-filtering-correlation-id: 80784705-48ed-4dd6-e114-08daf7f7a700
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1p3MQRXKDV2axkWLyDLubVhZUrVnKqlPOOiCJwlQon9wHn0rltgjoJJS/NAHyvxq1dv05V0Tv9Ebz4ofhc02ZkQSHviMPuuzijCNWOLTHdc22fbl48EzpzHjIlQnl98dwkUNOxVi8cr/3uygtgdVZ2MKqXVpnh6kIGnmeRIpv1I7JsQQROVZNk2qCEIhrLv/vongxUr4Mvp9NsdTxBI++QPI3ItyCk49InjZDX+JZmoUQGhYEO9vLi44fA79QlZeK60PbgSIWke4oTyFWZhW1A7Lm83x1veLQNV+gQOZodFyGyA6Kn2RVPPfojoJ7mBpblRX7YORi+/n7bFufRGIYJDZxzkAeOnsksi5ojT62NkunIoh7d2ZvJBWltnUX6MqxVWrpE2muXTxMBLIouAKp1ZdA7NfxiSkcVNQsxBCjfUw4bn39Tn5pS+BdIpM1WE2g/OFnGZYxHjyiMu4QgoTteM2+zazRv6cNSz0+blp83a36+VfTx+s2mfBSYq+d0YfvTm/UMEDC4AlKfm55L170uZrzDvrlp21wQbIZcNEcJDuIFcc+iCk4lLY4dQzenAhP7WFcW99RFuJlkMZ1rLe2KAyZkb9VQtKF/2eXZgegz6thIQuRF/qadkcuj5BfARljyPXTfEehp1GcV9wls6sqdYnVm1AVqAZ5DtQPG9FCs7RkmYUPfxavIOZ9INhf0T3hBnIsTMZQQnLvm6LH4lf+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199015)(33656002)(86362001)(186003)(9686003)(26005)(6916009)(4326008)(8676002)(64756008)(66556008)(41300700001)(76116006)(66476007)(66946007)(66446008)(316002)(71200400001)(6506007)(55016003)(7696005)(478600001)(122000001)(2906002)(38070700005)(38100700002)(83380400001)(5660300002)(52536014)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gbbHy7Nd+Nu0v0ogXlr8cU5fTxDe6Bb86h0YMq9hMz0Gjvf44waNj/SvhBmQ?=
 =?us-ascii?Q?jP5o30kjatn1vBOKvdYOjFf8v2MOBvmkQuPHKU9JabDycmaJp8FuDS8K4o4F?=
 =?us-ascii?Q?gWjaoJdgStoGNJHJERyHzwn881LPaliQW4SU6UhbM7oxwhtnKfua+BikFiy0?=
 =?us-ascii?Q?vDw45SfW4oEp1vv4GUqNmfUPBWOQhNtfyiuE+TpUG8s+HxUq/PtEJvlib9db?=
 =?us-ascii?Q?b3pS00JD0DCXfraHM6pFzITkRTKmskoTkGqVDCffmCKbwZPR33eUjoNPmPMm?=
 =?us-ascii?Q?UmfPKBDijKr8QzLzs2Pmi4EgSIGUc41g2ovlruQDuigQG+cyHiveHzF+5jmg?=
 =?us-ascii?Q?/sweFEmZhge1H9lnRW70WhsXZbbpvSX3cD9Ojuyt10qUwloL4I1YwK2mfD5p?=
 =?us-ascii?Q?56WgVxpR6wEnODKsM2aKVkVEB68A2bKdouZq/bmbqBmSBVUIvzd4HwaVTjj9?=
 =?us-ascii?Q?RJc34cJjpypBRcrCXivb4wqrctNTZbwviYkIbcB9n/X95MnLGel8r4LCap8O?=
 =?us-ascii?Q?iHqOXa/uNGBvItnjG6iLKzLnDcoPylHgS+Wis9sgrVkSP6T70UQ45kqQ9Tyk?=
 =?us-ascii?Q?0RRCAsX7/KrYB8yfIlI1PlRhl1L2Wuf3EjcYXe/QQvPBXqzi9cYsKDtxvwF0?=
 =?us-ascii?Q?QrS9+gU9BuJsdaoWTICHk9uDIKqNE2jJ938dcxavT44wWFW4mt+hwmJa1ICg?=
 =?us-ascii?Q?ZikGwqK/SjqsgdoIB09/3WGFFUvGohpQ4rfr1+SyuAeW5mqOlDoTKk9aMT/s?=
 =?us-ascii?Q?05mEnJFSoMaT8SsGyFWS5nGLLgRWnMd+zzAmQ+0pJuS3faX0B8zNWcaZ+/OR?=
 =?us-ascii?Q?BDKyoHA2D8IH5SY+dam7HkpWYbgYu0tx0StghxgwhFPReFCRBlLcctnWZ43V?=
 =?us-ascii?Q?rFRrFf5dBFXcGnKfpc61TAFACQu+7iLH3rYwZjDC7ziIzwA2mbzWpEn3tGgV?=
 =?us-ascii?Q?z0TnPIpEjPoVcJJ/WJCZScTKK7l1HK89r2db40JfrsLIrhwHozV8LDCPEhFz?=
 =?us-ascii?Q?o+KkGQUXDyKjYqst3j9a3bweJDpq5N+DBDAofaMtQdeQLYEjbJ9vEaa3A00S?=
 =?us-ascii?Q?Ws1reGp4tDq42A86m8SAum7UyUV+KG6xr0mru6YlvCMTaUHYp5+uzLA3703m?=
 =?us-ascii?Q?Cm+eqeSv4VV1tHCMUA0OoGpNgTeQzLSOjZ0pC4sEmTWuYyfNA5ahQQpW5xN2?=
 =?us-ascii?Q?k8g3KHSCkposAFIZk1kxucKS1bumafVuRN126GO2I2ZwiJTnPgK1Me8pvo6D?=
 =?us-ascii?Q?CebGx2ZMa9ukmmPk8T4/YGoW9skb0AZdkFs73DtcmbAhnoKmDWi6Lq9kejSz?=
 =?us-ascii?Q?n/lA0BUrjpL67eSh9WFsQW9lPHAFrBcfCHQ1xR4nmDSQxoCQLVFc8uM1LkIE?=
 =?us-ascii?Q?JVeyGOWtMT6TyMXi1wuV3HBNYaWY+8I9kli007cPkhADkFZrHlwG4XvSKZ+m?=
 =?us-ascii?Q?1LWURtN9yQQx0CR3rO9G1egu0H3Vtln+40lPzWc41vANE5wEEFRMOnlWe/Se?=
 =?us-ascii?Q?6StNCuG3ZHm+NyZJ/nl1zRR1kACw6kOuz17IqcgTqy70LdPBB2rikbP+UPo0?=
 =?us-ascii?Q?jl4SXfiWCFwTGvsezKc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80784705-48ed-4dd6-e114-08daf7f7a700
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 19:27:05.6870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fC36JCVjwIfPJKzby+b1+qC/8Ny4+RXZ3GC1KGkvOWlLNaaCqgQi4tkgVP2Qa/Ad2rNOmRcaLI/ULoomkROKvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6748
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

AMDGPU changed the codebase to use IP block versions rather than device IDs=
.
Some products that contain IP blocks "GC 11.0.4", "PSP 13.0.11" and "NBIO 7=
.7.1" work with the code in 6.1.y, but the various switch/case statements f=
or IP version match are missing for these.

So the following minor changes allow those products to work with accelerati=
on on 6.1.y:

69dc98bbd441 ("drm/amdgpu/discovery: enable soc21 common for GC 11.0.4")
d5fd8c89ed20 ("drm/amdgpu/discovery: enable gmc v11 for GC 11.0.4")
b952d6b3d3ff ("drm/amdgpu/discovery: enable gfx v11 for GC 11.0.4")
6a6af77570ad ("drm/amdgpu/discovery: enable mes support for GC v11.0.4")
94ab70685844 ("drm/amdgpu: set GC 11.0.4 family")
dd2d9c7fd771 ("drm/amdgpu/discovery: set the APU flag for GC 11.0.4")
1763cb65e870 ("drm/amdgpu: add gfx support for GC 11.0.4")
311d52367d0a ("drm/amdgpu: add soc21 common ip block support for GC 11.0.4"=
)
d0ca8248999e ("drm/amdgpu: add gmc v11 support for GC 11.0.4")
7c1389f1b122 ("drm/amdgpu/discovery: add PSP IP v13.0.11 support")
16412a94364d ("drm/amdgpu/pm: enable swsmu for SMU IP v13.0.11")
51e7a2168769 ("drm/amdgpu: add smu 13 support for smu 13.0.11")
9f83e61201bb ("drm/amdgpu/pm: add GFXOFF control IP version check for SMU I=
P v13.0.11")
18ad18853cf2 ("drm/amdgpu/soc21: add mode2 asic reset for SMU IP v13.0.11")
069a5af97ce3 ("drm/amdgpu/pm: use the specific mailbox registers only for S=
MU IP v13.0.4")
7308ceb44663 ("drm/amdgpu/discovery: enable nbio support for NBIO v7.7.1")
2a0fe2ca6e9c ("drm/amdgpu: Enable pg/cg flags on GC11_0_4 for VCN")
2c83e3fd928b ("drm/amdgpu: enable PSP IP v13.0.11 support")
f2b91e5a7cc0 ("drm/amdgpu: enable GFX IP v11.0.4 CG support")
a89e2965da6e ("drm/amdgpu: enable GFX Power Gating for GC IP v11.0.4")
f9caa237372b ("drm/amdgpu: enable GFX Clock Gating control for GC IP v11.0.=
4")
97074216917b ("drm/amdgpu: add tmz support for GC 11.0.1")
2aecbe492a3c ("drm/amdgpu: add tmz support for GC IP v11.0.4")

Can these please be brought into 6.1.y?  As amdgpu switched from device IDs=
 to IP blocks these are akin to "device ID" support.

Thanks,=
