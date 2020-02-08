Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D01115672D
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgBHSnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:43:39 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34584 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbgBHSnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:43:39 -0500
Received: by mail-wm1-f66.google.com with SMTP id s144so5405875wme.1
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 10:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5pkGGU8cEcpg1WQ5oeotxdCpOUBGNhi+JYRWVa+V80s=;
        b=ms+A/tTuvVz3HZCbAlRinLVe0SmeiI3IuRip/0uQPzHbS9mUbtBNFcgeSke7bLaLSp
         p5pgxVUFVWi2o+JvDU/dCAkNUKIwrCe5x+XurkivpcLK+ONpQm0aNnwLePtsKr2qGk0F
         PIUqpCV4OgxB5Clg78ul1dEnBJQqlb+Wm/dVlpVgInHGrWnynXzHG5xdBFivNhc1a4y+
         pWbLAE5x3LdoSNIyrCnG8Uq/2rd4rELIqEg8m69IeDmeAv1okYOMcgkjrScZ/bjfwNoT
         BCQffulbka/25ZR/6d1EvPDrVwadiuJbkfmlKsw9jN9iVuThDkS/FMsdAa4OKYi0zKAQ
         H/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5pkGGU8cEcpg1WQ5oeotxdCpOUBGNhi+JYRWVa+V80s=;
        b=GwyIIBB7pMJ4N5rxalA9Pw51qGTs2YEVI+W5fg/s/WoduWkpXxZ1JrbzdfO1lzC4u9
         vvw8SPCbuLCyuB9Pt8D+DGoQEJ2mUC38gYnWFoFLVFQHP3uNJD9l1XKl2PdId4zdS3zX
         UIao7jfFX5AWhR1GUC+u2Rgr05blWth9Z1t69wS5xwvs2ncdH6uoAUK9RztCwHYsAW3d
         npE/S4VpBQs6TtXYIFPMElf1WaJCqsStdzFe3+bVDwH0gc6TJcFIjwqzOXVZEtN0+p2b
         G/TYd3sXFLttrcWja5exbEpJ5x4J0+hO/R0lx9PkVuH91+A4liXLPXYbwmvDTkoTFi+q
         Cupg==
X-Gm-Message-State: APjAAAXogN3FtSyeYAaCe2IJ03USxxRXmaFMflDnT0jLQxRS/n+PM+mH
        bHeJBnEaMM2BlBuyspu3+6znzNCKxNPGDeHwCakuFg==
X-Google-Smtp-Source: APXvYqxtmrVmPK8v7/hnwsOr9LLRPCmhswgHaA017VNaGV7/DhRBF2VBSd/TMopxN856SckCGc/G/zrwkCk+G1ht4Fw=
X-Received: by 2002:a1c:9dce:: with SMTP id g197mr5128787wme.23.1581187416790;
 Sat, 08 Feb 2020 10:43:36 -0800 (PST)
MIME-Version: 1.0
References: <20200205194804.1647-1-mst@semihalf.com> <20200206083149.GK2667@lahna.fi.intel.com>
 <CAMiGqYi2rVAc=hepkY-4S1U_3dJdbR4pOoB0f8tbBL4pzWLdxA@mail.gmail.com> <20200207075654.GB2667@lahna.fi.intel.com>
In-Reply-To: <20200207075654.GB2667@lahna.fi.intel.com>
From:   =?UTF-8?Q?Micha=C5=82_Stanek?= <mst@semihalf.com>
Date:   Sat, 8 Feb 2020 19:43:24 +0100
Message-ID: <CAMiGqYjmd2edUezEXsX4JBSyOozzks1Pu8miPEviGsx=x59nZQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: cherryview: Add quirk with custom translation of
 ACPI GPIO numbers
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stanekm@google.com,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        levinale@chromium.org, andriy.shevchenko@linux.intel.com,
        Linus Walleij <linus.walleij@linaro.org>,
        bgolaszewski@baylibre.com, rafael.j.wysocki@intel.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> >
> > Hi Mika,
> >
> > The previous patches from Dmitry handled IRQ numbering, here we have a
> > similar issue with GPIO to pin translation - hardcoded values in FW
> > which do not agree with the (non-consecutive) numbering in newer
> > kernels.
>
> Hmm, so instead of passing GpioIo/GpioInt resources to devices the
> firmware uses some hard-coded Linux GPIO numbering scheme? Would you
> able to share the exact firmware description where this happens?

Actually it is a GPIO offset in ACPI tables for Braswell that was
hardcoded in the old firmware to match the previous (consecutive)
Linux GPIO numbering.

> > > What GPIO(s) we are talking about and how does it show up to the user?
> >
> > As an example, the issue manifests itself when you run 'crossystem
> > wpsw_cur'. On my Kefka it incorrectly reports the value as 1 instead
> > of 0 when the write protect screw is removed.
>
> Is it poking GPIOs directly through sysfs relying the Linux GPIO
> numbering (which can change and is fragile anyway)?

I believe so, yes.
