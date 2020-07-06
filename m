Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995C92155FA
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 12:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgGFK6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 06:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgGFK6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 06:58:44 -0400
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EEC720772;
        Mon,  6 Jul 2020 10:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594033124;
        bh=DHaVeBdGgGfIr0NZuIeBEu3g1835paZKX72HGKXym7k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=W62RhsPgIs5vdUGg8yamWJ4gQjU8Gs/x5guVzStRvWlRIA5hV6H0uJfc3w8rN0Eqe
         v8mtf62fR8C0TiY06zV5tjLLv9L0B7UAyqQO/H/vNoG/XqmOEWC56gWm76kJblPJh2
         v4ht/bYvW9A4TD+5fwiyZrSY95NI/OPmAGVSJj2E=
Received: by mail-lf1-f42.google.com with SMTP id g2so22310128lfb.0;
        Mon, 06 Jul 2020 03:58:44 -0700 (PDT)
X-Gm-Message-State: AOAM5327vmVjoH9plaPkvUPlqsorpQ1G43Q/UWCQOH4KfgKrqoEeCW3g
        Wpi+jonapzsDhkn9gfbHPT/tAqIiE6RSC+Sp/gw=
X-Google-Smtp-Source: ABdhPJxrG3emgV5/gynjNvHC6XzEE9+FwI2aJYvVhkhtZMptOkiTLEEzndluBtzjC+DdQqeNM6+brzzYWk9YzccWoks=
X-Received: by 2002:ac2:5593:: with SMTP id v19mr29352799lfg.43.1594033122519;
 Mon, 06 Jul 2020 03:58:42 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYsrGXd5survaX27kkfam1ZcJdMnzowvGdfy1xT4bGcfcA@mail.gmail.com>
In-Reply-To: <CA+G9fYsrGXd5survaX27kkfam1ZcJdMnzowvGdfy1xT4bGcfcA@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 6 Jul 2020 12:58:31 +0200
X-Gmail-Original-Message-ID: <CAJKOXPe1Y4JAj-OaF52UuZNkwf1Ug2VTB5kyui+GvqXsVJWsTw@mail.gmail.com>
Message-ID: <CAJKOXPe1Y4JAj-OaF52UuZNkwf1Ug2VTB5kyui+GvqXsVJWsTw@mail.gmail.com>
Subject: Re: WARNING: at kernel/kthread.c:819 kthread_queue_work - spi_start_queue
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-spi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux- stable <stable@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Peng Ma <peng.ma@nxp.com>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 Jul 2020 at 12:55, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> While booting arm64 device dragonboard 410c the following kernel
> warning noticed on
> Linux version 5.8.0-rc3-next-20200706.
>
> metadata:
>   git branch: master
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>   git commit: 5680d14d59bddc8bcbc5badf00dbbd4374858497
>   git describe: next-20200706
>   kernel-config:
> https://builds.tuxbuild.com/Glr-Ql1wbp3qN3cnHogyNA/kernel.config
>
> Crash log while booting,

Hi,

Thanks for the report. Did bisect pointed to any specific commit?

Best regards,
Krzysztof
