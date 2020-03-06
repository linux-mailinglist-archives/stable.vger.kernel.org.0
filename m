Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8137C17BD5F
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 13:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCFM72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 07:59:28 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37675 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgCFM71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 07:59:27 -0500
Received: by mail-pl1-f195.google.com with SMTP id b8so838447plx.4
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 04:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eJULMdO/mLnfNEq9uTcv+BvD08WumaLejnUd0qO2YNA=;
        b=DsKRWbUuJEuHhUTYuiFNK7vfUtb3SZZ3sEeeoEc/jmarQksgh5aimpv02O6ynV7/QP
         zlq3+cAoMp2qEpYZx85EFq/bNtMu01Q0PalQgI2FwBecd8RZsCl5KysIXyRarqQpnei8
         KXyvjynJzPV4e44j+e+066PYdAQd4dqs/RztMyjBgexUTbJoUiVmqGAMnUMS1BtWOmoq
         Y1P2TjJIzkuASenOSdTlJpSMnOfTeFVjAC/W2vaG2mCAEisehEeeCSiiLm0S7XYoJ4Tf
         CZjTVaYUM8avl3EUveXLIP7KpFqxnlz9aGMF4Lkqie9ZXvR5WUtI3A7aIgX/UeYJrtFI
         Q/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eJULMdO/mLnfNEq9uTcv+BvD08WumaLejnUd0qO2YNA=;
        b=B0HUrlDJWa/NvCH3oGeOB05a8OW0eUe0QpwHZBDMRM4GkPzX4NecDtzQhwLn9b56p9
         Lc+is0j0AqGZTm4HS/z+HM/4oFFPyYyImb33NMW9dxZc7zO0WlNlzvFG4FDmzY2vA9/N
         3Akh+LQ8FGKDqAvXz/q7uSoJ/VFmKA6Y2vIG7bZrmTNjy1IiME9UGSnl8LQgcA7QZ4R9
         sO7mJnJkvHaPZ5CCWxYIy8BSxVQ3itI6mW64KnwqiQP0p49QWgmo0TONm2a1qoDTmUHv
         KKe/nnBTjp4V4sCV2buD/Lg+GY5Ktx96F/4qHaQNPqVevSST5d3rkmjFpGG40w70Kwg/
         QJ2w==
X-Gm-Message-State: ANhLgQ1TcE3W4zsY5t4s1EYT0r/0JNzmEhYey5W6F6UdZs8NK3ZyeqKq
        ZXkMffCPgX626tNQfdF+yxpx0LJ/Xfo=
X-Google-Smtp-Source: ADFU+vvPj7qI/y3wPo133REAdBVPXBAxTFVsm9S0Bq8NieSsXQbtkVAu4Lzwe7CPxn3S51E71bdePQ==
X-Received: by 2002:a17:90a:3ee5:: with SMTP id k92mr1947365pjc.81.1583499566544;
        Fri, 06 Mar 2020 04:59:26 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g9sm36366374pfm.150.2020.03.06.04.59.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 04:59:25 -0800 (PST)
Message-ID: <5e62492d.1c69fb81.d4e67.0367@mx.google.com>
Date:   Fri, 06 Mar 2020 04:59:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.172
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 52 boots: 2 failed,
 49 passed with 1 untried/unknown (v4.14.172)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 52 boots: 2 failed, 49 passed with 1 untried/u=
nknown (v4.14.172)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.172/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.172/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.172
Git Commit: 78d697fc93f98054e36a3ab76dca1a88802ba7be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 13 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 9 days (last pass: v4.14.170-141-=
g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    sunxi_defconfig:
        gcc-8:
          sun8i-a33-olinuxino:
              lab-clabbe: new failure (last pass: v4.14.171-235-g7184e90f61=
c3)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
