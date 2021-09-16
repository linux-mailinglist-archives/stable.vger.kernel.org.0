Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6648E40E8FD
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345668AbhIPRpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350208AbhIPRnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 13:43:45 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB85C08ED7F
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 09:24:37 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i25so21033080lfg.6
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 09:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uCbvTsHrDfqrbHo7IDUZ1BawMYMw+OHW2eckD6leFrw=;
        b=SKdjY5FEaQ0GqG9e7SUgo3EJSdJ9cBYQfxQTaKIHYZlyV4GZikhSGj/4oOjIDWk5Wb
         Edk0aD9yZxW1Ze/5veona7v7EhD0rk69CslNznNbGzx61hz2Pnu82abABw8+gqdSHsoT
         geqFzAv+UZ+DCqHZE2jBeRQkVdl1JC5M9HYZ73S/dwMHkj8W+elzP9reXkaAQm5L8aRK
         woMVia+kvmYjfmJnGUoYgxOT+SNPICULOARPEM3WmqSK5XZdr0ZwtEFcT64NtSoGNBYc
         LS/a03kc0rRbDgV+YeV/gf6C3oBkmriTLlTZzXCedGAMrtxGX30oMRzS90xOUopFT6P/
         M5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uCbvTsHrDfqrbHo7IDUZ1BawMYMw+OHW2eckD6leFrw=;
        b=4mm3pRG6680EmK42heHyUSk/wnzBN6SWN12vmORJNS7F6QiE5Z0Y4weJE6N1AVPoNW
         D7HqyWQkaa/3BLFfDcMw2a0kDOwwpeeif1dWpLH42PlwBj/z3VgvdQ6zALkTDPRhcK1X
         CzUguLUG/QWESQdvL3fcVOOdsJ5JeMSRQLwpycn2ImLPTcNru+Z0wS/PmKZK21R1oEzo
         bL7AE1x5X+oOQZR084DASvX7/q93IIusfkBYcNP/cXpO5pVAU+FLq0tMcSGsTAJAZpnz
         ed/5/LlS6WcubN8wFg/LfGn9GQlnRHQVZmpPuZQkbA96h/tJxjXLcHITofMZdph4BOww
         NZbA==
X-Gm-Message-State: AOAM533sVFvRU8OuXiULNuu2nm2RwIEAYb8mJZjybDuJlbDhGY8UQC+R
        tDt3Cx0QbY6GLuS73snRdQd44cwsCx5o0YotHRI=
X-Google-Smtp-Source: ABdhPJytnDVsosxCMngJE5yp0mRR8F94qT0u4e2mWXWm3g/0VWW/3nL+Ga0NESVIvac7i3Nkv2XPSJi9VgDnP2OqOq4=
X-Received: by 2002:ac2:5d49:: with SMTP id w9mr4596739lfd.450.1631809476327;
 Thu, 16 Sep 2021 09:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210914174831.2044420-1-festevam@gmail.com> <96038e06b1141ad3348611a25544356e@codeaurora.org>
 <CAOMZO5BzU3_x7nb8sEF_NDeDOxYM0bQLEpbRzv39jayX=fudYg@mail.gmail.com> <5409ccef7ee4359d070eed3acd955590@codeaurora.org>
In-Reply-To: <5409ccef7ee4359d070eed3acd955590@codeaurora.org>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 16 Sep 2021 13:24:25 -0300
Message-ID: <CAOMZO5CgFFmKmKF0C_1okmu7N24=udevT3LE=0bRoZqUeDQSWg@mail.gmail.com>
Subject: Re: [Freedreno] [PATCH] drm/msm: Do not run snapshot on non-DPU devices
To:     abhinavk@codeaurora.org
Cc:     Rob Clark <robdclark@gmail.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "open list:DRM DRIVER FOR MSM ADRENO GPU" 
        <freedreno@lists.freedesktop.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Abhinav,

On Thu, Sep 16, 2021 at 1:15 PM <abhinavk@codeaurora.org> wrote:
>
> Hi Fabio
>
> Thanks for confirming.
>
> Although I have no issues with your change, I am curious why even msm is
> probing and/or binding.
> Your device tree should not be having any mdp/dpu nodes then.

The i.MX53 does have the following GPU node:

compatible = "amd,imageon-200.0", "amd,imageon";

That's why it probes the msm driver.

However, i.MX53 does not have any of the Qualcomm display controllers.

It uses the i.MX IPU display controller instead.

Hope that clarifies.

Please reply with a Reviewed-by if you are happy with my fix.

Thanks
