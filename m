Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A16162C7D
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 18:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgBRRTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 12:19:01 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41239 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgBRRTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 12:19:01 -0500
Received: by mail-pl1-f195.google.com with SMTP id t14so8337590plr.8
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 09:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ZWlQ1WjSgxA8I4ZY+yApt3ugQrYnwUE+3N99MUezcM0=;
        b=UwFbv5bi3bE75iKX5zzcsmKcVRLqjL5E4AvkAlKZ73z1axVtt1IFjpF/0MOkyHMmAs
         X9p2WgRVtQ2ObKETCtMyl0I1vh0AQdPPpZ648/GPGE1YbtAET6ksbsFftQUqW82U8LjI
         OERBQ19crtH/fY8cQ1pwlK17WjVVTtNlJBbAAX/IO0SE+wo67Dnrbe2Y8Zhqa1rIxSr8
         2kK57PN29rhvcYTL4kJCdXWTWMNGk5HJEepK9tY9rki5otdlJCo7P77+VySq6ASBymmE
         i7+dwSRmpmQi5Um3oVr/3xPqrZPWF/0nZnXqYko1+mId/GhOAd6ZBzTFJ3GbTG4VC3Bd
         ywYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=ZWlQ1WjSgxA8I4ZY+yApt3ugQrYnwUE+3N99MUezcM0=;
        b=WX0U7ehwvL9IEVtCh+3OZysfuky43+6TrCnqFd6tAMwt5LbX7FqJC448iGT1d0fsn9
         1mOIU3og5HEtFdWPl8ZC7gmA2jKTn9sjQuwQcB5aB/rBKKcVjg/QOb9JZQiMnS0l4MDu
         CEc91wrz3+W3s//yiwd5MvhybbLi6w/nLedBOqUbeVDsBhZLYyDlZNYELO+OsqwzzjrX
         3LpIo7wkAAxl1ItW0wpdOY8rl2zv1rCxt61/KTq8ucOK3ji9ahQAqsubwi6K/MHUpW3+
         SsLIhB78Oh/b+pZFxH8TgRIX6G4zQp6DNdz8ba1CIRrfTIyng+1Z8TvFKaPqFLOdkcS8
         T/xw==
X-Gm-Message-State: APjAAAUgRCcvvsTHaQ6UBxQjC1LiPx1sM3eRG6zOM4ac03jt7af+qOmL
        +ZQ8LjdB0BT5PMErl/+iBarw71Jj
X-Google-Smtp-Source: APXvYqxmkdaRI2jVVq9qvZOmjP+pgVq5HNAizl8F8FXSgTO/fyR/RUygOQqSjXFt5Upa+ppfyaLh0A==
X-Received: by 2002:a17:90b:4382:: with SMTP id in2mr3926709pjb.29.1582046339581;
        Tue, 18 Feb 2020 09:18:59 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a5sm3786736pjh.7.2020.02.18.09.18.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Feb 2020 09:18:58 -0800 (PST)
Date:   Tue, 18 Feb 2020 09:18:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Subject: mmc patches for v5.4.y, v5.5.y
Message-ID: <20200218171857.GA25822@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

please apply the following two patches to v5.4.y and v5.5.y to fix a
problem when trying to boot various pxa machines from MMC.

d3a5bcb4a17f gpio: add gpiod_toggle_active_low()
9073d10b0989 mmc: core: Rework wp-gpio handling

The second patch fixes the problem, the first patch is necessary for the
second patch to compile.

Background: Commit 9073d10b0989 claims "No functional changes intended".
However, it does include the following functional code change.

--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -740,16 +740,16 @@ static int pxamci_probe(struct platform_device *pdev)
                        goto out;
                }

+               if (!host->pdata->gpio_card_ro_invert)
+                       mmc->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
+
                ret = mmc_gpiod_request_ro(mmc, "wp", 0, 0, NULL);
                if (ret && ret != -ENOENT) {
                        dev_err(dev, "Failed requesting gpio_ro\n");
                        goto out;
                }
-               if (!ret) {
+               if (!ret)
                        host->use_ro_gpio = true;
-                       mmc->caps2 |= host->pdata->gpio_card_ro_invert ?
-                               0 : MMC_CAP2_RO_ACTIVE_HIGH;
-               }

This _is_ a functional change: Previously, if there was no "ro" gpio
pin, caps2 was never updated to active-high. This can have the practical
effect of making the the card read-only, thus preventing the system
from booting if it was mounted (and expected to be mounted) read-write.
This is seen when trying to boot "spitz" and similar qemu machines from
mmc.

I bisected the problem to commit c914a27c92f91 ("mmc: pxamci: Support
getting GPIO descs for RO and WP), affecting v5.0 and later kernels.

Thanks,
Guenter
