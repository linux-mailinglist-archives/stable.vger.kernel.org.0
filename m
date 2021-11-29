Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BCB461E24
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379197AbhK2Sc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:32:59 -0500
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:29809
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1379178AbhK2Sau (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 13:30:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIDIb8frn0fmx+hMa4ILk0mo6ehUMETWBFHLBxzx/vmub1bDxTMzA3toIMH4i1I4NBUIWqmjZNERCm1vMi5QeLXKiz+j4u5CwnuqwtY6cr5didfplRyCetegUh7Wgf/fTGRYhmGgWvDDG9RfopFHkghhvqX9m3g2//dYahqfQksZZn+Ppw1w3Fpnr5gfdQVglgU8Odo+FsRxDg/Wegu/Edwe37s12U3yNL84SQ1B5xGiMjIA1OT/AGsmIgo0mQf8DzrXVY9wpVR7yTJM0QlJAZPrCeanAkCSUOxxYnBSX7Ns789tnWp/ohagQfNvyUrFrk0zp/1SWFks2FPEFrpYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LaueIl0ApvPiUZAjVHtdxkFIg4NpUQl0bvlvdkPdmCM=;
 b=lbRkpBK43jNPugk7wnOk9gbMBS7Zu9AcsuhsAafOH3YBZlFl/ZNiCSxrNGM4TqvYrcyn5VQunT7P9cf32VN8/Ddai2kddCJmG+NFlxaxtIzDXAMMWo5VAGamhNO4DXIEm1ODrO06HhqcsZ5qeFj0KqCDg4dp7cC2Ur+08RhgkWbstScCktmZzFGYUQh/jN0CxQ2pjtS+4nBbiKFuWFwn64a9kuu5K4K2gWcrA5j0MNlc5bOrerR2Zb2ju6yI8PM6Fl2zYIv0YRUaR8/G6v/EnKxwMblCUJUxHJ8epDusOY6wQTIp4weUqdEfnP/T1RPC63Bd/WxNzlWNPQb48ibLjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LaueIl0ApvPiUZAjVHtdxkFIg4NpUQl0bvlvdkPdmCM=;
 b=Spj2olTkG2ChN6tOAdaf3TppFgubahlvAfJu+VvF4TCI0T0V2S9ONs8wY8B9bkLV5aA5CapguM0fSSoeS8YXmiKwul1m/YjXj+Wg5EeEl9wzlT5udGfYtvtZaNaRI2t2Q7WBoH6BWoZQAYLXE+9DFAUch0SsX67cVz3xU565DUk=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL0PR12MB5508.namprd12.prod.outlook.com (2603:10b6:208:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 18:27:31 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::6452:dc31:2a24:2830]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::6452:dc31:2a24:2830%9]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 18:27:31 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Tuikov, Luben" <Luben.Tuikov@amd.com>
Subject: RE: [PATCH] drm/amdgpu/gfx10: add wraparound gpu counter check for
 APUs as well
Thread-Topic: [PATCH] drm/amdgpu/gfx10: add wraparound gpu counter check for
 APUs as well
Thread-Index: AQHX5U6E3HD9c5i6sEa3e+bcIKJb16wa0q8w
Date:   Mon, 29 Nov 2021 18:27:31 +0000
Message-ID: <BL1PR12MB51447ED7FD5E2F3E33DEC37EF7669@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20211129182527.26440-1-mario.limonciello@amd.com>
 <20211129182527.26440-2-mario.limonciello@amd.com>
In-Reply-To: <20211129182527.26440-2-mario.limonciello@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Enabled=true;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SetDate=2021-11-29T18:27:28Z;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Method=Standard;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Name=AMD Official Use
 Only-AIP 2.0;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ActionId=4903d5a9-50f3-4a25-aad3-1a2a538c663a;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 242a7632-7c31-4e2b-8b47-08d9b365e801
