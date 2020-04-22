Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB11B4C8F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 20:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgDVSSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 14:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDVSSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 14:18:20 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B461C03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 11:18:20 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id r14so1523375pfg.2
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 11:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DeY3F7jMFzepjm3h+JDWfglHnsq1ZRTpxL+Kn+lg7rI=;
        b=eHKqY27lo/nPOXIfgBu+0RkXh7WiHNVRUlir0nEircB295DuskhdCj7nmEyxoF3NWw
         jHOLnosWDxpHKsF769zS3o8DsZGqeWhnrYh60bt0D/tQ6iIsrLEmU3GLaHKwhfJwUKh5
         KdHnf1EgZlLSaxz2/af7RfMu/pe6ehtNPYm6PrKjT9stdyxtY2lx60yaW5hoj+qlGvxx
         8OXwLNaYVx6eku8N0Nk8vb1vkmsx/qSnNIy06wghQO1OHNqBqFAVJiX6B6myvYleupp0
         YpoFIAnh2thH9U68iRDFuk0V9kSEdplg4jskxsLEsneo9YYa78okk95R3uC0mRp3i7ki
         Hs0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DeY3F7jMFzepjm3h+JDWfglHnsq1ZRTpxL+Kn+lg7rI=;
        b=KYAF85wR4/G7g8kLEQP1sFIcQJeF68pxjgBkglkvHz/y0kRZUJ1TVdxdHQuS9eY77o
         eeW88N/21eBpWkSQGdQC1CG1RF2eaEP+QP9s9V8i9aPh1p8FBbX+HUOGDwtOxNdsjEJs
         u5x4/fS+XaF+geM6u02/HyS8HE3xg2opHTHzoTZw8egbVxsRC3cCXe1ULrVBBTOtA7xM
         iweAInH9W9tEEplEqSqCsq0b249LgzRSPmVMO8iE4r0a7IfYkVhV/dtuXPN9R4TabSAh
         dw6c7WC0biIL0O61g2rgXiJW0sK8GWdQtmIIBsMVYrFwoTB/QMe/+7sNt9v39AefiCqs
         Mdbw==
X-Gm-Message-State: AGi0PuZpF7ztv8shjivsBIgmFAuRbreMNPLUdGpskHI+Y3HYC2wxErzx
        aemI2zDL90S4y8LC/wa/kI3b1CGoHyk=
X-Google-Smtp-Source: APiQypKDw78PR7VBNOU6QtKTl9KPUPvBciCLoQMV2BCkTBikFC49BZTP3ncC6Ujo8XAZzDBNH3KTtA==
X-Received: by 2002:a63:81c3:: with SMTP id t186mr258124pgd.414.1587579499714;
        Wed, 22 Apr 2020 11:18:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w12sm136342pfq.133.2020.04.22.11.18.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 11:18:19 -0700 (PDT)
Message-ID: <5ea08a6b.1c69fb81.cbe30.08e5@mx.google.com>
Date:   Wed, 22 Apr 2020 11:18:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.34-119-g186764443bf3
Subject: stable-rc/linux-5.4.y boot: 96 boots: 3 failed,
 85 passed with 5 offline, 3 untried/unknown (v5.4.34-119-g186764443bf3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 96 boots: 3 failed, 85 passed with 5 offline, 3=
 untried/unknown (v5.4.34-119-g186764443bf3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.34-119-g186764443bf3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.34-119-g186764443bf3/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.34-119-g186764443bf3
Git Commit: 186764443bf32f12e07093aaff52dd4a25231781
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 20 SoC families, 19 builds out of 200

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.4.34-32-g913=
df976b290)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.4.34-32-g913=
df976b290)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 74 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.34-32-g913=
df976b290)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v5.4.34-32-g913df976b2=
90)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: failing since 1 day (last pass: v5.4.34 - firs=
t fail: v5.4.34-32-g913df976b290)

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
