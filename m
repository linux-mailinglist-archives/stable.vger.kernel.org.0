Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3255CB41B2
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 22:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391325AbfIPUWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 16:22:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36998 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbfIPUWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 16:22:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so792945wro.4
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 13:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XGBwC1LLr3XkN/SNJ7vwcspwxMveVCR8HY1dtgNLoW4=;
        b=gYioHUuav7RJ7c7qoBnzcPtdluWu9SMwd9SuHMTxMThIejV37fxqGv901EivRnLWI3
         11ATWdEHAGN60X78edgJkm8Zqem7WGAvwGV7gpmzLZruJQlZlygZKfDXXWJ0D9P+a/q9
         feuOewc4PocvpeK0uu+RfCzQ2r7B0rMBMoJWKfgvn8nl3jRIp0fGs9hiXyENoOtdLjX2
         KLjqARcpSRh7N1+ZMeq8Ntz+JRDiDroIgV/8iyNaXlcZOGoeW3APcHH4lzpQzxbFCYeo
         X0FDZtpWQeYeLeV325WUAtznIjpYZAwtIq5lIPA2fmZJTaCaFO9V7GhEqgj71Jur94Ci
         770Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XGBwC1LLr3XkN/SNJ7vwcspwxMveVCR8HY1dtgNLoW4=;
        b=OpWN5GseboPSdIJGs1lOoe+AldUBNIC7N6T0Rqpcyb8yzK/P25+y7DdFUaYKFUjdjC
         i5UlHfC6Midft/R2FN52ttFqThwYHgmiZxNztIkSIz1Ur5/SkJrmXqlWuo/ymuIhQfAs
         hQYaYXDg/U83ua2biZ8KELDx+mi6mcKgZKVrWFfgowzmTQULocnSeI7jySmYcuE8IG81
         xJqvGlR5C4Id94kzquFrZwEUCb1TH03TTz5xv6UvZqRvFL9SPl6T40BGitgOz1Ue+zQO
         O1atooWpQqjVfXxT0c+aXlogi+9FVsvutHDMvfzXa+MH2LWVFN4Vyhth60z/NCnXPgRr
         v25Q==
X-Gm-Message-State: APjAAAULcVAkW+Tb1fZM24eCiNcLfSxVgV5FZDX2gHI5hZG011Ws90yC
        mhiZyuQTWqDanha6p/ImOWJBtjmjdVaC9w==
X-Google-Smtp-Source: APXvYqxFNyDE2kX9JkdpBb/33lj19VzYdqAYzP5tAblGI26D/qghhpUI+SwyWsJPKyHBUhDclbvvfA==
X-Received: by 2002:adf:e7c2:: with SMTP id e2mr107664wrn.319.1568665358384;
        Mon, 16 Sep 2019 13:22:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k9sm31823wrd.7.2019.09.16.13.22.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 13:22:37 -0700 (PDT)
Message-ID: <5d7fef0d.1c69fb81.8f9c9.028f@mx.google.com>
Date:   Mon, 16 Sep 2019 13:22:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.193
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 111 boots: 1 failed,
 101 passed with 9 offline (v4.9.193)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 111 boots: 1 failed, 101 passed with 9 offline =
(v4.9.193)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.193/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.193/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.193
Git Commit: 779cde69dcc0c1d3c992c902a9d07bf7ec7b729b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 22 SoC families, 14 builds out of 197

Boot Failure Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