x-ms-traffictypediagnostic: BL0PR12MB5508:
x-microsoft-antispam-prvs: <BL0PR12MB5508563D8E4165E9DCD8F15AF7669@BL0PR12MB5508.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7BAz7UigtebijtAkiNyvxGTXHHcHFtWVbJDuvLMtIq7Ydh5B64Pq1kD4CsodCJDEdylMl3csv+SYzlKxhuivJHNJ7m/lfVOTwy0O96Yi0DJjXKdDeHy/3LuBYMNOgqiu2NRe2iV86s4QMAV/Q9QVB3baTLLtDaW9W3B3OAgUWCyKVPhM/aKWyFMLyF8ks8LWYUuQOX8JGRzxPHIAHE8N8dmFQIgrFyiIC08OUXvgoYzimBcc7E1sFhE1KRmIzaDE8OdwK4j64CXNGyrwCv+bTk38j69tmKmQSSxxWrQbJLqqC4h4kZ6OhOKNoJ9soSr0XdUlQya/Tce49WCMYZ2C30amcFiyLUgk5sLmhiGxtFg6h4O9uGt9ZztnMwoD42GWx+m3A3uMITGmguZbakphGJCRolO9+bZmbr2ru+IoRN5Ct3YHor+vVYukqQbhonZaAzRVum2to9dcPQM8KuzegUKH2DY2TofW5r0+ID6zn6hgEI0Q77w4cNKwNNHPyQnKsfSBYI5wQ3dOTP5ZJNMnwLt29Hku7WUw/6CpojiLaXP0pXVT8/4E5KjOM/iaX9ZGTVv/6yjrjRrxPYI3sOchl56JQL2n/F1YMT7gHGcjDvMGZ5VV7u5GmAuPCE5VcmeTvVewhksL0Yig/Y9QmgIOFABrEElpyiYuvW4QOcUw598UEjiTJjeSiA3yhkZwiev0xpuslLx/pH70BgM3s7fwnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(122000001)(508600001)(38070700005)(26005)(86362001)(6506007)(55016003)(9686003)(83380400001)(110136005)(316002)(38100700002)(66946007)(2906002)(33656002)(64756008)(66556008)(66476007)(4326008)(53546011)(76116006)(8676002)(7696005)(5660300002)(71200400001)(52536014)(66446008)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NqDsTad8DBXGWna19lt10dEfaWk0jUH1KfhNP7hTp3TeWELpIT7bW8Ytypex?=
 =?us-ascii?Q?dyZun6Vg8vW0lIOS3cyseJJNM35b9f4+mZKKlyX2aGABSYLXw5UIkT84rB45?=
 =?us-ascii?Q?Zz915xCg1SzUAFR9zkSu/1YoJ82D9Z4uNaiukOJtjG2SHKNEl69twIwRWNa3?=
 =?us-ascii?Q?C8LxjxK4XsiX/UT30atlazxGXyj4xZ1aOMBihFBZBYAf+XMCx38s2G4hvIGJ?=
 =?us-ascii?Q?9L93GS8BKZb3Q7fT/Pg/FdohV3jMZON+p/FzoXRdI6e8m9iukff1SGgjC0dw?=
 =?us-ascii?Q?uTG1+B50Dpdepzwq7NW0NyfozGDIKw5PGnD9zX0LQt+B+DxlNDKf8Kc+BLQl?=
 =?us-ascii?Q?zsdwr4Z0xDm4ne1D/gdnkTaHXE4z3xY1lJZKoep0Ve0UBX2OlNSmo7zJ8z+v?=
 =?us-ascii?Q?6WcG1qoAGz3c1NfkLOdVmRSkOcEJk3/ootSjRPAcvN/qH8PnK+746ySAe/+X?=
 =?us-ascii?Q?WspEKcf2GeTY9VvQ+JmPImPylpfeVA246pmL1L0cak7rwxDz6TQh8+rMcoB+?=
 =?us-ascii?Q?XLzzSPDvzQ5DR9UE4gh+AJCR0orJpSTZwayduSz9tEOvrCCH8b26tQls+JWS?=
 =?us-ascii?Q?bebvwWoMpZvnaQiHGoTQSTudAqE9GDUIqsRMT6CJK7x3MoqVf//FX4EfGdMS?=
 =?us-ascii?Q?mJ7fV6EpwqEQT4c6/bWRVaWq+NvtltJxjTL76VDjQxalrbWXWRUhRJs2DAi6?=
 =?us-ascii?Q?9KRPTzAE1mkwZSSd9CjVNdNmhSffLe4SD7jQV+weB8Tj/YoUdKe2co374o4F?=
 =?us-ascii?Q?zbQs1JAKMi971rzUgK5VsUy/FK0LmGyERLx4+4ehFmyoXnUsWGsW6yHPDslW?=
 =?us-ascii?Q?BO7d8oN/QVeXIeI02Nno1H+GWs51X0Xd3vXWsF+UN5zgR6XaWXToN5Kif8a4?=
 =?us-ascii?Q?iN0iGRChYXBS1mTuFyKei1hy9cab0pWQmdpzUUAUX7sc+pc9dUWrebPlP73m?=
 =?us-ascii?Q?e7gKnOQLlRfdVzZf5YCjchiGq26/3DV5+QJ1iSnjJE9cKOFz3DkJZnjvEZzc?=
 =?us-ascii?Q?lgOTkCP0AFPQSQVVD8NGPrlKfjcgkMSggR03JBZCpSPSGPaf+mTaO4V9GKC5?=
 =?us-ascii?Q?TGSjcVl72C18cDEHrteQieoBhDIWZrZLYjdMWnEgP0EYRVpKMC3CJpL+NAzp?=
 =?us-ascii?Q?eDc771Lk4Qxw5ZDeij3drzXPZuX/usAidOmssTVtci2P/SgUcjPog+AS2v7l?=
 =?us-ascii?Q?nycSbphVsNkhlFS53tJ2Eq3eHT+A660ieGZUWWVzrLU0LcE/KI1OjdmWE9hl?=
 =?us-ascii?Q?X3U6OuP7AGWZezSNdUCV6a5fYGnD+X71Sf5O4MEUZhRlqGRrPaZjjaZ0AZRc?=
 =?us-ascii?Q?QhGbj5lkxxDuPUDWhjEQlFmAVoXn/EkuZHOrFN+PLuF5AMJrP9nCN0JXAXwr?=
 =?us-ascii?Q?0/sO3XNR8s+QI13in4XR0GeENVpkRmzr0+cqYR4GyWmmEOqH6vTjCuN/Nf9D?=
 =?us-ascii?Q?/O/PXYA7mz7r41u96S9vtVb3+dCa6Ei5JmbKet0voSacKjxMyjPBVYwP19us?=
 =?us-ascii?Q?/3TDHAMJU6438kKiQwmBmPHMbCu3h9Y+uvyRsoF3OyafmvaikW3qO1kYDlVa?=
 =?us-ascii?Q?e7h6q7QRT+ZmRihmbrH7wQ4WqQHZkCXil5WvznnyS0Sb+v5B9OGsikhfh2ou?=
 =?us-ascii?Q?8YwkJ2k/HrxcbXtoZqrNaco=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 242a7632-7c31-4e2b-8b47-08d9b365e801
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 18:27:31.4233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vk2VTrRVdtiu0bWaYYuHLMuQntQEPHxIzywdHfrRn68Um+U172MdJdT2w+CWFHsX06NN7/U6TF6vlMaAsLvZAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5508
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only]

