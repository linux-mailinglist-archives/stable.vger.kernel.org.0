Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8D3CB4B5
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 09:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387533AbfJDHBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 03:01:06 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36739 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387623AbfJDHBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 03:01:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id y19so5696749wrd.3
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 00:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Jc/WrDTffdzMOLmQCIoEtNdtkjgf6yNFeVahnwheomA=;
        b=bzEXD4sBdyP+iLfO9xnq99BYTVpfWbDxhxam3qyEl4lk175w0CrsdanhXfss7flWcN
         zEdYLo4Pt9WjuimTbDv+ovi8OIkosoNROOGJkj0d24LcruisVbBYPxd3qh0so9IJk8Ea
         5nrrH38DjiBGIR3npe4mttmKntA7BpNRyZkuXzLWjTnscqAXMrx/fO2T/8CHbGHwqAEB
         3BsYrW/H8ZT0gswQwBmZjhYyhfXsWjceE8dU1afoNs1kdcyEXXqCwXIwTjfVyFrYLe9i
         hFdsteRWALu18gwJ6PJ3V0euEXBv39WTSUf78rci9aF1mHEeTinhPwfd/9XCjRU6DW9a
         h2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Jc/WrDTffdzMOLmQCIoEtNdtkjgf6yNFeVahnwheomA=;
        b=o2CbEStCxXhpNcvaVloAgsKM4xV8NwfyCjj9jXsxgXCuWilkZ6qLA+UAK6vKPjcdd7
         /qkrdZTR3X0uEUBK54YHp/FGZN1MjNjPzU3Hbrh5s08M0lwC3I05yE+ABIsklxFhGnqp
         131fAYeIm6UMsS81i1jk7QzOYKS5kDUOy5n1ABK48H2cCOjGSOZX3ab8tVnR1393e2ve
         LiatFjrllX6bIJAPcoQjMg5//rIJaXh2BqJV/PiUaK+EiNf53wL/vSmzASoLiBlreKAl
         WuqwO8X0HxUYF79qR9Y5bBqIxNMskRqs2+p5ZCYpzLfmrmOvqOiGmKfvM9lWlrkk3hSy
         gWDw==
X-Gm-Message-State: APjAAAWKmTraeiqkzwRMq2xz5HTTbKPefuaJwL4tixdNL6Csm9hudTGf
        4BoQKk8nk+UTFrbtzy1IybPdfA==
X-Google-Smtp-Source: APXvYqwhYCcMQldMQo77du5ARRj7J5UzwBdXjn6Laoh7sQAzd4HRTmI+vGvm/uz69ancRxlG0jDaQQ==
X-Received: by 2002:a5d:5270:: with SMTP id l16mr10656378wrc.105.1570172462271;
        Fri, 04 Oct 2019 00:01:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w125sm8566712wmg.32.2019.10.04.00.01.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 00:01:01 -0700 (PDT)
Message-ID: <5d96ee2d.1c69fb81.6b8e2.7a8e@mx.google.com>
Date:   Fri, 04 Oct 2019 00:01:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.194-130-gc1fc11455620
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
Subject: Re: [PATCH 4.9 000/129] 4.9.195-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 99 boots: 0 failed, 86 passed with 13 offline (=
v4.9.194-130-gc1fc11455620)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.194-130-gc1fc11455620/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.194-130-gc1fc11455620/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.194-130-gc1fc11455620
Git Commit: c1fc114556201dc059e2c202e99eac038af8495e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 20 SoC families, 13 builds out of 197

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
