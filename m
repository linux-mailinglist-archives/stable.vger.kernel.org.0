Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CF537EDB0
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387962AbhELUlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:41:16 -0400
Received: from mail-dm6nam12on2049.outbound.protection.outlook.com ([40.107.243.49]:10241
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1383782AbhELTx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 15:53:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8Qqjfq20sIp4YQC5GToR4E4rJtvTY+AjQuU9TLOp7KN8QJDCbm2MiuuCRK2DPEk7JecUh8tDnyGnJXo7cEc4d6LvhcLJkpFzk+Pifkoa6elhz4xMZhtGu/Zdd3X24tgJ7zoHQnTImDxzebEGt2dIjv6Rt5LZwUyAhdZMlvQcmCqebpGQBN+a+WFWlklYxXCwdrMA7aDrgeK1glkmndT1Ll1Q6oOuKaqE6D86KvNWMgScJ6e+D6u3ZplwIiKj0TgHSO3PBGRIRmifRA/8fbA6ExCzi1r737m/fc6OE25xJObeBEzv8ywjrN6Tygmfuhq28xad3MA8h/ZBVUBwhDGLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3apukzZajOEK8wCJST5ovz/R12KxS3v83ksW5nEA38=;
 b=mW5hJR8d87Cm80cGlUkwcnPAcaxJkbrTgRKMeBWmb36HzPuNw5nhgnlY2Id+dl/9zc3/Nh2NznCm20GdTOUR5EcY9rQwpaccczCFaVoE20GwBA6hX611PsE+fbBEETkTIwoObvUdEQUkSU53Jdru6JauyhaAa4dPYgjhlH9gypWfB89EtiR4YyjeWNpjL+JkvJQLHEHikfRoeY7R49fH42UKwpEONNhCrfMWBUVdKZw2CBcgNNuUjYOVhSAgZZrJn8ruXhlRgYuw2MQi5Gonel7YMhBVjtnTb59pk4DG5hU083wbCWM0CXcCiwBNnk1kKd9G8/X0hpfyTtJc3I1fXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3apukzZajOEK8wCJST5ovz/R12KxS3v83ksW5nEA38=;
 b=XTygv1IZhMLxsV/ypXr+Fkq2zip1sHy62KI2gqPdmq/+bCwi03G7UUjy8/x15ZLDHqMAQY4v2nmdmqnzXKR4zleSJd3GRjw7qpiI/RN9T+aGrPG0zSo0jZpGZvZLppoU/+qMghdUJbKMN/4uFBll7NyttygMxkBj4bU8xpdGLmk=
Received: from MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19)
 by MN2PR12MB4030.namprd12.prod.outlook.com (2603:10b6:208:159::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29; Wed, 12 May
 2021 19:52:45 +0000
Received: from MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::3d98:cefb:476c:c36e]) by MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::3d98:cefb:476c:c36e%8]) with mapi id 15.20.4129.026; Wed, 12 May 2021
 19:52:45 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "Tuikov, Luben" <Luben.Tuikov@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] drm/amdgpu: Don't query CE and UE errors
