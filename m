Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB12E199BFC
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 18:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731245AbgCaQpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 12:45:16 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40671 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731113AbgCaQpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 12:45:16 -0400
Received: by mail-pl1-f196.google.com with SMTP id h11so8315074plk.7
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 09:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6Wse4mPAZ3PjWldGIfnvvet03DvhrdFoKX6UL6tIZAc=;
        b=hN5s+XnbRcnNvktgypXKL962jzoqAkaWlHdVXWodLj/po58pQ6ABZ3vq5ETOzjErJB
         n5/NKMpNlKaT7gcNEP0hHnlj4qWtiyJ15g/BqflY0Mklxc843EIwQVm2p3Tr2KjeLF9F
         yt+FNLwOUM0A4FsqqYElMb++S399jfuDbytfIe/piYAdpoPGrW8Ayfpt0TNrmEXi44K9
         fj/FTe5LMGVP6buRNQX3B2bW7+1aZg2yJDD8JqWbO1hOAO31lzMpGbTzLuqQhAPxZXAP
         ohfS+h6S0Dd6CxFr5Ti+V1kVaUlKYyjLXk3ZEx2eLLz0mdrCqveuPuFHBuhXJfR9kASH
         JQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6Wse4mPAZ3PjWldGIfnvvet03DvhrdFoKX6UL6tIZAc=;
        b=MNXPayVi9kG/9K6Yqecvopzpdex+cSQWRUk9hU/NUjulh+XMngSH8VNrSIoyZznyDj
         3Krbu1ifgnG7LJuh5hBHPCzeM5I7hU36N/wDghOfrdpRHNTrmrfjzbN6fnD5uNLucdDs
         5vPY6093uPCi5KOrnE8VgqyrVxU/GAFWpLjYt/+Zj+VWkC+4IN5sBbEbK+PIIXaWNeS2
         nIUhWwTPc3H+sDq/kXDrJHM9CPzVfTfh7m0EZdHFjRCmCGQKJo1dKHFhIGGlcAXyecx4
         06tfzA6ymBtEKlLWcu4gq1x+nZPybVwOPohlszm+Xm6xZYVf3/XszmPXCR2TiHp9B14z
         SJXg==
X-Gm-Message-State: AGi0PuZ/ue1bVKecIVe/E7bdsmztUKqIRJTFrmCPKa9JAQe1tQEHSwt7
        wqpRj2H+QuKGFEfljaTLYXT3BIIholo=
X-Google-Smtp-Source: APiQypJ7kqmH7p6lV8jWIDFR0j+L8a3BE+YdN2QVKPYxMxWoD1U0JBhASh6s6T1fMAdZWDc3PjgqMQ==
X-Received: by 2002:a17:90b:3585:: with SMTP id mm5mr5109251pjb.168.1585673115220;
        Tue, 31 Mar 2020 09:45:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 16sm12801359pfp.155.2020.03.31.09.45.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 09:45:14 -0700 (PDT)
Message-ID: <5e83739a.1c69fb81.497b.96ba@mx.google.com>
Date:   Tue, 31 Mar 2020 09:45:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.217-90-g97f382d34529
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 106 boots: 1 failed,
 101 passed with 2 offline, 2 untried/unknown (v4.9.217-90-g97f382d34529)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 106 boots: 1 failed, 101 passed with 2 offline,=
 2 untried/unknown (v4.9.217-90-g97f382d34529)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.217-90-g97f382d34529/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.217-90-g97f382d34529/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.217-90-g97f382d34529
Git Commit: 97f382d345294b8739b9d5cb0823dcdca88b9570
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 52 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

Boot Failure Detected:

arm:
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
