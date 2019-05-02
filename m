Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B58A12202
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 20:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbfEBSiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 14:38:07 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52380 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfEBSiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 14:38:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id j13so4256425wmh.2
        for <stable@vger.kernel.org>; Thu, 02 May 2019 11:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7fwM49qBC91b6r7qDMOTxd8v6xDQjqvpChtl/rBe4/o=;
        b=masQedwE7hQZcMTr0xc614b0jEBwZr4qxnmhKybCOAxpS3WMS++dWFXHPxIFs0LpDN
         pCojBKlrAzGLldvldJDCCODcOG9jHUHJ4l3688kPfjfLWRXrCV+U8ENeoDpbSwoOyaNr
         H2mMzld6z3zBAoTTjaUNd0r1wrmUPp4nAZcgJ0Q6dPmEKcSmXbtwOJnbgnBxJVeCoCFi
         lHA9ZGaKBu6zBV4mK/M+xK893qvBE7y3HG2pO/eAAIoTJiSVhwojt4hYkoO2wDbU4V/N
         OPEFQeUxTEvsTJp7YB/e9M2kX/10Dm8GPtX4hcLk6jSnKfbGsaGfjTehtJpZcuNm+dmm
         k5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7fwM49qBC91b6r7qDMOTxd8v6xDQjqvpChtl/rBe4/o=;
        b=MtmF0tcTnlNf/260wCHimRui2K5OUsmzCTqj9WeDY97Iky42P2jMt4wuIItPjupusq
         Z0JDJTEFJZQznhV/gGVay+sSyLHvL8z038vmvW6eAXcMSO0T/StZ1Xvu2lHIt4whCsNd
         FYfI52ZACDjYtE+G111fBjygyKG/R+PAS9T3dC1aN0Y4Vg+rw5faqLjaWciGtuB5O2BA
         s6lZCC18hirFrP1snX4y7aoyBroozeFl/OADMVY+Os65ysgbD4+XajF5ZSh/yDDO8LAy
         Ne3VksjMeT+khll0T2/OjQrg7p7A2hVkNu3dxZX4KvRNRFKjay0CVl2R/4gFTDLtqotp
         r5LA==
X-Gm-Message-State: APjAAAXgFZ+BXNsddKHBGuvbiTsKG2/Y8mAaC6VTa3b1MSk+woj4VcDN
        8nTtbgTJAblqymKczN8YfLEVDgf29YHSBw==
X-Google-Smtp-Source: APXvYqwrH4fo+fTHKcPy2uniDuIjxjPbM4m+bhZy0sCotpVrYlPr1cvefXoW4l9TXO1+XCJMiug5pg==
X-Received: by 2002:a7b:c3c3:: with SMTP id t3mr3354123wmj.88.1556822285442;
        Thu, 02 May 2019 11:38:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h123sm6825wme.6.2019.05.02.11.38.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 11:38:04 -0700 (PDT)
Message-ID: <5ccb390c.1c69fb81.4481b.0088@mx.google.com>
Date:   Thu, 02 May 2019 11:38:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.179-110-g6d4c797f7aaa
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 87 boots: 3 failed,
 81 passed with 3 offline (v4.4.179-110-g6d4c797f7aaa)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 87 boots: 3 failed, 81 passed with 3 offline (v=
4.4.179-110-g6d4c797f7aaa)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.179-110-g6d4c797f7aaa/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-110-g6d4c797f7aaa/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-110-g6d4c797f7aaa
Git Commit: 6d4c797f7aaae4e4deb811474b9a56b188283dfa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 21 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-7:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.4.179-85-g0e=
b41477d1a0)

Boot Failures Detected:

arm:
    qcom_defconfig:
        gcc-7:
            qcom-apq8064-cm-qs600: 1 failed lab

    multi_v7_defconfig:
        gcc-7:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-7:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
