Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E9456988B
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 05:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiGGDBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 23:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234957AbiGGDBh (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 6 Jul 2022 23:01:37 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAF12F669
        for <Stable@vger.kernel.org>; Wed,  6 Jul 2022 20:01:35 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dn9so24835297ejc.7
        for <Stable@vger.kernel.org>; Wed, 06 Jul 2022 20:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KpPHVF1nfIeVtEHZNbPLRqXXa3Dp4YpbMkHQTFDRuUo=;
        b=J9e7SAvUCUkGd6931X1OEIC5+60UPxzm21JoMh48KVXhwqQgWyZ9wu6D7eDmPPDcAS
         p41O5ciwHSgI/T4zpoxBb5aDZKLdelyPn4F5ljPPvQw2s+H8HPyhXf2/LvqySPp2dnDK
         w346k5oIfA5hJ9TrEIuFBfmsbIY9vsnzInLIz1WjvAe38eLVRvRnh3cUIYSrO0cLCix2
         HUtrqvVcl34Mw97VDg3+39dVeeiVkrXXXJdI88PlE8wmbF3tzwESJYXLmlIlaq9UfaUL
         WzhSbdgiHcrb+KjI9QtbAg9kK5QU6nlnesKlAOgKxOrk7CokjhqEvhmokeykqRcRwQxh
         mhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KpPHVF1nfIeVtEHZNbPLRqXXa3Dp4YpbMkHQTFDRuUo=;
        b=NRlPsKqmyet687RQhZf8zpC4mm9mPb77z8RhAQoT3Jhp3JEi/cK4Q+2auAZOUISnD6
         H/hlJkO5JzDDgNGI+ytlEnMmexjwJ3KYYxPXRuyG2s31c6J61ckk+GbYoJKaIiepOoSD
         ZTDRzY8aZtDh5NTrG+YY4TPnKfp4RPGicpheQRQelj15ijXhWSHNOUiBzNBKXHqQfFdz
         +w6JEKssqRjYgFhiDERDgXJarkyd+YUFh7UcMyvqLZxdqw8qVhH8a7tzN2AybbYNruTJ
         X2tKoYMRNGc/wK+Zk6Djm/DZi8DOMWzR9nqYJYZrb2sLpePyInO4n8qNC+q9pm0axCTf
         Kfsg==
X-Gm-Message-State: AJIora8EH3evJrFYbLyMPXYUJzxfx4fD13mwfcTJ64UQFUnA2rLJJweD
        q/XqtH8tH4ZY9x1/Hiu0rkCH9gK8qHxBobtZh1/+Qh6BXKQ=
X-Google-Smtp-Source: AGRyM1vODdBJq8KNJdTZSUSjqm0nrDPUaTiK1pGT1+dx84E4uwwjm0XH0jrQSF32WXUUfHL5HEhUsPX50jrcliA2T20=
X-Received: by 2002:a17:907:d22:b0:726:dbb1:8828 with SMTP id
 gn34-20020a1709070d2200b00726dbb18828mr43421645ejc.722.1657162893654; Wed, 06
 Jul 2022 20:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220707024531.90263-1-evan.quan@amd.com>
In-Reply-To: <20220707024531.90263-1-evan.quan@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 6 Jul 2022 23:01:21 -0400
Message-ID: <CADnq5_Mv2iwJK2035-8dU6-7jhZpyAFsrK5veK5coUpZRuRXFw@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: correct idle_power_optimizations
 disablement return value
To:     Evan Quan <evan.quan@amd.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Aurabindo Pillai <Aurabindo.Pillai@amd.com>,
        "for 3.8" <Stable@vger.kernel.org>
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

On Wed, Jul 6, 2022 at 10:46 PM Evan Quan <evan.quan@amd.com> wrote:
>
> [Why]
> The return value indicates whether the operation(disable/enable) succeeded
> or not. The existing logic reports wrong result even if the disablement was
> performed successfully. That will make succeeding reenablement abandoned
> as dc->idle_optimizations_allowed is always true.
>
> [How]
> Correct the return value to reflect the real result of disablement.
>
> Fixes: e40fcd4a ("drm/amd/display: add DCN32/321 specific files for Display Core")

Need 12 places for the git hash:
Fixes: 235c67634230 ("drm/amd/display: add DCN32/321 specific files
for Display Core")

> Cc: <Stable@vger.kernel.org>

This doesn't need to go to stable.  These changes are queued up for 5.20.

Patch is:
Acked-by: Alex Deucher <alexander.deucher@amd.com>

> Signed-off-by: Evan Quan <evan.quan@amd.com>
> Change-Id: If87d4cf76f6cfb36d607f051ff32f9c7870b4d6d
> ---
>  drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
> index d53cbfef3558..1acd74fa4e55 100644
> --- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
> +++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
> @@ -373,7 +373,7 @@ bool dcn32_apply_idle_power_optimizations(struct dc *dc, bool enable)
>         dc_dmub_srv_cmd_execute(dc->ctx->dmub_srv);
>         dc_dmub_srv_wait_idle(dc->ctx->dmub_srv);
>
> -       return false;
> +       return true;
>  }
>
>  /* Send DMCUB message with SubVP pipe info
> --
> 2.29.0
>
