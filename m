Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4818949B7EF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 16:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350895AbiAYPtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 10:49:12 -0500
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:35361
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354633AbiAYPqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 10:46:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U640OVN9+P6mf95NE1z8g1YdLIDwromb6TNoF1HAextd5CW9I+fH0StUWQG/3VCvQZpx6IsJ0dJWTP2EwXx4Kle1V0vxd5owwA5QpAP8mRjlDQF9W2Rgt4VXa2+/lbLO8Uazwc7d5BvgS4nrVWQEbZeY9JYdLarab9H8iKJzdtjN+KoPlcqPIDXmFIvWv/go+G0MSIx61rQlLdvzC8rrNu3aDfCJ5D1SN31HeUtddj/b1JRO6FE3wIWNs8Nj6VrgjS+8VmWH9RER+eE0zwMSfctIMR7OVustksR94L2RXSyf/Nju3+nUbaI9SKAk/q2gUXreZV7qepCVFlkxTu9nEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXUpXUMSL2jcvnajeu/M+V1Q9ix2Y2RUyNUixZ2J9FM=;
 b=VK3OcmKECcj4bXmlmFIdfvgCbiG/P8iasoUw6QABhvaMwqC+4eE25VnUFc1/zCcm3Lx6AOL4Bn35l9UD63KoyF7IfAzJhRbEebZWAHtR8nPwPXd+B2gXnn4iK6zmwqgRwm12tITsJXNFxXwntecKKM+uUD40/4i2B0710Ut2S+CEQB09cKw/4Fy3btzMHrg8eAzvcuODXkNH+RZxsxaY2VTo4FxUUGlONTYvKjKjWQMEt0qXnA9U+3g8f3mH++sXSEK5zcDocpeUP0VJdkDYobj1+IUXfVyfifBsuGcA+2bUZyxA4glSwrYh6vgf5SCHF3jRmPxj5t1B51KQN3DVSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXUpXUMSL2jcvnajeu/M+V1Q9ix2Y2RUyNUixZ2J9FM=;
 b=RckmBPn1HZF0kD7ts94ejHFg3lLPQJRUQwVQpT0lqOzrqYcWtflQY2FTUKujwSnoVvs3EawvSvNmXvYSkBYx2r4Nr4FlBU5V8uVeTC+UUCcSLo+7Ll8Vf2sYbA0lRso5YVytc2N4DMSjwk0/V4soJtiJqr+2Pj+C6b6cvtg3/rQ=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BN8PR12MB3284.namprd12.prod.outlook.com (2603:10b6:408:9a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 15:46:26 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4930.015; Tue, 25 Jan 2022
 15:46:26 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>
Subject: RE: [PATCH] drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2
Thread-Topic: [PATCH] drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2
Thread-Index: AQHYEf8xLsAkzLtQ9E2V0Q9AMYb/Haxz4ToQ
Date:   Tue, 25 Jan 2022 15:46:26 +0000
Message-ID: <BL1PR12MB5157F98E8A1B86E582DB709DE25F9@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <20220125152111.22515-1-mario.limonciello@amd.com>
In-Reply-To: <20220125152111.22515-1-mario.limonciello@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-25T15:45:46Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=7a8005b2-ff8f-404f-a8b3-9dc5cb2fcc21;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-25T15:46:24Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 880d764b-89b4-4052-83b3-e0e42f46abc6
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5701b73-9854-43f7-3714-08d9e019d8af
x-ms-traffictypediagnostic: BN8PR12MB3284:EE_
x-microsoft-antispam-prvs: <BN8PR12MB3284C4AA123A6DC64031195DE25F9@BN8PR12MB3284.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bICWc+fO2AkKHAWekIMQU8ZCOQIJszN0cXBHZ0yGn1IQZflwuCK/FwXKsxiZUMtzf/4XMSSorZhXUo8pQPWorGqu9G+rePGqtxQ4l5V1N4qGMDR1o+eG3TuAWHYdCCMUoYiFCPr9kADn7V0HoTYWVxZvT/Q7BmwA6A55a/TiQEM2Jso2XXxyWcOO+k1+FWydDHbOvLypr8qibhQ4VFP/UAVWeJkI/LDZhlGO4ad/5BQxwXsODm1ne4v8yO+h6VX5fUCYZKwQfRgxwS1yy5AONTCQLQGcAX20R6uHeN14QUUTFSjLy7tc+y8S7SUmfU20ErpZYOPJG4H+zeoMyTnqVpDQKLzTTH2x0BaFw8ayq6DoiKWqRsHzZELC1WzeGPnkfkmrOt2LkBoIHgz/0UAlES6J8sXh4aHhbxoIRlDEWinadOXv2eKDENkEEnAex/jcloM0m+ffzCNc+A7U/G4ASjHW3Nl+3rhEIdLXeLx30+aZHg6sxtm1wKLePa4Eh2outXTmCrqwL3Z3nLfc7X+BDPwsb+gaccSdT/djzQ6V3jY6GNXFEmXxIspPwOgMt7e2ZQh+3x9ehMRxwKV5fUuhSgBXf/dRUgQbf2Y2bOusCDdm92ZlqBcSQbsMp8ioEl8xQmJs4yWbezO9jnKsQq+RzWA8Rl8B45udP7p3b6lnQqnZs538ZLdlGMFmtlbBc4VnQqRbU5RfOQ0BlCsbjmwdpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(38100700002)(66946007)(76116006)(2906002)(66556008)(8676002)(64756008)(66476007)(66446008)(5660300002)(8936002)(33656002)(4326008)(55016003)(52536014)(9686003)(86362001)(54906003)(316002)(7696005)(6506007)(38070700005)(71200400001)(508600001)(6916009)(53546011)(122000001)(83380400001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QqsLulthex/edmy0MypVbrKSImpqG6RYpEsdkOPTWoUljxEBe1TELJHDkD/x?=
 =?us-ascii?Q?AWsm/RWRGZq5wOxbghZfrhDBN4YFX9XxdcWrRp6UkSybtCM2cQilG6qdXklF?=
 =?us-ascii?Q?fK64vvmXlkW5RgrFmjnmCgclX2bRu6lIrhcnFGTjmgXP76YXhCiXO72bfWpV?=
 =?us-ascii?Q?x8jntrC2kSRBjApIEwbtYYdfjf/lmz6JNqQ4JxSzQXSCnof8oM7jX7f0vIvC?=
 =?us-ascii?Q?O6kbeH4oFvS7FbTA2rSikg5S1bTMSn/D2z+BVF6HtLHDDBz/V2dvE0ScFZMu?=
 =?us-ascii?Q?iufvA6xSuMhZudhF60bNt/uAwzOTvBAoW8KCc8eHFaLEmpAFTgixP0tbFC9+?=
 =?us-ascii?Q?8UbKOkzBgRbRFAh4B5nsF5Kpx1E408RKQjIYwn261wlW0ZLvL4vpvxcKbd/P?=
 =?us-ascii?Q?zZNKLjQUlKwu4mRh/lgPnOckoLU4lYSWmOM1rgl/oRUPJZr5pq3G706vItv7?=
 =?us-ascii?Q?zdm+1toa9ZZQII+GAgumDjPshu9mG3Zg3xEHKfcj0GMgpCHLLVQ+uSaci9da?=
 =?us-ascii?Q?BllLtLPFi8dyCLdRwdydsZZxIrPU14B99SKggwnx+WMVoW2F9RFKEkkQnjFR?=
 =?us-ascii?Q?gI4FbSbQGKalOocf2WpuTTPwKDy9ucIlPIO5IyP4VFA+8jZM1/tuJMVRIOQQ?=
 =?us-ascii?Q?y4o5Gu/XjmZwWF7xd80GrNqdntyGpRmWin/g8Fl8ipC4MGmXFhmkr/tY1KIS?=
 =?us-ascii?Q?CSXuBVlpV/M9BU8b4WyaScvHpHxpIcQ5qullKLKNPEm4OIRoCQbOwkI5NVt0?=
 =?us-ascii?Q?iY1LsaiFE68OeAJ1W1rlUtSsa3zwa2hYm8lGKSDuzCWeJmusKEOt4y0YqNqN?=
 =?us-ascii?Q?hRNrYIyOg2aOkIbNpxlKa53t+2vKVZU05/6uLzuV4oYQ5m352FugMilF6Ek+?=
 =?us-ascii?Q?MbRWO6pMOPrkhPjPF/V09Y37+e/eVxhrMZi0RCJaZcimQ7jjdGVU1fIHJEvQ?=
 =?us-ascii?Q?tB2sRbMqA847syurpUp7DEsGBlSA5Bzpv8RjERnP791JDp0fn9ZYo/47OK8U?=
 =?us-ascii?Q?uQgG6+/QUIAFTIMYFlgM6uhpEAuRHO8vAA+ALERprHVKsFUxBn+AL6ss2TZf?=
 =?us-ascii?Q?5xvLIwFisbYMGa3Kos9aMXrLm0FLeO4G65gkw1o9ssJo1AAYtEDP/qiVPrvm?=
 =?us-ascii?Q?xpdNFJNyzkLvN0pXg+bqXsREJLNc5teCwcM29onEi9Kv+LwXndW1HaE7vCTA?=
 =?us-ascii?Q?L+mXf/3o9jvqZvSm+4hW7avKIiTAH6UqT8HuKE/KpKVlpfp0exteYk5vyVDQ?=
 =?us-ascii?Q?bDmsMVq1gioDYhfccVgGpTEA8A9D1fnFsN7LQWE8Q0WpnoFpN79ddy263HZ+?=
 =?us-ascii?Q?ENKJBDAQF07dge/39h8h4yWv+2IHglgXTTEhllp0tsY0A/oh7s3L+WcZgsZ3?=
 =?us-ascii?Q?Hk+6XYS/7jC5tmQZXJcF9QtwnFVANC1cRdupT1jKto0zqSiMHagD0+flFtcT?=
 =?us-ascii?Q?NJKEezs9v68yUHSzdkIBookCrJ86eeEFrUnzhoNquevOjFE4HSMIiJiP64z1?=
 =?us-ascii?Q?hriKRsBgXiVVrzn4dIX428Z3R1DSmnTDkSiOEZjjAyZT2SwYLigs/VYmRaS/?=
 =?us-ascii?Q?uLOTbMEQ8TB2ZcQVePPN78zjUUx0V46cm+nRZaM1rIle6ZXrv6wFtwMJcFK5?=
 =?us-ascii?Q?BcDdDOsl2DUC3oAgzA116kw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5701b73-9854-43f7-3714-08d9e019d8af
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 15:46:26.2082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +LmmKWwjrNLz7U962MFwOQqewL1j+SKq3AiGMvxXZW5P54vbM8gcgYMMBc0694JuvOslfVc067Ay7GOYDP7v4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3284
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]


> -----Original Message-----
> From: Limonciello, Mario <Mario.Limonciello@amd.com>
> Sent: Tuesday, January 25, 2022 09:21
> To: stable@vger.kernel.org
> Cc: Deucher, Alexander <Alexander.Deucher@amd.com>; Wentland, Harry
> <Harry.Wentland@amd.com>; Limonciello, Mario
> <Mario.Limonciello@amd.com>
> Subject: [PATCH] drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2
>=20
> For some reason this file isn't using the appropriate register
> headers for DCN headers, which means that on DCN2 we're getting
> the VIEWPORT_DIMENSION offset wrong.
>=20
> This means that we're not correctly carving out the framebuffer
> memory correctly for a framebuffer allocated by EFI and
> therefore see corruption when loading amdgpu before the display
> driver takes over control of the framebuffer scanout.
>=20
> Fix this by checking the DCE_HWIP and picking the correct offset
> accordingly.
>=20
> Long-term we should expose this info from DC as GMC shouldn't
> need to know about DCN registers.
>=20
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> (cherry picked from commit dc5d4aff2e99c312df8abbe1ee9a731d2913bc1b)
> ---
> This is backported from 5.17-rc1, but doesn't backport cleanly because
> v5.16 changed to IP version harvesting for ASIC detection.  5.15.y doesn'=
t
> have this.
>  drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)

