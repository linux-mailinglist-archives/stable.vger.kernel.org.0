Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883CF1090C4
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 16:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfKYPJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 10:09:51 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36451 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbfKYPJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 10:09:50 -0500
Received: by mail-wm1-f66.google.com with SMTP id n188so14396201wme.1
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 07:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dOea5uwTVjqlRTgjoi+QK1yGWnhsEeqKAi0tQjHXbfE=;
        b=bCxTDjE8YM9LUzP5Tzqu8vu5X38qIofq2yuWhEnmx3fuvz1ynifp9X0Vhp6izbro9p
         EG47Ir9PjiTcVncp14WRqsaRvGnxDdGWwphjEfME4ME2vgGlmI6lSBHKHVM+vNC82Fgu
         Zumf0bFlnhgGsA9rGMUXOHEN4YgLg4LhbgQrbqAJ3rKY4JkizdB5USls0zGBycag+xpj
         Dkyd78nnpfRHSuiiZIxfHBJdCkbcOTsZfO0RJFcREUQ4UAqkSDhDDrnse4IsV3UOmoWE
         Wrg0KEMYNOp7h/LE3vQw4b66XgWTD7IX1a3OV4Wzgg3AEmPdQZLSN+0a2rrB8mKPF8jX
         XurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dOea5uwTVjqlRTgjoi+QK1yGWnhsEeqKAi0tQjHXbfE=;
        b=j7MrkyCrZXygkaviOFSAXuBOgR5+LOndfEvMTB3aE+Rzm/FKF8X/lL/9fcBhS52Sc5
         AuS3OEL/5YdKvU8glHF83dO6/GD1fpJvDEk9ZeqEW42aKLcIcxtITNxjVfFHa/WVVniD
         tokCSi1pz41u8+VBMM7vJUwoHPrypA+QdeKdThz75/M/qa4fmllgsN+55uIDEWcrxTXb
         DvDRJt7d6zChzdV0+jVZWNwspZVwMLjD8YBYUIJaopDL89Zwyws/72p0toGdiCsYfutL
         ZEMTI4SjKPAfe2T3EfkoBBr9Ue9spjuaa7u1W41ukavA94C+7VYulKTMTAHofsZvChF/
         fEMg==
X-Gm-Message-State: APjAAAUFf+yJDV+Uzr7j+rDFKcKwYoSXfOLWLLJiBLD+QblV9T9ja590
        U4vsawk6I1T1OYmQElS35UzV3A3u2g5JlA==
X-Google-Smtp-Source: APXvYqwCRr+2h90b9z+VMkrFc+Frej+RH6MOumK7KDoPpI3i445s5mkKEOWTQ7NZUqckrr4+fFrrug==
X-Received: by 2002:a1c:ed05:: with SMTP id l5mr12186734wmh.161.1574694588439;
        Mon, 25 Nov 2019 07:09:48 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a2sm11284701wrt.79.2019.11.25.07.09.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 07:09:47 -0800 (PST)
Message-ID: <5ddbeebb.1c69fb81.3d68b.9468@mx.google.com>
Date:   Mon, 25 Nov 2019 07:09:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.156
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 115 boots: 2 failed,
 107 passed with 6 offline (v4.14.156)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 115 boots: 2 failed, 107 passed with 6 offline=
 (v4.14.156)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.156/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.156/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.156
Git Commit: 43598c571e7ed29e4c81e35b4a870fe6b9f8d58e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 22 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.14.155)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
