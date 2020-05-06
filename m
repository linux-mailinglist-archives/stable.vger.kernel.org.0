Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5011E1C7B86
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 22:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgEFUuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 16:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728733AbgEFUui (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 16:50:38 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC1CC061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 13:50:38 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a5so1567854pjh.2
        for <stable@vger.kernel.org>; Wed, 06 May 2020 13:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JkV15PIDM8lmq1J9EXvmr/LP4uIn5L6IhlgJBPq1pjo=;
        b=PLxsFmz0PB3/thnjKFA6PG5V5ye5u1gixbGTPYCzhk+psFT6NK55QjUElVD5jR9Jm2
         apnU3EoIhbrXo/JfCJpE8GCAh+ZhTKYHtPB2+5z5JMpLVmzlunYjwB7LaRmMau19X4ZO
         DSx9x46t2ajhQsgtgpeP83VGLfnsFErwPT4JHxPh+gsh01G1szgbkAxdIRx9FCSfxK3I
         9V5F8QrET1eJU4mQlHYjXD7xPxYJ8yDw7cTyaRRb4Tr+n5LObnJCW65kw9N33qhQVuR2
         pHfW4rLa2/+lrHvHpUNun7joOvIDoOeD/Spv8qx8BBfgAnyy50H4tIEE6EKmD2n23R+p
         sJAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JkV15PIDM8lmq1J9EXvmr/LP4uIn5L6IhlgJBPq1pjo=;
        b=lcBw7rpdoHfdNQe0Bhe90VtFY9ygQAZSnyWcJ9MXeMlxfe1vantJUOPToL9jCjki/R
         PYSUag3thenvkXE87ytw9gILPY/vEVw3nDV6ueKGngP1Z68u0M6clgWRoBSSpmoH8lio
         Eq7zsdOSENUcmgNhXcHYb4HYJYzvUeVj8qcu0Z8mx/kPvPo/upQ6CxngfFwRKFAr0byh
         KTJcFnNaSN5favTrHXtJBM2bjWXnUN9jEewvC6fyvNsc18xOLxsHzoSyJIR9b8hYbSqh
         QHRAikw1YPhmnKIydmrZ/dhIyfn56tIIaRPFkQDBebA29WchZQkRCbsreVG75vuFk4i5
         1ORg==
X-Gm-Message-State: AGi0PubeKw+WjqSoz4MPjofwBIExU19WXMQJ7hTFVt3CnzuqYhsQ0hl8
        pSLTM0TqevdMwjdlkIuDKQjf46qBRPCBlw==
X-Google-Smtp-Source: APiQypJh5wNEpzt4APBTR6r448cSerChFHRSCgNHYNulGyjx1In+oiARAhDnOp9AJhumW6VzT5fwSA==
X-Received: by 2002:a17:90a:284e:: with SMTP id p14mr11981640pjf.10.1588798237725;
        Wed, 06 May 2020 13:50:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e135sm2713425pfh.37.2020.05.06.13.50.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 13:50:37 -0700 (PDT)
Message-ID: <5eb3231d.1c69fb81.34f79.8a75@mx.google.com>
Date:   Wed, 06 May 2020 13:50:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.179
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 133 boots: 3 failed,
 118 passed with 5 offline, 7 untried/unknown (v4.14.179)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 133 boots: 3 failed, 118 passed with 5 offline=
, 7 untried/unknown (v4.14.179)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.179/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.179/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.179
Git Commit: d71f695ce745df9544a85d8a762f16d72e72df00
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 20 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre: new failure (last pass: v4.14.178-27-g6d39cf919=
746)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 88 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 76 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.178-27-g6d39cf91=
9746)

arm64:

    defconfig:
        gcc-8:
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v4.14.178-27-g6d39cf919=
746)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

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
