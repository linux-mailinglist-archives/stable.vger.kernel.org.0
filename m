Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34FF649576
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 18:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiLKRzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 12:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiLKRzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 12:55:54 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2082.outbound.protection.outlook.com [40.107.96.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F23ADF3F
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 09:55:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noX9Ng5BhJjEfLZuWXMpNvatJCdDPbUTiF4yO/eXgSCllbwzyDBaxRLSt8yukz0GudTYpiA64qDBJ004Ka1J2uMhNOMF63m9RXy5i3B5YGbKSn7K00cgLLrRFGJL3pKQEemHScAmWzNdLKDGSghHnzlvG/BEM+tpFIJCTj5+bgiIhDsIJrt0Je4m6tsU9ijluHwf07r6a8iXNNxa0k0rQCuaxznLHDz6ZnVac7UvNELnlZY11OyLtD00jUlMzch1kAGMqoF6deb+O9QKTSfn1vUsjQb+mkTXJS+MMlAI2r97HSNOl8rmnfSHaxoOsZgxg35Ag97+eNwVRSswWbdc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDSbwhY9VJVebozt99Ypjl0gji7P+szeURAUy9YFe5U=;
 b=Z29wU7+yChhEnKHs+SffXHj0NeNWjfqnfOAdfzTPLXI6qbvfKER0nrmb8eW1bYKxCtn36+eEhCHbTkYMiXt2FndYEn0mgHRhy3XTZ8aLULjD9WJs4vkAXf5CrXIWlgioWgt7Fj4btPG4aBThPu71jD1EVrMqtjbZKfhLyk24BkOMQxkEVHLImy2OF2UyG6m4iw1N9irJwTXPuY+PXwTZyDwm6mKlemK//eSZyDBG+KydOGf8HhoVJ37iwDB7NPa+SuNVQ5Sixf+mJIUdUoUQES9Qt9cET2zzq0/GbSzrdtACpXhvM6ghuF7MEEhJc9xS/HhPEx8JkViYO4UsmnoLmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDSbwhY9VJVebozt99Ypjl0gji7P+szeURAUy9YFe5U=;
 b=VV/KGcWEFZDoQG3XkNdloHNL6iEQyoiQB/qpv4ZDa3ry3tCVba6dnX5V84NuNXjM40XKtcDqSS4K7kc9diXoQHOuhkWoEwsrgfDvZsQsQcVKEMN+aQTiNLXOw30sgAwz2/czFalN9uNwD/wlrn8UyvfhUgUC6Ev4iJ3u3Zu9ipo=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SA1PR12MB5637.namprd12.prod.outlook.com (2603:10b6:806:228::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 11 Dec
 2022 17:55:47 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%4]) with mapi id 15.20.5880.019; Sun, 11 Dec 2022
 17:55:47 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Dong, Ruijing" <Ruijing.Dong@amd.com>,
        "Liu, Leo" <Leo.Liu@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: RE: [PATCH 1/1] drm/amdgpu/vcn: update vcn4 fw shared data structure
Thread-Topic: [PATCH 1/1] drm/amdgpu/vcn: update vcn4 fw shared data structure
Thread-Index: AQHZBdfflNiNdaL9Lk2rQ4+S8v2QGa5pB0yQ
Date:   Sun, 11 Dec 2022 17:55:47 +0000
Message-ID: <MN0PR12MB6101E8DA6281B2B40ECCE705E21E9@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20221201225417.12452-1-mario.limonciello@amd.com>
 <20221201225417.12452-2-mario.limonciello@amd.com>
