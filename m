Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D186119615
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 03:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfEJBH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 21:07:56 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:50465 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfEJBHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 21:07:55 -0400
Received: by mail-wm1-f50.google.com with SMTP id y17so4504332wmj.0
        for <stable@vger.kernel.org>; Thu, 09 May 2019 18:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ftpViN5j8NFAV54qkkJMS7+epm3RTRKzoNYTV0PlOJg=;
        b=WjPiH2401k9Vkb79qHM90l+00eQTrZocbhtRRTuM0JB6licLYHXCKI0Yht2dJo5DLq
         gexY5CFVpr4F79BtRJZGPMnMtMyHC8wWBF9lGEuv+SSZJyZ+3RFozvzWePlgOoHnKV9I
         fTAJbP2UNZZrZAttJBF8hzUxIQ1gbzdeceW4lfl55r6VckYdv0ap1lsPIADxWHPaOXLH
         vB9tRs7Xxqjqljy7EH+B9UzAfKt3HCjdINWETWbIqGN6c9nR77tkbD2CVUSm2cLjFSXo
         1gJ3Ngxh6UdqCRt9Ow1lNPsKoQHqBGSp2AzvDpIs1mZc94BrhJcxLZnzG3aMT+FC7taD
         xo6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ftpViN5j8NFAV54qkkJMS7+epm3RTRKzoNYTV0PlOJg=;
        b=uOxkShuj2JrF2aGsXK8rJx/4Bc7VWXkPV5tBLwIjlhEIxP6w/Fdd3Kb821plHZq1zn
         nOEre3B3+XoWBVrBXYmlp0syk6MjrXVEyGFq7H9glyTHhb4hktDJHBYN0d+KyBCaW7SX
         TpaAi+ZjujOTWZJZl25XQQa8Rgf35/WHAVRnb3X4NE8i8DurSLgqjKk+lG29LFdBHwTj
         Qrd03eFD+EhMiiufHE6V3Mott/rtqF6fC3fFogpa7rHWDmm+3N+iWPxPdZaF1omcIL9+
         XQCjWC0VtBugegXdKr2a1W5x/ybilke2BfQYKC2qn5E7Uhl3o9xx1ClDB/CdHEKy+l7H
         /woA==
X-Gm-Message-State: APjAAAVdzd/wVzwbGt+scymtWtDgdyDwFOrpXzHDP8lyu5AI8agwpRvf
        ixtFtznJkRG6p712LnCC0n5+MKcAnCiHkA==
X-Google-Smtp-Source: APXvYqy0WwNai1m4lMGkNZ2fkANQhCn1ONcRSlPUl6x2qeoxX7Nc6rJIfs/ScYZ8KPB52xc/hqv+HQ==
X-Received: by 2002:a1c:7a03:: with SMTP id v3mr4622560wmc.58.1557450473299;
        Thu, 09 May 2019 18:07:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r9sm8219428wrj.57.2019.05.09.18.07.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 18:07:52 -0700 (PDT)
Message-ID: <5cd4cee8.1c69fb81.9ec4c.8418@mx.google.com>
Date:   Thu, 09 May 2019 18:07:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.174-29-g50bbfeb1e2a3
Subject: stable-rc/linux-4.9.y boot: 112 boots: 0 failed,
 107 passed with 2 offline, 3 conflicts (v4.9.174-29-g50bbfeb1e2a3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 0 failed, 107 passed with 2 offline,=
 3 conflicts (v4.9.174-29-g50bbfeb1e2a3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.174-29-g50bbfeb1e2a3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.174-29-g50bbfeb1e2a3/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.174-29-g50bbfeb1e2a3
Git Commit: 50bbfeb1e2a357db99ff35681cfa95341b33103a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.174)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.9.174)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
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

arm64:
    defconfig:
        meson-gxbb-p200:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
