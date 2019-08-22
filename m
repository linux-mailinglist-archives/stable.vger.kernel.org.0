Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F82999992
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 18:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbfHVQvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 12:51:41 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45879 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730214AbfHVQvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 12:51:40 -0400
Received: by mail-qk1-f196.google.com with SMTP id m2so5722963qki.12
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 09:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fALdrDCxue4VKel6Wk07qgTKZ9dDtwP3hCE5W1IdFsg=;
        b=C49Z6dJFN0R8PAVFHI7oqRyQg5udCqiz3D/djcSs+gdtPJ3Pn7HQHO00BgVkvslTp1
         LgLRqC9Zco1QWsWYswuXu8FxSGce6EufjUOjLZ5ML2qHGXe4sv3LZyz+lNDGNt7OaXIa
         HP6lXtkphSfqQwFDq9gZRmuLOs6aJtcbPLhnStqbmpOAglBw+Y5M4PnhStc6dDpzcxws
         ZFCV4VXG2a0RRxrkz4g9y8sk+1GTA18jjA16YZCjXRmFC/EWv0HcN1OAtDzsUi48o2Q9
         ovU3KI85eXSfc3gW65A9BAehuohN33pUWnUx+6oJB2hhff/G64W0n48ecmvzY4Mx/wdb
         SUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fALdrDCxue4VKel6Wk07qgTKZ9dDtwP3hCE5W1IdFsg=;
        b=sszUzj2cV1jGTsNV2jdh9w+aPlCJO9P7FAvn8kX+jXsgdF4aVDoZKm4SnvmhzJ5ykY
         N9jNsg0Cho6nBjt69/+FJrXmuoLu+EJBTnX2hbFjw5+/9w/3WxTUGvXjv7wqJ8qLa45l
         t15XspQeSGksth9Mbf+axlHLS/GGIi7sDIxIlzRqItCENlu3VwgiEdTSC9KLtMWAPp8d
         Ha3sQ9inpsKFHoDBEr5BQNbZRmNFR7rxkBBYAr4v4qMIP0ip7BbZ7+0lAqLrpz6RYjRr
         9rcu1XoDDCMU+YxFXpwBYLWL5YXI96wdEzUQB5im9fsnVhhXlJosQroNYrTQWe3Kl3zM
         Nj3A==
X-Gm-Message-State: APjAAAV4iZGl4xMSDqfDU4Stg3wAnH9ySe3L6E4poI25oFmEHtSuQuMp
        RxUxJr6bScDTU9Q8U7eqSydlXXqHXkP+/9+45fmciQ6VC2M=
X-Google-Smtp-Source: APXvYqyHYjVx+HhQg98QbicZBACG7KcfROV52TqIe0LwFeF6zATk7mMEAgANqijZONvYECutsPIVUOc2WMk+Y0CH6Yg=
X-Received: by 2002:a37:6007:: with SMTP id u7mr21915968qkb.92.1566492699745;
 Thu, 22 Aug 2019 09:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190822083200.18150-1-jarkko.nikula@linux.intel.com> <20190822090509.GK30120@smile.fi.intel.com>
In-Reply-To: <20190822090509.GK30120@smile.fi.intel.com>
From:   Curtis Malainey <cujomalainey@google.com>
Date:   Thu, 22 Aug 2019 09:51:28 -0700
Message-ID: <CAOReqxjVcOdeT+ii7+ZT4Csi+-1fwO__cOBpAaozs9eRjXRzLQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI / LPSS: Save/restore LPSS private registers also on Lynxpoint
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-acpi@vger.kernel.org,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Curtis Malainey <cujomalainey@chromium.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 2:05 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Thu, Aug 22, 2019 at 11:32:00AM +0300, Jarkko Nikula wrote:
> > My assumption in the commit b53548f9d9e4 ("spi: pxa2xx: Remove LPSS private
> > register restoring during resume") that Intel Lynxpoint and compatible
> > based chipsets may not need LPSS private registers saving and restoring
> > over suspend/resume cycle turned out to be false on Intel Broadwell.
> >
> > Curtis Malainey sent a patch bringing above change back and reported the
> > LPSS SPI Chip Select control was lost over suspend/resume cycle on
> > Broadwell machine.
> >
> > Instead of reverting above commit lets add LPSS private register
> > saving/restoring also for all LPSS SPI, I2C and UART controllers on
> > Lynxpoint and compatible chipset to make sure context is not lost in
> > case nothing else preserves it like firmware or if LPSS is always on.
> >
>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
Tested-by: Curtis Malainey <cujomalainey@chromium.org>

> > Fixes: b53548f9d9e4 ("spi: pxa2xx: Remove LPSS private register restoring during resume")
> > Reported-by: Curtis Malainey <cujomalainey@chromium.org>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> > ---
> >  drivers/acpi/acpi_lpss.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> > index d696f165a50e..60bbc5090abe 100644
> > --- a/drivers/acpi/acpi_lpss.c
> > +++ b/drivers/acpi/acpi_lpss.c
> > @@ -219,12 +219,13 @@ static void bsw_pwm_setup(struct lpss_private_data *pdata)
> >  }
> >
> >  static const struct lpss_device_desc lpt_dev_desc = {
> > -     .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR,
> > +     .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR
> > +                     | LPSS_SAVE_CTX,
> >       .prv_offset = 0x800,
> >  };
> >
> >  static const struct lpss_device_desc lpt_i2c_dev_desc = {
> > -     .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_LTR,
> > +     .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_LTR | LPSS_SAVE_CTX,
> >       .prv_offset = 0x800,
> >  };
> >
> > @@ -236,7 +237,8 @@ static struct property_entry uart_properties[] = {
> >  };
> >
> >  static const struct lpss_device_desc lpt_uart_dev_desc = {
> > -     .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR,
> > +     .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR
> > +                     | LPSS_SAVE_CTX,
> >       .clk_con_id = "baudclk",
> >       .prv_offset = 0x800,
> >       .setup = lpss_uart_setup,
> > --
> > 2.23.0.rc1
> >
>
> --
> With Best Regards,
> Andy Shevchenko
>
>
