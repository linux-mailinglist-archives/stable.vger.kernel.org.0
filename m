Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E231CA59
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 16:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfENO2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 10:28:42 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:50931 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfENO2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 10:28:41 -0400
Received: by mail-wm1-f53.google.com with SMTP id f204so3132737wme.0
        for <stable@vger.kernel.org>; Tue, 14 May 2019 07:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FgviNWbR68aZKeTkZLmp6ocFGNcnajNp4+yXVnqMOMA=;
        b=l0PlTwXhxSWBt5MO+MZgIYwwL7eJnsMLnn9DrSUJfAlgh9uL9NBvQfum12DdZbi1wO
         owNHYe4pnHlFjYCAH8xGXV+ch2vKnAeWwOg9nCEkf0rC7rCahb4cam5E/7z4q5YU+vfb
         kuP7txakVa4sT3gTohU4aHmp9WBrS1GnrI+Li1IO/wbETYC62BaEpxffsyofGU66V5PB
         pncRvJItcL/TmnkuCxmwyvlaRz8oifYMyE7xdq41AzH/ETHEWT41wxbWDC1JncPi2gBm
         VrWwl02P2NBgjRmO9A0+XA/w49a8Av8nFlJdO69PjvJOKU755HqkrMj+eAlEI9hLr0B7
         tncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FgviNWbR68aZKeTkZLmp6ocFGNcnajNp4+yXVnqMOMA=;
        b=gdPC/qfeHNGqkFDUNa7ThvEZVavaqecQmqxcsiNGcxyLEKQRQLPgCFS6VqgS+hmvzh
         8XI2bfufft1e4d758M7YbXD4wHaFXkn3XS/DGZc2vtWs3+vQd6T2Zp3z5KI9jeFu5BvN
         FVglG7S4HFOyQI9C9L7WTBKCAuM7uWeyKade3Sr/BHwLmYUP2vcBdx1GDdyCV+abTCib
         Gz/XbgAThX1UiWkP+5QQEEqPIhnR+VTK/6BDr6KHHl8ycP+cwLkU12EV355p0Vy5fnMn
         gg8ykctf1Yh2K9Y0f/ojjsSeW/TJU1UrZknqCm61YKyvmiSzATyRKyOoRoXcfzLXxOEf
         cXKQ==
X-Gm-Message-State: APjAAAVlUORV6h2azCRcNn/7wL10eIkRTQEoVJ65C42A+pJc9wbvDQsG
        d+lE+IHQFFenc1ceyd2+WnuAZVmWay8pXQ==
X-Google-Smtp-Source: APXvYqzpX5J4WRvkWLVxhil1Vo6+kYeBt52L9+ASDlvC8v89AAJLTtCzoE21FR1mcBftOgEc3d9c+g==
X-Received: by 2002:a7b:c301:: with SMTP id k1mr19123903wmj.37.1557844120018;
        Tue, 14 May 2019 07:28:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f6sm2896746wmh.13.2019.05.14.07.28.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 07:28:39 -0700 (PDT)
Message-ID: <5cdad097.1c69fb81.8abf1.ef73@mx.google.com>
Date:   Tue, 14 May 2019 07:28:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.42-86-gc8e3be30c4b6
Subject: stable-rc/linux-4.19.y boot: 127 boots: 1 failed,
 120 passed with 5 offline, 1 untried/unknown (v4.19.42-86-gc8e3be30c4b6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 1 failed, 120 passed with 5 offline=
, 1 untried/unknown (v4.19.42-86-gc8e3be30c4b6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.42-86-gc8e3be30c4b6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.42-86-gc8e3be30c4b6/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.42-86-gc8e3be30c4b6
Git Commit: c8e3be30c4b609f2f7c587d1a2ae32d1a1d8f9c9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 23 SoC families, 14 builds out of 206

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab

---
For more info write to <info@kernelci.org>
