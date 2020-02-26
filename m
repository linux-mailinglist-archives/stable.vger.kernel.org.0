Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEFA1704D4
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 17:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgBZQvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 11:51:49 -0500
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:23299
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbgBZQvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 11:51:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHkW28kNCgE5jxLfUgNexVqRbvAoxu9qyRdslFDr/nQ=;
 b=hjxdk+uY7SKjzPIofjbCBJh5iKr8kK3uD9qKolnDbmxRK5qrIolwOqnjS4ctdmTAb4jwEhyajYW869hxmgqZLN7h1S/zcNNhjQWH1rzC9oQ74lBx5ESTbnnirjvhlFNpF74S6pqDnxfNnP+vJlvvQpL3se3IkMNnewgWNwCr+Gw=
Received: from HE1PR08CA0077.eurprd08.prod.outlook.com (2603:10a6:7:2a::48) by
 AM7PR08MB5414.eurprd08.prod.outlook.com (2603:10a6:20b:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Wed, 26 Feb
 2020 16:51:43 +0000
Received: from VE1EUR03FT032.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::200) by HE1PR08CA0077.outlook.office365.com
 (2603:10a6:7:2a::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend
 Transport; Wed, 26 Feb 2020 16:51:43 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT032.mail.protection.outlook.com (10.152.18.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15 via Frontend Transport; Wed, 26 Feb 2020 16:51:43 +0000
Received: ("Tessian outbound 1f9bda537fdc:v42"); Wed, 26 Feb 2020 16:51:42 +0000
X-CR-MTA-TID: 64aa7808
Received: from a460a236c16b.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id A96C5F3A-5DEF-42DF-96A9-1B05A59F67AF.1;
        Wed, 26 Feb 2020 16:51:37 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a460a236c16b.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 26 Feb 2020 16:51:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FT0zHBcRjUnLayMn+a773jv5GQPlJVemR+O885IjHgvz647AE+fWQMyIFRSUuTWO04Dj88Nfmrr/vSJha/hoQxyq3c6ZxOGQoiZclx5mLLbbadLjsG2pbSwovHnQCM4TyVulGguvbVHfMWfTYFGjG32C8A0Wra3Hs2RcHRr2+57jhZYwmTa0CxOGbh78B0Ia4v1CSVlTEHwh3Ds5z30ZXqSG28olzl+1x1i/nXoF0TDLE7YFLTawNuQYLbM5TWDgSDiEeqzK8h7AC74esVSapqa5glWjtcrjHK6Er9mqHxIXeQMGdj4BmQqOrMFhJ9mOgy3y3Ubi2w7vRDsof4qs2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHkW28kNCgE5jxLfUgNexVqRbvAoxu9qyRdslFDr/nQ=;
 b=IXeTna96gpI2Si5Cj+cvJyZ77tGWmhvRCF5Zcilu9GLZXRmd0wjFmjx0jRQP5ppN0q49NvjaG6+VhqJsdE0+Qwfa62RQAz0Yi8Gm51zYVJfUkbq1QHFsvM2gACc0CwuCdNdF/yEKDA1iAGi8JFQuveCHhnhbEfmKb5Obr4Kh4/JzhyGMOueH6zHyHgx6KgNmLguSVgoP8V+weKRM7rDBbTFWQYA71dAJC1boiN/8H5Kf5AXd7ZLPiqINqvxszQm4Rn951OSD37R2jz6xmkIee+B9+7VCcNVIltQc/YLeKi9doDzXkQWvKLBGCteSQqCnXEmhZYEvMT3X3J/IqUxFew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHkW28kNCgE5jxLfUgNexVqRbvAoxu9qyRdslFDr/nQ=;
 b=hjxdk+uY7SKjzPIofjbCBJh5iKr8kK3uD9qKolnDbmxRK5qrIolwOqnjS4ctdmTAb4jwEhyajYW869hxmgqZLN7h1S/zcNNhjQWH1rzC9oQ74lBx5ESTbnnirjvhlFNpF74S6pqDnxfNnP+vJlvvQpL3se3IkMNnewgWNwCr+Gw=
Received: from VI1PR0802MB2237.eurprd08.prod.outlook.com (10.172.12.145) by
 VI1PR0802MB2575.eurprd08.prod.outlook.com (10.172.255.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Wed, 26 Feb 2020 16:51:36 +0000
Received: from VI1PR0802MB2237.eurprd08.prod.outlook.com
 ([fe80::74dc:6713:1819:a113]) by VI1PR0802MB2237.eurprd08.prod.outlook.com
 ([fe80::74dc:6713:1819:a113%9]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 16:51:36 +0000
From:   Guillaume Gardet <Guillaume.Gardet@arm.com>
To:     Gerd Hoffmann <kraxel@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     "tzimmermann@suse.de" <tzimmermann@suse.de>,
        "gurchetansingh@chromium.org" <gurchetansingh@chromium.org>,
        "olvaffe@gmail.com" <olvaffe@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 1/3] drm/shmem: add support for per object caching
 flags.
Thread-Topic: [PATCH v5 1/3] drm/shmem: add support for per object caching
 flags.
Thread-Index: AQHV7Lwl0GK9e5pUr0Sp8jAc9YZ23agtsG8A
Date:   Wed, 26 Feb 2020 16:51:36 +0000
Message-ID: <VI1PR0802MB2237D75512DA7A60A272586883EA0@VI1PR0802MB2237.eurprd08.prod.outlook.com>
References: <20200226154752.24328-1-kraxel@redhat.com>
 <20200226154752.24328-2-kraxel@redhat.com>
In-Reply-To: <20200226154752.24328-2-kraxel@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 4648bdfb-604e-45f5-87c4-08e21a4da047.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Guillaume.Gardet@arm.com; 
x-originating-ip: [2a01:e0a:d7:1620:d09c:e29d:cc48:6fa]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1356267a-54c5-47f8-6972-08d7badc28b2
X-MS-TrafficTypeDiagnostic: VI1PR0802MB2575:|AM7PR08MB5414:
X-Microsoft-Antispam-PRVS: <AM7PR08MB541494466A24A3C8D8D3001683EA0@AM7PR08MB5414.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:6430;OLM:9508;
x-forefront-prvs: 0325F6C77B
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(199004)(189003)(186003)(86362001)(5660300002)(33656002)(2906002)(66446008)(478600001)(64756008)(76116006)(66476007)(66556008)(81166006)(81156014)(53546011)(8676002)(52536014)(66946007)(7696005)(6506007)(54906003)(110136005)(7416002)(9686003)(4326008)(8936002)(71200400001)(55016002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0802MB2575;H:VI1PR0802MB2237.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Rdv8Y0owohErmZ86HQx/Hch7vGZn3iQxXYlYqc9ax9wTStA0RQ8HFFPwjqnDjvv8EMP+xvugysjh2Df1tLo8A9IxiOuvKcdIWEQj5VBfJAcF8q6fNW8twNjOAMMXA23WLG+NgNQwF6z34AfZ+cWZDXTHN1VpfG8YTfEhKh7PYpuBb2ckaaT9ox+R7+HUAtmohDh+RiwNNm9Lz6DhSLUvf2Pf7X7DgCKQ3psMNKSE3/Pu3wGoalZtQA6N+D8GC7mlhx+2gQOEzJDX3+Apw3l4OMmRnkTgv35rFKUEzWTjiVkn0VFqi/7SjD58VMnUN+EvzMYzl7MvEimoGOtokVibuW7UREurUr+fAaw2nSwc3bRsU26RNsZoyVQbP0I+Bljk/rZLx1eqzZrOl/X+Vb3mHh2acach3IFG4YOKkGzBtOhEM3cZKbpfQqCMuwY+n2LO
x-ms-exchange-antispam-messagedata: zUBFJbjk+T1TkSBbie41Do22WThogZS6stgLkpWVCDI8Duj8c6H6ZfVGhW3mMaKm6RjzgBRlAk4NXCxF2r8t/IlgcSMeh8h/Q6nLLTuwAvAZpMb7Z3ri6zzk+egFeoImQ7ab3ve5Zya5Hnk4irFdMLETU2nCdQgWSE8JkeAH8vPheku0sAL0NYitbtHJM+K/i0Oml/GaDIJSeERUtev8jQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2575
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Guillaume.Gardet@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT032.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(39860400002)(346002)(199004)(189003)(52536014)(5660300002)(70586007)(26826003)(478600001)(2906002)(70206006)(450100002)(55016002)(9686003)(336012)(356004)(53546011)(6506007)(81156014)(8936002)(8676002)(81166006)(186003)(26005)(54906003)(110136005)(316002)(86362001)(33656002)(7696005)(4326008)(36906005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR08MB5414;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: ccb052f5-05d6-48ad-e04d-08d7badc246f
X-Forefront-PRVS: 0325F6C77B
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DFC58agMTy+sftIcVi+9PzC2De2qFQe5ycRvcII130wiP+H6uIvV/zsXoJ/Po2AtrmuO+VvDwFGyqO+EhyIRcD+w+HwBhzT3Ufw+ADAxqawRekfbwin7mHQpFdI9smR7gaGZ5rB69uj54pPPQU0P4IOHZt0m+cV5lqoWA+Mq397VkvweNRUgM/0xJk4cNClTZxSr96tz4XIQ1Sny857+MFj1DPEU2aP4pYahGnlqZaVe1qnnnZOyYqR5YXTo9Phr3YTde51wDk0eRkTTCt+rPhUO0WVocLAAdBs1DcRhJ+c2SGvWwqA6vQrBMNwql2W+Uh1qkRkBGnhZWy1dKFNBYK91pugNRyQO4YJmGJT6kw7eGpd3U64X0RfcqRV8fwkrbUynGo9tfssMffRBfoo8QhUKdWni0isCw6lKGonHmWzxm4/k6mumCmpl9atEBHuA
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 16:51:43.3055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1356267a-54c5-47f8-6972-08d7badc28b2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5414
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Gerd Hoffmann <kraxel@redhat.com>
> Sent: 26 February 2020 16:48
> To: dri-devel@lists.freedesktop.org
> Cc: tzimmermann@suse.de; gurchetansingh@chromium.org; olvaffe@gmail.com;
> Guillaume Gardet <Guillaume.Gardet@arm.com>; Gerd Hoffmann
> <kraxel@redhat.com>; stable@vger.kernel.org; Maarten Lankhorst
> <maarten.lankhorst@linux.intel.com>; Maxime Ripard <mripard@kernel.org>;
> David Airlie <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>; open li=
st <linux-
> kernel@vger.kernel.org>
> Subject: [PATCH v5 1/3] drm/shmem: add support for per object caching fla=
gs.
>
> Add map_cached bool to drm_gem_shmem_object, to request cached mappings
> on a per-object base.  Check the flag before adding writecombine to pgpro=
t bits.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Tested-by: Guillaume Gardet <Guillaume.Gardet@arm.com>

> ---
>  include/drm/drm_gem_shmem_helper.h     |  5 +++++
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 15 +++++++++++----
>  2 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/include/drm/drm_gem_shmem_helper.h
> b/include/drm/drm_gem_shmem_helper.h
> index e34a7b7f848a..294b2931c4cc 100644
> --- a/include/drm/drm_gem_shmem_helper.h
> +++ b/include/drm/drm_gem_shmem_helper.h
> @@ -96,6 +96,11 @@ struct drm_gem_shmem_object {
>   * The address are un-mapped when the count reaches zero.
>   */
>  unsigned int vmap_use_count;
> +
> +/**
> + * @map_cached: map object cached (instead of using writecombine).
> + */
> +bool map_cached;
>  };
>
>  #define to_drm_gem_shmem_obj(obj) \
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c
> b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index a421a2eed48a..aad9324dcf4f 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -254,11 +254,16 @@ static void *drm_gem_shmem_vmap_locked(struct
> drm_gem_shmem_object *shmem)
>  if (ret)
>  goto err_zero_use;
>
> -if (obj->import_attach)
> +if (obj->import_attach) {
>  shmem->vaddr =3D dma_buf_vmap(obj->import_attach->dmabuf);
> -else
> +} else {
> +pgprot_t prot =3D PAGE_KERNEL;
> +
> +if (!shmem->map_cached)
> +prot =3D pgprot_writecombine(prot);
>  shmem->vaddr =3D vmap(shmem->pages, obj->size >>
> PAGE_SHIFT,
> -    VM_MAP,
> pgprot_writecombine(PAGE_KERNEL));
> +    VM_MAP, prot);
> +}
>
>  if (!shmem->vaddr) {
>  DRM_DEBUG_KMS("Failed to vmap pages\n"); @@ -540,7 +545,9
> @@ int drm_gem_shmem_mmap(struct drm_gem_object *obj, struct
> vm_area_struct *vma)
>  }
>
>  vma->vm_flags |=3D VM_MIXEDMAP | VM_DONTEXPAND;
> -vma->vm_page_prot =3D pgprot_writecombine(vm_get_page_prot(vma-
> >vm_flags));
> +vma->vm_page_prot =3D vm_get_page_prot(vma->vm_flags);
> +if (!shmem->map_cached)
> +vma->vm_page_prot =3D pgprot_writecombine(vma-
> >vm_page_prot);
>  vma->vm_page_prot =3D pgprot_decrypted(vma->vm_page_prot);
>  vma->vm_ops =3D &drm_gem_shmem_vm_ops;
>
> --
> 2.18.2

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
