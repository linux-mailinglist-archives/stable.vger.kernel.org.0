Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C964D67291F
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 21:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjARUOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 15:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjARUOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 15:14:21 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2F35D7E4
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 12:14:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPxu4pUz+2fIK4IyQ6oeXA3WRwEqWXZZUbG1boqEFzyuiVPz9GoaNmJwRSzjSPbEg16DSgow0eNAEMo6zY4cmgnqlXoiSGolYlthd6DSj4f8z+xzkuBJOpZUreK63JJuZUPsxBPV3jU4NEs93tObFm9MyqzgK1XWIShiyZCCM1aM0eGsueyALa1NS+Hb/MVSG+0inGcYx4l45UZ1wXq5zBbHf2T+P8nK2DfZzNXYXL5c90N+PtWVCbcg+JV7jHeKqiQZQub112poQgKgy12Nb6MPXocxZm6/YvRNGOn+Wd9F27/apHZZgjcdUtpFFF13ybv4dkYO0Vggr4CJvJvF+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uibfv0zrXKcdX2LjygsENAj1gvK736iakiTVgM1Rupw=;
 b=ha+1qg07R4R4i7JsNscuG1QuVneoJto0nOk6nCxd8alPCX//CDxixv/hU4b8Uv+7Z4xky4CwjOdXhqAqPm+tRmTP5bnDcqj4W1sGkGAxz1JDeh6/+JzHROUD5uTYrWCFnKMwFWCHA3M6rX7uPtdegMQmHulAVgeh7JthZEpSkblAdIW/AeEOTUFzwabd47gWgnHnwrz0+CHYQSbqsQwHhof8/gTdCIc22KYi9cqSk+4dwKhy64iTNRMWw6Pq788X5vhkKyQwTljc2RXNnrm6X7ZJFjrfSmG+q0FEXNEYuJejSjPSHYSVaOLva28/A9Vtxuz34LOjWiEzICGWzLEXvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uibfv0zrXKcdX2LjygsENAj1gvK736iakiTVgM1Rupw=;
 b=M2/aRS7x2Wdgb7cuaDTSSIFseH7N5GWzTDYq2L0CpuZbvGdzU1oUp2rj3v6ZqP94pIG0K/go6TYEEZ21denSF1fX1ZS4dklUy3RBsZ2qIXgCzZBKnisT7IDslq3HWfBHRNjmJbDRhiGQRQFas9WVTZLXpis9DFaOcHAZlR1GL3o=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB5818.namprd12.prod.outlook.com (2603:10b6:8:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 20:14:17 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%8]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 20:14:17 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Gong, Richard" <Richard.Gong@amd.com>
