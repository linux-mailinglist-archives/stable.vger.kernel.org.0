Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBD1A0303
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 15:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfH1NQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 09:16:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35281 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfH1NQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 09:16:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id g7so1281005wrx.2;
        Wed, 28 Aug 2019 06:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=25zohd2xh+pzvcsnF+tzTNE+YPLY6vqdzQiEP9XHnm0=;
        b=FCSq5sySqnbCfb9b3ZwBlAzVnCcWmxbxqpWcUe3qXQvRjpYBSvwOE2frxKcJG/ULGO
         OUYtBOPm8f/PflCS44QQusrdQdTL9X2u7V8AjsbelGBEtRTMBQLrC2LvUbIXD8xdMC96
         RFDh27PmVX6/JsZzstRwypDOZEdEedI5Vxz/J3R1N0I/VanlVhoBYuFvGp/kMKzn3kk9
         4h2PAw4BBCronL3MeGuBGAdipkXDWeO1QA1j7FGuP7N9z9Zt+ZAUPkpCzCe3Nlr3WUvl
         9Ado6CpOzmxiVzIbSt0O19lmyp6q0ivdd02sWeEZS9oiVlevmLYFwjayLAlr8Yayyud9
         51SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=25zohd2xh+pzvcsnF+tzTNE+YPLY6vqdzQiEP9XHnm0=;
        b=Vck6YBbE9JnmvvhQS1qRDOW8iG+C1uC7Kf9lZV9Az81FLPvsYrrm6yGBj5R0fYlPOS
         4RP88lr5ltiDdWbAQZaCGnq5G8C8FAi227lvwitBiTnwYcLOPKMub+PeHUEgkx9cixRR
         zwUPc6KNaWB5xzQquKTppTvvpC4uuYlZKyyK+FlRqKLKHUwVNWEB02AsYrgW59h7OWR2
         RL8vmW5awQ5J2wHaj75S+65GuR+9P4d7KZ9hYMJrLaHvP+zGCQSBgVwLtBSEVxe1fEWg
         cOXFyCCwbFLOEv7FXhrb1DW52HRa+YRz0LQZztOWMl/CwL0o4WAznq6JAh9uRCHDJFDZ
         poyQ==
X-Gm-Message-State: APjAAAV19dnyQhqjtF31kMWukel2OP+6t856QyjCFSElJKHeslImkaj2
        ecE1/AJd/zBMbHF/1XtcmhOxCEYaXjVny4eQ1kI=
X-Google-Smtp-Source: APXvYqzQG9O/DS/fNOUx9hGjL+6UhlcM/boVbNLCBZF0aFCbmz31KRICTsYsRNEHfJ+Zpn8t7Glc8r1eemBqCbaZEIo=
X-Received: by 2002:a05:6000:152:: with SMTP id r18mr4883090wrx.41.1566998213954;
 Wed, 28 Aug 2019 06:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190827202835.213456-1-hdegoede@redhat.com> <20190828113748.GK2680@smile.fi.intel.com>
 <005b954d-46ad-5e45-6a9c-0b1efe020b92@redhat.com> <c07a8e2e-61a7-7ce7-4f73-48978be98d27@redhat.com>
In-Reply-To: <c07a8e2e-61a7-7ce7-4f73-48978be98d27@redhat.com>
From:   Ian W MORRISON <ianwmorrison@gmail.com>
Date:   Wed, 28 Aug 2019 23:16:42 +1000
Message-ID: <CAFXWsS89-fB=LGLRpeSrH8Y97=fqhZ7d77WORjXdS1YU5Xbfsg@mail.gmail.com>
Subject: Re: [PATCH v2] gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot
 option and blacklist
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Aug 2019 at 22:21, Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 28-08-19 14:20, Hans de Goede wrote:
> > Hi,
> >
> > On 28-08-19 13:37, Andy Shevchenko wrote:
> >> On Tue, Aug 27, 2019 at 10:28:35PM +0200, Hans de Goede wrote:
> >>> Another day; another DSDT bug we need to workaround...
> >>>
> >>> Since commit ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events
> >>> at least once on boot") we call _AEI edge handlers at boot.
> >>>
> >>> In some rare cases this causes problems. One example of this is the Minix
> >>> Neo Z83-4 mini PC, this device has a clear DSDT bug where it has some copy
> >>> and pasted code for dealing with Micro USB-B connector host/device role
> >>> switching, while the mini PC does not even have a micro-USB connector.
> >>> This code, which should not be there, messes with the DDC data pin from
> >>> the HDMI connector (switching it to GPIO mode) breaking HDMI support.
> >>>
> >>> To avoid problems like this, this commit adds a new
> >>> gpiolib_acpi.run_edge_events_on_boot kernel commandline option, which
> >>> allows disabling the running of _AEI edge event handlers at boot.
> >>>
> >>> The default value is -1/auto which uses a DMI based blacklist, the initial
> >>> version of this blacklist contains the Neo Z83-4 fixing the HDMI breakage.
> >>
> >> Thank you!
> >>
> >> Assuming it works for Ian,
> >> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >
> > Note I have access to a Minix Neo Z83-4 myself now and I did test that
> > this fixes it and that passing gpiolib_acpi.run_edge_events_on_boot=0
> > breaks HDMI again (so the option works).
>
> Erm that should be gpiolib_acpi.run_edge_events_on_boot=1 (not 0) breaks
> HDMI.
>

Many thanks again Hans. I've also tested the patch including the various command
line options on my MINIX Z83-4 and they work fine.

Best regards,
Ian
