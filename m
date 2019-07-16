Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A446B766
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 09:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfGQHli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 03:41:38 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39057 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfGQHlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 03:41:37 -0400
Received: by mail-lj1-f193.google.com with SMTP id v18so22572352ljh.6;
        Wed, 17 Jul 2019 00:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VOWjiRAyIBAA+YCK5C8RMkBh8f2aDSBnlOvisjIniJc=;
        b=KjFYBoZiC/Y3OZRSoGBXmfpzdXHy2ngPq4NdAAEhxL0GDmoFOraGIy4xC48ktFnPeo
         iQGMmgNaFjR5oksxhfhZDKl/hxxFeNK+9xToNvJitI2pvK/M6AeWZMnZHb6cTFRYdFpQ
         TBiQezFr1nlXsPtvf/Cg/eexbQ1YAIJJZcaxwP4wNlY+L39C3CIsrKL+piX4oePI+iUa
         iu7J7GWJppYHzNIKRK+8HE11a0mYfJWg9/QfmAEynFpGKh/3vYskX/DDGaFbNTE8yvQ6
         OxKBENgZtNyQlK4Tj340BBGnPYJ3W9FAPlLo/WhZQRlOwiL2Nd5EsmyrtlqlC+oxIkD8
         XrUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VOWjiRAyIBAA+YCK5C8RMkBh8f2aDSBnlOvisjIniJc=;
        b=UHY3jl7Eazq1U+B41LoHa4cRq3tv1EF8KZsfvwGQWnvmXYKFVmRW+g+3gRuEJq6Tkp
         DQzFxqM7wuxWXSGAITiwAU8mdSHoqQrFa/h0DNkJArR24yYkvXvqEcGNSdv7upXQuyhA
         wWcYuOEKleHJtdQLbuKO2XHOH3sifXZUs8v5Vb7cY8+lVqwje1CMG1iFrIocGhFq4Pg4
         Jcl80ivU6WU9ShS7KoRQD0CGFYmPLpyR6x0Jd2k52l3w6Tf1jcVajSTsPTCmKXyk5kE4
         2BU8pdNtvskTnx8/1nrT9zwrvfGIr8h0162m3Kp/g36KDC/CV84c45LTkrpsJdkP5mhG
         qd6w==
X-Gm-Message-State: APjAAAVydP/4syVdE7nIzr6HB/yKpoEWNHnorvrDjJIvefc4R7uaytHp
        yNJLXW2bwy+8ST/Pdb3THjk=
X-Google-Smtp-Source: APXvYqw+XC5WC6PzUMfGn22IglKAtHXg9ynnF3rI4nMrfIG4UqXNVjJddkOKRcy3mcr8ifPyuMl0Cw==
X-Received: by 2002:a2e:98d7:: with SMTP id s23mr19571304ljj.179.1563349295111;
        Wed, 17 Jul 2019 00:41:35 -0700 (PDT)
Received: from localhost ([188.170.223.67])
        by smtp.gmail.com with ESMTPSA id s1sm4238234ljd.83.2019.07.17.00.41.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jul 2019 00:41:34 -0700 (PDT)
Date:   Tue, 16 Jul 2019 22:28:09 +0200
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Lyude Paul' <lyude@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: i8042 - disable KBD port on Late-2016 Razer Blade
 Stealth
Message-ID: <20190716202809.GB584@penguin>
References: <20190407213735.10658-1-lyude@redhat.com>
 <20190407221034.GA162359@dtor-ws>
 <0ac9aef48f4cf974f4f7046aad1267ab5c8fe525.camel@redhat.com>
 <28dc38a55c45467dad6f11e9ea459172@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28dc38a55c45467dad6f11e9ea459172@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 08, 2019 at 09:55:00AM +0000, David Laight wrote:
> From: Lyude Paul
> > Sent: 07 April 2019 23:55
> > On Sun, 2019-04-07 at 15:10 -0700, Dmitry Torokhov wrote:
> > > Hi Lyude,
> > >
> > > On Sun, Apr 07, 2019 at 05:37:34PM -0400, Lyude Paul wrote:
> > > > The late 2016 model of the Razer Blade Stealth has a built-in USB
> > > > keyboard, but for some reason the BIOS exposes an i8042 controller with
> > > > a connected KBD port. While this fake AT Keyboard device doesn't appear
> > > > to report any events, attempting to change the state of the caps lock
> > > > LED on it from on to off causes the entire system to hang.
> > > >
> > > > So, introduce a quirk table for disabling keyboard probing by default,
> > > > i8042_dmi_nokbd_table, and add this specific model of Razer laptop to
> > > > that table.
> > >
> > > What does dmesg show about i8042 for this device? Especially line "PNP:
> > > PS/2 Controller  ..."?
> > >
> > 
> > Apr 07 18:42:46 malachite kernel: i8042: PNP: No PS/2 controller found.
> > Apr 07 18:42:46 malachite kernel: i8042: Probing ports directly.
> > Apr 07 18:42:46 malachite kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
> > Apr 07 18:42:46 malachite kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
> > Apr 07 18:42:46 malachite kernel: mousedev: PS/2 mouse device common for all mice
> 
> That is the 'default' probe of the ps/2 serial ports.
> Looks like the BIOS is correct in not exposing the ps/2 controller.
> Usually they just fail to expose the mouse when it needs a ps/2 splitter :-(
> 
> I do wonder what they've connected it to though.
> It is extremely unlikely they've found an x86 chipset that doesn't
> have the ps/2 serial ports at the standard io addresses.

I wonder if it is time to start trusting BIOS if it was released maybe
in Win7+ timeframe?

Thanks.

-- 
Dmitry