Subject: RE: Minor changes for supporting products with GC 11.0.4
Thread-Topic: Minor changes for supporting products with GC 11.0.4
Thread-Index: Adkp4IOprinj+G+QRTa+xGNq2js50gBmEWgA
Date:   Wed, 18 Jan 2023 20:14:17 +0000
Message-ID: <MN0PR12MB610117420F72DB3E08FD0C57E2C79@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <MN0PR12MB61011CBAC4D256484D291A8BE2C19@MN0PR12MB6101.namprd12.prod.outlook.com>
In-Reply-To: <MN0PR12MB61011CBAC4D256484D291A8BE2C19@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-01-18T20:14:16Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=73ceda5e-9826-4703-aeed-df039714b055;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-01-18T20:14:16Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 7c3b0a50-0f86-42fc-9f39-c0050aec105b
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|DM4PR12MB5818:EE_
x-ms-office365-filtering-correlation-id: 2fcc04de-fad4-4aa1-bdae-08daf99093c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hGbXHxHPP1eTa+et67hGRMz0yG8fpgCKO038TZ88SRQecGRfiiEx2T3tseMOQr4YY5jl4yqUaMCE9f+3hH3fzZNlRYIFZNCR+M1MsG+LBPipW0kqay0a1VBVxXy7B2jqjXTJ5Xk0NxhUB62N4Q9jQTeE54lkopGYcHszwhfQUCp0ZpVt9E59WF0iyJG3UP4p1uzS/6xJK8zT1vgs24TdkeEj/YMDa7QEhRHwM7oH/ksIOdo6DJkEHQ/D/gOyMcVd0OYmiPVFzH8tznn1OJnYMOAL9JdJTNmBV1gPcxCCS/ueRJKoexgum8kVOTseJ2q4qq7ksDvVZp5Ermewv9DNNasxWtJT63av2KwVpWXsuHFrJFttQ8sbv24gx2m8aPjzISHLSuqaxg4VfyW6ifrxlrlCpzYPUtbe8tAyk81TyyLLU9ObJtRuijFpUIBrZDFPdkWGXAJ+8UWOjxntFL473IVc0ynspK5BLybXOzqIe/z8M7IHa6GQT1njEJ0vdBIMqz4/yq8hAWiWVAjF/PzAgZJAD3efBnuOa01TJlef4lOmrbxx9rXMHY0tSk8UW4AKrw0feP13RyLNfsLu9bC/PF65QcK2BY8mOUHBYCCUhJMkLVoO47hoCE54czBumxz9G9LCIfl6zh5WiPYUvqC3zuG8uEPxkbSbc8S9GaTcsQ1nQ1SEa883GfW1OqheyRx5Uhd2f+a4uhLMKWvV3+iIig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199015)(8676002)(83380400001)(41300700001)(8936002)(52536014)(2906002)(55016003)(66476007)(122000001)(76116006)(6916009)(66446008)(4326008)(64756008)(316002)(53546011)(5660300002)(38100700002)(38070700005)(86362001)(66556008)(186003)(9686003)(478600001)(7696005)(71200400001)(66946007)(33656002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2mCJ8kd0Mbho72hzAcxwo/VRcZW/pxdjxWuQyVxc03zyBtuzNlrNdE6flLjB?=
 =?us-ascii?Q?VUMcFXh0BA/6aPOijJAjm4BS0FyU9SHGomKtZoEtEf3995aYWw45Ll+oeqG4?=
 =?us-ascii?Q?BjJqBIVdlWYB9yDYtYxZSlEQZ5nJsEgaicjENA15IVV28qWdSfwqdBZccz82?=
 =?us-ascii?Q?1dSv0M4bcDq9uOz2uoS/ac0AXxidlwZqWDPP0RIED4K57SasOc60JkLp9Ujp?=
 =?us-ascii?Q?P4Cwm95EMoHnTSdMI1vEzSrH93RUkpgQcGZCSgZJ5RS/nqzK/kit31jKP16D?=
 =?us-ascii?Q?h6R67QMArXykgkyTP5cMB4s2Mcm3uNNIe2nTbvmfZz4w2cq77EMetF4UZ6lO?=
 =?us-ascii?Q?RQPmbnv5rFGfXsX7tlFQJdJJHIi4+2ub3cvE6f6sj5XJ6XKoTKRsL17b9o9p?=
 =?us-ascii?Q?6ypMphw2gTiXQnjNw70/x0b1oguGPemg3g0Glanss9LD0el6x5LtUQYBb1RF?=
 =?us-ascii?Q?bfIe/z+td/p8S68pMqVizzB+gwpPEvM37OzI2LkHh9dRa+STdLkHJRbkPUqA?=
 =?us-ascii?Q?Vt/CzxQ47RaHReRk8jU6j+T6Xa1N7AOz/Uhwk8OY69LWWCgyLFkm16bOXqcG?=
 =?us-ascii?Q?H3B1pc/UdhZwqBhsaAP6FxFVId9+r6kvuVV0abKkqALhla3cCWo8F8bfqknW?=
 =?us-ascii?Q?gmotj8+KBQ/O8+bLcynd5ZTLjvYkWpoVRlByb1OUlf0Q1wCA7r49TQGXNtqM?=
 =?us-ascii?Q?S3MHbgudZBTBPUtOMAy0AmHI6XR7DlmGDEYkiqo23AyBvo/5nb7VYZ0ynGWQ?=
 =?us-ascii?Q?uNtOUp81V7Te6v7He00LzOJMgtIFgqjqMvtU8Z5RkzJooL2WikdtIwD+RUsV?=
 =?us-ascii?Q?i+SqK5eiE6o+QB3yY7SntdDno2/tUPnQQu3HTtk89Jr+pD57944nuLX+hn86?=
 =?us-ascii?Q?QyZ4nkvtgJWSwpwh1dCeLHMEXNADlE3QTY7tWxlShj98y54AQ5cHUIT+miE+?=
 =?us-ascii?Q?srmWHc5K88d1R2LzvbrNF39y6VFWIcorKrt5GbBgqaWQ2vnpz/ZkrdKsblbi?=
 =?us-ascii?Q?QFVOiK0yJwshaFRrRq5k7eSXI7GCWq0hq5oBrY46ckSwIwynkCYtb3plMpMg?=
 =?us-ascii?Q?d6Ak+/pjI0fkryi79EceWhlWFKAPhmy/PheehFgVWZNG9eRToyZPK1Nswxem?=
 =?us-ascii?Q?T7I6lQvoiSi0NPM3jhUmuE68S+QEO2AsMiEws8yly9YUxe1BrhJxBAA49j/Z?=
 =?us-ascii?Q?zcf2Pz4iFEa4EYZufBYznC7Tzrr4gEbmNzNMtdkMgLjYL/20LI41PqUCvUUK?=
 =?us-ascii?Q?CazEBhuJO+EtxEGygRlbH2G0tpWyG+wmDWwo54SG91lWBA4Ty2M58gWV3Uyq?=
 =?us-ascii?Q?gKQQ2yUgQTo6vWlSnVlAFRMzY8YlRzVV+mYNXA+1yHDS22OiqIPYt0o/xg31?=
 =?us-ascii?Q?aSt37T5dXoCQrr+a4FtEMB8NpOchPMvKjqJi/SjMtL0jaKBPoR5+9lDE7t3y?=
 =?us-ascii?Q?SNFiT/50wh45wX/u9HVNEJaX00/SrKpwop4hLE5EB7jpqYqmZL9VrHaI1077?=
 =?us-ascii?Q?35KPWtI8N+H508iMHdcOLQeK3k3zGWWTd+uiA6mFyr0JQbOkw9uL4RE0Sun8?=
 =?us-ascii?Q?O474cQ0X0r6/elEOy2oBzo1mlKWT4wd0Tcd6QphjooEbqNE+qJ4eZpIufUNz?=
 =?us-ascii?Q?DLbpKzltzuKBcSH1fLPBmsxQGXsZiztRwevH1LOCF0xd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fcc04de-fad4-4aa1-bdae-08daf99093c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 20:14:17.5981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UyBZRwxcF39lSPYsd0/e8WXav/JAFAH7HpiJgkjN0msmZ6n262yJRHNIatscRFKZQLljAYIoIsn4QcRkdI5BMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5818
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

These merged into 6.1.7 from Sasha:
drm/amdgpu: add soc21 common ip block support for GC 11.0.4=09
drm/amdgpu: Enable pg/cg flags on GC11_0_4 for VCN

So here is an updated series of what's left:

69dc98bbd441 ("drm/amdgpu/discovery: enable soc21 common for GC 11.0.4")
d5fd8c89ed20 ("drm/amdgpu/discovery: enable gmc v11 for GC 11.0.4")
b952d6b3d3ff ("drm/amdgpu/discovery: enable gfx v11 for GC 11.0.4")
6a6af77570ad ("drm/amdgpu/discovery: enable mes support for GC v11.0.4")
94ab70685844 ("drm/amdgpu: set GC 11.0.4 family")
dd2d9c7fd771 ("drm/amdgpu/discovery: set the APU flag for GC 11.0.4")
1763cb65e870 ("drm/amdgpu: add gfx support for GC 11.0.4")
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
2c83e3fd928b ("drm/amdgpu: enable PSP IP v13.0.11 support")
f2b91e5a7cc0 ("drm/amdgpu: enable GFX IP v11.0.4 CG support")
a89e2965da6e ("drm/amdgpu: enable GFX Power Gating for GC IP v11.0.4")
f9caa237372b ("drm/amdgpu: enable GFX Clock Gating control for GC IP v11.0.=
4")
97074216917b ("drm/amdgpu: add tmz support for GC 11.0.1")
2aecbe492a3c ("drm/amdgpu: add tmz support for GC IP v11.0.4")

> -----Original Message-----
> From: Limonciello, Mario
> Sent: Monday, January 16, 2023 13:27
> To: stable@vger.kernel.org
> Cc: Gong, Richard <Richard.Gong@amd.com>
> Subject: Minor changes for supporting products with GC 11.0.4
>=20
> [Public]
>=20
> Hi,
>=20
> AMDGPU changed the codebase to use IP block versions rather than device
> IDs.
> Some products that contain IP blocks "GC 11.0.4", "PSP 13.0.11" and "NBIO
> 7.7.1" work with the code in 6.1.y, but the various switch/case statement=
s for
> IP version match are missing for these.
>=20
> So the following minor changes allow those products to work with
> acceleration on 6.1.y:
>=20
> 69dc98bbd441 ("drm/amdgpu/discovery: enable soc21 common for GC
> 11.0.4")
> d5fd8c89ed20 ("drm/amdgpu/discovery: enable gmc v11 for GC 11.0.4")
> b952d6b3d3ff ("drm/amdgpu/discovery: enable gfx v11 for GC 11.0.4")
> 6a6af77570ad ("drm/amdgpu/discovery: enable mes support for GC v11.0.4")
> 94ab70685844 ("drm/amdgpu: set GC 11.0.4 family")
> dd2d9c7fd771 ("drm/amdgpu/discovery: set the APU flag for GC 11.0.4")
> 1763cb65e870 ("drm/amdgpu: add gfx support for GC 11.0.4")
> 311d52367d0a ("drm/amdgpu: add soc21 common ip block support for GC
> 11.0.4")
> d0ca8248999e ("drm/amdgpu: add gmc v11 support for GC 11.0.4")
> 7c1389f1b122 ("drm/amdgpu/discovery: add PSP IP v13.0.11 support")
> 16412a94364d ("drm/amdgpu/pm: enable swsmu for SMU IP v13.0.11")
> 51e7a2168769 ("drm/amdgpu: add smu 13 support for smu 13.0.11")
> 9f83e61201bb ("drm/amdgpu/pm: add GFXOFF control IP version check for
> SMU IP v13.0.11")
> 18ad18853cf2 ("drm/amdgpu/soc21: add mode2 asic reset for SMU IP
> v13.0.11")
> 069a5af97ce3 ("drm/amdgpu/pm: use the specific mailbox registers only for
> SMU IP v13.0.4")
> 7308ceb44663 ("drm/amdgpu/discovery: enable nbio support for NBIO
> v7.7.1")
> 2a0fe2ca6e9c ("drm/amdgpu: Enable pg/cg flags on GC11_0_4 for VCN")
> 2c83e3fd928b ("drm/amdgpu: enable PSP IP v13.0.11 support")
> f2b91e5a7cc0 ("drm/amdgpu: enable GFX IP v11.0.4 CG support")
> a89e2965da6e ("drm/amdgpu: enable GFX Power Gating for GC IP v11.0.4")
> f9caa237372b ("drm/amdgpu: enable GFX Clock Gating control for GC IP
> v11.0.4")
> 97074216917b ("drm/amdgpu: add tmz support for GC 11.0.1")
> 2aecbe492a3c ("drm/amdgpu: add tmz support for GC IP v11.0.4")
>=20
> Can these please be brought into 6.1.y?  As amdgpu switched from device
> IDs to IP blocks these are akin to "device ID" support.
>=20
> Thanks,
