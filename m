Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E414C4DB59E
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344785AbiCPQI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343865AbiCPQI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:08:58 -0400
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C68E6006F;
        Wed, 16 Mar 2022 09:07:43 -0700 (PDT)
Received: by mail-qk1-f175.google.com with SMTP id g8so2253476qke.2;
        Wed, 16 Mar 2022 09:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3kQi/ATz8vXUZ8yEbTxILdWl+W/EazBouregaIRmudw=;
        b=zH6HSMbLokaaI4W5CrJVgrJsrUGiuwlM/WIS1wLB2JFZUCc337J+nApRrsMmGRXnMh
         s57C4FO+9dAyP3WA0vYUt0DOwvU5wBgWLDPcM/EElEgYzAQnFl7jYOm3XuJR0HIJBuvS
         AgSZTLmHqNtWvdqCbT8N1tQ9JE66ftpl/WvqjbRGkoqHUeMBnxj0lgXCmJo8aSfBrwed
         9Bnumu3AdKQc2wV91rHL1NJoVzGNJlIC78g82Mg7hAVNPftewaixOeyWyYdrgwkrvVtz
         mCrg8/6SYJ/Wo99/f6E4paNOF6PeOYrkNKnXwyZ8h1VVPt4rqQ3wT1xfeZp14MZPAcV3
         x4cA==
X-Gm-Message-State: AOAM530xfhnh4U5Lwg6dOJO+V2Nbqx3lbAXJfWTAlxklb+DIm4X1dyW1
        etMJL8+8hoHbaa8LJe+AU+N7QUtflwqfrw==
X-Google-Smtp-Source: ABdhPJxzJ5J1YB0KYzMUusjiJwklstERWjnbu4Y+blpzMppdSnLNkCUp1Hf3QxbYf4OA7bUL080HRg==
X-Received: by 2002:a37:68d0:0:b0:67b:3c3c:eeaa with SMTP id d199-20020a3768d0000000b0067b3c3ceeaamr389583qkc.616.1647446862155;
        Wed, 16 Mar 2022 09:07:42 -0700 (PDT)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id s64-20020a375e43000000b0067b0e68092csm1106455qkb.91.2022.03.16.09.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 09:07:42 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2db2add4516so29105987b3.1;
        Wed, 16 Mar 2022 09:07:40 -0700 (PDT)
X-Received: by 2002:a81:618b:0:b0:2db:d952:8a39 with SMTP id
 v133-20020a81618b000000b002dbd9528a39mr936600ywb.132.1647446859767; Wed, 16
 Mar 2022 09:07:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220316141354.247750-1-sashal@kernel.org> <20220316141354.247750-12-sashal@kernel.org>
In-Reply-To: <20220316141354.247750-12-sashal@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 16 Mar 2022 17:07:28 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVtGb6LCTbDKo9vn=1MmP+RZJTe2=VNTtrNsPa-=1Q6zA@mail.gmail.com>
Message-ID: <CAMuHMdVtGb6LCTbDKo9vn=1MmP+RZJTe2=VNTtrNsPa-=1Q6zA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.16 12/13] spi: Fix invalid sgs value
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Mark Brown <broonie@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Wed, Mar 16, 2022 at 3:15 PM Sasha Levin <sashal@kernel.org> wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
>
> [ Upstream commit 1a4e53d2fc4f68aa654ad96d13ad042e1a8e8a7d ]

This commit is not 100% correct, cfr.
https://lore.kernel.org/lkml/CAHk-=wiZnS6n1ROQg3FHd=bcVTHi-sKutKT+toiViQEH47ZACg@mail.gmail.com
Please postpone backporting until the issue has been resolved.

>
> max_seg_size is unsigned int and it can have a value up to 2^32
> (for eg:-RZ_DMAC driver sets dma_set_max_seg_size as U32_MAX)
> When this value is used in min_t() as an integer type, it becomes
> -1 and the value of sgs becomes 0.
>
> Fix this issue by replacing the 'int' data type with 'unsigned int'
> in min_t().
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Link: https://lore.kernel.org/r/20220307184843.9994-1-biju.das.jz@bp.renesas.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/spi/spi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 8ba87b7f8f1a..ed4e6983eda0 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -1021,10 +1021,10 @@ int spi_map_buf(struct spi_controller *ctlr, struct device *dev,
>         int i, ret;
>
>         if (vmalloced_buf || kmap_buf) {
> -               desc_len = min_t(int, max_seg_size, PAGE_SIZE);
> +               desc_len = min_t(unsigned int, max_seg_size, PAGE_SIZE);
>                 sgs = DIV_ROUND_UP(len + offset_in_page(buf), desc_len);
>         } else if (virt_addr_valid(buf)) {
> -               desc_len = min_t(int, max_seg_size, ctlr->max_dma_len);
> +               desc_len = min_t(unsigned int, max_seg_size, ctlr->max_dma_len);
>                 sgs = DIV_ROUND_UP(len, desc_len);
>         } else {
>                 return -EINVAL;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
