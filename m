Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCCBA1959D
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 01:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfEIXUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 19:20:47 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:50701 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfEIXUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 19:20:47 -0400
Received: by mail-wm1-f52.google.com with SMTP id y17so4300096wmj.0
        for <stable@vger.kernel.org>; Thu, 09 May 2019 16:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ny9DAjRdHRW8uBEUv0pXdjnGdpSKpdU7nUDj5e8Y9eQ=;
        b=0Iq3aWtX7RqjkVBXmm8SHdeP8OBfuBVWpOF8vBU1/5ki3L80K55L7MNW6SUROjcyZg
         MfpzpfrGsQGb+o+bRo62NNXtoTMHRog0sNhcsgx4RgiebNGNAaInRpqG4mrwkrQZPQpR
         wKHB0vjUawkgOKAPdZpq2FydSlnoqyRvsC3WT9d5rxlvn+fl+3dtpFxv40P3A01kLX+M
         wwI0JhBav2qpSpWT6WYHQiGAI+ydBlBM7tq9r3vaTh5vfn65J5RPsaX1qwrNRVDT0kdn
         arga2okpHDmfpNN7rIWGoZQ4oCP/3Yh5olmX47Fp7bTHtP79Uok3+HQUinHdr1zhyQeN
         mRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ny9DAjRdHRW8uBEUv0pXdjnGdpSKpdU7nUDj5e8Y9eQ=;
        b=FSZOP+F7lrUYxMl4hPc7qyLzTlBDRgF88hkMmlqK/B+PAyIOGkz5GTtVoTwFpjSqJ2
         /D1AhTzUYsc1YDuf+wBqLW67EiJIyBPAl4YLD0uB1zjmnd/rxYq4SSwPQWHoeGGWjis7
         R+yjGfHL9YgM//s0FXVzjFDzxm+pLt+UYuOdihNX0TFU5+xVnSDPjObN7rnuzPUgQdXn
         o+KhVlmvvdBwUoiSWk5/kswLrjN7qprWgA9LIXi3GGH62097EyEj7QoRzwUE35o2PBeC
         Ox/Ln7LM9d/vYknyi7KD30cQLtL3PLoPf5RukmK+dmjkbU/xgoyvpdLMpr6wALa0S0vU
         cP8w==
X-Gm-Message-State: APjAAAWqEv8ne03lwC31qf8Gzbh4CbIBlVdMZKb5p0gct3WRDIIoPkd2
        /vE/qQ+fa2IvRMl4DZcthTeJtSjK0cOY0g==
X-Google-Smtp-Source: APXvYqwoI4mEef9KQaOX8+C5HNyuS1zXCRZ+ViEHyR8njdSt1hmFtc96Msqcg2AklB2x+t9InVsLog==
X-Received: by 2002:a1c:dcc2:: with SMTP id t185mr4990965wmg.143.1557444045277;
        Thu, 09 May 2019 16:20:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a8sm3689460wmf.33.2019.05.09.16.20.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 16:20:44 -0700 (PDT)
Message-ID: <5cd4b5cc.1c69fb81.629e.287e@mx.google.com>
Date:   Thu, 09 May 2019 16:20:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.179-160-g2c68c4c9b112
Subject: stable-rc/linux-4.4.y boot: 98 boots: 2 failed,
 95 passed with 1 conflict (v4.4.179-160-g2c68c4c9b112)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 2 failed, 95 passed with 1 conflict (=
v4.4.179-160-g2c68c4c9b112)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.179-160-g2c68c4c9b112/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-160-g2c68c4c9b112/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-160-g2c68c4c9b112
Git Commit: 2c68c4c9b1128c52fd9915bf8529f31601fc81b6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 21 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.4.179)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
