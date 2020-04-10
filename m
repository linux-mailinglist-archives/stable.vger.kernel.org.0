Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E851A3D6A
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 02:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgDJAf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 20:35:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41388 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgDJAf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 20:35:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id b8so336484pfp.8
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 17:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H2MKPYBly89spm/Nt3jTu+gBoLPMdKe/EQSiUZlQF14=;
        b=Aj5GY1oqcK2kuzZ9EBESnh5khjYiZGMcSe1Ky/0F4cw8MkzxJQH3FVCzJFaLUxedYF
         9ZXPB2nNhgpk3WAeGjufjPxVYvi/WnkCelM67k9A6/HeDMPH1oDjSX94ExrYaZE5rt+2
         Sby7gnr5FqGxoPtey9/f0/jQr42y7lM9BMdFFNVr98mEB7Z3oBA1jEOeyIS8yeiOxJ4t
         ddeHmPiqSGj9zpx5CnpwrQ7pkrVs3beQ/p9q6hL56TpPEs7GfOjK9voUHQoWqMyXZCfg
         PruPIQvkCpW24IhayCur2l0ExgZxTS/ORlsqUvhHMXGouuDlHcXZV5vv8pyoOR8z225J
         0Dgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H2MKPYBly89spm/Nt3jTu+gBoLPMdKe/EQSiUZlQF14=;
        b=HbWuazfFSwdb0TMZ8bHanFKBlnPEwgrRnno9JzhyXAdP+E4WujTBlY5dFV8AkX2Cj2
         JQq+9PY+XeSkH2Of6T5DXsohB9DlqHtCx6VAEQdK1GUqp/9gMFTh+QwmvGOlWt/JxU75
         kYlySPHqBoKrSt3oeCrJ6soDh1QqD/f072iONdgGw4Jr6HhFSXn7xtfkaHYGOxmO2T8f
         VBvUwUuxiwTAjZaEdBTQbM6gYfdB1V0IEY2sYibLzZ445EK4rJCR6FIDFbQC13GrB5kx
         6EBg/6e88o2g9QX1gxn4LsSCgluRGf/G5KKIVoK19VAaabAMR5cINfAkat2gKznoF64A
         nM2g==
X-Gm-Message-State: AGi0Pubyjdl9q1MqVs5s3MpmkBzCYVLjfS1c3eawVYblsUxzeND+iihY
        Dw6IYQZA9ZdboeshXQKw6Ep6zR4vOos=
X-Google-Smtp-Source: APiQypJwPF9nrEKRy8zIOh57ZYgTZZKWbQ/+aRTXBEFd2WvWTtBK1nZ/o9MgUEP1gv3If16NaTLbMg==
X-Received: by 2002:a62:30c3:: with SMTP id w186mr2347805pfw.245.1586478957004;
        Thu, 09 Apr 2020 17:35:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5sm270147pfg.141.2020.04.09.17.35.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 17:35:56 -0700 (PDT)
Message-ID: <5e8fbf6c.1c69fb81.1e41b.120f@mx.google.com>
Date:   Thu, 09 Apr 2020 17:35:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.2-47-g4491f12cfc6a
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 162 boots: 5 failed,
 150 passed with 2 offline, 5 untried/unknown (v5.6.2-47-g4491f12cfc6a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 162 boots: 5 failed, 150 passed with 2 offline,=
 5 untried/unknown (v5.6.2-47-g4491f12cfc6a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.2-47-g4491f12cfc6a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.2-47-g4491f12cfc6a/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.2-47-g4491f12cfc6a
Git Commit: 4491f12cfc6a536509ae984b1e64640588c9b6f6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 101 unique boards, 24 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v5.6.2-31-gf106acd0db7=
c)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab
            exynos5422-odroidxu3: 1 failed lab
            stih410-b2120: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5800-peach-pi: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
