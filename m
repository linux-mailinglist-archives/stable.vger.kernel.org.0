Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40E98259A
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 21:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfHETa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 15:30:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51126 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHETa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 15:30:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so75842652wml.0
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 12:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l9wql1bYTmDNkXfhnDXp9a3DvZeVItY86SBM/7bj3jw=;
        b=Kzm42EqCKKV0goebfIkS9+awqX+jCfP6gw5lRrb9x685SV7yK7e8+7D5JaVZRsY2bV
         MuGdU7uqAwWPXlJhg6DMmKqrASZ4Wh+g+C61ivD1ZpjFIAu282AgyOfYaBugqev+V3Vr
         bnGHw6bKav8U36epx2eKeBABonaz7V+M7ATLRaYAos1PSAg+dnzax6kxp1pIjYujJzx3
         6BVYvqlaB0ADGULvxPXgni4mN2NTY217tzNdtq9xC9/4E8thvRouoSBBNk9gxZc19zWG
         zZABzZXlYD+Uy8jeoLJ/mc+hw750Qm7EThZ7rrjILgMLMwQufn9+Xa6lD+pg3XhEdrdi
         MG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l9wql1bYTmDNkXfhnDXp9a3DvZeVItY86SBM/7bj3jw=;
        b=ezv6jnMPaBM+2PGNIdX7Kcek5O5iq78boHLgZip03a+BOVx/k7rUXnTKTFNqU646Vm
         ogLqykCHevIFBW/EbqNGuJR7PjkoCZFuUDkcFb2xKI6ASG7+RYI/KzQ1/5IfQeZcsEqB
         4Mx+s2ZdT/DcY4CdIFk6yFaGAJno/JM6sUD4YVxAgIg2SEsKKyNGfCKL+WWvDdxN++Qy
         9UOxwcuUnb23GOdma+eIOm49dRybI+ZSH/R7AP4eRnGvXV6BeX016qnt7eTaVqnJPug9
         Ql/bgD/gmT/ZnYdVYHBxF+lLhXcBHiJc13cLnCTE4BMsBn5c0m3V007C7obYxLSXQOSC
         REBw==
X-Gm-Message-State: APjAAAUkvhB2kh18JpK/0tCiTIj16RtJlWeQZ3q0OU3jwB2ri6NQwNOB
        mWOuvSUVzuidxVB4EJPRtMb/IDsg6L9V8Q==
X-Google-Smtp-Source: APXvYqwWBtZnxcLDw6YWTQVCL9hXjDAKsmANUHQvivP4aqM3w1sq+YxZo8fOye2TIhTYPKkp5zbXfQ==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr14444wmg.86.1565033425225;
        Mon, 05 Aug 2019 12:30:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g2sm75653706wmh.0.2019.08.05.12.30.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 12:30:24 -0700 (PDT)
Message-ID: <5d4883d0.1c69fb81.8ac23.34e9@mx.google.com>
Date:   Mon, 05 Aug 2019 12:30:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.6-132-g22499a291939
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 133 boots: 0 failed,
 122 passed with 10 offline, 1 untried/unknown (v5.2.6-132-g22499a291939)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 133 boots: 0 failed, 122 passed with 10 offline=
, 1 untried/unknown (v5.2.6-132-g22499a291939)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.6-132-g22499a291939/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.6-132-g22499a291939/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.6-132-g22499a291939
Git Commit: 22499a2919399df3cd619a46afd6a90a731892f0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 28 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.4-=
235-g44397d30b22d - first fail: v5.2.6)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.4-=
235-g44397d30b22d - first fail: v5.2.6)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            bcm4708-smartrg-sr400ac: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

---
For more info write to <info@kernelci.org>
