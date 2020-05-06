Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147021C7461
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 17:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgEFPXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 11:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729704AbgEFPXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 11:23:33 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89AFC061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 08:23:33 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s18so909289pgl.12
        for <stable@vger.kernel.org>; Wed, 06 May 2020 08:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RNJricoYk+i9m84RJzbJAB8gJIwOz2Zkm/krTZQILPU=;
        b=QSO8513lb0eUBxnR5Egko4DsN9Xidugcc2RLhgxvBy8iazJvvcSMoebio2y+Nae0Ar
         ITpME67tURk1Nvy06Vanv3PnEitfF19jL8CiinDyM9y5Bf7eqCsvsdf83rD2eB5Msd38
         9EXZ9stb3dT/MLd3fUkTm0zMdbEJRB51DYm8tMP2osxk1JUE8LVryizbRt++EIDMFqhF
         SBPTkPRaEIma9zrPvYuT7Rx5ZqQRXkaTNx+hoeUXw17neVkckZK7zZ/5+LMBC6roWsYr
         HH7MjCNApgm+ZOxqYGM+hlBoortcUWI8ws/oDoKUuC7qzhGWIlshg2KxbuNuDHN14kU+
         22NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RNJricoYk+i9m84RJzbJAB8gJIwOz2Zkm/krTZQILPU=;
        b=HeNKxNsWiK+WCqe5Or1pB8YLx4R5NUEpPEh6MziDyPBKhF0UTR9HdWNcSSa+b6ql1e
         QMbQntUaFL3o+NKkiTI29+MCQ/FnD2f+5z/oofxfbkjxdZp/gI2IxI8w1iGQc3YwOLyJ
         VUxSCQnF4pMcd698ZoznEfNz1Z+1oKR7gpHA2QE9EZUA45pXZ+96fQGMjuO700Jc36mW
         lsvYy7lgW03rFsKvzroyk/lLCA0u+zwr7VlM0s6u1NXm8OSbZus1IKWpYilFJMcB9gvx
         ZkUbZ+Mov8g9ZR7LDRmORSU5tEUsWIyD2Z7lyeZFJL1RVNPJvowRb6S+2DDiCvlkyMdt
         oBiw==
X-Gm-Message-State: AGi0Pub790zqkfjSDq0ejOUwnBYq5zszdJs0ZdUsCN1aCtDQjKaRSsQ8
        x4nb30WOvfQvjAjwymZ2+WRRCh0WKrbt/g==
X-Google-Smtp-Source: APiQypIC2pjgK5VIYtPbAVs7qP+vJ7aqCfaFk5M5zEiqgWUZZgziTnegTPYZT3QjpJBjCXl2W94f6w==
X-Received: by 2002:a62:35c1:: with SMTP id c184mr8093955pfa.120.1588778612946;
        Wed, 06 May 2020 08:23:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c124sm2081600pfb.187.2020.05.06.08.23.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 08:23:32 -0700 (PDT)
Message-ID: <5eb2d674.1c69fb81.112bc.68cd@mx.google.com>
Date:   Wed, 06 May 2020 08:23:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.11
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 140 boots: 2 failed,
 131 passed with 5 offline, 2 untried/unknown (v5.6.11)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 140 boots: 2 failed, 131 passed with 5 offline,=
 2 untried/unknown (v5.6.11)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.11/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.11/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.11
Git Commit: aabff12c5db172e726716cdf22c3c55a87a81e2f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 94 unique boards, 24 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v5.6.10-74-g6cd4bcd666c=
d)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            sun50i-a64-pine64-plus: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
