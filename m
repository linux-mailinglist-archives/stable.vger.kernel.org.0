Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D441BB83A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 09:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgD1H4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 03:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgD1H4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 03:56:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F290C03C1A9
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 00:56:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a5so782450pjh.2
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 00:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gD6lJCZ5KM9GJrgSOdYTt+BB4AicS74NtxW4/UGv5q4=;
        b=zMUhrl5uyB2YaCu7J6flGiF3xbjztsb9ov3XbGWrZliFtbhCNeuKF/DUySNYLJiY+2
         oIabSlBht/4j9Xu1Lw08hEKCSSDjPrJf1O232XUKa+Yiv5QpKPGyY4M8uv82TeQwSDWY
         Vrgm5x9Vwu9RGrXV2LdSek9WVgPy/ZIYMgGTI1ga/oJAjhPcvaeXFFkRIClZiTTxBEBt
         68xqofs6j4SDVWa5wD47iI6XdlMZvSbphTq+e9CVQWo0Y9eQBVnBT8QD3v4TkU2UmYIS
         Sd5zpxkiM0ftnNHWpEe0jLpcaFTT64ul8Xe51DT4f2OxvX0PxxlmcV++C6e4UXRQfRIn
         hpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gD6lJCZ5KM9GJrgSOdYTt+BB4AicS74NtxW4/UGv5q4=;
        b=mDyXQwpvEM1hfIFfIOnhOC+Ad9V0NJXWQtgjemhfrhaaybqAKs/QedEdxM/SQDbb9p
         FEHhxqhBHL9L3QzGbPc9JAMmn0IbJY1Is9B+8sgeGvcosB5mnaZDiDvrnCK4wsTeVpkk
         Lp8Lv9G0IE/jTA2ifk4AxQebh+VZ0aJRh1Z/7a0jRfV1p48+5i2EwMLk3/trMtkha2pa
         lQDwWHRm+yk1CMdjz9ljnqfOOdHQ5axyIz2cnWnlJKHZAaECdGIa9miSX4LFdJSrhMt0
         8qoRz3H69c68GD3a5UjIIMO0RzfSsRWDJKVPLyACOL7xeIHj/6YFcFerhvfy8xEo8n4x
         trwg==
X-Gm-Message-State: AGi0PuY3IzhAm/op6MZJUGIUpM9f2Q8zjEcAGw964Pm0BaYZPoIHksl8
        fVXsxxW4MuRWg3ygGq+BHu/sKtHnAuc=
X-Google-Smtp-Source: APiQypJg+sKD6f5hHObj3gQ6hm9NGp3Bn6OfGmxcY+tYAujXT/61jqnBTia/0gFuycbO7MDFWygCSw==
X-Received: by 2002:a17:90a:28e5:: with SMTP id f92mr3543018pjd.38.1588060592475;
        Tue, 28 Apr 2020 00:56:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g79sm6816169pfb.60.2020.04.28.00.56.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 00:56:31 -0700 (PDT)
Message-ID: <5ea7e1af.1c69fb81.f92e5.dc3f@mx.google.com>
Date:   Tue, 28 Apr 2020 00:56:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.7-164-g86cfba65ced0
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 143 boots: 3 failed,
 132 passed with 4 offline, 4 untried/unknown (v5.6.7-164-g86cfba65ced0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 143 boots: 3 failed, 132 passed with 4 offline,=
 4 untried/unknown (v5.6.7-164-g86cfba65ced0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.7-164-g86cfba65ced0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.7-164-g86cfba65ced0/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.7-164-g86cfba65ced0
Git Commit: 86cfba65ced0c2c8bdc2fc919361cc85f1c3ff67
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 96 unique boards, 24 SoC families, 22 builds out of 200

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v5.6.7)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.7)
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v5.6.7)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v5.6.7)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            sun50i-a64-pine64-plus: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