> -----Original Message-----
> From: Limonciello, Mario <Mario.Limonciello@amd.com>
> Sent: Monday, November 29, 2021 1:25 PM
> To: stable@vger.kernel.org
> Cc: Deucher, Alexander <Alexander.Deucher@amd.com>; Tuikov, Luben
> <Luben.Tuikov@amd.com>; Limonciello, Mario
> <Mario.Limonciello@amd.com>
> Subject: [PATCH] drm/amdgpu/gfx10: add wraparound gpu counter check
> for APUs as well
>=20
> From: Alex Deucher <alexander.deucher@amd.com>
>=20
> commit 244ee398855d ("drm/amdgpu/gfx10: add wraparound gpu counter
> check for APUs as well")
>=20
> Apply the same check we do for dGPUs for APUs as well.
>=20
> Acked-by: Luben Tuikov <luben.tuikov@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Mario Limnonciello <mario.limonciello@amd.com>

I just send these out earlier today and Greg applied them.  I forgot to cc =
you.

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>=20
> Modified to take use ASIC IDs rather than IP version checking Please appl=
y to
> both 5.14.y and 5.15.y.
>=20
> When applying to 5.14.y this also has a dependency of:
> commit 5af4438f1e83 ("drm/amdgpu: Read clock counter via MMIO to
> reduce delay (v5)") If necessary I can send that separately.
>=20
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> index 16dbe593cba2..970d59a21005 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> @@ -7729,8 +7729,19 @@ static uint64_t
> gfx_v10_0_get_gpu_clock_counter(struct amdgpu_device *adev)
>  	switch (adev->asic_type) {
>  	case CHIP_VANGOGH:
>  	case CHIP_YELLOW_CARP:
> -		clock =3D (uint64_t)RREG32_SOC15(SMUIO, 0,
> mmGOLDEN_TSC_COUNT_LOWER_Vangogh) |
> -			((uint64_t)RREG32_SOC15(SMUIO, 0,
> mmGOLDEN_TSC_COUNT_UPPER_Vangogh) << 32ULL);
> +		preempt_disable();
> +		clock_hi =3D RREG32_SOC15_NO_KIQ(SMUIO, 0,
> mmGOLDEN_TSC_COUNT_UPPER_Vangogh);
> +		clock_lo =3D RREG32_SOC15_NO_KIQ(SMUIO, 0,
> mmGOLDEN_TSC_COUNT_LOWER_Vangogh);
> +		hi_check =3D RREG32_SOC15_NO_KIQ(SMUIO, 0,
> mmGOLDEN_TSC_COUNT_UPPER_Vangogh);
> +		/* The SMUIO TSC clock frequency is 100MHz, which sets 32-
> bit carry over
> +		 * roughly every 42 seconds.
> +		 */
> +		if (hi_check !=3D clock_hi) {
> +			clock_lo =3D RREG32_SOC15_NO_KIQ(SMUIO, 0,
> mmGOLDEN_TSC_COUNT_LOWER_Vangogh);
> +			clock_hi =3D hi_check;
> +		}
> +		preempt_enable();
> +		clock =3D clock_lo | (clock_hi << 32ULL);
>  		break;
>  	default:
>  		preempt_disable();
> --
> 2.25.1
