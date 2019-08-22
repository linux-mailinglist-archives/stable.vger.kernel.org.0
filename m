Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72EBD9A320
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 00:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389529AbfHVWkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 18:40:10 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39444 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387670AbfHVWkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 18:40:10 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so4517165pgi.6
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 15:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=A7V2Sg9nWGS4mEo8d+F5LP3wRASvDwa06t/k4Kfsn4c=;
        b=mamCn+a/Uo68O9hwTP6tF/jIVLEPcdbYDfQyMfc4rAF+9SrmgMbgAFD/mNNx34KDpR
         lhqWIT8vhcMYcDyZSMods1POj2vZhr3WE2mOrHID0TFjhRGJ+Mg/u72jLsVRohUdqpaT
         FYFQNchICUoX7BJH1RIx/dy2j2hOztOUMGio+J5SYgoQpNXhwXE2xiCtte+c6kGjlK+6
         kdMmtpWOKYPbHGnkZZgfIWN88HTOOpsFGxr4D0bEF+p/S5d4060GLU+3S/gFPkh1Z/hZ
         WR1gwi0QAUOPgWH63Ks03+h9fZbVWRCGVwLPIQSB7eUuAgxW8RzjLkcoNZqGR1KxmKJD
         7a7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=A7V2Sg9nWGS4mEo8d+F5LP3wRASvDwa06t/k4Kfsn4c=;
        b=exDgnj+6nqXNkV+yC9/EwGe9jQYP1Lc+CupbforjTADJd7ui7kM27xaT8dPM95kb2P
         D1odVpWEIyjZGuawCCoZ8ZztadCWYTd5Og9XuHjlLVKM8CPgZWxIIEpD5UsoTqmzx8VH
         ygNLYfK4KyaqhwRIxdU964HYPbode2hwDplZjqRJVbPdLblv5ggzbSaK87EWXUOiE0ms
         hCyrQKXbrDPI5O1WEVGBK63ktJwXzOrkWZjv07jMTY/F/Xi4DB3kClxv3Hlz8HuOnKuf
         /r59+CQasfFo+fMWzKzudwwLVsPEJpxd1U7fH2fSaA5kItrYMSItrG4mEoCpCCTSe/P8
         t48Q==
X-Gm-Message-State: APjAAAXfhVpwo4ir9Om+XcZYbi+iFMuX+1u6DOkjiDyAEG5qqtoPFxOE
        OlJ/rg91esG728EqvH0kB5ZSSQ==
X-Google-Smtp-Source: APXvYqxjTnO7ypHTwAHQ1H/iNIsZYjYQSlWvjpLw3u/pWZZ1QeYIz/eRYc0oq1GWblzmbv1EVhONHA==
X-Received: by 2002:a17:90a:bf01:: with SMTP id c1mr2087251pjs.30.1566513609917;
        Thu, 22 Aug 2019 15:40:09 -0700 (PDT)
Received: from localhost ([2601:602:9200:a1a5:89d4:68d1:fc04:721])
        by smtp.gmail.com with ESMTPSA id o24sm465918pjq.8.2019.08.22.15.40.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 22 Aug 2019 15:40:09 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     "kernelci.org bot" <bot@kernelci.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, gtucker@collabora.com
Subject: Re: [PATCH 4.4 00/78] 4.4.190-stable review
In-Reply-To: <5d5f064c.1c69fb81.e96ef.73f5@mx.google.com>
References: <20190822171832.012773482@linuxfoundation.org> <5d5f064c.1c69fb81.e96ef.73f5@mx.google.com>
Date:   Thu, 22 Aug 2019 15:40:08 -0700
Message-ID: <7himqo259z.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"kernelci.org bot" <bot@kernelci.org> writes:

> stable-rc/linux-4.4.y boot: 101 boots: 2 failed, 84 passed with 12 offline, 2 untried/unknown, 1 conflict (v4.4.189-79-gf18b2d12bf91)

TL;DR;  All is well.

> Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.189-79-gf18b2d12bf91/
> Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y/kernel/v4.4.189-79-gf18b2d12bf91/
>
> Tree: stable-rc
> Branch: linux-4.4.y
> Git Describe: v4.4.189-79-gf18b2d12bf91
> Git Commit: f18b2d12bf9162bef0b051e6300b389a674f68e1
> Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Tested: 47 unique boards, 19 SoC families, 14 builds out of 190
>
> Boot Regressions Detected:
>
> arm:
>
>     bcm2835_defconfig:
>         gcc-8:
>           bcm2835-rpi-b:
>               lab-baylibre-seattle: failing since 1 day (last pass: v4.4.189-75-g138891b71be5 - first fail: v4.4.189-80-gae3cc2f8a3ef)
>
>     multi_v7_defconfig:
>         gcc-8:
>           exynos5800-peach-pi:
>               lab-collabora: new failure (last pass: v4.4.189-80-gae3cc2f8a3ef)
>
>     qcom_defconfig:
>         gcc-8:
>           qcom-apq8064-cm-qs600:
>               lab-baylibre-seattle: failing since 7 days (last pass: v4.4.189 - first fail: v4.4.189-32-g35ba3146be27)
>           qcom-apq8064-ifc6410:
>               lab-baylibre-seattle: failing since 7 days (last pass: v4.4.189 - first fail: v4.4.189-32-g35ba3146be27)
>
>     sama5_defconfig:
>         gcc-8:
>           at91-sama5d4_xplained:
>               lab-baylibre-seattle: failing since 1 day (last pass: v4.4.189-75-g138891b71be5 - first fail: v4.4.189-80-gae3cc2f8a3ef)

Hmm, something's terribly wrong with our regression checker as these did
not fail at all in this boot run.  We'll check into this.

> Boot Failures Detected:
>
> arm64:
>     defconfig:
>         gcc-8:
>             qcom-qdf2400: 1 failed lab

This one looks like the boot firmware is not even starting the kernel.
The Linaro/LKFT lab folks will need to have a look.

> arm:
>     multi_v7_defconfig:
>         gcc-8:
>             stih410-b2120: 1 failed lab

This board should be blacklisted for v4.4, I just fixed that.

Kevin
