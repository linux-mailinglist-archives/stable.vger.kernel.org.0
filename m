Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1AA19349D
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 00:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgCYXdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 19:33:14 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41029 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbgCYXdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 19:33:14 -0400
Received: by mail-lf1-f65.google.com with SMTP id z23so3290725lfh.8
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 16:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fq+rH4YE72x0k6vRBalpeRHnZGOCdmKPprbP9ia4MOM=;
        b=SNZW1PD3VW0c1h12/8mpMh7w/sIRy8tamsLzdz1LCfbU6hfQlo6W347kP/HwYMVR1F
         Qc3yQZxk2Q6Ac3hySPQRuUUIwmpgB6X/EVSlxyyQNguRk2dl6pjGMgclgPV2raGbzK9K
         s59O7jhtZLpU2H5VUcs/tWXFwDu7pd96OmcSlz6AjBg6aNFsyXNjjm+mTP00meS7lENx
         30l18riTd02UZ0+iUuspw9fB5iqhvl4NzVmod84EmrphxF5y+4nSuUukkIRM/Yu9tVby
         Q6rqikN8GIdZXWqgKQlp9hlkE1iRyVFIljrbqfzTgsWv9pAU/0VmpnsJ149VCt+YWN23
         o4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fq+rH4YE72x0k6vRBalpeRHnZGOCdmKPprbP9ia4MOM=;
        b=DlCWry60WmNK7xmygUg4QrULRg6HJviuHJZM7BfHBpB7u3zpPgY85dFOOalraJuClB
         mi5JE8YArZw8P+/eS3IaK1GTx1TnXWV9GJ997fRsinY4bU1r1sX4ZZ1mQHypoeU+xUAR
         zLWt2U6lTw24nKIlVh3VU+KbdkB+jqHLGm9yIkhquTOrumBiIpDARx72U2Mqf5SYvRbH
         qtX4Xp4tidCG2eSKA6L/A2bzu2JCex/riDpUZfcvFosN2P3fJQlvNjchzFwirOowqI0q
         Oq9R+HcRTylRoqSXEBuiUT4w8GfqdsZ/+szoOpit9hPg+4sdpRt/kDY6ZGsNYGnyH+a7
         OK5A==
X-Gm-Message-State: ANhLgQ1Z375OD4xowl+qRnE7ugNcOcgP2xVrac88Qyw22sLMfBSSXCyk
        A2YKxQf7bOcJ2N8A15Bx6CNvmDSjM06e+cNJqIA3Rg==
X-Google-Smtp-Source: ADFU+vuRDjYt3cPfXr2YkUhRSV2AIb2Y7M3IIMYmQtgu1PjJAXlpar+ygRx9KVGiGad0CHgJv35Duhka07JGj4GSRfE=
X-Received: by 2002:a19:ac8:: with SMTP id 191mr3760382lfk.77.1585179191616;
 Wed, 25 Mar 2020 16:33:11 -0700 (PDT)
MIME-Version: 1.0
References: <1583941433-15876-1-git-send-email-tharvey@gateworks.com>
 <CACRpkdb3VzOFmnZkXXopsbKAAiQ9nzsqm6fMpcsCfmuvmaeOmg@mail.gmail.com>
 <CAJ+vNU0U9jKDoZLBdC2aRrCCQkKmWATk6G6XAzQcF03tQY9r8g@mail.gmail.com> <20200313150105.GF1349@sasha-vm>
In-Reply-To: <20200313150105.GF1349@sasha-vm>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 26 Mar 2020 00:33:00 +0100
Message-ID: <CACRpkdZmTi5xfiNRX6i1JKT_kxP0G1c=+SiqRi_eWb6YQ3NZ7Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: thunderx: fix irq_request_resources
To:     Sasha Levin <sashal@kernel.org>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        stable <stable@vger.kernel.org>,
        Robert Richter <rrichter@marvell.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 13, 2020 at 4:01 PM Sasha Levin <sashal@kernel.org> wrote:
> On Thu, Mar 12, 2020 at 10:16:40AM -0700, Tim Harvey wrote:
> >On Thu, Mar 12, 2020 at 6:42 AM Linus Walleij <linus.walleij@linaro.org> wrote:
> >>
> >> On Wed, Mar 11, 2020 at 4:43 PM Tim Harvey <tharvey@gateworks.com> wrote:
> >>
> >> > If there are no parent resources do not call irq_chip_request_resources_parent
> >> > at all as this will return an error.
> >> >
> >> > This resolves a regression where devices using a thunderx gpio as an interrupt
> >> > would fail probing.
> >> >
> >> > Fixes: 0d04d0c ("gpio: thunderx: Use the default parent apis for {request,release}_resources")
> >> > Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> >>
> >> This patch does not apply to the mainline kernel or v5.6-rc1.
> >>
> >> Please verify:
> >> 1. If the problem is still in v5.6 (we refactored the driver to
> >>    use GPIOLIB_IRQCHIP)
> >
> >Linus,
> >
> >Sorry, another issue was keeping me from being able to boot 5.6-rc but
> >that's now understood and I can confirm the issue is not present in
> >v5.6-rc5
> >
> >>
> >> 2. If not, only propose it for linux-stable v5.5 etc.
> >>
> >
> >Yes, needs to be applied to v5.2, v5.3, v5.4, v5.5. I cc'd stable. If
> >I need to re-submit please let me know.
> >
> >Cc: stable@vger.kernel.org
>
> Linus, could you ack this patch for stable?

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Sorry for the delay :/

Yours,
Linus Walleij
