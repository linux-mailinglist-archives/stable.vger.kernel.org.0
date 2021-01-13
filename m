Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379432F4EA3
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 16:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbhAMP2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 10:28:43 -0500
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:61152
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726787AbhAMP2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 10:28:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXKTO5D3AYXey5zUpTK5Vfi+rRpIfIgv/2JxP2lqxM8Io80yhi3VM1P6JczrO6OUzqzyseok+xO49qXV2ooW7lm9l3PrKoEIC8yxOj9NyTMVhF86NoF8bD1lU6DjUVBddSfyaNqs08AExdp7Q1KoQSt0HBgxhxgVpVr5VjRMxiK9NThKCwdHVu/xf/bR98DNdd/UYluXiJR8m1nH3NG+O5ZiOX8+JIvUHTv1pvQY/4cSSqTkn9Zaf0GPm+sH0qSuShTWOgkeYTYc7NE9cfPUdH0h1s/estcoWOA3cIo+kwkVpKliqPzVc4lf3bZnThIfNMhWbZBxfke155wgCnDoXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDy7kICbf2Cx1XADg7pFo+6pPuzDqMBDRw3SDy5k3CA=;
 b=MycQarX2JhofIg1R1JKsvio0uECeQPNXAM3u/Rs4rXLS8b2HXLR9KremajQr1Px/xzL2mCw2Mt71CxEtuFkbmWrkh7OyoUMeYgzCdf79b/vkftAocy3oMDauXOlOz9ZPe2abLZG7vhopFZ0LcawE610WJQn4E98pYqRbRVAM+7WwLsFQL2p7I8KkvF1f332ZIyKiEYhkZb6wgfUI0Lkoen9RuTXuC+zSSDFKNsV5b+PjKVaQ+7+vmAOixPzNKuKKKzTlJCvqtDLlJAFCRJYMSGphYLmEy54JFQDU0uQun3YEmgL2kSXXJM1exYFFK73sBi2WmLnpgRQI8l/IRdks8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDy7kICbf2Cx1XADg7pFo+6pPuzDqMBDRw3SDy5k3CA=;
 b=iyzQaiS5P/Hi575PEUovzcKySFQyB26pPsXqm8RT3CuSZEY9tG84o69zxUX1sVqvew9TYOjCzH1DyicCdjkAD+wgVsl6+hTT/aW/JVCEpA24fg1HLrvJRMdGU62Yd7Fw7rN38vpZ1VTlAMEtTl5BN9rgrNfXQcxinF10jIFVOYk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MW2PR12MB2457.namprd12.prod.outlook.com (2603:10b6:907:10::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 15:27:53 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::8c0d:7831:bfa8:d98]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::8c0d:7831:bfa8:d98%6]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 15:27:53 +0000
