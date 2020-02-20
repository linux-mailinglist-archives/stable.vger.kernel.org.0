Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B9E165727
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 06:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgBTFrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 00:47:51 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45985 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgBTFrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 00:47:51 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so1334378pgk.12
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 21:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ys18kTbLZ8ICe9rhjageltwyrJgPQkLnLlhvlHYn5PA=;
        b=r2OM21z4mXiUsnH8MA6zMY4gv8kH/+H2MKQ7ClrKFSMhmXFc6yLJoO7js7Ib0Tw/w3
         sB0i3RJhRl9FP7N4nFIqCtEWfcoZQ4SDvpAIX6Dqt4NE3I8Kd1NG2XSOUsOHafEM0CU3
         dS6WSz7qnSwiXrrGNEY11ZCm3l5A4IAG3pOKyDlPHgPmNHdtf3X4BDaVZNs2EhSEELoa
         Qd1QvqCzirNh9fz0gbAWJdEL1dSB7jsdvTrb1L2RO21NqyzTxaWfNbzW1x++8Wepgmoa
         0lEbcOR1LPioJTJEVUCWKOX/oIsKZXy/iZEO/O3FkGRC4s8JWv1Jm7QwFAMKjYQTmVp1
         P0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ys18kTbLZ8ICe9rhjageltwyrJgPQkLnLlhvlHYn5PA=;
        b=QMvX7ru4RukWPD8ENPk6MkntV3RPltM+eQ3c7JHnW2eeAeHcUgol3n2/HwsYg3VQAE
         tR3XEd+B/zVdCiMprP96YpotGBBZP9qwUVAtkZN4TfWE5isJdMTplO4srnEpuyvqbuX2
         cF9cFbUmFtpOIv2MkxPwtNZjLtowknBKDlWv800bhNpzMs0bDoozCA+xZ1N9sSakfnqh
         KEvFoptAQVAfThmfQnZyQgCOnQZ3wdPFfewH6sp0FMxFui+Ka8lhBjMMLDdZGU5Qvwfy
         VpwKSZW0UHgHALloM8e/L/I1sY8yN8y194IA7lqZ6A9b2leViMtWHeBWfwb59qOTTok7
         OUAQ==
X-Gm-Message-State: APjAAAUeR6ZL7RpsVxCMbSCIm8LqQNrUmnHVKa7WzjiGSB6pX+DRbQ/F
        zE9RYlpJL6pnybLDtbSrwNi1OV+5gic=
X-Google-Smtp-Source: APXvYqyPu/DIAp/DSJepDsM4wSJfvqFf2s9+VsoNd/dypK5V2QYYycqeXtLCom2+vF9JPH9NhVuUlw==
X-Received: by 2002:a62:1615:: with SMTP id 21mr30261353pfw.84.1582177670237;
        Wed, 19 Feb 2020 21:47:50 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t66sm1629297pgb.91.2020.02.19.21.47.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 21:47:49 -0800 (PST)
Message-ID: <5e4e1d85.1c69fb81.ccb1b.60d6@mx.google.com>
Date:   Wed, 19 Feb 2020 21:47:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.171-29-g9cfe30e85240
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 21 boots: 2 failed,
 19 passed (v4.14.171-29-g9cfe30e85240)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 21 boots: 2 failed, 19 passed (v4.14.171-29-g9=
cfe30e85240)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.171-29-g9cfe30e85240/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.171-29-g9cfe30e85240/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.171-29-g9cfe30e85240
Git Commit: 9cfe30e85240f615f3fba2200df56acc52117c06
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 20 unique boards, 9 SoC families, 7 builds out of 111

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.14.170-141-g00a01134=
14f7)

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
