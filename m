Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44B64E79AB
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 18:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377219AbiCYRKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 13:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377181AbiCYRKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 13:10:21 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F378739143
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 10:08:46 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id c15so11119326ljr.9
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 10:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZFrF+CYFOvKN03TIvF3ZR0fRymyFsHP8W7IC0SeXaOA=;
        b=ZNljRmXlUlUpPFGYZ9zvl1HpJ/Em2ll596NnZlMJTJcCHoosozlSd9njUDjHUlWWrM
         kzWUYvR+IfjdRsOMVi1Zrzz2U18ctTdACdFwXxUeClRwbuRAqxvxlKavqgR8qM7pDqgO
         QSNiqmcmyCq7O9WUtSK8KTyLFyoCZNnO9IZ+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZFrF+CYFOvKN03TIvF3ZR0fRymyFsHP8W7IC0SeXaOA=;
        b=N7qQh377zeNYb/OHBhHZwLH61ouNqX9j7r1U5wqqQwrwAe5oCC4HON/l/0dCUX2eUA
         Fs3IStFlBP6bd37ueY27OJ/dYqw5yT+ggtSUdnA89CnT6CKkl47cpVoeWANgdzuqMj5+
         SM32t34c+LYqg/vDPHMpkvbcElEwjFY8bVPAVL9pT/R3BPTEMrnSy2nDXhkO69RZejcB
         DZynpZkaCXpfYYvdESXQWAUsZuKMKAEPZM/RZlhvwP+v4oZV9GFpbcZ8UETSlWdz0M/n
         2I0MRTScHgjReggtzl4mv2ZpspbS1hrCDiAGYNq67i9BKjXFmZeYaPba1UeN473uPJt8
         mK7A==
X-Gm-Message-State: AOAM530LR/G5fvEHwVNrlHJkFRVq8mkmw/H7CnUs1/CjtwAPOF7hfxWw
        CrhQ3i09Y0dSG9ZlmQutYJAOxlB0u6LLR8EfAaY=
X-Google-Smtp-Source: ABdhPJwenBMxxRLVJ9LqTlZwyRycNWzuJeAZROlFVt/SlrCyoQTxtxtDSjPOhTt7jmo9dhPPmjveYw==
X-Received: by 2002:a2e:3e15:0:b0:247:d94b:c004 with SMTP id l21-20020a2e3e15000000b00247d94bc004mr9011821lja.428.1648228125061;
        Fri, 25 Mar 2022 10:08:45 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id br12-20020a056512400c00b0044a2c454ebcsm764699lfb.27.2022.03.25.10.08.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 10:08:44 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id w7so14439944lfd.6
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 10:08:43 -0700 (PDT)
X-Received: by 2002:a19:e048:0:b0:448:2caa:7ed2 with SMTP id
 g8-20020a19e048000000b004482caa7ed2mr8774773lfj.449.1648228123047; Fri, 25
 Mar 2022 10:08:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150419.757836392@linuxfoundation.org> <20220325150420.085364078@linuxfoundation.org>
In-Reply-To: <20220325150420.085364078@linuxfoundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 25 Mar 2022 10:08:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiaeZKiEk87Sms1sy53m8tT3UCLOoeUBnX1c_1dZ78WjQ@mail.gmail.com>
Message-ID: <CAHk-=wiaeZKiEk87Sms1sy53m8tT3UCLOoeUBnX1c_1dZ78WjQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 11/38] swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 8:09 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Halil Pasic <pasic@linux.ibm.com>
>
> commit aa6f8dcbab473f3a3c7454b74caa46d36cdc5d13 upstream.

This one causes a regression on at least some wireless drivers
(ath9k). There's some active discussion about it, maybe it gets
reverted, maybe there are other options.

There's an ath9k patch that fixes the problem, so if this patch goes
into the stable tree the ath9k fix will follow.

But it might be a good idea to simply hold off on this patch a bit,
because that ath9k patch hasn't actually landed yet, there's some
discussion about it all, and it's not clear that other drivers might
not have the same issue.

So I'm not NAK'ing this patch from stable, but I also don't think it's
timing-critical, and it might be a good idea to delay it for a week or
two to both wait for the ath9k patch and to see if something else
comes up.

              Linus
