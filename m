Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98BD29864C
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 06:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766820AbgJZFNk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 26 Oct 2020 01:13:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41149 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1766817AbgJZFNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 01:13:40 -0400
Received: from mail-pf1-f199.google.com ([209.85.210.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kWup7-0007hi-Dk
        for stable@vger.kernel.org; Mon, 26 Oct 2020 05:13:37 +0000
Received: by mail-pf1-f199.google.com with SMTP id a27so4960279pfl.17
        for <stable@vger.kernel.org>; Sun, 25 Oct 2020 22:13:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/Hat/sfTBDPDMcXjee5mGekZGwjQRAeCYkWueJk0PdQ=;
        b=AWUCP6Meqxq0gfXQGlI9hSHPzE7I0B1FJ9/1aeZVKtPf9utAHnP47pwW7v8Jey7V2Z
         HpSNhpHH+VFTmnkSdDao/7VkgfsUHbJj3qVQpA7VYxa7z+Hx5a33DdUDf6pGKqBdWXlf
         CZZXw6kM1OQd35j9b+WmsHiOmogPJlLcaI2VurFP14mWlcyF+Lhgv0VdOOxa8KH1oO5n
         UIfCI+o7C99X3PPInr1PFy3ieKRlc1HVWLRdgzZS62BQy8kCD+rJyt0oU2zOLug8fUFt
         AAuiPPUEQ/iZeMTqFE5ziOxONQxLm6BDS8XNWJw6kZUiS3TnvjPnawuZqXv6mOXuxpEY
         qJBg==
X-Gm-Message-State: AOAM5321IYFrgaI21GSopgy0eBTHs7MaR5hpawyttfloxjrgucl37AID
        zovsSPa8prX/+pUYRQZBCcM+2oLTV5utSMyXdfBY01YBQJ717xXEj0jVJ7vspcOeablZvBMKE63
        1Cqiy3FRgQwLa9g1LBRZPy3NFknrLbhYpeA==
X-Received: by 2002:a17:902:bd48:b029:d2:8ce7:2d4c with SMTP id b8-20020a170902bd48b02900d28ce72d4cmr8246081plx.42.1603689215579;
        Sun, 25 Oct 2020 22:13:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdZGHsDkkCPDw3F/gmGuawTjwbyGqOWLQNF+wfC1ju1QtqBMlFFcEXCERdXlJljWFGsccpew==
X-Received: by 2002:a17:902:bd48:b029:d2:8ce7:2d4c with SMTP id b8-20020a170902bd48b02900d28ce72d4cmr8246060plx.42.1603689215261;
        Sun, 25 Oct 2020 22:13:35 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id u7sm10501907pfn.37.2020.10.25.22.13.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Oct 2020 22:13:34 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: Patch "drm/radeon: Prefer lower feedback dividers" has been added
 to the 5.9-stable tree
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20201026050946.9E8B6223FD@mail.kernel.org>
Date:   Mon, 26 Oct 2020 13:13:28 +0800
Cc:     stable-commits@vger.kernel.org,
        linux-stable <stable@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C64F56FE-C10A-4F1B-B80C-2F0634E79222@canonical.com>
References: <20201026050946.9E8B6223FD@mail.kernel.org>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

> On Oct 26, 2020, at 13:09, Sasha Levin <sashal@kernel.org> wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>    drm/radeon: Prefer lower feedback dividers
> 
> to the 5.9-stable tree which can be found at:
>    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>     drm-radeon-prefer-lower-feedback-dividers.patch
> and it can be found in the queue-5.9 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Please drop this patch because it causes some regression.

Kai-Heng

> 
> 
> 
> commit 3fa04dfbb55a95e7c6075d0644f64bcb6e7f4ef8
> Author: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Date:   Wed Aug 26 01:33:48 2020 +0800
> 
>    drm/radeon: Prefer lower feedback dividers
> 
>    [ Upstream commit 5150dd85bdfa08143cacf1b4249121651bed3c35 ]
> 
>    Commit 2e26ccb119bd ("drm/radeon: prefer lower reference dividers")
>    fixed screen flicker for HP Compaq nx9420 but breaks other laptops like
>    Asus X50SL.
> 
>    Turns out we also need to favor lower feedback dividers.
> 
>    Users confirmed this change fixes the regression and doesn't regress the
>    original fix.
> 
>    Fixes: 2e26ccb119bd ("drm/radeon: prefer lower reference dividers")
>    BugLink: https://bugs.launchpad.net/bugs/1791312
>    BugLink: https://bugs.launchpad.net/bugs/1861554
>    Reviewed-by: Christian König <christian.koenig@amd.com>
>    Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>    Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
> index e0ae911ef427d..7b69d6dfe44a3 100644
> --- a/drivers/gpu/drm/radeon/radeon_display.c
> +++ b/drivers/gpu/drm/radeon/radeon_display.c
> @@ -933,7 +933,7 @@ static void avivo_get_fb_ref_div(unsigned nom, unsigned den, unsigned post_div,
> 
> 	/* get matching reference and feedback divider */
> 	*ref_div = min(max(den/post_div, 1u), ref_div_max);
> -	*fb_div = DIV_ROUND_CLOSEST(nom * *ref_div * post_div, den);
> +	*fb_div = max(nom * *ref_div * post_div / den, 1u);
> 
> 	/* limit fb divider to its maximum */
> 	if (*fb_div > fb_div_max) {

