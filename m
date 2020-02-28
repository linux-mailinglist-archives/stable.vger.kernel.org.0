Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADD4172D68
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 01:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbgB1Ac4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 19:32:56 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39646 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730250AbgB1Ac4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 19:32:56 -0500
Received: by mail-pg1-f196.google.com with SMTP id j15so553322pgm.6
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 16:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qE8v00JBZ+QlDL/myaZJPGI1xg4LoFuBmFcYS9XQdH0=;
        b=Yt55gpzWJnAIierZ3Z5QPB3r0o2gbvbc15w7wiihd8FwhBhb5xH8si7o9HiXlMErrr
         e99oSffmQJFpbULK3zsilXTcaiw66SSnIYwg6Rugsn3ZgL/oMlpo2suhYhbrU/mh4bZs
         dQ0RsWh5DNop+K0MQcnSfquDmfyxAWD4uNjUuMLqY0cRdSiRTxMytCY46fmQLp1wSJRg
         QISUVbzi7ud2GfqDsd6Ca5CE0COqN6jnOtAW66Z3LObGNOXEPIwfndBRgBDWUASajA4l
         xrl9p1S10RtOG9gyq7qFagjdgfaaYBwG2tj56fHhkA2DCFltP08h6c0wcPF/bn8SPflh
         Ig+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qE8v00JBZ+QlDL/myaZJPGI1xg4LoFuBmFcYS9XQdH0=;
        b=P9PARyzTBEVhQRH4ITessIiEI6BK2r2AF83wxsmcSXhujQpJ02oRAp0eCOn7i3oe5k
         le/6+glfUahYyyXe80UY6ZNQrC3RdBHxoQoaBB78PuLvUCG8a1OdFPHJiaxSKvbIlcSP
         QnpFBx2y61o9TLDV/W+blU9b1hN2rpXusGdGsLcjlpgXhUN2KY/qmy/9vDvPZUcsEhu8
         RmVLivnw4eYGsIlEG1e7v0M0vA2ShEOArPL+iCnG9mhWcBynNWrBtoKKrp3sm2YReixh
         H9tgfMMBr0iSwTvjeXV38uqs44/3pTRmybMjhcxp/IxMljvkw4G0hZEewpveNxu/2LGv
         0UfA==
X-Gm-Message-State: APjAAAVlGASb2dgKvjUtS7vcvkpSvjQypuftCt0+KJVAjMXM1/I3flRf
        hDogMLmNoLce4ZDAAnSxNdJrlFlKbwQ=
X-Google-Smtp-Source: APXvYqzqqYfhE6x0NPia/Zz0jh/9Ps6rpxtzicFFVmcm4qTAE8b4SoDJe0qZ3pnBAjcSqaHCxRNglQ==
X-Received: by 2002:a63:5848:: with SMTP id i8mr1873378pgm.438.1582849973837;
        Thu, 27 Feb 2020 16:32:53 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q6sm8324219pfh.127.2020.02.27.16.32.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 16:32:52 -0800 (PST)
Message-ID: <5e585fb4.1c69fb81.8f778.7149@mx.google.com>
Date:   Thu, 27 Feb 2020 16:32:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.214-166-gb8e4943d6bee
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 64 boots: 3 failed,
 60 passed with 1 untried/unknown (v4.9.214-166-gb8e4943d6bee)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 64 boots: 3 failed, 60 passed with 1 untried/un=
known (v4.9.214-166-gb8e4943d6bee)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.214-166-gb8e4943d6bee/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.214-166-gb8e4943d6bee/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.214-166-gb8e4943d6bee
Git Commit: b8e4943d6bee55c8a2c077fc7639d0b8e8127e1a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 14 SoC families, 13 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: failing since 3 days (last pass: v4.9.214-15-g4=
d9c5d6bb1c1 - first fail: v4.9.214)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.214)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
