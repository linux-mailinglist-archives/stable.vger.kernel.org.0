Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBA918DC52
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 01:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgCUAEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 20:04:33 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38880 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCUAEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 20:04:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id w3so3182903plz.5
        for <stable@vger.kernel.org>; Fri, 20 Mar 2020 17:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fwpd7OfRoUCahnYL9exWAIIcOqGQAUF3zTIWJQkuGAE=;
        b=TNeYnuuMcSRq8gMdezRtkTkN2OH7lqTQw7K+AWDPE59qeYciqHy+Em/XIm8aHaC6Y9
         RWu3SxB6Okdzive27WIQbV+2lP2bBh5KXWvtJg7CZkM2s28OwR2MABC0e3/bvBKxrIWE
         FOlk/UUJ0eKZliQoRpldVTXJF+poKVkpCFEpPaN0RGPR/zrmKkUmUFMDimIgqR7n1RbX
         iC/qQJXf1rNbmKe94ezjkOqb0K+14lOJ+r3xl0weecoet4mJHDUpq1JihC5CGw/j1U3w
         a/cPQk7m2dPJFUOpYy42hP9uVn3ZHp8WyCZxAcBS5A3AWR2T0ahn6Kc7UYewBwYiTaxO
         B8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fwpd7OfRoUCahnYL9exWAIIcOqGQAUF3zTIWJQkuGAE=;
        b=gxJpz1A163NLMxSKRMOavQfx4KdfffWBKOfSkNMtSZaukQRRx2Aqkny0XbmLLlA0v4
         RkaOGsTwc9b2R1MzVa7LqZl6jt9/ttfFTJIQrPMce5QLlmb4DGZPu5TBm67HZJ/zUExB
         I3eG1TT5g682upOlP52id4vxNgq1WWz189C4caxTcwkBe96LmWZQgZNfGj1WjMnAqPY4
         IR6eua6ZpSLUZfnjv58vLFmi+naQT9yIAHVwk4qY/8zmt+BoPqwmU3K4rnVhr06iizXA
         1eZuPzRZbhK/N3nJGHzXE6umi0MrxaVUg9tIDjYkGyYRUnwKFoCK6rT4Wm3us92EAjXA
         awqw==
X-Gm-Message-State: ANhLgQ2U9efXzX38xmR4parrlPqwdKnA4Lt8aBcnQsu80OLaAQ2iesrY
        Pyx54SJs7nLaJLm6fnocI/tS6QfBLeM=
X-Google-Smtp-Source: ADFU+vsmZDnSLD73FtPS7SR9McU3eqClKYxrYRcnI2V5NBhRxAKsyc/RwuRNfmXZqJ/VJBajP3MYsg==
X-Received: by 2002:a17:90a:fa96:: with SMTP id cu22mr11737823pjb.187.1584749071915;
        Fri, 20 Mar 2020 17:04:31 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 20sm6342616pfn.58.2020.03.20.17.04.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 17:04:31 -0700 (PDT)
Message-ID: <5e755a0f.1c69fb81.b07ad.4f02@mx.google.com>
Date:   Fri, 20 Mar 2020 17:04:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.25-175-ge72abf1f11a9
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 155 boots: 1 failed,
 150 passed with 2 offline, 2 untried/unknown (v5.4.25-175-ge72abf1f11a9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 155 boots: 1 failed, 150 passed with 2 offline,=
 2 untried/unknown (v5.4.25-175-ge72abf1f11a9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.25-175-ge72abf1f11a9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.25-175-ge72abf1f11a9/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.25-175-ge72abf1f11a9
Git Commit: e72abf1f11a982a2a3fb555b5a9bd2eb2011dee8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 100 unique boards, 26 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 41 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 5 days (last pass: v5.4.25 - firs=
t fail: v5.4.25-58-gc72f49ecd87b)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
