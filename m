Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693752F885E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 23:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbhAOWV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 17:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbhAOWV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 17:21:57 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A39C061793
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 14:21:17 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id o19so15460224lfo.1
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 14:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P5tRwFZpJtVF/buhxZcoEoFQtvw2RmFYD11GvJuVe9E=;
        b=OyyLbfx9J1qLgRci7wZTIyT4U9KdlUzetkeHVvVxvlw82fsYYml+Fkzsds7VfcTzaW
         ehrV2wHLPbV/yX/eT/taKe0AFrnkF2wixHO9J6lqy7pVfo+hN6IcC7kH/umPa0X7sPGd
         0i+VKkhYyV2PWy+1o/gARg6hLaQxh3nyCTo/KNdhebVl9unlWNBHegnqlGXh/XcgVgiX
         bHabjLBC4Ctnx/IwRjH3tyap8bs7CXZMGO9jLSJnsDM809Jvg/3H1KFr4Nz9b+U5tjOm
         ogxjejK4qkMRDhnzinWDTKVjSLxF8nbKFD7923Pi4wYq+FTMgD11wNL2r5+J681PBlbY
         2GwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P5tRwFZpJtVF/buhxZcoEoFQtvw2RmFYD11GvJuVe9E=;
        b=Nda+AmQaSDBYp1VwjUX1dhJwJ/BqRkclkgKMLqk6hoxUR5Qp/UYN9cmYCFedIl7H6C
         n+MBgAudu6eW80AyoUI0FF6FctHAR2h17oEmNG322oT7n45vCy41xuAnTCZc1TBBCVRw
         HkwpWenZ98N509DSjGMDX6HFtCMw0cZiJTjSF+Sh/9rwR3h+w5v4L8BA2VhTjEqn1mkF
         QmS2bbvLlSv3rbDjHPZd7mJtwhQWergY3aHwMYfP+pecdR9PAiLI3IyZTwbmIqJ22LZQ
         X7B4Nh00z4BmK+1rUmo++LSpzNAdmgjNXe+qTB4Gl7q/uMnNs7L7y/vsPBwKBshjT4jA
         rgcQ==
X-Gm-Message-State: AOAM532bOlR3L1pE5LknUHfLoWaR3RzwQ9nYj9n1eoBvF84/n6nQPAkZ
        adHZ9qrmfI4v/pE/fY59iuI+MnqQ/NXSfa0zTN01+w==
X-Google-Smtp-Source: ABdhPJyazJTE6p8cMWOgUToD0TsF4sKXwlDtfVufaAh9yZKxEA2JGi2DzJU7Cr9YjXQFjerZ5jjJjROYo+ci5pns4VQ=
X-Received: by 2002:a19:495d:: with SMTP id l29mr6235978lfj.465.1610749275587;
 Fri, 15 Jan 2021 14:21:15 -0800 (PST)
MIME-Version: 1.0
References: <20201213225517.3838501-1-linus.walleij@linaro.org> <161073123818.625238.784153877114947970.b4-ty@arndb.de>
In-Reply-To: <161073123818.625238.784153877114947970.b4-ty@arndb.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 15 Jan 2021 23:21:04 +0100
Message-ID: <CACRpkdZBMxjBbUXFEa=ByGMKQ189=JHR=CxBBdZ5ejPVuQ_c1A@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: ux500: Reserve memory carveouts
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     SoC Team <soc@kernel.org>, arm-soc <arm@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        David Hildenbrand <david@redhat.com>,
        stable <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 6:22 PM Arnd Bergmann <arnd@kernel.org> wrote:

> I had mistakenly not applied this last year before the merge
> window, as I misread the description as being not very urgent.
>
> On second look, this seems important enough for the v5.11
> fixes branch, so I applied it now.

I was just thinking about it while cooking dinner!
- Hey what with that critical patch now again...

Thanks a lot!
Linus