In-Reply-To: <20221201225417.12452-2-mario.limonciello@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-12-11T17:54:45Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=6e73b34a-80e2-42f5-b577-67796730b134;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-12-11T17:55:46Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 05d34afc-81c8-4205-bcd7-6d7ac92c0897
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|SA1PR12MB5637:EE_
x-ms-office365-filtering-correlation-id: d19cfb70-1d37-4729-85b9-08dadba0eea7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aLsEY7+wZ5Ndc1OPE+HIiJ6j8qLr6gH+ViAFsdevZX8GTqi2rnNc7zLbPbHRzxPPYC0gyl0PpsZdMX/t01EOdaYeGmi0Oma9XGTAlVdGYC3xOAeJt+fVcya7u6HQjJooSt0MAZfPXw+SKXr0hSmtQkPYJwdeBdGvYCU00Kxnc+Ipnm1Ah08+F7mO5PtuJwVcvS3GuIhByBbR1xbLWO/f0X4+P7u205gbqP7gN5L63DOSzcHnrQ6Rj+Y8PdX/zVqNQMoGYr73DbOeIheWZXl9Dz9jpCpSMWRq0U+4AGmgE4D7XZjUPbKG4HU32m9B/564m8/iWtU8r/CnNIZdahug6DdwZ27QHpEsM5IQxKH9zBEGodGaMAEP9x/zMsBpyH2FR3GFMnleuOGVUR49WUVGuuHsHbv5nfnHls7CmTNNfX/YdtQAE7KnhJZ7kwuXxzmei6eVmJ2XdSBNUlWULLb31zwc6GhnJxK1kRQ0yiPSAnT+8ZZWi9P+n5pYRSCw7EFJ12rMT63mR+/1lQ4pqSqnkK18dMEalKKzxEth6iMY3/Ci+mfelxD2bHmh8njYDjxqvOUSZzFDxxo2nd1yCWJhYRDeUXPGlu7cfp0EbYtfcKz1POk/UNFfgu9LVNBOVQ3E38SsOYpAM5RxZZn74z+YAdzkPzpkx7EEViyR6S+tbN4PBUO8xGG24/NXrfAkHjffCjmi7oHFd9psv6h5RGENaKAkhNxlclCexS/y1WI758o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199015)(966005)(122000001)(38070700005)(83380400001)(33656002)(186003)(86362001)(478600001)(7696005)(71200400001)(6506007)(9686003)(53546011)(2906002)(41300700001)(55016003)(5660300002)(52536014)(66446008)(66476007)(66556008)(110136005)(8676002)(66946007)(64756008)(76116006)(4326008)(316002)(54906003)(38100700002)(15650500001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fomqhCs6TOaXDZ2dHfOQ1OT5fXe1K8RIM5anYK5v31grQ6mTOLWCeJKIEAdJ?=
 =?us-ascii?Q?WAFta9YFZQtb2IOp5soCv5g+A5/ZHoDp6pcCEEDN2B3RaD5DV8dB4ojVFGsz?=
 =?us-ascii?Q?R1qIaKiLv4fU/A6S3Nd/qZ9dw8X+rISEX0ofAmHARUUKx1OAxJ4vswVdQNIb?=
 =?us-ascii?Q?0AyJB6rv41befcZwYFeZhOVo33hdXGEGwWfr1MsSOTqdZa0tftv7u5QezhZO?=
 =?us-ascii?Q?ZQZgAYy1ErhKJjyu5B7cscN5BGFXoUy4WDJtkAV+iVkYRjYCBMQqmWnO+K3D?=
 =?us-ascii?Q?aAidnPPmmdzwin3FG2q6E3NpXiL9vJidwqBehBqfhkRDfiFGSHcDoK9f0S2z?=
 =?us-ascii?Q?vb6sDKVd1uKStvMcb0WWMxJTKX2xnWO7Jo8sFepIIaMRKLNT81r47fNkwqnw?=
 =?us-ascii?Q?ey43bDOEKxq2HG8Hkr5jbWN0CR9I9FaCghpwFYX1TcCbKrOLObVvog+tvlbo?=
 =?us-ascii?Q?G8V8QkUxA/ktY1nrnU78ZsB1RAxNk8H32PE2ZKRUWPGswNFp6x3KvMqpzDvh?=
 =?us-ascii?Q?tKyfCAXh2wVsb6JUwHQywDdBHgUSLHLi9DdlFtC0cXmzZaU2P0fHHjwHpxoL?=
 =?us-ascii?Q?MMUXpl4wABqCIoy6hWd9prd7OFqlMCjKHW6Z2B5dZvuma4DrUV5P6C+pAt0o?=
 =?us-ascii?Q?bFgm94jtZX3fJaQvQ1RbEYiqTtM2UTvBKt9OuDCDQ0SxBTL4f2H9H+ScrGBW?=
 =?us-ascii?Q?WRYh3RL3SL9eCzX6m9LGjiFbEvbIKEc+dLEIYGLrQfD9mOkCUFRyaocGeG+X?=
 =?us-ascii?Q?hGqRkEt1wyAAvMhL2aMSd5FpFyy5/9b3cUM5xlpUn7ZrHgzFllE9BlDBukfp?=
 =?us-ascii?Q?pF/3K8YbP22jICaklh/weHNYZmD6UeT5nd8ROUjvdrAq1TDdo02Jyu15jpab?=
 =?us-ascii?Q?uBrUtnqc46BJpo1gfutSeBsZ+hAnkzKpCJDUbbKHrZ4VbeCgL5DxeMdga1/G?=
 =?us-ascii?Q?heDVCdtbjNT54xIK1Gi7G/mpMTgr+rmboXvGJ7hpD434iIO11oGZxY4ZJBfH?=
 =?us-ascii?Q?RmvVYOJSv1OrIfxi5g30G3CVzF5X6W73As8icEnB3rg7a50U6PetvsRvzwmS?=
 =?us-ascii?Q?vEcGRcY62NDHVv7oiZAh3tbDVmo4BoNCed3KhBRCp2lFO7o4lFh5jB/5InvV?=
 =?us-ascii?Q?p+XbOE/QdAgQAmTamHv1ryIGhqdE6b6KicG5GZ6zBdt6jeXvo4kcjsYy45/k?=
 =?us-ascii?Q?y8g/xrqBncUuooDBcRFpShOywupu/P9lV+OCSgmLjRw0BDMw0bNrpNXMvhVX?=
 =?us-ascii?Q?oLhkq/+/ZRBZU51cacPCEbKWa0pc8g3axHujV0kfSYV/B2B9eAG0uQMVKzDq?=
 =?us-ascii?Q?jZAE6kiPKSG9QqUu00gEXp83kYrUMbX0Fe1gRvlh+UIjCgt1yOYsVQ1TO7z1?=
 =?us-ascii?Q?TPHg05DN2+3jQLB2sGkmr0+nL/cUZrSbrXftdKIeWFrfZk+57zCTawgdCsbv?=
 =?us-ascii?Q?dSQwWqhCYjdwhXwvLPEioPCMGrgs0BYvg+UYp6QDxVt7Rrgru0jko3gfcGSy?=
 =?us-ascii?Q?GKp5JghfR/4Pi62vDpXrV53R5ZUXjSaTBhfPxtNdpBrGVhObVqWsUbqNG9bH?=
 =?us-ascii?Q?cvaf+J/SeEV2M8Y33zE+sN2sPUHdQBN1590pzJR0scOqUqqsyBxsAqLCY+75?=
 =?us-ascii?Q?3bI98gCjL7Y9uXj7Bc9DR9s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d19cfb70-1d37-4729-85b9-08dadba0eea7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2022 17:55:47.1084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zMqlJWbwC7ND1byhUyb1kc5OvEle00eJIZZHHR3D+HIQJPVbvm3fdczsKUsScetDvcAT5wnu1HcmOjAgIBpUJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5637
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

> -----Original Message-----
> From: Limonciello, Mario <Mario.Limonciello@amd.com>
> Sent: Thursday, December 1, 2022 16:54
> To: stable@vger.kernel.org
> Cc: Dong, Ruijing <Ruijing.Dong@amd.com>; Liu, Leo <Leo.Liu@amd.com>;
> Deucher, Alexander <Alexander.Deucher@amd.com>; Limonciello, Mario
> <Mario.Limonciello@amd.com>
> Subject: [PATCH 1/1] drm/amdgpu/vcn: update vcn4 fw shared data
> structure
>=20
> From: Ruijing Dong <ruijing.dong@amd.com>
>=20
> update VF_RB_SETUP_FLAG, add SMU_DPM_INTERFACE_FLAG,
> and corresponding change in VCN4.
>=20
> Reviewed-by: Leo Liu <leo.liu@amd.com>
> Signed-off-by: Ruijing Dong <ruijing.dong@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit 167be8522821fd38636410103e1c154b589cb1d9)
> Hand modified large dependency of commit aa44beb5f0155
> ("drm/amdgpu/vcn: Add sriov VCN v4_0 unified queue support")
> This no longer updates VF_RB_SETUP_FLAG, but just adds
> SMU_DPM_INTERFACE_FLAG.
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h | 7 +++++++
>  drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c   | 4 ++++
>  2 files changed, 11 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
> b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
> index 60c608144480..ecb8db731081 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
> @@ -161,6 +161,7 @@
>  #define AMDGPU_VCN_SW_RING_FLAG		(1 << 9)
>  #define AMDGPU_VCN_FW_LOGGING_FLAG	(1 << 10)
>  #define AMDGPU_VCN_SMU_VERSION_INFO_FLAG (1 << 11)
> +#define AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG (1 << 11)
>=20
>  #define AMDGPU_VCN_IB_FLAG_DECODE_BUFFER	0x00000001
>  #define AMDGPU_VCN_CMD_FLAG_MSG_BUFFER		0x00000001
> @@ -170,6 +171,9 @@
>  #define VCN_CODEC_DISABLE_MASK_HEVC (1 << 2)
>  #define VCN_CODEC_DISABLE_MASK_H264 (1 << 3)
>=20
> +#define AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU (0)
> +#define AMDGPU_VCN_SMU_DPM_INTERFACE_APU (1)
> +
>  enum fw_queue_mode {
>  	FW_QUEUE_RING_RESET =3D 1,
>  	FW_QUEUE_DPG_HOLD_OFF =3D 2,
> @@ -323,6 +327,9 @@ struct amdgpu_vcn4_fw_shared {
>  	struct amdgpu_fw_shared_unified_queue_struct sq;
>  	uint8_t pad1[8];
>  	struct amdgpu_fw_shared_fw_logging fw_log;
> +	uint8_t pad2[20];
> +	uint32_t pad3[13];
> +	struct amdgpu_fw_shared_smu_interface_info
> smu_dpm_interface;
>  };
>=20
>  struct amdgpu_vcn_fwlog {
> diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
> b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
> index fb2d74f30448..c5afb5bc9eb6 100644
> --- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
> @@ -132,6 +132,10 @@ static int vcn_v4_0_sw_init(void *handle)
>  		fw_shared->present_flag_0 =3D
> cpu_to_le32(AMDGPU_FW_SHARED_FLAG_0_UNIFIED_QUEUE);
>  		fw_shared->sq.is_enabled =3D 1;
>=20
> +		fw_shared->present_flag_0 |=3D
> cpu_to_le32(AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG);
> +		fw_shared->smu_dpm_interface.smu_interface_type =3D
> (adev->flags & AMD_IS_APU) ?
> +			AMDGPU_VCN_SMU_DPM_INTERFACE_APU :
> AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU;
> +
>  		if (amdgpu_vcnfw_log)
>  			amdgpu_vcn_fwlog_init(&adev->vcn.inst[i]);
>  	}
> --
> 2.34.1

Hi Greg,

I didn't see this one get picked up I sent back a week and half ago, did yo=
u miss it or did it
need more discussion?

The cover letter [1] for it indicated all the background for why it's impor=
tant and intended
kernel (6.0.y).

[1] https://lore.kernel.org/stable/20221201225417.12452-1-mario.limonciello=
@amd.com/

Thanks,
