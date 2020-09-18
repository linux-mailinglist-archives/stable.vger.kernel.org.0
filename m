Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14B926FF49
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 15:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgIRN5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 09:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgIRN5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 09:57:49 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DFAC0613CE;
        Fri, 18 Sep 2020 06:57:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s12so5718808wrw.11;
        Fri, 18 Sep 2020 06:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JyHX/3xaI4MUjJWsWpVy5PNH+Y48SlI7AjmXE8ItCY4=;
        b=HaN8UMxQ6Z/S3OwGAIcjPPmvBARR7wJZunOxgWrFCryJXlG256dWNW6qFFUqZIMwGo
         tqDc88KQ0bjbPoz+R+7iEYdJBqBqDUQvp/K1p3BTfadlR6AnjAtB6o1MWtzAnUy0HnKp
         xKbuDnLR7Pssn06GQSk5+FnxBOoYJysnDThKKIP8zm7xyM3MnITaZgmqIM0F2deB/IHF
         VeCX2GhtmcZqANVzingHDFA2s4pZo2/y1AW6ovuceejdYTwl3UMIUPsMkit+V/p17noz
         rCYL+6n/G39xQQvfcZptkXOtiSMyGM1k2MSAnR9yHFP3xxj48NmI6l3QgIbrp2WVpVkL
         MnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JyHX/3xaI4MUjJWsWpVy5PNH+Y48SlI7AjmXE8ItCY4=;
        b=UA+h5uQwK1hXOlp9/1/oaHmU/3+9ObrxTA+pAUlUAVC3JaePP7crn98MbmkZIM8QQj
         /UaaRXF5aUb1MvGYbfzgYbOrBBpEvdDydKRrS3BjLSHd01p5o0kS3YAXWVHHGklqXVFW
         QfpxUUhBmiF6VaH87wJWle3TugNqbbjTUhLvQDt/62C4HrpvP16ksf1ZbJ4NQRbpu/b5
         PsG8GA+LSSZjCCHp94VKOoiKoLpxk4XU7mFDfoXeBao9hYDMnKlQ7sAhFICzXUH5Atml
         jMt+dMVg2qdx1JUzsYo8Plj9qPVht9tQXvXeHTRLkpSIAR7Empwt++OZ2ZWydaUXxWSJ
         Sebg==
X-Gm-Message-State: AOAM5338rPNn9GLAKIqajzN3/BaBnxWKIapqKv7Zlh7WzLsyU74QNo3k
        n7FnsZ6eRtEXZSwRxwDSCbuqXDtDMWVCi2DAO9Q=
X-Google-Smtp-Source: ABdhPJwWCJ1rgPLDm+BkbE+i0k2c1DMueTOhyzwGz7zvvTROjRAdso6zbAbPEmlKLUv1f9V7qeky8Te3EfTjy2cLYZw=
X-Received: by 2002:adf:fc0a:: with SMTP id i10mr37464146wrr.111.1600437468135;
 Fri, 18 Sep 2020 06:57:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200918020110.2063155-1-sashal@kernel.org> <20200918020110.2063155-265-sashal@kernel.org>
 <DM6PR12MB26190E9DD4C2DF9CEEFAD8EFE43F0@DM6PR12MB2619.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB26190E9DD4C2DF9CEEFAD8EFE43F0@DM6PR12MB2619.namprd12.prod.outlook.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 18 Sep 2020 09:57:37 -0400
Message-ID: <CADnq5_NhURUSqBJvoYRdUEm+QukfD1bxwFihoSzc5uV4D9ijVw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 265/330] drm/amd/powerplay: try to do a
 graceful shutdown on SW CTF
To:     "Quan, Evan" <Evan.Quan@amd.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 3:17 AM Quan, Evan <Evan.Quan@amd.com> wrote:
>
> [AMD Official Use Only - Internal Distribution Only]
>
> Hi @Sasha Levin @Deucher, Alexander,
>
> The following changes need to be applied also.
> Otherwise, you may see unexpected shutdown on stress gpu loading on Vega10.
>
> drm/amd/pm: avoid false alarm due to confusing softwareshutdowntemp setting
> drm/amd/pm: correct the thermal alert temperature limit settings
> drm/amd/pm: correct Vega20 swctf limit setting
> drm/amd/pm: correct Vega12 swctf limit setting
> drm/amd/pm: correct Vega10 swctf limit setting

I would suggest we just drop this patch for kernels prior to 5.8
(where it was introduced).

Alex


