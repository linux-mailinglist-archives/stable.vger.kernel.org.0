Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C8F195EF
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 02:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfEJAHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 20:07:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43368 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbfEJAHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 20:07:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id r4so5332077wro.10
        for <stable@vger.kernel.org>; Thu, 09 May 2019 17:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=x/CXGRp80IRiXeAmAwY4ABp5f377aFe0bLcL5F214gE=;
        b=zm7hjnBWdxRz8c7snZRskGOs1vLkqvVfnT0vVKjhAKFq8NC62YJR+yasZjfxGLV6UT
         UCyUOOFzTMbYBWfsDD+Zr9K6/iX3IEvrmpxobfIYO1jjB24JPxulhwOQfpMBjcuixMLY
         fIaVNiX1YPChBlGvKvLl9lO21Uv1o1JJCDJxTZtbTIalLy4vLXzUvm9neO+p5T9YVXsg
         sPOHOIfewBUcanaEOnzU+I+LIiKf/QYjw2NPEifXmDeZG2ad4IqZ37py2m2a7Nq2TcaP
         3eeh6if3CU0BktRmj1YsLN8DXwg2zuuLwf3332LUca6TopfLZMOdGOi00dGDYkZmA3Q+
         ndAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=x/CXGRp80IRiXeAmAwY4ABp5f377aFe0bLcL5F214gE=;
        b=l1Fyk68kIEpsc5XUAEw9ccih/8mR7HtA+5hUjaSgvil4KaxeHhacVjO8YRD9W7rwni
         nzR2c3s/Ujr6IBiU9eaSQencmPdvCj+nqjGChr+BA2rEHC+o2khORQEKs5IGY3yoKfqm
         CRXq4LQMb9TRvj/EizEortK2iEWyLY6RUc3aV4O8waYncQflAc+omlLNbiiBqRaM1n32
         UBEJe4NTUcOCaMUSOsnseEgxO2i2UuaIwb8skl9l7RkFc60ws/qrpGnsr9uWy9DBa7ec
         s+YVD0WrN7Nc6UmSu4FTC4GT7fu5Ge0UyFaM9CHWwoGlZ1HAY4c+4B72fkehuqcIan9N
         0AQA==
X-Gm-Message-State: APjAAAVHNaC/WwSYSXjAtrrU3wlSn/Ouw/32L72+LoY3r6iJTyxM3dlK
        cERjCvXMzsf9yTUm4IkK6Tw54uBXvA/5EQ==
X-Google-Smtp-Source: APXvYqw8TyNbsxwv8pfcxINOYbZZdRhwzpvv30ozame/EW/8EJOBSC5fqlVypo8Zm1YUlheuC2LpRA==
X-Received: by 2002:a5d:4d46:: with SMTP id a6mr5503966wru.142.1557446834027;
        Thu, 09 May 2019 17:07:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g10sm2273532wrq.2.2019.05.09.17.07.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 17:07:13 -0700 (PDT)
Message-ID: <5cd4c0b1.1c69fb81.2bb79.a649@mx.google.com>
Date:   Thu, 09 May 2019 17:07:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.41-67-g82fd2fd59cff
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/66] 4.19.42-stable review
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

stable-rc/linux-4.19.y boot: 135 boots: 1 failed, 132 passed with 2 conflic=
ts (v4.19.41-67-g82fd2fd59cff)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.41-67-g82fd2fd59cff/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.41-67-g82fd2fd59cff/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.41-67-g82fd2fd59cff
Git Commit: 82fd2fd59cffa3045f205da555c0defe8bb35912
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 25 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.19.40-100-gf=
897c76a347c - first fail: v4.19.41)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-collabora: new failure (last pass: v4.19.41-56-g487b15502=
665)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
