Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A8BDA1B5
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfJPWqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:46:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45809 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393439AbfJPWqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 18:46:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so73672wrm.12
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 15:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mYXoRFsbL/E9Oj2ISdc4mor0IPBeY6H9K1TzgYfVlTI=;
        b=xmD/ffEjc2YA+84yG18hlGNOVjhjiiA1GH549jKOTSpOOcc/ZUgK/xYNfrNLnLh+Dz
         5q3E/RqLNYLrL2OrOHhDBBWiyT1k6ZmnE/19fYG7CDufFAfxCfJ3f0nkwo9QHe+t62O+
         Adbe901Bi0qIEQPqfOdtMM8vsLbucUOyXuRFdMN7elvklJe6wi//MMVI5IPU+AkTzz7Q
         /sK/btlI9F0FshaqMEMKTIO4/xkK0Ymv8i1Vn7j4IIsJFtJX1hbeyax/XHkH2KnDMnTc
         oTzA6/ZPcaQWHQEUCiLGwNYd+0k7kb0Wq7u3z9Fi2WmioAyQQV4IrtdaCLqIipYuQRtJ
         pREg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mYXoRFsbL/E9Oj2ISdc4mor0IPBeY6H9K1TzgYfVlTI=;
        b=oGnVyYDJog02GxFLRXR/y+if0alPO3DudHYL7F3TzPYsoEyRH8ZUC6zZ1AADObTfjD
         j1kcomow0/DCmiTgfVnPCbK5aJ2fKkW7JLO92m1eQ9oTx8Ua9Uxlt8EE2WRsB/FUUveI
         C5Pm3uEnPVW2pCsFyoOzklGkmxvo6Lx/0/JpBoPxxkokoBwXckwYtUF7mFDkh4x+X0IH
         m5WeBXuJCcqlcMI+rhUMFT/rIT6yEO8NXNFTLfw4HyUVVTREZt/c53dQ7WbhVadUgfL3
         614EPsAwfbpYvNChpawwRsFO9w9VW4EnMMeqst/IFGwNtLE0Nj5mLPxuNemL27L5dXX4
         mvmg==
X-Gm-Message-State: APjAAAU3V00bwtiV2MEpsoVGVPZqaSzy1N+dyoNahdUjrCktYv9AT5LU
        i/V0Wmm0BFokDAOmEc6+2GQ5F8ikNLo=
X-Google-Smtp-Source: APXvYqzJMG25W4ML1hMtIl8xa2dt4dlHxcHMky8VWiKldlEvAeVkL0EG6yJ3VagpXZ3ciV9XVE3/cQ==
X-Received: by 2002:a5d:444b:: with SMTP id x11mr176248wrr.207.1571266008583;
        Wed, 16 Oct 2019 15:46:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q124sm633923wma.5.2019.10.16.15.46.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 15:46:48 -0700 (PDT)
Message-ID: <5da79dd8.1c69fb81.eef08.3327@mx.google.com>
Date:   Wed, 16 Oct 2019 15:46:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.6-111-g51401491d85c
Subject: stable-rc/linux-5.3.y boot: 116 boots: 0 failed,
 110 passed with 6 offline (v5.3.6-111-g51401491d85c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 116 boots: 0 failed, 110 passed with 6 offline =
(v5.3.6-111-g51401491d85c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.6-111-g51401491d85c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.6-111-g51401491d85c/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.6-111-g51401491d85c
Git Commit: 51401491d85c9416bdf36f9a6150fe1aec0e2750
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 25 SoC families, 17 builds out of 208

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