Date:   Wed, 13 Jan 2021 23:27:45 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Liang, Prike" <Prike.Liang@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] drm/amdgpu: add green_sardine device id (v2)
Message-ID: <20210113152745.GA283203@hr-amd>
References: <20210113152404.1307212-1-alexander.deucher@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113152404.1307212-1-alexander.deucher@amd.com>
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HKAPR03CA0023.apcprd03.prod.outlook.com
 (2603:1096:203:c9::10) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (180.167.199.189) by HKAPR03CA0023.apcprd03.prod.outlook.com (2603:1096:203:c9::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Wed, 13 Jan 2021 15:27:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 819058ad-43c4-48c0-8e87-08d8b7d7cb69
X-MS-TrafficTypeDiagnostic: MW2PR12MB2457:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR12MB24570A58958C26BAA54E444EECA90@MW2PR12MB2457.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:407;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ip1DbgHboy5O8jEpdAkMKC3PmLAdGx9mUptOV661Vm2/94ZX1wzntHLgnJt/ZS073p5DjgG2q+lG6s3+1FrMpCW4VSmiIB4G/DycvRwtspQndE36kYf38/vVSG4glZWTBY/nggjixq3j6+INWIP3qCcnkeCfEBfKEPVY3jm/cBJz6BfIEuHPLRA0vPl2dUGY5a7OnbYyOnOJ57fre0b3+/N65WckqYNxLGxsAA2S+3JQ23hp281ZOrd8FUGI8wT+EH26umIAfcmPZl+5idbXDxK9IICtlJoDpZRDzuoyM/8P5qlIZQUONbVJp97xKyorj+A1OtCkBdN8IialS6B/qe+Kty9eOzt4/FvjlrUliqbvns4jr9aQPpwj/fQYNqLxhNcLBJY6E1b4kB9b/4ZLMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(33656002)(86362001)(316002)(478600001)(8936002)(1076003)(26005)(6666004)(4326008)(2906002)(6496006)(186003)(16526019)(55016002)(9686003)(52116002)(33716001)(8676002)(54906003)(5660300002)(66476007)(66946007)(956004)(6916009)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?B0RJ7/F50Kt4dJVv0uq1EJWfhPqq5B8kIR3i6y0xXG+w8g+qXsyc9yxWgqSI?=
 =?us-ascii?Q?LnKJ+1c2y2h3ecHMX1vPmt9Sd2dpgf8O4uWPw2D/RKDgd2901bfbqdI4lYFh?=
 =?us-ascii?Q?KytVICW9neLKag90TYnLIzvDRs+6NobKWDJJL+MRiDTGrnIF4e+08Y4WuchE?=
 =?us-ascii?Q?Kf4cH1eoyF7CUhOA3QuOxRCNwNCl0z0n5OfUyqm1zjz/bSsQHDeLyQJUWwRr?=
 =?us-ascii?Q?lkUEII4JoJzEy4dHSlQl50Z4lUbReIacjPILF82Qw15rP4BE1CgZaYZlsPkt?=
 =?us-ascii?Q?W2F9B3evV1AS2jdAYyNRkmZ1WK98+2zAEN/SHp3islGURJz8fIxbuyqtHYgV?=
 =?us-ascii?Q?d+kDlvtAHbC7hiEzL9RjPpZBa6Ifp9mPv2H7jtNylzKEYCg++W6Eolu+tcyJ?=
 =?us-ascii?Q?mk6+KzMqYwV7+3Veo4X/eG0t8vrrc+d63m/6hvGzY4no9oy0+fKfYOxtsd3b?=
 =?us-ascii?Q?esRbga/SQKv/ArT8stGhZWADmXACdDH6gRhYY16KC2GdYoTQaVfyUNXmG5Qv?=
 =?us-ascii?Q?TPa74avzZpuFYWuNcwe3dbk+PZMlAgk21+TuXqDmjpF5E85MdP1i11EoLlza?=
 =?us-ascii?Q?ljY8GZ3JTB6Dw+1wBRT+gjkVsuk5z/DxhDSfCrgbbdirlGSABh1isQ0n2O/q?=
 =?us-ascii?Q?2VjKVOlqW3CewvQuwf5svVKawJNy1GCZNnY7dRacEMUk4edirPDhczva6X3U?=
 =?us-ascii?Q?MXKhifpcQlmyPrCdjV6WYHCAxslaH0wNl6kUakLiIXTKpXWx9dR4Zx7aRwm3?=
 =?us-ascii?Q?utk+Z3t7XUa5uNb/Lz9/aiCOhtgWu8QCuIZhOVXbkS7jH3OCPNw2fvCgCT/U?=
 =?us-ascii?Q?9SjSPzeKhvIplsdcdmfOU0kvaS19aZyFnCOUnacsT1vmzTZ/4/LAU9Q3CIEz?=
 =?us-ascii?Q?06Hrtyfwmf081AJxyzlQiayaSBCuwF0TZB/xL3OV/riCQ+/JPMQCtF7QMJEq?=
 =?us-ascii?Q?JoVXYTtqAlUuCvzQHWYYv80I+81s7RMM+xn3aSBjGaBs5ppvBQBHrxl1p5TE?=
 =?us-ascii?Q?jjyE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 15:27:53.0819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 819058ad-43c4-48c0-8e87-08d8b7d7cb69
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ib75KS0n2hSF2IFRLJ3C9/PaFmk4VVoqlz/5gi2EWFo3kN9DDJcAY+031FnbDwXexUvlhf2pOEd3LBPViPAbqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2457
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 11:24:03PM +0800, Alex Deucher wrote:
> From: Prike Liang <Prike.Liang@amd.com>
> 
> Add green_sardine PCI id support and map it to renoir asic type.
> 
> v2: add apu flag
> 
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Reviewed-by: Huang Rui <ray.huang@amd.com>

Series are Reviewed-by: Huang Rui <ray.huang@amd.com>

> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org # 5.10.x
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> index cac2724e7615..6a402d8b5573 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> @@ -1085,6 +1085,7 @@ static const struct pci_device_id pciidlist[] = {
>  
>  	/* Renoir */
>  	{0x1002, 0x1636, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
> +	{0x1002, 0x1638, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
>  
>  	/* Navi12 */
>  	{0x1002, 0x7360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI12},
> -- 
> 2.29.2
> 
