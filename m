Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0396A285A6F
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 10:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgJGI1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 04:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgJGI1R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 04:27:17 -0400
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0A0C20B1F;
        Wed,  7 Oct 2020 08:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602059237;
        bh=5/kL+ZLfMp1q+Qloa6EMZ+ykXgDZfaSq59tKZokiPf0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=f/kTnJQvc07mqdXz7UK1j+P0eKzSkxZraloPgnK7sVPwps8T+nZjwx2NitPEj/zLS
         x76lTRM2lWT/k/C1FxdNWOTTOhj776/yZbVqK4kt6DRISDCPzoLdNNgiUohVjBMW8q
         kUPHL7uJBiH5Rk24ZJUZu+aWOMg0u4QOOJPq8DAU=
Received: by mail-ed1-f42.google.com with SMTP id p13so1245765edi.7;
        Wed, 07 Oct 2020 01:27:16 -0700 (PDT)
X-Gm-Message-State: AOAM531BrovAbuUenUOJuvgONqlS9g0i/kQwvh15vEmSHLvqtoIj+B4z
        586y36T6D6rr3pHPeYteZ5ohe6bmdXx625/swzw=
X-Google-Smtp-Source: ABdhPJzTbDteYkGgC2Zx7Ay5FsxCOPkEOJUv/aD/EBvxopJJh6eS/nJQ9mQ8hm45dOw/IdBxbgSNS2Gp0PzFSnpgXtc=
X-Received: by 2002:a50:a452:: with SMTP id v18mr2251384edb.143.1602059235307;
 Wed, 07 Oct 2020 01:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201006160814.22047-1-ceggers@arri.de> <20201006160814.22047-2-ceggers@arri.de>
 <CAJKOXPctS2DGkQW3EhP5Tg0y39oVF0xhEcmbs=T0vHmUsMgsQw@mail.gmail.com> <5729679.lNAy7qQNGU@n95hx1g2>
In-Reply-To: <5729679.lNAy7qQNGU@n95hx1g2>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 7 Oct 2020 10:27:02 +0200
X-Gmail-Original-Message-ID: <CAJKOXPd+kqwnFiqEz6wDRcA3Xeqo8zngQWEzc4svrND=Zi=3FQ@mail.gmail.com>
Message-ID: <CAJKOXPd+kqwnFiqEz6wDRcA3Xeqo8zngQWEzc4svrND=Zi=3FQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] i2c: imx: Fix reset of I2SR_IAL flag
To:     Christian Eggers <ceggers@arri.de>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        David Laight <David.Laight@aculab.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 7 Oct 2020 at 10:17, Christian Eggers <ceggers@arri.de> wrote:
>
> On Wednesday, 7 October 2020, 09:50:23 CEST, Krzysztof Kozlowski wrote:
> > I replied to your v2 with testing, so what happened with all my tested tags?
>
> I am quite new to the kernel development process. Seems that I should
> integrate all "Tested-by" tags into following version of my patches.
>
> In which cases shall the tested tags be kept and in which cases they become
> invalid?

https://elixir.bootlin.com/linux/latest/source/Documentation/process/submitting-patches.rst#L584

Your v3 touched only one patch, so all tags for all other patches
should be added and preserved. If the patch changed significantly that
review or testing is not appropriate, you could remove someone's tag
but then you should ask for testing again. And you did not send it for
testing.

Your v4 only extended a comment which does not affect testing. All
tags, review, ack and tested by should be added/preserved.

Otherwise you ask for testing (or reviewing) and then do not credit
this person. Neither maintainers know that patches were tested.

Best regards,
Krzysztof
