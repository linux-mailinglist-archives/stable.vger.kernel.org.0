Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5CA5B12EA
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 05:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiIHD3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 23:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiIHD3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 23:29:06 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08628C7B9B
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 20:29:04 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1225219ee46so41145288fac.2
        for <stable@vger.kernel.org>; Wed, 07 Sep 2022 20:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=iWL5Bo8vYJGNVw9v2NhY7MkNjhDtje3cmY9GoMdR1Vs=;
        b=q4Ag8s0bjzHqGngazSy+woz3ZJ4pjMluqR104ZusqiuaQWD8ZSeHCgblqoKFOy9FBk
         LiE03FXZRC+JRXNRT+WTm6eIO+olJpP9P9KnpPuPJO9LSo5EHsHTxDefi4ZlayZnqKVC
         +BScqG/tPbUQ5cUVz3gBLvDVkiTKyhoYCDqiZLoO/J60miST0ztN8pQs7zMa/zWZ5Lot
         66aSRLghzHDX6wEFXq7qEf43BalJbkfjN5hUQnJqcmXVKu3akhDqLloh2ksLoC1oGIU2
         +NlbTJzDV2TmqsmCDt51GDWkV+MYIa98A13EJW7BsKWD9iCLMgLnbp14tNddMVgQ55EI
         sdww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=iWL5Bo8vYJGNVw9v2NhY7MkNjhDtje3cmY9GoMdR1Vs=;
        b=oz8dHajEDx5pcEbKT1lP8i/fhbfMDVLpcnRPCR9HLHnnU51aVbipKWpjMYWze9cmBp
         Pi6vrtqgfF4ILT5uJnIFv+A3jAbZnQdXUf38qA+IjqTj3hf2Mi8sNbtnUZRqxpzMRebc
         nmR6rbQI4ys1ymBrnJtXai/5kv/3HOiW+WU/8OEQ08FNe1n5U72PTCqUEYAB6NIHe7mn
         1JhLtRtVhxHdyky5wG7xsd3cL0VNU9KA3hXAcwWyCiKwmpAGschTgEDB6i/jrSuByUql
         wQPi/KZhpOkgsCpkmtwlacRAiKktDiF69Jgqat3GkzvZOBwYsH9pr/0MyL6dwaYIOZ3t
         1c3Q==
X-Gm-Message-State: ACgBeo2Jbq//TS+EQlOszhnQ6sS6pizvpP3e9+kqRdPCdl9bJmiqQYf0
        Vltbid0uWC1/Ror9gv7Ja0srhKUOWh/1lxqOIXw=
X-Google-Smtp-Source: AA6agR5+nBXUWNsuk2vULsUXKsUkpqppD+vxxyiiE409vN8FNIHALinOShCaZlKl0YxxZ4syBz6CVwJGse7w5bqAefc=
X-Received: by 2002:a05:6870:738d:b0:125:1b5:420f with SMTP id
 z13-20020a056870738d00b0012501b5420fmr835126oam.96.1662607743298; Wed, 07 Sep
 2022 20:29:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220908032344.1682187-1-lijo.lazar@amd.com>
In-Reply-To: <20220908032344.1682187-1-lijo.lazar@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 7 Sep 2022 23:28:51 -0400
Message-ID: <CADnq5_MQ64piXz-CJeEn2e4yi_kwePYCea_sTxdFUAb+j8wu5Q@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: Don't enable LTR if not supported
To:     Lijo Lazar <lijo.lazar@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Alexander.Deucher@amd.com,
        wielkiegie@gmail.com, helgaas@kernel.org, stable@vger.kernel.org,
        Hawking.Zhang@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 7, 2022 at 11:24 PM Lijo Lazar <lijo.lazar@amd.com> wrote:
>
> As per PCIE Base Spec r4.0 Section 6.18
> 'Software must not enable LTR in an Endpoint unless the Root Complex
> and all intermediate Switches indicate support for LTR.'
>
> This fixes the Unsupported Request error reported through AER during
> ASPM enablement.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216455
>
> The error was unnoticed before and got visible because of the commit
> referenced below. This doesn't fix anything in the commit below, rather
> fixes the issue in amdgpu exposed by the commit. The reference is only
> to associate this commit with below one so that both go together.
>
> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
>
> Reported-by: Gustaw Smolarczyk <wielkiegie@gmail.com>
> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
> Cc: stable@vger.kernel.org
> ---

