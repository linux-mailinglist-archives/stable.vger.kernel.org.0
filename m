Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F18156588
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 17:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgBHQke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 11:40:34 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54016 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgBHQke (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 11:40:34 -0500
Received: by mail-wm1-f65.google.com with SMTP id s10so5537924wmh.3
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 08:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=40gghtJIDRRhw6Xqz8HagZtRmy2QdxlMoBivti/1PMs=;
        b=oKBDOeuZZlNqDtgD3fJ3Le9GlxqWnFM79g1GxZwUeWjVLfHJ3vniJcTARgPrdD/kJO
         XBFcy1YYRLGfteOKOn42+4mCZr8LetaQcx0uclPJGnHs/Vj8trCsFe0d7kiDKC6oyRZY
         B1WJccab/3CX9ZHshqCS4/Lq+/8L9z6XnkoG5EFGhltev2iP172KTPTX8MTQaVIlS2xL
         ojIbysbW8dkgnGGyw9wPDPhlLSkV5yW3t7ZpTTCZzUszUeew7mV/PeDWVbxbkpAP8Uy8
         7R/WJSsWE21bBcjd7+0fBT2ZUI/w5H77PmirtsxWr0MLYGpK7keL3plmhN1bSv45QoD6
         2AWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=40gghtJIDRRhw6Xqz8HagZtRmy2QdxlMoBivti/1PMs=;
        b=SobGPDaqx6G+jnbder9nxxSyqDpTafGU6yuyDTVTHpFgNyPrZzC8pBzi6dUd77nHxM
         m4urYZUx+1J3PP4+8D90rKG558/K7dt7WbJgxIzjZ6XUzeZgzQR4hsTgrB+WACIBYdwb
         RCd1fMLA18HqoDmzvyYcP9kpakjkHEfklB4CElDSmLS84H/YpJek17AU+vYx2FK6kg71
         A6XTDKSm45vaG8Vw9qL+j/WUOpk2nT0hGl0ujGQsNyreoP+O9H4gzw/PIl5XWZUZVP1p
         rChZz0a9a13lPMCTECHKWxTvQSiIZuyCJPjw7uF4LPOAgy05AFxVEZv8cby0VMM7kjUv
         +N4g==
X-Gm-Message-State: APjAAAUEY8MT3cxaTEj2Xd+s8EVrbsONKSN5NbsnUzTYDfC+Wo7sgVB9
        gkfOKN0ipihJjGBE8AvGo9vonpSup9o=
X-Google-Smtp-Source: APXvYqx0zdIhinDM9wGLflskluDDmvfnvpv5C1r8DzSL1s7tueDyEtW2473IQzO8sLtsww5RvQb/dw==
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr5032530wmk.160.1581180031285;
        Sat, 08 Feb 2020 08:40:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j12sm2369268wrt.6.2020.02.08.08.40.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 08:40:30 -0800 (PST)
Message-ID: <5e3ee47e.1c69fb81.38d9.8e49@mx.google.com>
Date:   Sat, 08 Feb 2020 08:40:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.102-96-g0632821fe218
Subject: stable-rc/linux-4.19.y boot: 86 boots: 2 failed,
 80 passed with 3 offline, 1 untried/unknown (v4.19.102-96-g0632821fe218)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 86 boots: 2 failed, 80 passed with 3 offline, =
1 untried/unknown (v4.19.102-96-g0632821fe218)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.102-96-g0632821fe218/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.102-96-g0632821fe218/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.102-96-g0632821fe218
Git Commit: 0632821fe2181ec1b3d20a3613b1fc5da28b7e24
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 17 SoC families, 14 builds out of 170

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.19.101)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.19.=
101 - first fail: v4.19.101-74-g32591972abd8)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.102)
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v4.19.102)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
