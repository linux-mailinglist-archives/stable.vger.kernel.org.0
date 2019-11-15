Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E568FDD4F
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 13:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfKOMUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 07:20:06 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46262 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbfKOMUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 07:20:06 -0500
Received: by mail-wr1-f68.google.com with SMTP id b3so10741728wrs.13
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 04:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=NBITj17KIDDQ/wzdId3cQD3bmEwVbK2XADeS/shNAmE=;
        b=aA0SMJqxZ5qcVRg+Rexn4IUDhZEFaMChYd9AwPuKUGLa9qL+xmKhDupbAKhCCvks4o
         fCOKnxLnPDDOw/51wdM8v81Q2bCibCu6/z/9U2K8fnvi42KWtW0siAoAzx4s8j7aCIuU
         0VCQRonwNfB0R2bQvytQKWcaeM7x8H3NwFQ8mw1BEx5T1Jv+hFDLAhbPQldkreXTshHC
         FyrGdYBd17ZKus/LpSAsH9zscydFiIwAfcr3MR190/DirJIBMCtPeNyi+z+mLd0pDAIL
         cFepH6QXLOvJmi3sDRtfqBdqQx76aZDwfKHAm6gxOGqpdQc02xqpuX6I+NoW2YMW0877
         kk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=NBITj17KIDDQ/wzdId3cQD3bmEwVbK2XADeS/shNAmE=;
        b=mVlLdisoKj4EBEnPdqHzOtmRgMDJGZJLgTHBhHyY+xvyjN60KsVNkfCRALU1EtZ7OB
         ANidsXlDPIy7jzzZ6+YY1S9OOXRsBt0RvSQeCGlNtouDSLE5DNDhFlquzLKJj47nZD6P
         YKOR1HoVdN5ofe1YWejIPbZvzFyH/umzFzkTLyzaILPEdikUaRVmP0qgQpKihc6aylLo
         aMAmZvdfcC86Lr2IJ0XNvXevGvcdgnfKkXevgfRjpbSTCR/SxpMdVsDriQ9UjBJwxuT1
         o6b2XTE/amWN2FzFPmC0kVIJ2506NT9swvb5hwUS4ThO5u5SSS6Jd2D+WVRnEL0wK2Vt
         1UWA==
X-Gm-Message-State: APjAAAUKF58H/0x5fvZgaqYCii1HFnaeoFpwkHUyRhiXEAGMUDKaFb0Q
        3HHQnrl3dzPMYe6b/1WiU+k7Dg==
X-Google-Smtp-Source: APXvYqyHejg2wpDCQ5Xb/fga24iRY4A1buPXc45rZpw01kmq5mw3Gd43YdLn2qDVw5DFt6a2GDzDmA==
X-Received: by 2002:adf:e60e:: with SMTP id p14mr15982979wrm.249.1573820404646;
        Fri, 15 Nov 2019 04:20:04 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y16sm11276365wro.25.2019.11.15.04.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 04:20:03 -0800 (PST)
Message-ID: <5dce97f3.1c69fb81.6633c.685c@mx.google.com>
Date:   Fri, 15 Nov 2019 04:20:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.201-21-gb0074e36d782
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
Subject: Re: [PATCH 4.4 00/20] 4.4.202-stable review
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

stable-rc/linux-4.4.y boot: 80 boots: 1 failed, 75 passed with 3 offline, 1=
 conflict (v4.4.201-21-gb0074e36d782)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.201-21-gb0074e36d782/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.201-21-gb0074e36d782/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.201-21-gb0074e36d782
Git Commit: b0074e36d782e84e6a2e08910103642762949d2b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 17 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v4.4.201)

Boot Failure Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            bcm4708-smartrg-sr400ac: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
