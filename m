Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F354474B1
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 18:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbhKGRqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 12:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236012AbhKGRqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 12:46:51 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12915C061714
        for <stable@vger.kernel.org>; Sun,  7 Nov 2021 09:44:09 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u11so14320387plf.3
        for <stable@vger.kernel.org>; Sun, 07 Nov 2021 09:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xjl9+CEP43AsYHfS7KL6O6N3m1KhqAGplZ+XQFg3jQo=;
        b=YWgefyqzxxBD3rlgz3CG3XU0eq36CTeZVt//aHpCohfr2fHrU6xTlvDRaBnWh0bbPT
         PxrI7M/8IWvYBznnoAIo8IKWUMVES0sQDjR5772kxkrTs03I+VEcttQh5UGSJKibWImf
         /Ezx8ZN/hI72TV1W3NVEZfyc2bKX8wF1AJ8mPdtFXlgiSSzkfEdeQNjq7bQLYnTqz5km
         wIqrKtgFVk0s5BwVw5K99KC8e0oag8BDBUfFq7n7ymT7UkPuOiD1xkfCM10F+DN4ILFY
         pLBoVne4VcRixznWYrhdy+4zRDOTbkfVR647aWPF4dVzPIvN/cRTN2Ko/2XPNpr/i36K
         US5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xjl9+CEP43AsYHfS7KL6O6N3m1KhqAGplZ+XQFg3jQo=;
        b=f5MohuM4l4mJ4bO5HHZ9+fn7tvL2MYOWrpkq5uKY3gf4qhcFdqKtjd9rNKuEV4iOTl
         KTVR6prxsaio+KoQ0reqFHwKfp2rLgWQVcehTTPncDHfT2zEGrY99dCuhAvwPaiAJ/dT
         QJ27S8SYsCnZS40XlQbwwehDin2q0bTGxx1aIaoJmZQB8C1l3A62EqamyVF35yHEmO1m
         2PXWFO4bjM1wVc+eyPHYjvaQsLXxP8zyLMUU59V6duOOWUurgc6XXcMHCxZ2QceBXqJz
         BHvRKzjZnkkiabQXOfQ00L0Uf3gFRaPpuaLNZk60Mhg6rWKEBYLqiQYMvOsMIb+mp3bn
         22NQ==
X-Gm-Message-State: AOAM5303Hs4sR10UesOm7xKh34x/+lPm1x+l8jdCD+DC9rT/kbSVLHKR
        nZHGWbJjHtald3MjM/IQ/yeq8C7G7TWolggd2R21Ag==
X-Google-Smtp-Source: ABdhPJxINONf55fxJqdllPtpzr8XTcFEY4Av/x9s8kcehhAWTNeEb7kHflA42J/sEDupZtwyCOKhgDCJakICmgVRxMo=
X-Received: by 2002:a17:902:934c:b0:13d:c685:229b with SMTP id
 g12-20020a170902934c00b0013dc685229bmr64444159plp.25.1636307048598; Sun, 07
 Nov 2021 09:44:08 -0800 (PST)
MIME-Version: 1.0
References: <20211107173543.7486-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20211107173543.7486-1-Larry.Finger@lwfinger.net>
From:   Phillip Potter <phil@philpotter.co.uk>
Date:   Sun, 7 Nov 2021 17:43:57 +0000
Message-ID: <CAA=Fs0mCkY4_5PJg++EWDcJaaTPjN6q3d6o2ZU_ZW4HBDPU4XA@mail.gmail.com>
Subject: Re: [PATCH v2] staging: r8188eu: Fix breakage introduced when 5G code
 was removed
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <linux-staging@lists.linux.dev>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zameer Manji <zmanji@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 7 Nov 2021 at 17:35, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> In commit 221abd4d478a ("staging: r8188eu: Remove no more necessary definitions
> and code"), two entries were removed from RTW_ChannelPlanMap[], but not replaced
> with zeros. The position within this table is important, thus the patch broke
> systems operating in regulatory domains osted later than entry 0x13 in the table.
> Unfortunately, the FCC entry comes before that point and most testers did not see
> this problem.
>
> Reported-and-tested-by: Zameer Manji <zmanji@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 221abd4d478a ("staging: r8188eu: Remove no more necessary definitions and code")
> Cc: Stable <stable@vger.kernel.org> # v5.5+
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> v2 - fixed use of () rsther than {} - found by kernel test robot
> ---
>  drivers/staging/r8188eu/core/rtw_mlme_ext.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/staging/r8188eu/core/rtw_mlme_ext.c b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
> index 55c3d4a6faeb..5b60e6df5f87 100644
> --- a/drivers/staging/r8188eu/core/rtw_mlme_ext.c
> +++ b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
> @@ -107,6 +107,7 @@ static struct rt_channel_plan_map   RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
>         {0x01}, /* 0x10, RT_CHANNEL_DOMAIN_JAPAN */
>         {0x02}, /* 0x11, RT_CHANNEL_DOMAIN_FCC_NO_DFS */
>         {0x01}, /* 0x12, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
> +       {0x00}, /* 0x13 */
>         {0x02}, /* 0x14, RT_CHANNEL_DOMAIN_TAIWAN_NO_DFS */
>         {0x00}, /* 0x15, RT_CHANNEL_DOMAIN_ETSI_NO_DFS */
>         {0x00}, /* 0x16, RT_CHANNEL_DOMAIN_KOREA_NO_DFS */
> @@ -118,6 +119,7 @@ static struct rt_channel_plan_map   RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
>         {0x00}, /* 0x1C, */
>         {0x00}, /* 0x1D, */
>         {0x00}, /* 0x1E, */
> +       {0x00}, /* 0x1F, */
>         /*  0x20 ~ 0x7F , New Define ===== */
>         {0x00}, /* 0x20, RT_CHANNEL_DOMAIN_WORLD_NULL */
>         {0x01}, /* 0x21, RT_CHANNEL_DOMAIN_ETSI1_NULL */
> --
> 2.33.1
>

Reviewed-by: Phillip Potter <phil@philpotter.co.uk>

Regards,
Phil
