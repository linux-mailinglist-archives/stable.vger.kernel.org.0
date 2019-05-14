Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943451E5BE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 01:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfENXrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 19:47:04 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:32841 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfENXrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 19:47:04 -0400
Received: by mail-wr1-f53.google.com with SMTP id d9so625731wrx.0
        for <stable@vger.kernel.org>; Tue, 14 May 2019 16:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y1yCinQaM2Vmj6Yv8t+O/0jUVbJQbMArWu5UO2gt3QQ=;
        b=qHWNhcHVUzSPffX1SE1C5OQJ/jn+e1XOfsc35frXDhec2n+cnWEfVevjoUKHrvvRB2
         oWFlhBdsPIMHBQuLNCgDVkwM34GA9VXv9eAdIW879lZT/ZHg3uypz1sCjLs3nOLICm3M
         j87i2OVZWo+AqhHGeKfVbatolnrO/FNcwhL/n3wJVXRS29E7CNCMygfTKPAgKzX9tb0c
         G+9hbStcXTfHFz1CaNPPAnW0TcBs3MlRmUbIiWWV4dpZQribke9RG2bofBTiOUbRP3dF
         d/fmnLLDDXAz+CARB7zIIUCFogK+Lq6DEhrApwCGClUE3A/7dP/RoRNeaa4eKQNt4J21
         40Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y1yCinQaM2Vmj6Yv8t+O/0jUVbJQbMArWu5UO2gt3QQ=;
        b=r8h6nx0sUx2j7rSyTXpoznMD2PfhsnDLKcCYuPV2MnkIYcYBIVNPp3NOkQqGKbDiQo
         LpGvagfhCH8C6F5T4l+ep+TgiARppEpkjNlWb+6nkCXkGFfFiYS+2oJRn3UlJscnTE4T
         LSSb/d2LqlSEKe4VLzbUTDz5i4rkHq3+P14LDRPnEoAaicXWrQ+0g578nywcJciWepiP
         hDRUZ3zsUrHF/JEwjuxEepM6hPp6r9rMXTifm9kX9I4sR9zUv+cnqdiO4NaKkXTwYo+5
         GqYzgRtnTYG9b6iSfHsWlWMwJ4DT6INPQjeRlBzSLpEFFNJhnZw15I/iZOZN6t68pKjB
         PFNw==
X-Gm-Message-State: APjAAAVdduK1Cmex90EaSATV2ylLq5NJIJoC5gh7EHIZucaCG6RV4gxX
        MXq/p5rfTY6f6F56HA11KlpjQTbmCk6KjA==
X-Google-Smtp-Source: APXvYqzCzRGMK01P5Y00ofejFv/qCk9LQj8L3n5LzC3gyB5wz8gjXRG6f+A5MtW0XgJBjevSltac4A==
X-Received: by 2002:adf:dcc8:: with SMTP id x8mr3761567wrm.3.1557877621930;
        Tue, 14 May 2019 16:47:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 130sm576372wmd.15.2019.05.14.16.47.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 16:47:01 -0700 (PDT)
Message-ID: <5cdb5375.1c69fb81.2cb21.360f@mx.google.com>
Date:   Tue, 14 May 2019 16:47:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.119-98-g8d3df192fd69
Subject: stable-rc/linux-4.14.y boot: 127 boots: 1 failed,
 119 passed with 5 offline, 2 conflicts (v4.14.119-98-g8d3df192fd69)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 127 boots: 1 failed, 119 passed with 5 offline=
, 2 conflicts (v4.14.119-98-g8d3df192fd69)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.119-98-g8d3df192fd69/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.119-98-g8d3df192fd69/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.119-98-g8d3df192fd69
Git Commit: 8d3df192fd693f418413a618e212fdda602f473f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 23 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 3 days (last pass: v4.14.117-43-g=
fd7dbc6d8090 - first fail: v4.14.118)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
