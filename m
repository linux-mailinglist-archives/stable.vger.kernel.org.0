Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDABA2AFCE1
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 02:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgKLBdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 20:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgKKXQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 18:16:58 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1616C0613D4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 15:16:58 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id s30so5609546lfc.4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 15:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CWWrQNlrqNu3PmdGxq8JyJTFPup9rQoNWJqUzri1lE=;
        b=LpRBAHuzcK4BzoEFa+JKRIKn4Nl1L6dIrf3fXK2LuUBNgbmsc7ju8+9L0dVHtXRj9a
         UMEJN1of4BPh/ZrUgufIDU/M5DWzS2a1ZZF8jbepSugzsMJbtlvs9kind5fCiwDZdQy9
         KColWYr9qQV6HNQE9KaKOntW7SRqLOlyEQQgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CWWrQNlrqNu3PmdGxq8JyJTFPup9rQoNWJqUzri1lE=;
        b=R0w+CB/LI4aQdO08wJQpxKhNZMHlJYCZY/T4KvU8wHyCE3RfSi5hf7J1RplASFz1f9
         HVIgLRQrunqsmVCXqtwNMfC6ToC8CMRn2Am29SY1hA/OKRH5JC+MgIece+Cq8XkJpRpA
         ThSuFvTqntwfm2pPSoTrsigytwkSbBnXHfsZG+JA+6a5+MYZguryrXrzqxh/T7D2cu/8
         fU/rf+D7GDTYOpT181VSndF++hcgu/EujSCWGL5qjgANj8tWUemdK/1EWijM03Y9Up8S
         lp4XPX3vzsy7OpDykaH2C1knMp1RVr9z74EEfhnSecEuV02JlFIw0mjtVYZANj4tSlwU
         8yew==
X-Gm-Message-State: AOAM531xs0Rimwq40bwbSZUvrFQfi4HKNxTT03LnHbyDsNL2kEv4bnJY
        vNPYxGiyZhurqjW5cWYgBsCFOY6A2SH0Ew==
X-Google-Smtp-Source: ABdhPJx9PWUkDLZ/+0Bn4bgE+urxMpHcpILGwi0bGCCSpcVMtatOyN6xfmomFIJ8ynnRUR3aorHU4w==
X-Received: by 2002:ac2:4216:: with SMTP id y22mr10658805lfh.169.1605136616934;
        Wed, 11 Nov 2020 15:16:56 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id k23sm358304ljh.95.2020.11.11.15.16.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 15:16:56 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id l2so5617727lfk.0
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 15:16:55 -0800 (PST)
X-Received: by 2002:a19:c1c5:: with SMTP id r188mr7786174lff.354.1605136614924;
 Wed, 11 Nov 2020 15:16:54 -0800 (PST)
MIME-Version: 1.0
References: <20201110144932.1.I54a30ec0a7eb1f1b791dc9d08d5e8416a1e8e1ef@changeid>
 <20201111221400.GT4077@smile.fi.intel.com>
In-Reply-To: <20201111221400.GT4077@smile.fi.intel.com>
From:   Evan Green <evgreen@chromium.org>
Date:   Wed, 11 Nov 2020 15:16:18 -0800
X-Gmail-Original-Message-ID: <CAE=gft6CpRsEt_MRyCZ0-NheBVgjTqp+omCJXeLUj1sExNHADg@mail.gmail.com>
Message-ID: <CAE=gft6CpRsEt_MRyCZ0-NheBVgjTqp+omCJXeLUj1sExNHADg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: intel: Fix Jasperlake hostown offset
To:     Andy Shevchenko <andriy.shevchenko@intel.com>
Cc:     Andy Shevchenko <andy@kernel.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 11, 2020 at 2:13 PM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Tue, Nov 10, 2020 at 02:49:49PM -0800, Evan Green wrote:
> > GPIOs that attempt to use interrupts get thwarted with a message like:
> > "pin 161 cannot be used as IRQ" (for instance with SD_CD). This is because
> > the JSL_HOSTSW_OWN offset is incorrect, so every GPIO looks like it's
>
> Simply HOSTSW_OWN, and same spelling in the subject, please.
>
> > owned by ACPI.
>
>
> > Signed-off-by: Evan Green <evgreen@chromium.org>
>
> > Fixes: e278dcb7048b1 ("pinctrl: intel: Add Intel Jasper Lake pin
> > controller support")
>
> It must be one line, and put it first in the tag block
>
>
> > Cc: stable@vger.kernel.org
>
> This is second one...
>
>  Fixes: ...
>  Cc: ...
>  SoB: ...

Thanks, will fix these things, spinning now.
-Evan
