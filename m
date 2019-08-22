Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802F09A188
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 22:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbfHVU5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 16:57:04 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37879 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730991AbfHVU5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 16:57:03 -0400
Received: by mail-wm1-f65.google.com with SMTP id d16so7069016wme.2
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 13:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=0i/B4N1uUKn39gW6CKzddRGMqMAE8IUJXmHV1krCefk=;
        b=MQoTf0CNTOfPpdGgQIw1Qoa+j5lhFoCBD3FnKzfD8v9JyT36iEpe0vazfsyD6UUUoT
         6Q/NAX3Ga5cxiidDc7eULxB6fRG19wLt2M5qTHiQAt0PhSyvvKfuh7eC1Baphrk7vuJY
         huwpDUC+sHCKF1uStl0+NEvcPLpvhk5MptS7KtkiRO7jqKphWeHfEwYnOsJjGI5oK9KA
         iGTsKg7OXyZXJStVjTrw0tlOKVGlrs8c7FHGsYn2p0HJFTOm7ERvG45Khz45mwxLV30R
         2R1ukYfgI0FFidF+laS2B2W63Nn7HN7CkxpTMr5paytJ5t31Zm2khmQKDLu10n/Fvqkw
         QMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=0i/B4N1uUKn39gW6CKzddRGMqMAE8IUJXmHV1krCefk=;
        b=V5f4TQK+1WNPJmXe2LN5xESy1IF0xNpVMmWeQwJMjL9IQtuhuDtaPc1/MCgw/4/mCc
         cLs8Q21bNIjepjJSOxVldecVKV3UPctd9tTIL1UTkgyeoWoSiJgjfnAnpkCO4lHjDCMD
         z7TMprLVDNX6az93F+qrnxRHjlY2hfvQiQ9Xo/C3KSYkTLgeBcL1gqTn4yya52uUn9p7
         NlDFdagZ7khdyTFTXrFF6D3JnKrYU1aR45spxxYd4/Zk5tB4Szrlrf3QVEloxh5Iw5Lq
         wzN2D0O64yU5WoOXhms4XU5s82S9vncddVO7jL1jmnzbRAajImMLvtXQMCUIErzxKqWq
         i+pg==
X-Gm-Message-State: APjAAAU3AAUkfy+KRPVdIwEmZgwSgx2O33u1Jb8RItBDc5WVTHlK4OqQ
        JYfNHQJV4GTwK71chscicoxQWA==
X-Google-Smtp-Source: APXvYqzB7f93pdfLt5YiBg84OdSMi/XbAxwmp7RD70TCXmIntNUoS9bbCF97+nQKjlJzM5DmAdAQIQ==
X-Received: by 2002:a1c:541e:: with SMTP id i30mr1043918wmb.54.1566507421427;
        Thu, 22 Aug 2019 13:57:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 39sm2019758wrc.45.2019.08.22.13.57.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 13:57:00 -0700 (PDT)
Message-ID: <5d5f019c.1c69fb81.b6100.a526@mx.google.com>
Date:   Thu, 22 Aug 2019 13:57:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.9-136-g6451706234b4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 134 boots: 0 failed, 114 passed with 18 offline=
, 1 untried/unknown, 1 conflict (v5.2.9-136-g6451706234b4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.9-136-g6451706234b4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.9-136-g6451706234b4/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.9-136-g6451706234b4
Git Commit: 6451706234b494afc737f64c0b442d6594c4ccf9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 27 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