Even though the ASPM code in si.c, cik.c, and vi.c doesn't mess with
LTR, it still sets up ASPM so shouldn't it be protected with
CONFIG_PCIEASPM as well?

Alex

>  drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c | 9 ++++++++-
>  drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c | 9 ++++++++-
>  drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c | 9 ++++++++-
>  3 files changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
> index b465baa26762..aa761ff3a5fa 100644
> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
> @@ -380,6 +380,7 @@ static void nbio_v2_3_enable_aspm(struct amdgpu_device *adev,
>                 WREG32_PCIE(smnPCIE_LC_CNTL, data);
>  }
>
> +#ifdef CONFIG_PCIEASPM
>  static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
>  {
>         uint32_t def, data;
> @@ -401,9 +402,11 @@ static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
>         if (def != data)
>                 WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
>  }
> +#endif
>
>  static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
>  {
> +#ifdef CONFIG_PCIEASPM
>         uint32_t def, data;
>
>         def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
> @@ -459,7 +462,10 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
>         if (def != data)
>                 WREG32_PCIE(smnPCIE_LC_CNTL6, data);
>
> -       nbio_v2_3_program_ltr(adev);
> +       /* Don't bother about LTR if LTR is not enabled
> +        * in the path */
> +       if (adev->pdev->ltr_path)
> +               nbio_v2_3_program_ltr(adev);
>
>         def = data = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP3);
>         data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
> @@ -483,6 +489,7 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
>         data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
>         if (def != data)
>                 WREG32_PCIE(smnPCIE_LC_CNTL3, data);
> +#endif
>  }
>
>  static void nbio_v2_3_apply_lc_spc_mode_wa(struct amdgpu_device *adev)
> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
> index f7f6ddebd3e4..37615a77287b 100644
> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
> @@ -282,6 +282,7 @@ static void nbio_v6_1_init_registers(struct amdgpu_device *adev)
>                         mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
>  }
>
> +#ifdef CONFIG_PCIEASPM
>  static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
>  {
>         uint32_t def, data;
> @@ -303,9 +304,11 @@ static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
>         if (def != data)
>                 WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
>  }
> +#endif
>
>  static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
>  {
> +#ifdef CONFIG_PCIEASPM
>         uint32_t def, data;
>
>         def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
> @@ -361,7 +364,10 @@ static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
>         if (def != data)
>                 WREG32_PCIE(smnPCIE_LC_CNTL6, data);
>
> -       nbio_v6_1_program_ltr(adev);
> +       /* Don't bother about LTR if LTR is not enabled
> +        * in the path */
> +       if (adev->pdev->ltr_path)
> +               nbio_v6_1_program_ltr(adev);
>
>         def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
>         data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
> @@ -385,6 +391,7 @@ static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
>         data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
>         if (def != data)
>                 WREG32_PCIE(smnPCIE_LC_CNTL3, data);
> +#endif
>  }
>
>  const struct amdgpu_nbio_funcs nbio_v6_1_funcs = {
> diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
> index 11848d1e238b..19455a725939 100644
> --- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
> +++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
> @@ -673,6 +673,7 @@ struct amdgpu_nbio_ras nbio_v7_4_ras = {
>  };
>
>
> +#ifdef CONFIG_PCIEASPM
>  static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
>  {
>         uint32_t def, data;
> @@ -694,9 +695,11 @@ static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
>         if (def != data)
>                 WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
>  }
> +#endif
>
>  static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
>  {
> +#ifdef CONFIG_PCIEASPM
>         uint32_t def, data;
>
>         if (adev->ip_versions[NBIO_HWIP][0] == IP_VERSION(7, 4, 4))
> @@ -755,7 +758,10 @@ static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
>         if (def != data)
>                 WREG32_PCIE(smnPCIE_LC_CNTL6, data);
>
> -       nbio_v7_4_program_ltr(adev);
> +       /* Don't bother about LTR if LTR is not enabled
> +        * in the path */
> +       if (adev->pdev->ltr_path)
> +               nbio_v7_4_program_ltr(adev);
>
>         def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
>         data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
> @@ -779,6 +785,7 @@ static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
>         data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
>         if (def != data)
>                 WREG32_PCIE(smnPCIE_LC_CNTL3, data);
> +#endif
>  }
>
>  const struct amdgpu_nbio_funcs nbio_v7_4_funcs = {
> --
> 2.25.1
>