One more comment - dc5d4aff2e99c3 backports cleanly to 5.16.y.
So it should just be a straightforward cherry-pick in 5.16.y, this special
modification only for 5.15.y.

>=20
> diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
> b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
> index 5551359d5dfd..a4adbbf3acab 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
> @@ -72,6 +72,9 @@
>  #define mmDCHUBBUB_SDPIF_MMIO_CNTRL_0
> 0x049d
>  #define mmDCHUBBUB_SDPIF_MMIO_CNTRL_0_BASE_IDX
> 2
>=20
> +#define mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2
> 0x05ea
> +#define mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2_BASE_IDX
> 2
> +
>=20
>  static const char *gfxhub_client_ids[] =3D {
>  	"CB",
> @@ -1103,6 +1106,8 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct
> amdgpu_device *adev)
>  	u32 d1vga_control =3D RREG32_SOC15(DCE, 0, mmD1VGA_CONTROL);
>  	unsigned size;
>=20
> +	/* TODO move to DC so GMC doesn't need to hard-code DCN registers
> */
> +
>  	if (REG_GET_FIELD(d1vga_control, D1VGA_CONTROL,
> D1VGA_MODE_ENABLE)) {
>  		size =3D AMDGPU_VBIOS_VGA_ALLOCATION;
>  	} else {
> @@ -1110,7 +1115,6 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct
> amdgpu_device *adev)
>=20
>  		switch (adev->asic_type) {
>  		case CHIP_RAVEN:
> -		case CHIP_RENOIR:
>  			viewport =3D RREG32_SOC15(DCE, 0,
> mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION);
>  			size =3D (REG_GET_FIELD(viewport,
>=20
> HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_HEIGHT) *
> @@ -1118,6 +1122,14 @@ static unsigned gmc_v9_0_get_vbios_fb_size(struct
> amdgpu_device *adev)
>=20
> HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_WIDTH) *
>  				4);
>  			break;
> +		case CHIP_RENOIR:
> +			viewport =3D RREG32_SOC15(DCE, 0,
> mmHUBP0_DCSURF_PRI_VIEWPORT_DIMENSION_DCN2);
> +			size =3D (REG_GET_FIELD(viewport,
> +
> HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_HEIGHT) *
> +				REG_GET_FIELD(viewport,
> +
> HUBP0_DCSURF_PRI_VIEWPORT_DIMENSION, PRI_VIEWPORT_WIDTH) *
> +				4);
> +			break;
>  		case CHIP_VEGA10:
>  		case CHIP_VEGA12:
>  		case CHIP_VEGA20:
> --
> 2.25.1
