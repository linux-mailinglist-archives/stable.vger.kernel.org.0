Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D35ED761
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 02:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfKDB6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 20:58:31 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:39733 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbfKDB6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 20:58:30 -0500
Received: by mail-wm1-f51.google.com with SMTP id t26so10284234wmi.4
        for <stable@vger.kernel.org>; Sun, 03 Nov 2019 17:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y+u0FRu7jfuih55FbrlKhvnNcFOb1ujsWRbxajQ+B/8=;
        b=sLvREL7RqMAdH9MPcyj+5/90Xcx8bhU+gIUPO3+sX0IflEXgGseusVCLoxpmO1u/0i
         TOEb7XnqN31yZtRL0WnpyY+fVrM5uiEAattbY6YMgTLbTxRCm9dMpxpOFkkQ6wPmmptF
         MNPyKf4K7UXAhygWYKFidQdqKgsU2tvaSsjXqX3GcoKvAWN9E0OZTKHyuDyGEkDn+87r
         dClbBa0VDCacYFnHg05aq2I2uSHRCp1RwTwOrQdWSdC1jfq8BE8RrNf0pL6fGziQy/sX
         EwrTK75GVcwTgVylg870uL6SizPuKETBJ+gRKU+e4UcWFhgVY2y39vakMO6YdevcPGRo
         eAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y+u0FRu7jfuih55FbrlKhvnNcFOb1ujsWRbxajQ+B/8=;
        b=aTY9fhdOjf83cflw5zRp0NYWz2RCe9z9+CsqJyYTZmV9HuuM5it/DLLVDEEcPeQwbe
         NgBzXh1VXFG15tLuWafqyeFHqm0QQROP/7Aa0ZO2vEnd6dovj7q61kSEDQjTI1z4ajSK
         M7LnYQDyR1n/LV+/dP0LF4iuBKK4gnMwMDvo4PK7RlYSuUDnjBRB/qzTMibuFFL4JTvH
         z2wYdjHKyWXVmITqMq4vhJ5HFrlYs7Ph9gKO4U2jsuvuECyHVsJhmbusRCXBRq+AklmM
         uQsOLWzWpiCj0HQknMwWANsCUOof3JbFyJ8cYHoSl5V0VUX3YTgiF7QU4+pRwo4Qbyut
         XOJA==
X-Gm-Message-State: APjAAAUzJXgoZ/0Z32SmIXVjLEuWQa37i4dP4KyPgzFoQVNQnW1qQWvs
        kAMXeY85P2WD+IDv3wOg1OeMBcasfnc99w==
X-Google-Smtp-Source: APXvYqw+N5YF0CscZvDJ8TlrTJROU+2XkWkNIckWCpWslvyegvijkQWytg0q14hsuMrjfVxDhPZ4xQ==
X-Received: by 2002:a1c:e08a:: with SMTP id x132mr21192404wmg.146.1572832708704;
        Sun, 03 Nov 2019 17:58:28 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a16sm22752044wmd.11.2019.11.03.17.58.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2019 17:58:28 -0800 (PST)
Message-ID: <5dbf85c4.1c69fb81.53545.a9d4@mx.google.com>
Date:   Sun, 03 Nov 2019 17:58:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.151-68-g6315e63eb529
Subject: stable-rc/linux-4.14.y boot: 110 boots: 0 failed,
 103 passed with 7 offline (v4.14.151-68-g6315e63eb529)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 110 boots: 0 failed, 103 passed with 7 offline=
 (v4.14.151-68-g6315e63eb529)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.151-68-g6315e63eb529/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.151-68-g6315e63eb529/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.151-68-g6315e63eb529
Git Commit: 6315e63eb529c3e0813988aa6cc049b925f5d9bf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 22 SoC families, 13 builds out of 201

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
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
