Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB1950FFBF
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 15:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240014AbiDZN7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 09:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351298AbiDZN6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 09:58:53 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CD615F581
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 06:55:45 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id e12so4242707ybc.11
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 06:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uBWTMy19BCU8GJLOpBmlkiJHgnhETyOqG4xsK78wLxQ=;
        b=y0qlk5Wop1rWL3gXkgBl5O9PjeYqAiQ1ig5/DeQlJRMziLwwYQx+LkfhDm+OGi+g9j
         7oliRUhScsahDl34Eu1Fa2j59Y8ajc/Vhlir2Y7/aPAFoB67qyf+oqHDK1XZ2UVaQNlw
         sr0RkEERg55+T9vK0IZlgRpc6eSXLnVnM291eRkpVjMG3Z0VLQR9eTKNxCaKdALs5NFO
         hBhWH+3ZRcXKKK1sultcqu8lbZ7aCzaRdi1IzAjb3TqCebP5VSiWhG6+vmvI6J4przib
         ASXHvVFfO5rMIdh1GlBR0Q1uYleb+NKjAVVfkERYhkI039Egka5l45WNe6gJpXbgkXQt
         rCuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uBWTMy19BCU8GJLOpBmlkiJHgnhETyOqG4xsK78wLxQ=;
        b=otT7EMui+CEp4uYL7uOzYOjeJgTr+GrXLlheCsRIK8j75bKopyG08IDQj23tzEGLZb
         SxzJx50S59e5jJQ+t+pkqC+hkU5H5suxyXjaIcS+HZ9ubaehWc023//KFXrGOX4Wq5Kl
         7TKhlHq6sjG30paYfTZFISJiZcxwHnLm/ScyDV/VifXuzNCPkx3LF91eN/wllc3ZHlUz
         lRlgofay0ANHJ/ilbFROyEqAWzJtXBu0wIMqIsUhtd+6/iaCJCeKltxAONHlTWzFnmw1
         8ccQ7LjlydgMVX4lgjjvn0tWK706bUpgHLTFzL1AsiddDvBvPRtY3WhvGYP2tVsxnHrj
         NtDA==
X-Gm-Message-State: AOAM533vnv84gecN/EQhLcqlL0pyxTwV7o7uIxDDQ6/xGQ9p35dXUM47
        lR29KIw2JFq+oNOiGVKcqGFtFHe3/dBEoQCE2jsCyg==
X-Google-Smtp-Source: ABdhPJw92iLZ8A8h//KsmSd7zk7HfXV1sN9OJS8uxSz8+RRspq25GOq/lPymHBG1FtpLpzP8LuhhvxTuI+IgUuTf+0M=
X-Received: by 2002:a05:6902:8c:b0:631:ef56:6694 with SMTP id
 h12-20020a056902008c00b00631ef566694mr20679552ybs.194.1650981344539; Tue, 26
 Apr 2022 06:55:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220423221623.1074556-1-huobean@gmail.com> <20220423221623.1074556-3-huobean@gmail.com>
In-Reply-To: <20220423221623.1074556-3-huobean@gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 26 Apr 2022 15:55:08 +0200
Message-ID: <CAPDyKFrksB_kgrnmcay+ub0nDfmPVZfw-zJihop5N8_6qUqrug@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mmc: core: Allows to override the timeout value
 for ioctl() path
To:     Bean Huo <huobean@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     adrian.hunter@intel.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, beanhuo@micron.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 24 Apr 2022 at 00:16, Bean Huo <huobean@gmail.com> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> Occasionally, user-land applications initiate longer timeout values for certain commands
> through ioctl() system call. But so far we are still using a fixed timeout of 10 seconds
> in mmc_poll_for_busy() on the ioctl() path, even if a custom timeout is specified in the
> userspace application. This patch allows custom timeout values to override this default
> timeout values on the ioctl path.
>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Applied for next, thanks!

Linus, I interpreted your earlier reply as a reviewed-by tag, so I
have added that. Please tell me, if you want me to drop it.

Kind regards
Uffe


> ---
>  drivers/mmc/core/block.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index b35e7a95798b..6cb701aa1abc 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -609,11 +609,11 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
>
>         if (idata->rpmb || (cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
>                 /*
> -                * Ensure RPMB/R1B command has completed by polling CMD13
> -                * "Send Status".
> +                * Ensure RPMB/R1B command has completed by polling CMD13 "Send Status". Here we
> +                * allow to override the default timeout value if a custom timeout is specified.
>                  */
> -               err = mmc_poll_for_busy(card, MMC_BLK_TIMEOUT_MS, false,
> -                                       MMC_BUSY_IO);
> +               err = mmc_poll_for_busy(card, idata->ic.cmd_timeout_ms ? : MMC_BLK_TIMEOUT_MS,
> +                                       false, MMC_BUSY_IO);
>         }
>
>         return err;
> --
> 2.34.1
>
