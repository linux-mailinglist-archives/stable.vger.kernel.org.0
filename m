Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818EC52BD42
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 16:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237090AbiERMm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237616AbiERMmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:42:51 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4EB1AB786;
        Wed, 18 May 2022 05:37:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaL5yoJdkc0fxVvqgKIqYKDsWAHFi49wxtUXoILCD6juyK21MSNHiAiC/xakHpW86We3d4cn/8lONMCcWQgqcXmzVxKoPhcQ/AFOmbcSeFEQXhudWhxhfNOuBw3QoZqCYyguhnCPwRM/n6NCR5ZWU5QKRALiWLNjvRjs8phy0oZmE8uoIyMJRXD+mQSmI9fi6nG5pF4ISCqDSr6/0Fi/y1TN5p7wYQKsU04YXr4SJGmJKaJIrPxE8EsExY4yV5FM7r6oSv4t3zLpH2L3o3nTjNF48mHAxnviXGlx40QK2rLk++tciV0KkwZ9P7DcYOIZk2Yotf2VgBvs3vVP6Z8EmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7E+Re84kAUwTEEjMiQhH1qMuKRVMcYmtmU228XBUmbE=;
 b=HkO7eeaEjYkGrGl9hVLjMprLqUDAjlPGSG5BacTHvQmDqQ4xK0E6XG+1aqP1XUrJ3CUTx8FnPg8OH89djCFvUeU1GokmLRPdBGChG1UgTZwJTtTbA1clMQwuWpTsVZPcGRHMjV7GLAlhNkVgaaGX+7fsJM2NfJI2dZTN1O0rma3VP/3hdKTUFYTYIcWq6AgldpteEL201xEv9POgKVK3PMO0LF6ReU/5YV3wpanmBXOHY0sQ0+w1RhWvh2M8KQnrd47nWEqO0EGDvox5AxrileKJ+SWZdN0j/y2eDJQGTU6HJktVOjWOodoKJvrem0JgcwLSy9R/JqduvxBC7VA8QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7E+Re84kAUwTEEjMiQhH1qMuKRVMcYmtmU228XBUmbE=;
 b=FyXkTJWGMkB9lIaqZzLM9ABlcV4HAzVzlWkoShHgxSvA3BZ3Z0tznWmJHASgrkzbW7qfhimjj60Gnw6MWQg/hQq4AcCqALo/LMcLqs3oDYzLYg4JJ+ppMjladmQfWR7seKxd7oAan8SsSZS4lwVec/m3gmezAfZnlrMwsKOVih8=
