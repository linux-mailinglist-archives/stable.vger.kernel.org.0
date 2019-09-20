Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5A4B96E7
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 20:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404951AbfITSDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 14:03:44 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:35846 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404946AbfITSDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 14:03:44 -0400
Received: by mail-wm1-f53.google.com with SMTP id m18so3137718wmc.1
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 11:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R5FJonxqC/9LJd67EGSb54AmKcWkkmq3fZh1GQxS5jc=;
        b=Yf9iK8asOklK1rk3PuFO3w5HG689p6Eef1L3Qc6NDqVcGOW8w2tdO41pBjIbUvOgwi
         MzEs03AigwSTOQTO1qmNmUuogp5DIVfLYLABz+Ua5A4POwmm3DTjr6RKhBtCRPX3AMTV
         ZFRICz+fhGuN28ilT7dpHfycR4OYMw8Uq+S7K0A0jbCpsYTNQbAkN8d3zkGVi6xPJZoH
         h52Q6Wiub0moBKQr0v2mSmDVCcynTY3Hy3Yt4+fzq6HpQ52KAja4ub9Q3fj5vnkpMjnY
         XRY1RJvwvVgAeA4ytRabSMHd4BoMqfDZRRrXaEulhRlmp3C4Io6dRm2wbb00+SExq54z
         mcDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R5FJonxqC/9LJd67EGSb54AmKcWkkmq3fZh1GQxS5jc=;
        b=kAAp9hRcC46BQ58QACu8WbGWN+5L/zxelEloSX2r9WYHpNxVaBzzkS6nU5tsYVkQIx
         O1b2ZIPGYkfcXPKvHpIY+VxbcgF9nvxNlnPO/qVUR/XyNFBdQay10NVgG5UEA8tLejJc
         4TLyEYF+GPNrHDl6ZJAd3AajXIHX6dems+mYVsRMEbkPkepGLMbBZjliVsEHLlQOFoQ3
         xT+QrgbZzvuHHHwuNzOjrRi1uYBkNL2BxNhL3NpKHNJqvYW4HpAgcYZHqm0v9mx2AsV+
         3FKCoNsL4tm12TpqroML0fI+hW7rcJ0rKzc10NJANqLmsCEW88iymbXsodYiKxYW09y2
         qI/w==
X-Gm-Message-State: APjAAAV7Eza0lPZ3Hjj1pf9Wazw5HIDYgJarYxi7PymURJJQHNlIs3PG
        dQdMSBOHGZZG4ub93E31ZY9vm5dJCVcPTA==
X-Google-Smtp-Source: APXvYqzZCFPV2jEcQ7skLR0HZNZtKTrCKKJglm+xAF+1sll9fR0nqLqAGver5TRqgSavURQe9uAr2A==
X-Received: by 2002:a7b:c045:: with SMTP id u5mr4429390wmc.139.1569002621488;
        Fri, 20 Sep 2019 11:03:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f15sm2031318wmh.4.2019.09.20.11.03.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 11:03:39 -0700 (PDT)
Message-ID: <5d85147b.1c69fb81.3086e.a905@mx.google.com>
Date:   Fri, 20 Sep 2019 11:03:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.145-60-g6ee21d3e1811
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 123 boots: 0 failed,
 114 passed with 8 offline, 1 untried/unknown (v4.14.145-60-g6ee21d3e1811)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 0 failed, 114 passed with 8 offline=
, 1 untried/unknown (v4.14.145-60-g6ee21d3e1811)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.145-60-g6ee21d3e1811/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.145-60-g6ee21d3e1811/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.145-60-g6ee21d3e1811
Git Commit: 6ee21d3e1811973deadaad1626ecb14a42faa01f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 22 SoC families, 14 builds out of 201

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