>
> BR
> Evan
> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Friday, September 18, 2020 10:00 AM
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Quan, Evan <Evan.Quan@amd.com>; Deucher, Alexander <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>; dri-devel@lists.freedesktop.org
> Subject: [PATCH AUTOSEL 5.4 265/330] drm/amd/powerplay: try to do a graceful shutdown on SW CTF
>
> From: Evan Quan <evan.quan@amd.com>
>
> [ Upstream commit 9495220577416632675959caf122e968469ffd16 ]
>
> Normally this(SW CTF) should not happen. And by doing graceful shutdown we can prevent further damage.
>
> Signed-off-by: Evan Quan <evan.quan@amd.com>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  .../gpu/drm/amd/powerplay/hwmgr/smu_helper.c  | 21 +++++++++++++++----
>  drivers/gpu/drm/amd/powerplay/smu_v11_0.c     |  7 +++++++
>  2 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
> index d09690fca4520..414added3d02c 100644
> --- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
> +++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
> @@ -22,6 +22,7 @@
>   */
>
>  #include <linux/pci.h>
> +#include <linux/reboot.h>
>
>  #include "hwmgr.h"
>  #include "pp_debug.h"
> @@ -593,12 +594,18 @@ int phm_irq_process(struct amdgpu_device *adev,
>  uint32_t src_id = entry->src_id;
>
>  if (client_id == AMDGPU_IRQ_CLIENTID_LEGACY) {
> -if (src_id == VISLANDS30_IV_SRCID_CG_TSS_THERMAL_LOW_TO_HIGH)
> +if (src_id == VISLANDS30_IV_SRCID_CG_TSS_THERMAL_LOW_TO_HIGH) {
>  pr_warn("GPU over temperature range detected on PCIe %d:%d.%d!\n",
>  PCI_BUS_NUM(adev->pdev->devfn),
>  PCI_SLOT(adev->pdev->devfn),
>  PCI_FUNC(adev->pdev->devfn));
> -else if (src_id == VISLANDS30_IV_SRCID_CG_TSS_THERMAL_HIGH_TO_LOW)
> +/*
> + * SW CTF just occurred.
> + * Try to do a graceful shutdown to prevent further damage.
> + */
> +dev_emerg(adev->dev, "System is going to shutdown due to SW CTF!\n");
> +orderly_poweroff(true);
> +} else if (src_id == VISLANDS30_IV_SRCID_CG_TSS_THERMAL_HIGH_TO_LOW)
>  pr_warn("GPU under temperature range detected on PCIe %d:%d.%d!\n",
>  PCI_BUS_NUM(adev->pdev->devfn),
>  PCI_SLOT(adev->pdev->devfn),
> @@ -609,12 +616,18 @@ int phm_irq_process(struct amdgpu_device *adev,
>  PCI_SLOT(adev->pdev->devfn),
>  PCI_FUNC(adev->pdev->devfn));
>  } else if (client_id == SOC15_IH_CLIENTID_THM) {
> -if (src_id == 0)
> +if (src_id == 0) {
>  pr_warn("GPU over temperature range detected on PCIe %d:%d.%d!\n",
>  PCI_BUS_NUM(adev->pdev->devfn),
>  PCI_SLOT(adev->pdev->devfn),
>  PCI_FUNC(adev->pdev->devfn));
> -else
> +/*
> + * SW CTF just occurred.
> + * Try to do a graceful shutdown to prevent further damage.
> + */
> +dev_emerg(adev->dev, "System is going to shutdown due to SW CTF!\n");
> +orderly_poweroff(true);
> +} else
>  pr_warn("GPU under temperature range detected on PCIe %d:%d.%d!\n",
>  PCI_BUS_NUM(adev->pdev->devfn),
>  PCI_SLOT(adev->pdev->devfn),
> diff --git a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c b/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
> index c4d8c52c6b9ca..6c4405622c9bb 100644
> --- a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
> +++ b/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
> @@ -23,6 +23,7 @@
>  #include <linux/firmware.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
> +#include <linux/reboot.h>
>
>  #include "pp_debug.h"
>  #include "amdgpu.h"
> @@ -1538,6 +1539,12 @@ static int smu_v11_0_irq_process(struct amdgpu_device *adev,
>  PCI_BUS_NUM(adev->pdev->devfn),
>  PCI_SLOT(adev->pdev->devfn),
>  PCI_FUNC(adev->pdev->devfn));
> +/*
> + * SW CTF just occurred.
> + * Try to do a graceful shutdown to prevent further damage.
> + */
> +dev_emerg(adev->dev, "System is going to shutdown due to SW CTF!\n");
> +orderly_poweroff(true);
>  break;
>  case THM_11_0__SRCID__THM_DIG_THERM_H2L:
>  pr_warn("GPU under temperature range detected on PCIe %d:%d.%d!\n",
> --
> 2.25.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
