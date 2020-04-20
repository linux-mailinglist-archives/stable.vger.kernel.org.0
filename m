Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2721B19BF
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 00:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgDTWsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 18:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgDTWsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 18:48:24 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEECC061A0E
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 15:48:23 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h69so5819544pgc.8
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 15:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QJdLBQKVRBzlOpnem6B3pL4lmDkYUEZc+x2ouUu+mU0=;
        b=Eg/zC2J75H707N5VhfmcJF2mlk3sgt50tkJQir/QQyM8VaYag01SQLs/r4CBif0qLR
         huaiCQVmJkwMKcut/Tvu9O5i3LXCLYe0CU+IGv70dzhDnoPQWRv7eJXcVfJOY9pQtQ/u
         ig00605Nucjqgd70aNzcAp8EYiyV6uif7N11AaZCIB4ObSIUQsQ66zB1l2l7NWEfdXcJ
         qPLNyIQ55plZa8zdtSKRSPxxUlhQ6V/bWnYukSI6CNp2weDyoI0x5up9/itkheYrHIBb
         PRtj69apEy83lSq1ZBjro9lY0ADIgy+pom6dYY2orMSdvc0PISJeSrZbbpxW/j1YMrof
         p6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QJdLBQKVRBzlOpnem6B3pL4lmDkYUEZc+x2ouUu+mU0=;
        b=YGqkJQCaZ4z0pTYEedKHEcpKhOTIzpXV+2yN/sX3J9+DVP+qxCMyaOohmvrA4FJbjY
         0f4HCQAQ3rPEYqrzw4MsHH9tU4eOnzpHCqRoGfMkEL7BK5JtYtL8sn0ocQpSlGk5jJ0d
         SNRjuFIRvN5qws02ZamyRP/4M7W3Ngvgg0IeEjlE92JoZFZQhJOMW0X5eTDMYAiH2bNC
         HKj0iuemC7Kgbllm9rBt9fSyX+rK0d8/S1bJGHvTkcvK7xetnuynM0POhiEdoyNSn1c1
         G5xbeltY2n4gCkKEOuT9UA+cGKytK9CqN1gfnUKGzP3BPPj4zhHRit4ax1xDESmHlLY/
         WBrQ==
X-Gm-Message-State: AGi0PuaveOU2Xt+9irVnrCamIeIoWtBSMSArStM+KKEZQTplBpdZCNV2
        jWBRGOoE18S5H6QZQINneH5Ade447aQ=
X-Google-Smtp-Source: APiQypJyYnSjtdGSe4lcQFhM/uTwXlQKb20ZK+y+hBWh/1kgADkvwHX4qqjcGEkHgd8JEdHqXl/2dA==
X-Received: by 2002:a63:6e06:: with SMTP id j6mr18994491pgc.167.1587422902827;
        Mon, 20 Apr 2020 15:48:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6sm519605pfh.98.2020.04.20.15.48.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 15:48:22 -0700 (PDT)
Message-ID: <5e9e26b6.1c69fb81.ae93d.1e74@mx.google.com>
Date:   Mon, 20 Apr 2020 15:48:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.116-41-gdf86600ce713
Subject: stable-rc/linux-4.19.y boot: 150 boots: 2 failed,
 134 passed with 7 offline, 7 untried/unknown (v4.19.116-41-gdf86600ce713)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 150 boots: 2 failed, 134 passed with 7 offline=
, 7 untried/unknown (v4.19.116-41-gdf86600ce713)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.116-41-gdf86600ce713/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.116-41-gdf86600ce713/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.116-41-gdf86600ce713
Git Commit: df86600ce71383e8c73aad9f536cb0dccdf840be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 87 unique boards, 23 SoC families, 20 builds out of 206

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v4.19.116-25-ga501871d5=
9fd)

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.19.116-25-ga=
501871d59fd)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.116-25-ga=
501871d59fd)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 72 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 38 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.116-25-ga501871d=
59fd)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.116-25-ga=
501871d59fd)
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v4.19.116-25-ga501871d5=
9fd)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
