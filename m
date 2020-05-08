Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63EF1CB7ED
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 21:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgEHTJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 15:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHTJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 15:09:15 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A05C061A0C
        for <stable@vger.kernel.org>; Fri,  8 May 2020 12:09:15 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mq3so4726954pjb.1
        for <stable@vger.kernel.org>; Fri, 08 May 2020 12:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yzY8TnVKTZv/Td8Boyy1pRy0nYmnXhSxnDaTtSWoyR8=;
        b=w0s4i9cG4SnYnth9ksThyeZQ9wbwcfxinSbsee0IThWC+pU2RbPwQXkZ6XePIMHN/b
         c5KfAuQw5bNv8C80r1FoUwVFZSxyY3wIf+9elNLhsMgDG/LrvH89ys2wLSjmJKwJw3BG
         bTkZRdxxxJVexdqnEytAnoCtGVsnlLoL0ndAoGEbsNrkwP2HaYD4VbRG20gV+xOz6d+b
         WWLfkGNxUMe2ba2pCUHXuQY3xCUuGEtToEyQTx3LQ05/ewtVjMn2RhcCWo/nbOfcmNfp
         74fELQ2vuKL3uhctzZP28EkmXSVAcmTSqScv/oCKn3zv6JqrjK5P9maQWTmb56mtFnap
         4LsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yzY8TnVKTZv/Td8Boyy1pRy0nYmnXhSxnDaTtSWoyR8=;
        b=aqs3qE+6xbecLZArnwcenIhCr9k/ilzxOtu8DLbyRXHXyxC9+aU91L+bB1A3L/Glo6
         V24Jdtb/WjRuFzfTgc4MRhXb61upMQr+wXecpPUfI1xDiTGBd5ghrDNbBmSFV9VTK0op
         j5vdXSbAjbgzerpagE1BomJJDyxsI8wnHsd0gAiIx1q5jl9xDu9G93MaOW6Hp9fP9TW8
         5gd5OAvG3m5B8Przx7uvtgQCqm9Qj1XisJnG3WJfAz47Lx/epXKR6wRddo9Dnv45VBLc
         odVxN4Neohe2e5eING7yrWOS6+Pw4Us6WgT2A6MgjnFCwzNTuJe0O8DgGvV5QPWTGmty
         NNAw==
X-Gm-Message-State: AGi0PuaSV2I8SMLr2H3QfokS2BlVjF/KNTgelGw9D0QQhhwjGRJb0XDL
        aGJDSEcRxDzHhnKRJxFwC0FJpSn08e8=
X-Google-Smtp-Source: APiQypIIpwQojeNWwPYyDaUh3WXfzVCaLfWFgk2uZqQRRyguh7rUcHQyYOzcQH+0ZtRpesfsmGaPNw==
X-Received: by 2002:a17:902:9882:: with SMTP id s2mr3739325plp.184.1588964954413;
        Fri, 08 May 2020 12:09:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p2sm1829310pgh.25.2020.05.08.12.09.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 12:09:13 -0700 (PDT)
Message-ID: <5eb5ae59.1c69fb81.99bdb.70b3@mx.google.com>
Date:   Fri, 08 May 2020 12:09:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.222-19-g7d23d52af97e
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 80 boots: 0 failed,
 72 passed with 5 offline, 3 untried/unknown (v4.9.222-19-g7d23d52af97e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 80 boots: 0 failed, 72 passed with 5 offline, 3=
 untried/unknown (v4.9.222-19-g7d23d52af97e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.222-19-g7d23d52af97e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.222-19-g7d23d52af97e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.222-19-g7d23d52af97e
Git Commit: 7d23d52af97eef655fac0057e12d85ce7d4894c3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 16 SoC families, 18 builds out of 196

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-cubieboard2:
              lab-clabbe: new failure (last pass: v4.9.222)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 90 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