Thread-Topic: [PATCH 1/2] drm/amdgpu: Don't query CE and UE errors
Thread-Index: AQHXR1C076EFrjtVw0CPtHf4+AAhh6rgQS1A
Date:   Wed, 12 May 2021 19:52:45 +0000
Message-ID: <MN2PR12MB448837F2FFA7B74AD3345C10F7529@MN2PR12MB4488.namprd12.prod.outlook.com>
References: <20210512170302.64951-1-luben.tuikov@amd.com>
In-Reply-To: <20210512170302.64951-1-luben.tuikov@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-05-12T19:52:41Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=f499384c-60ab-4e82-9819-23d683cebafd;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
authentication-results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [165.204.11.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63bbd4a7-819f-4b3f-6913-08d9157f8300
x-ms-traffictypediagnostic: MN2PR12MB4030:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB40308671D2D2AF85D3997758F7529@MN2PR12MB4030.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GmJOcxwALE+2USIn11tDTOVPYh6aPjI4AmiE9D8Rnd4OEwB56+Qf5RjR1yFFgCbzEL9gygMZ9IRCxc3KUqnYdoRWQgrecntmwAxHtt83t3FIzqsSb2eQTQICzOJN7z9uBCTJGZJzeVCbW7tnr8QJAgYcHFQuOur+CIqumQTBa6HETW6L9qN53hQ1mcr2U7msMnPYPi8icl0GLlWIzgf2YSRx95YAelSb8Pc3KgKPZJMit0XNc+3ffN2XBrW2stA+XbFCZlfD6X/fh78gEaYgi6pGW7x+80R9no8bZwC0GV5880/I4n9CS2csUvYrsc5+OQB5eR/HkLgT9Fwhy1U74TOadJWHDS8iJeVVdp2g2LqwWGu/ayaSz5D5ZkddTIKLN8iw16Lmfh7yLephMSK5me++RzJh34K68o9Qk00hPV5bYwoPRnMFyqeaSEd3BgKSXiQmMisv6lWNiKul6paQfh0geCJPqE4ekr5thxU5ubHSZOvWM0NErdETgDRzgFcAGv2VfHLvQ6ubck69/nkC8r80vixKBcdNDwmVNNqFyvcQx/2EOPtsxW/ERmSa8jv9jepD5tKH6LfVPeUtVqArw9k/gJDKDro2YVuMG6TgN0k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4488.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(66556008)(122000001)(64756008)(86362001)(2906002)(38100700002)(66446008)(76116006)(316002)(66946007)(26005)(9686003)(6506007)(52536014)(4326008)(55016002)(186003)(33656002)(71200400001)(110136005)(478600001)(53546011)(7696005)(8676002)(8936002)(5660300002)(66476007)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OexqVyXFEr+xhJUJyMbHCkec+Qfxw1KAIyiq+pcI+9zp2yuM/FJtWPJYzrbp?=
 =?us-ascii?Q?1CZstD9GHqkDeZjjE3luZ26lsM+SRR5LyAQwpI0n5wO7AyCvSJhywiv9LVDN?=
 =?us-ascii?Q?NjShjfyYbNGs50aWG3tLDvctiYZ78RePoelNV7h8xqJU3nmUCqsv16QwXWwC?=
 =?us-ascii?Q?kk2Xfhst8TzJnoKBSz5gd+3jrPT7fQj9CgKXriDfpqEMwBTAOUcJmi1g+cLr?=
 =?us-ascii?Q?N9EO0XYkvZEk4YBa42Z9GOpKQF6GARKOJJovqtSgLbfWwU+zEaO5gR0BtBUe?=
 =?us-ascii?Q?KE66j+KZxJDIAoEjSSj3j7bSq8l7A/lotCzFCKMrKK7zexUWW62QAjGKijOB?=
 =?us-ascii?Q?rjo+LlO5EHkdDJiTe8SW/v4w0oGDeXUgGwZlXx9yupDFwMtnkmTF05pA2Zt1?=
 =?us-ascii?Q?dWhM7sMyV18UzunZP7DS67Hza5aMZbolcc4BCYu13lT4A8fyllQfNj8Stuk1?=
 =?us-ascii?Q?WHPUodSu4yftykbL0k9GQu/n8MWQ8oXUgM8k+ZOO/OY0NnGRmoMSD+pb62eN?=
 =?us-ascii?Q?6V/wXrvG/7YymKOcjE+LszvbKZ0JilOLfiKmRPvE3oYu2lI9Yg75fc3VrxXB?=
 =?us-ascii?Q?ZON1eA3dqQD69c7ufGQHHRjylO4CHzwm0GXVE1aU6lpNrAythib7c5oW19pH?=
 =?us-ascii?Q?G/lHPkaR5g5KL1c5EL6sWmBbkpkYZae++eEx9qYXHTCn22qL6TwkfpCmGoHh?=
 =?us-ascii?Q?UKLq5+spT+5derx+LN+z4TTjRc/466AHTrOnfJnYvmCIPBTH3w/3Y4zcgIS6?=
 =?us-ascii?Q?EsD6V7rwc0BfEDO2i5PoY2VYhyD+aJUxhur6YELx6bmzGiA4I4rwZ9OyMvgd?=
 =?us-ascii?Q?UPog/emc6HaBzCFxn140IOwRTmwPaIPnUYIsEqPAZCorWgT5nOIgd1z3A8JA?=
 =?us-ascii?Q?zH84P8cjzy439glr6kzQLeL8MHdO8uwt83JfhyryOywoPtHaniQllhKhK5qj?=
 =?us-ascii?Q?IGobfTtJwZ84Lcm1+8Lr1AK1IfKeGSoFSUL2QjqZ8gvEyJW0OxSsdJOwqr9/?=
 =?us-ascii?Q?sC/0pYjjHJBCtnBkcz2nBjrFM1pExVAdvBR+d8rqzAiPzCANhD6arTMn5mag?=
 =?us-ascii?Q?hIfQIZYqysCneQpsqvA4s/3DXcvv1nZegz9ykptCAg4aj3E5s9dsQtzTDMmc?=
 =?us-ascii?Q?HMqzQvMnEZwXp8D3C3fWy8Vu4gRsHU7a9XlE2mQktVrJdibQZTyTbhAl5CUD?=
 =?us-ascii?Q?YgEFxVlrXU/mbQnEt78Y5J9Hi99fJPi2BEIRqE/iYwCgCulWshdEQ2TcrnC7?=
 =?us-ascii?Q?OYcXrOQXN+jBtt84tay2NEJ8o4McOtJ/qjZ1A+ik6UOhPEkyUc0hg/cTyL+m?=
 =?us-ascii?Q?DXcy1TJvvo4Zvkp8rizdoqko?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4488.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63bbd4a7-819f-4b3f-6913-08d9157f8300
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 19:52:45.0974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OlGcUQBWHEd1QWr8HAjq3485gYoi83U/+hcL4F50Y72IK1iyCFkVjZvNx+PE4zHI5KGgqnvZQyi+Ofm8+R2y6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4030
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> -----Original Message-----
> From: Tuikov, Luben <Luben.Tuikov@amd.com>
> Sent: Wednesday, May 12, 2021 1:03 PM
> To: amd-gfx@lists.freedesktop.org
> Cc: Tuikov, Luben <Luben.Tuikov@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; stable@vger.kernel.org
> Subject: [PATCH 1/2] drm/amdgpu: Don't query CE and UE errors
>=20
> On QUERY2 IOCTL don't query counts of correctable and uncorrectable
> errors, since when RAS is enabled and supported on Vega20 server boards,
> this takes insurmountably long time, in O(n^3), which slows the system do=
wn
> to the point of it being unusable when we have GUI up.
>=20
> Fixes: ae363a212b14 ("drm/amdgpu: Add a new flag to
> AMDGPU_CTX_OP_QUERY_STATE2")
> Cc: Alexander Deucher <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 26 ++++++++++++-----------
> --
>  1 file changed, 13 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
> b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
> index 01fe60fedcbe..d481a33f4eaf 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
> @@ -363,19 +363,19 @@ static int amdgpu_ctx_query2(struct
> amdgpu_device *adev,
>  		out->state.flags |=3D AMDGPU_CTX_QUERY2_FLAGS_GUILTY;
>=20
>  	/*query ue count*/
> -	ras_counter =3D amdgpu_ras_query_error_count(adev, false);
> -	/*ras counter is monotonic increasing*/
> -	if (ras_counter !=3D ctx->ras_counter_ue) {
> -		out->state.flags |=3D AMDGPU_CTX_QUERY2_FLAGS_RAS_UE;
> -		ctx->ras_counter_ue =3D ras_counter;
> -	}
> -
> -	/*query ce count*/
> -	ras_counter =3D amdgpu_ras_query_error_count(adev, true);
> -	if (ras_counter !=3D ctx->ras_counter_ce) {
> -		out->state.flags |=3D AMDGPU_CTX_QUERY2_FLAGS_RAS_CE;
> -		ctx->ras_counter_ce =3D ras_counter;
> -	}
> +	/* ras_counter =3D amdgpu_ras_query_error_count(adev, false); */
> +	/* /\*ras counter is monotonic increasing*\/ */
> +	/* if (ras_counter !=3D ctx->ras_counter_ue) { */
> +	/* 	out->state.flags |=3D AMDGPU_CTX_QUERY2_FLAGS_RAS_UE;
> */
> +	/* 	ctx->ras_counter_ue =3D ras_counter; */
> +	/* } */
> +
> +	/* /\*query ce count*\/ */
> +	/* ras_counter =3D amdgpu_ras_query_error_count(adev, true); */
> +	/* if (ras_counter !=3D ctx->ras_counter_ce) { */
> +	/* 	out->state.flags |=3D AMDGPU_CTX_QUERY2_FLAGS_RAS_CE;
> */
> +	/* 	ctx->ras_counter_ce =3D ras_counter; */
> +	/* } */
>=20

Rather than commenting this out, just drop it in patch 1, and then re-add t=
his in patch 2.

Alex

>  	mutex_unlock(&mgr->lock);
>  	return 0;
> --
> 2.31.1.527.g2d677e5b15
