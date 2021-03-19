Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E84341F06
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 15:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhCSOKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 10:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhCSOKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 10:10:33 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC40C06175F
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 07:10:33 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id f11so2117709vkl.9
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 07:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R+2pClJKNrDjC0jJNOAgxtn3SS7+pbCOoKqmxQWs/Zg=;
        b=F1TVWoNN0IFWz9G5oqbkL0k5aGfTPkdeVBxEYg4MnZjKcTYVkWmGPxlDKx9QFMbd/a
         W29zPnHyeumYQPQI3m86w1ZOmKeD6VVmjjbnEvtwM5Zyendc8vVAWys2D3Oo2vp69N67
         ZkBJVHlQW8GI//oqDQE4BWvyuz1DkfvBiL7X1ygRaCQudOKCcrUfGBCVczd20hNbPctD
         rYzkmYJR1R/J/cTB+UilIg9bj7TAC3MZ+gtEDz1Puiv320HLCnr2vag06E9w2KV5AEoV
         +RzucoSt2YZedRFNVGDClg9sgmJiTGs5KnzIT5dqrRYUHBeFVPNVK0WH26Nofq+9jHpR
         Nvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R+2pClJKNrDjC0jJNOAgxtn3SS7+pbCOoKqmxQWs/Zg=;
        b=NojQ8KedYjGuw7JKAGWRvT61++MusSmhRuoUfbhV2R+eON2UFHjLuNflnzb97waM/M
         YSMmwrCKbkSOnbGuVHknvRewFC6gJWxEpZNX4JwREqrebfcbSNDlMstNyEscXEnakTeu
         pe7D/xeNUBqKCSJB5WWoIf+Rr7H5aw8u4WztVJtYktS3A2mlKHqCxuemSsWynMuIO8Nf
         FquaRqcrn4nxni+8bSDWPPJ79JsuGIIzOzBjF6owPUxIgBeHR46C/GZIO1Quzz4Z8x68
         ts4GLDhOQRq3ntRQwpgVlUjAHyrTI9iDsuZt6rSjliGravJOPd1Ycw1NVT8SUZrvTFPX
         k5og==
X-Gm-Message-State: AOAM532SLsrvdPYwnRCT+svMvS/G2KhBur51+PRcirJFtE7JLAKqO5Dm
        lPeAjyjrHFZ5TWt4kRFvxgFYgzPR8g0CUzwSg0KGGw==
X-Google-Smtp-Source: ABdhPJya1hVWD+5DJP5ed50sVNI7Btnb6+n4XM9kubcFDzzapxLfg1ql04vWdxhGFQKqYert8HlYu3HUGuo2gDnOUI0=
X-Received: by 2002:a05:6122:11a6:: with SMTP id y6mr2699063vkn.6.1616163032596;
 Fri, 19 Mar 2021 07:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210319121357.255176-1-huobean@gmail.com> <20210319121357.255176-3-huobean@gmail.com>
In-Reply-To: <20210319121357.255176-3-huobean@gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 19 Mar 2021 15:09:55 +0100
Message-ID: <CAPDyKFrU591aeH5GyuuQW8tPeNc9wav=t8wqF1EdTBbCc9xheg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mmc: cavium: Remove redundant if-statement checkup
To:     Bean Huo <huobean@gmail.com>
Cc:     rric@kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Mar 2021 at 13:14, Bean Huo <huobean@gmail.com> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> Currently, we have two ways to issue multiple-block read/write the
> command to the eMMC. One is by normal IO request path fs->block->mmc.
> Another one is that we can issue multiple-block read/write through
> MMC ioctl interface. For the first path, mrq->stop, and mrq->stop->opcode
> will be initialized in mmc_blk_data_prep(). However, for the second IO
> path, mrq->stop is not initialized since it is a pre-defined multiple
> blocks read/write.

As a matter of fact this way is also supported for the regular block
I/O path. To make the mmc block driver to use it, mmc host drivers
need to announce that it's supported by setting MMC_CAP_CMD23.

It looks like that is what your patch should be targeted towards, can
you have a look at this instead?

Kind regards
Uffe

>
> Meanwhile, if it is open-ended multiple block read/write command,
> STOP_TRANSMISSION CMD12 will be issued later in mmc_blk_issue_drv_op(),
> since it is MMC_IOC_MULTI_CMD.
>
> So, delete these if-statement checkups, let these kinds of multiple-block
> read/write request go.
>
> Fixes 'ba3869ff32e4 ("mmc: cavium: Add core MMC driver for Cavium SOCs")'
> Cc: stable@vger.kernel.org
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/mmc/host/cavium.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/cavium.c b/drivers/mmc/host/cavium.c
> index 95a41983c6c0..8fb7cbcf62ad 100644
> --- a/drivers/mmc/host/cavium.c
> +++ b/drivers/mmc/host/cavium.c
> @@ -654,8 +654,7 @@ static void cvm_mmc_dma_request(struct mmc_host *mmc,
>         struct mmc_data *data;
>         u64 emm_dma, addr;
>
> -       if (!mrq->data || !mrq->data->sg || !mrq->data->sg_len ||
> -           !mrq->stop || mrq->stop->opcode != MMC_STOP_TRANSMISSION) {
> +       if (!mrq->data || !mrq->data->sg || !mrq->data->sg_len) {
>                 dev_err(&mmc->card->dev, "Error: %s no data\n", __func__);
>                 goto error;
>         }
> --
> 2.25.1
>
