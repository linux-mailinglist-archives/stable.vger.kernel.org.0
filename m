Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72ED5642246
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 05:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiLEEav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 23:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiLEEat (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 23:30:49 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1484412632
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 20:30:48 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id f9so9442211pgf.7
        for <stable@vger.kernel.org>; Sun, 04 Dec 2022 20:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9GCEA+SSJQob9uLrpSyNUMykzy3VL+SnBP5yRlvK1eo=;
        b=WdEG7G34TfSohxVW9Q+va8i1yUPOGQf/M6WmLtC9heVeKK2gExscC77yAx6CqPfdHi
         cRvSxc1m65yCLFHrzSLTwLaRHOhfsRz/5V19R8mGii4xaLLmVumM1Et3q3FiV11JeVCd
         zmj2LR9JBNZU9ZZ8UAEPZ37+2z97MiQbL1aR+BUlFXSO8t1GAUMq8WEpEvmtDJpac83a
         YF63+Fe7kpGPw1Cg/OFqe0F3s0XAUNqBwvaoDCTIOkO2OLp0XSoiMzZjlRntBEVAKdmq
         lqVAqDOxqyP6Ci1Gvk2rRQ1l7a9UnMXmzm4Gn4+CPct8bNpEs+xNdc9pvwGizWj/l0Yu
         FONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9GCEA+SSJQob9uLrpSyNUMykzy3VL+SnBP5yRlvK1eo=;
        b=3QBOCfLaQFDLslWzIPuhiiIWwHbVpozQzQFNk0V6rPUQul5SalaWIyz0r7V/T8SXLK
         yYUXVcokiECZK7mJ2I8LjPFKVv5c/OrKDsrJNOtlev874jQEgenKtNcj05HhHcT/1mTg
         eZoB1jjqAXJfTAfYXFRkeTbsIY9k1ZrNI9e4/lspP/5T8mj03qE3zOALT6XjliEzMm0h
         rga8kCdIvInCkmdwCtBM/fOtaSaypzM5QKbAwlxt0do2B6ISF7IL8ZcoTKqAD/4FrgfI
         Y0b7We3P8nAVpNtVCQQcYQ9AnuAIZP7QLc+34uJuigOYu8D3grLECWZBYHah7GwBHMtv
         DKuQ==
X-Gm-Message-State: ANoB5pmP9GLdOyfF1e0JpNIKNdcnRpkRXJ6jVTq84s2en2xAC5mXNsxC
        Z9yHK33+7NegnV86YeAfjQGM8g==
X-Google-Smtp-Source: AA0mqf6rJI2yAAtTzCc5R8ix0sglB93D7T4rOHrW51DOxVwN6cVLQy/R1rzvudeCKEm6YcqArp3EnQ==
X-Received: by 2002:aa7:810e:0:b0:56b:f23a:7854 with SMTP id b14-20020aa7810e000000b0056bf23a7854mr68378113pfi.66.1670214647512;
        Sun, 04 Dec 2022 20:30:47 -0800 (PST)
Received: from localhost ([122.172.87.149])
        by smtp.gmail.com with ESMTPSA id m1-20020a17090a5a4100b00219396d795esm8236199pji.15.2022.12.04.20.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 20:30:46 -0800 (PST)
Date:   Mon, 5 Dec 2022 10:00:44 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        regressions@leemhuis.info, daniel@makrotopia.org,
        thomas.huehn@hs-nordhausen.de, "v5 . 19+" <stable@vger.kernel.org>,
        Nick <vincent@systemli.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] Revert "cpufreq: mediatek: Refine
 mtk_cpufreq_voltage_tracking()"
Message-ID: <20221205043044.bgecubnw7d3xlyi5@vireshk-i7>
References: <930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org>
 <18947e09733a17935af9a123ccf9b6e92faeaf9b.1669958641.git.viresh.kumar@linaro.org>
 <CAJZ5v0ixHocQbu6-zs3dMDsiw8vdPyv=8Re7N4kUckeGkLhUzg@mail.gmail.com>
 <CAJZ5v0hc8CsvqLKxi5iRq7iR0bkt25dRnLBd23mx-zdi2Sjgsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0hc8CsvqLKxi5iRq7iR0bkt25dRnLBd23mx-zdi2Sjgsw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02-12-22, 20:46, Rafael J. Wysocki wrote:
> On Fri, Dec 2, 2022 at 1:17 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Fri, Dec 2, 2022 at 6:26 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > >
> > > This reverts commit 6a17b3876bc8303612d7ad59ecf7cbc0db418bcd.
> > >
> > > This commit caused regression on Banana Pi R64 (MT7622), revert until
> > > the problem is identified and fixed properly.
> > >
> > > Link: https://lore.kernel.org/all/930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org/
> > > Cc: v5.19+ <stable@vger.kernel.org> # v5.19+
> > > Reported-by: Nick <vincent@systemli.org>
> > > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> >
> > Do you want me to push this revert for -rc8?

No, I was planning to make it part of my pull request.

> After all, I've decided to queue it up for 6.2, thanks!

Can you please drop that ? AngeloGioacchino already reported that
Reverting the proposed commit will make MT8183 unstable.

So the right thing to do now is apply the fix, which is on the list
and getting tested.

-- 
viresh
