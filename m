Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A21AC186019
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 22:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgCOVot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 17:44:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38681 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729166AbgCOVot (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Mar 2020 17:44:49 -0400
Received: by mail-pg1-f196.google.com with SMTP id x7so8510653pgh.5
        for <stable@vger.kernel.org>; Sun, 15 Mar 2020 14:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aHDeKJ12Rfhbe5/JD0D2B3qMX1ZGe0O9jQy8DEiuapc=;
        b=Ya94QqGk0obvLVYuQ+36959thN4RlkHGu8AYaUUoJd3E02CXWBIKynIwGq7OVZmMZF
         JhWWWjs/uywZGLmrev2r9bd8zKmiL7WfhRe0FvrbRxgoI8p7PqhMIxz7gGCUit81e3Sl
         sjb/OQiKMHrTsW++SDy0V78UZu4iFkO/v2Lvcc61BfYmT2nndEHEuB/GgIoJKxcr3wUY
         5USKgcSk/3jXEChovm8Q5RLbvS2v5UhTxNJhKdp/VkDaY94c9oSlclXevEYXfQA02oy8
         MYdXXNoAnIOnGv41OFe0Pw0Mg4CB8pobRTA1p9i5dluSthjqc6TjGCHOYWYmLGZkyY2r
         gdYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aHDeKJ12Rfhbe5/JD0D2B3qMX1ZGe0O9jQy8DEiuapc=;
        b=D+sYvyAXCHnHH4W0SCSgKEFQ6k2k83jbC7OfhP6/BIfhN/V74mKmdyLS8Ze+aNrW0h
         bBJKnzRbK89k9C5UEFje1hkf7ZaJIiuUhwauK5Nyp2YVJG95KM+u4Fp8T94ojjWt+DFc
         gSvb+iK31byoy1GFxp4QxBkEhSG/Guil4qMavGuBn2xzjIgmCoT106mZtvVJeCVm7pD/
         Jec7Xg9AgM1Es2iKPqRoGKTgnA7ySKe/KF1GlI1S9BZ8fQE+QNvTnzdHisfsQedNMVQE
         T/z5ADXrzaWqEnKJtooZZNyywiWSpRd3JezUejOvUzOncCof2oFZ9h+4dSZrLViksz7V
         WOfQ==
X-Gm-Message-State: ANhLgQ2Xx5gHvQ0Dvi7GZo6rPLjZJGj9B51E80QPZSgc93kd2IzrmHq5
        QJhgzStR5U+YfVxLWiQl3y2UENZpJC8=
X-Google-Smtp-Source: ADFU+vviM+b42rIZ9kJspdfRuKLbye073fbPtDsnBLSbxxLLK/J9225MjmTwKdTrQ1oXkyFY/1iy4g==
X-Received: by 2002:a63:b216:: with SMTP id x22mr23213749pge.198.1584308688485;
        Sun, 15 Mar 2020 14:44:48 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m1sm13211109pjl.38.2020.03.15.14.44.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 14:44:47 -0700 (PDT)
Message-ID: <5e6ea1cf.1c69fb81.a348.ec40@mx.google.com>
Date:   Sun, 15 Mar 2020 14:44:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.216-31-gf9b8330d3e74
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 111 boots: 3 failed,
 99 passed with 4 offline, 5 untried/unknown (v4.9.216-31-gf9b8330d3e74)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 111 boots: 3 failed, 99 passed with 4 offline, =
5 untried/unknown (v4.9.216-31-gf9b8330d3e74)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.216-31-gf9b8330d3e74/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.216-31-gf9b8330d3e74/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.216-31-gf9b8330d3e74
Git Commit: f9b8330d3e74cd78a83e15c2d74f50355696221b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 36 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 30 days (last pass: v4.9.=
213-96-gdf211f742718 - first fail: v4.9.213-117-g41f2460abb3e)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: new failure (last pass: v4.9.216)
              lab-baylibre: new failure (last pass: v4.9.216)
          vexpress-v2p-ca9:
              lab-collabora: new failure (last pass: v4.9.216)
              lab-baylibre: new failure (last pass: v4.9.216)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