Received: from MW4PR12MB5668.namprd12.prod.outlook.com (2603:10b6:303:16b::13)
 by MWHPR1201MB0144.namprd12.prod.outlook.com (2603:10b6:301:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 12:36:40 +0000
Received: from MW4PR12MB5668.namprd12.prod.outlook.com
 ([fe80::4911:d6fa:f15f:a139]) by MW4PR12MB5668.namprd12.prod.outlook.com
 ([fe80::4911:d6fa:f15f:a139%6]) with mapi id 15.20.5227.023; Wed, 18 May 2022
 12:36:40 +0000
From:   "VURDIGERENATARAJ, CHANDAN" <CHANDAN.VURDIGERENATARAJ@amd.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Yang, Eric" <Eric.Yang2@amd.com>,
        "haonan.wang2@amd.com" <haonan.wang2@amd.com>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "wyatt.wood@amd.com" <wyatt.wood@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "mikita.lipski@amd.com" <mikita.lipski@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Kotarac, Pavle" <Pavle.Kotarac@amd.com>
Subject: RE: [PATCH AUTOSEL 5.17 13/23] drm/amd/display: undo clearing of z10
 related function pointers
Thread-Topic: [PATCH AUTOSEL 5.17 13/23] drm/amd/display: undo clearing of z10
 related function pointers
Thread-Index: AQHYarKiOZP/iIcp70e9k8jQNn0/Va0kkcYw
Date:   Wed, 18 May 2022 12:36:40 +0000
Message-ID: <MW4PR12MB5668AA4277ABA5A76CAABB1F96D19@MW4PR12MB5668.namprd12.prod.outlook.com>
References: <20220518122641.342120-1-sashal@kernel.org>
 <20220518122641.342120-13-sashal@kernel.org>
In-Reply-To: <20220518122641.342120-13-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c59cf9a-2ae2-4a46-b92a-08da38cb0ef6
x-ms-traffictypediagnostic: MWHPR1201MB0144:EE_
x-microsoft-antispam-prvs: <MWHPR1201MB014474D1B400BD8517EE6BCB96D19@MWHPR1201MB0144.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GJ1UBA5Wnc8bbPMAkWb0G9wmCAzwN/EBFgRjNVU3n/1CIeDKESg8ARb8Sx1cwnDgs6fbLKvf4TVAQS1ydTwxpfZFYn7Gl5/CYFevTifBOqhzWJg4w4FVCLhF+/a+m6/hCjgV/LkDOA43WiN+WmheK7lj8N3w3aHM7NHPt3CmUqE9HoSB9tCRbDBKYBGW5fyekr7og1+j6W+snOP6MHkvXOriDgWSPv6lIBL5mV0QnkiBc8OmRwsH4ABsUtYVfVzATj4wlWpL4Z+DlxA7ZH+R9OJEGztnGzNyZ5jyLTxeECR/gak6pYIK/mztdgDIKAX9yzLTmuAGh/R06Yh7hC0dJwhRjQRduSuJH44okdpHHa74md4eUJc9cxLv2Ga+nubNg3Ro4k7c6IdRBRlawC2oiWstnL7reTEuScOFQjAY/m52Suh8nCUiOMc4r3aU/3jeZojIEwSO0m5kNSGX36NolWIqUYhnuIY4PQbYkplT5OaKWek3QFTREU9lbLMIfzCAkmcANE1KIfp47jcH2GR6HAvKTrREjctAqS480b8KArqa3OL8QXxGI4g1kok2Q5SSB+0mAW70B7jcN4Rz36QknkIXCbUFqhA8pepiWmCcgepA/iVuJMm7PjX8lNpE2KARRDcD15nYFaQhzBjNHnUcKSxeV/i3exrajy/83fNpRw6sbHHf2sBaMvR/8cDgbIz+mKjLzoGwDw6foMgT6miP2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB5668.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(2906002)(33656002)(26005)(110136005)(66446008)(9686003)(66556008)(86362001)(7696005)(54906003)(38070700005)(66946007)(38100700002)(55016003)(76116006)(64756008)(66476007)(186003)(316002)(8676002)(6506007)(8936002)(122000001)(83380400001)(4326008)(52536014)(5660300002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f+Nx4/q19mNQWC3jmnviUYCvjU4auooNU3SUGlh98Lrj5Lj3s/ZPyfdi7tQm?=
 =?us-ascii?Q?a+1U3Az/mLBJAktyDraScJACmZ8SqTEY9WV8HxwnmKReocw2nhp+OzEijBZA?=
 =?us-ascii?Q?yy8K0zhQK0t0Yrin94ZbMB4Za7K1Ff2GOCTtEB6KgoIGDlQB+P5UCaaAH++j?=
 =?us-ascii?Q?kOvZvmvT3JbPtm7PAoJSJ/x9AMHePjceNyJKPssIoUEH0qpXDheImMqcpUts?=
 =?us-ascii?Q?Cfs+1qEX0R0WfqWzs8tGLelwkAPS7YsFEPzfxv2F+pRKo96gCZZtMmSMjI7Y?=
 =?us-ascii?Q?unismPjONrDLFuuT+GFvsADUcQ5Sj147QELY2K5QVicnazoiC/ApVP2DV8Z/?=
 =?us-ascii?Q?bEfomqu84+a4xLM4ipCDW35ihzCNwjmsMb9+08mZUU5wWIH43pGDaGWORJwx?=
 =?us-ascii?Q?/7dEJ1RIZhjGRlBqXJYRqGCtoIQpx6puBPkfIGTtCJhjdADpe3aqJH9oWh8+?=
 =?us-ascii?Q?FCodOSMNcbiQSwzQd0wggRSs4jBdsdPK/fo3nQtT0q2P+P+IxuY43ZxPt7EX?=
 =?us-ascii?Q?+jCl33+FsA5JrPaD0FczCtYB3lcpT1ogLE7ki0fKmfAHaeJRT64JXM6Fonmh?=
 =?us-ascii?Q?+pcOTMGb32zDsirEBhbFxZmxl897XnnuDPPzjxWQRCdrln/SiL0pPzqcFJr3?=
 =?us-ascii?Q?LqDRUvjMkPLqRMI/gHbPQQiO8833O1J1ymcLAUUszHseIYoAeloIRin+MqVk?=
 =?us-ascii?Q?ZXsvujFUu+F2Db5WtkWa2XfltvwCI5kRYm7YWK1JmI10fusBZRGhDfGktkYM?=
 =?us-ascii?Q?uMnefUvUdN3nUmGA5/taFq0apx/Ii0D4eenliol9uFrTTqsmpgQ22VP93oCR?=
 =?us-ascii?Q?cxboJ7m+BMWPiwPbpFZ4SLKPM97JcVmzY8xad1+1oUIE8oosFbCuolZ07LaE?=
 =?us-ascii?Q?TFuMPwrwWAbsqhr2/Fr573QkztvEbkbL7+3B8W7MBhDEpHrD2nDqZfNZy3K9?=
 =?us-ascii?Q?dxckvUzohijtiyBKjhStFOwkx+U/8fkZjaoLZrKNtB9CUJGBYiTwWjNZN4V+?=
 =?us-ascii?Q?YvV3Vg/Bg8E19Af7UTCRFFClExeKvP0dZhHhTiFjmgz74/XUo8a1FgJPIWWH?=
 =?us-ascii?Q?6a5LRM3DsdAabOg2UWN7VaVS/qjFb7AmgDQNheHsUE4TeKZ4r5E7kQrfnlIa?=
 =?us-ascii?Q?HARJPH6Zb7Pd0e9bXyf150dNbxha9bPG+ADUUy7PZDFgmOEtooz3AZ2xVU4S?=
 =?us-ascii?Q?RkgvzvST0obXrCLY7WdGwYvitgX/uSuRSA5WPDBpMTATb7OQKntRC4dx0hqy?=
 =?us-ascii?Q?toHxglehQmLFUQQedRn5h2FsQqt3hUV6Fo2qPP6pQ+/6pMbeQMcDhhwWccA2?=
 =?us-ascii?Q?ZfGVPP5+s/KqZGyjVRDdum1pT9oErUaO0kY5s0n51CAZflcaeP2RnaipOdZa?=
 =?us-ascii?Q?Xn7dYqN/amGexkLpqIEYLvPcJIIQuS/iqssEP+HoGKOww/gCg4cS9KbggAlJ?=
 =?us-ascii?Q?BuccNIMOxWSQjaliVDrMWUqqp0IGmsFdCAxF9aeC7D1qMjzYu5ZyX/9zrtTT?=
 =?us-ascii?Q?iv7dX25pAmhWL5FdpA0xT053Va8lsa02re0skRYjJ8YdQNASnmzduI9Ro5nE?=
 =?us-ascii?Q?AvLHipilyj5vSJak3ucryKgjmTV0/+r/fxQ2BvyFq8dw7Ryayva7TcK26Kgw?=
 =?us-ascii?Q?SgDCl0gxj1Q0+3rIHAgjz1bs/FgeI4T/hObDYa1IxBIfMmHCyZ6otcJ7SM9t?=
 =?us-ascii?Q?WTjNt0oBuqsdkIJltcjGHC5tLuzIg+WdxQyMaGshl/ZCUZ/4nUEt4UtEll/q?=
 =?us-ascii?Q?u9sMgrs2Ag=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB5668.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c59cf9a-2ae2-4a46-b92a-08da38cb0ef6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 12:36:40.6444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Brs0yiURjhpXhNEh8IObh6bflYUM+75PoP+9ew4yBtjFDRDN1tPHY6Gs1SA7iZPxA9frAYCzPMu1XWLyeG6Cyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0144
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Is S0i3 verified for DCN 3.1.6 with this?

BR,
Chandan V N

>From: Eric Yang <Eric.Yang2@amd.com>
>
>[ Upstream commit 9b9bd3f640640f94272a461b2dfe558f91b322c5 ]
>
> [Why]
>Z10 and S0i3 have some shared path. Previous code clean up , incorrectly r=
emoved these pointers, which breaks s0i3 restore
>
> [How]
>Do not clear the function pointers based on Z10 disable.
>
>Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
>Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
>Signed-off-by: Eric Yang <Eric.Yang2@amd.com>
>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>Signed-off-by: Sasha Levin <sashal@kernel.org>
>---
> drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c | 5 -----
> 1 file changed, 5 deletions(-)
>
>diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c b/drivers/g=
pu/drm/amd/display/dc/dcn31/dcn31_init.c
>index d7559e5a99ce..e708f07fe75a 100644
>--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
>+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
>@@ -153,9 +153,4 @@ void dcn31_hw_sequencer_construct(struct dc *dc)
> 		dc->hwss.init_hw =3D dcn20_fpga_init_hw;
> 		dc->hwseq->funcs.init_pipes =3D NULL;
> 	}
>-	if (dc->debug.disable_z10) {
>-		/*hw not support z10 or sw disable it*/
>-		dc->hwss.z10_restore =3D NULL;
>-		dc->hwss.z10_save_init =3D NULL;
>-	}
> }
>--
>2.35.1
>
