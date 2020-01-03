Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF51412F914
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 15:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgACOOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 09:14:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33489 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbgACOOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 09:14:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id d139so7048863wmd.0
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 06:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UbjzoSE7U/RLlrN1efJ1uOMJjFiByYEejOvBgb1vaS8=;
        b=TGA5PMhg3SoK81fveB84ITXP/P7PQAKWgdFCa4pDqySik5nIM6nM+cPaYpONogG3Vp
         0nD3OQh+Q1eiAv3soIyn0jwsmCIwmgxvuGL7Q5+Is+thxrU8pZJKt4ZjXdSg/MWVXdA9
         Pz9oGg6WDOpCNZZhVj3oJjQK80145unn7vM+/rOOFE34ZcXmL0EqOCkubvrbsBF//4BI
         SvUKL1lWfFjdX6AIIVvCNrnjzwMhz5DxQwmdqKfXKRxzkk2w7CopZ/wKNc/G2exg+4x+
         ktrn+rbM1iPuCGT5GgEvycR/rcNTSmzdZyNJtZIgAOhsZjv24ssjaWQc+ogAAzRkz7Py
         nfeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UbjzoSE7U/RLlrN1efJ1uOMJjFiByYEejOvBgb1vaS8=;
        b=KRSpkPN/JLsJzY3uHW9jtZYDV0bLJIcbwWJPkJi/KsyojX1mDH9nuy9m0OKSGgcrPr
         4a5GJIUmPc809jPG7oomEhyZsac8P4XYSZOJkO8Krr3XZrTuXap0J6LJdjCUGaqW0gRl
         Y5f+PnvmIdXVhxUvIiJIlw9qqEFCAzN5XYNED8QDa/pUW+9pSETUfs4pHKFkzcHEyZXF
         xWq6eU8+SA1pEZryQbeer0WMzRI4dl3gY/lxmhYx7IuO421UTY06MrRC9J0OpDdHPZY/
         8kfM5ZmOlNiHcrY3XmVu15aJ1KIAp863rOXSRkw9yEOhMph5o6J4tajD1niMpnfBhdn1
         MzCQ==
X-Gm-Message-State: APjAAAUyXlUyrZ4pIolc8M6UifRnHmbUi7Gifo3rMx7kMVG3yYhJ2bOB
        3H3zCuRvO3tJG8kILu79XZ5HVtZP872etQ==
X-Google-Smtp-Source: APXvYqzHMyGpSslDRVlAZ/7kFXOL8lyZzt/Xjzf+Avdk6U6gfBRdBL969tU13cfwkaKIR65W6SA8Cw==
X-Received: by 2002:a1c:628b:: with SMTP id w133mr19625784wmb.25.1578060881941;
        Fri, 03 Jan 2020 06:14:41 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q3sm62354081wrn.33.2020.01.03.06.14.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 06:14:41 -0800 (PST)
Message-ID: <5e0f4c51.1c69fb81.71a0d.cf73@mx.google.com>
Date:   Fri, 03 Jan 2020 06:14:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-114-g6a2e2a4c865f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 63 boots: 1 failed,
 61 passed with 1 untried/unknown (v4.19.92-114-g6a2e2a4c865f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 63 boots: 1 failed, 61 passed with 1 untried/u=
nknown (v4.19.92-114-g6a2e2a4c865f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-114-g6a2e2a4c865f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-114-g6a2e2a4c865f/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-114-g6a2e2a4c865f
Git Commit: 6a2e2a4c865fe8eea3f61a30fa56517586329640
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 15 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.19.92-115-g0ff4783e7=
0ef)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

---
For more info write to <info@kernelci.org>
