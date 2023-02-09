Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BB969119A
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 20:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjBITwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 14:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBITwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 14:52:17 -0500
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999902B2A0;
        Thu,  9 Feb 2023 11:52:14 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id lu11so9786770ejb.3;
        Thu, 09 Feb 2023 11:52:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iQ2nMKzI1m5a52055nXQNovTY3NnLIerNmBEzVVfKpA=;
        b=AYUdL30QoWEf80KupY09Xt6GLGsoUE7gY4e9q3KYUMOFYLgWfO0XPagEIsFzn15Z9L
         lS5conPoHsWiGah+MCAIt+YdPeP/9/MUjtIWqzwd4NQDHRfcFmICPhc1K49QmQNaoACN
         JxhFwd+r906BbNbQpAvzZSsbERT/10pA7yewacYK1Z8JIRtUsecb3RoY6VwfGyLtgCBn
         kx3KK8C0PU9N6XNoo8hWbp/hVcoZ3L3jvAVq/trqRwrHrwreTCAVMhnvo5hBK02fLRfw
         ZhIBxqbN5Ca/ZZf7aFTHxPrfv1KZdiUWMfRHCZ6W+RNvnHTb9zIbLHYrysKNMlyYJNME
         dQlg==
X-Gm-Message-State: AO0yUKWhYNsiVkCghVlwcGPmXCp89+yU5NpyddLzBArDivRFjT57NImL
        GQ9WF0Kgn8psDkEc2hpLt1BWi0FQFAE9KsmWr1E+XMmg
X-Google-Smtp-Source: AK7set9N4PFR1o4yOFTtelh2DCU80CsvMl06mLWeTYaelSu5rvsE8SUckCS91ReIOoTok0UPKEoZKO7P0KG5+f3MSb4=
X-Received: by 2002:a17:906:8805:b0:878:6169:71a6 with SMTP id
 zh5-20020a170906880500b00878616971a6mr817794ejb.5.1675972333180; Thu, 09 Feb
 2023 11:52:13 -0800 (PST)
MIME-Version: 1.0
References: <20230206193319.4107220-1-arnd@kernel.org> <Y+IkjuCr9UuY5ZDg@orome>
In-Reply-To: <Y+IkjuCr9UuY5ZDg@orome>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 9 Feb 2023 20:52:02 +0100
Message-ID: <CAJZ5v0iTumTZcvi3p0cBU5V=0N3e9GQ6b+Nkgxfk-W4C_wp2qw@mail.gmail.com>
Subject: Re: [PATCH] [v2] cpuidle: add ARCH_SUSPEND_POSSIBLE dependencies
To:     Thierry Reding <treding@nvidia.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        Anup Patel <anup@brainfault.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Michael Walle <michael@walle.cc>,
        Bjorn Andersson <andersson@kernel.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 7, 2023 at 11:14 AM Thierry Reding <treding@nvidia.com> wrote:
>
> On Mon, Feb 06, 2023 at 08:33:06PM +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > Some ARMv4 processors don't support suspend, which leads
> > to a build failure with the tegra and qualcomm cpuidle driver:
> >
> > WARNING: unmet direct dependencies detected for ARM_CPU_SUSPEND
> >   Depends on [n]: ARCH_SUSPEND_POSSIBLE [=n]
> >   Selected by [y]:
> >   - ARM_TEGRA_CPUIDLE [=y] && CPU_IDLE [=y] && (ARM [=y] || ARM64) && (ARCH_TEGRA [=n] || COMPILE_TEST [=y]) && !ARM64 && MMU [=y]
> >
> > arch/arm/kernel/sleep.o: in function `__cpu_suspend':
> > (.text+0x68): undefined reference to `cpu_sa110_suspend_size'
> > (.text+0x68): undefined reference to `cpu_fa526_suspend_size'
> >
> > Add an explicit dependency to make randconfig builds avoid
> > this combination.
> >
> > Fixes: faae6c9f2e68 ("cpuidle: tegra: Enable compile testing")
> > Fixes: a871be6b8eee ("cpuidle: Convert Qualcomm SPM driver to a generic CPUidle driver")
> > Link: https://lore.kernel.org/all/20211013160125.772873-1-arnd@kernel.org/
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > I found this in my backlog of patches that never made it upstream,
> > testing shows this is still needed. Please apply.
> > ---
> >  drivers/cpuidle/Kconfig.arm | 2 ++
> >  1 file changed, 2 insertions(+)
>
> Acked-by: Thierry Reding <treding@nvidia.com>

Applied as 6.3 material, thanks!
