Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C784C28C2C
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 23:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbfEWVP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 17:15:29 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:45098 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfEWVP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 17:15:29 -0400
Received: by mail-wr1-f45.google.com with SMTP id b18so7733868wrq.12
        for <stable@vger.kernel.org>; Thu, 23 May 2019 14:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9L0Wpl84GG8xfE3p0sH8/hSrpm7Fw1aE4cVu9AIso0w=;
        b=QFnu7YfEuArua1hz1QZfhlZ1e/EJ9s+JSiyWxfYoKNBHpsRINOrDxsGgHwENZzI5bk
         nn7djnDECPXdCk4dc1+CHO5Re2HZTD+roZYH5tfLpo6vSl8HD95ryLGE8isH9MI7gRFP
         zIkkl7nkzH1tlHdZ/0Hv3aVb9kC0RdqSAd0KLvdpkkBd9aogD/DrZXPUC+HLkRV5f+q0
         u4wvMzdkpOmfFKPyn/ht8ViTU8lsxR1a7tZhJ9H8vsik3ljMVmyhnwtru8aim7vaSR/E
         jSgsGLr8fgZO6SYzqrmZZxR0PcenIwUoAbJwzt29rl/bYtlm5pdyJPAXafussyf8TIQU
         5y9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9L0Wpl84GG8xfE3p0sH8/hSrpm7Fw1aE4cVu9AIso0w=;
        b=ScFpVytd7VveT0hJN8bgPx0fp0xQ46QQi8zsu6hQm2zNx71gZMNL4v4onsphQhF4zT
         WYi2TdxEzs+HuZnAwm220M+7UcVIfR/X4gpB+eSWSDuF96ycugF/WZLRZHWf1FAy/GPF
         N56Z/11yamwcP2KNGYwoaCMg7cKJf0qK5+CMqi+7aeuFKX+pAr+u6f2NpxKvOl6ySyLL
         rgjnfXoLOKDHKzGatyTQAgJKunAHLkOEhJl9xh8lsOcmbpkUjyZuh1CMrGk5MDyIBM0I
         4Ig2nXR/kdz0pNfFuBg88GdJS2umqYMudPbRwfVq2kuLtjcvxOFpVic4d+yf3Jt6tOh8
         f4Ww==
X-Gm-Message-State: APjAAAXhl3liHSHTQcV6eTnObIQm7obkuw+kj5n1KpznMszAKmpXNk7j
        rfSnh3xWajL3CsGJ1y8kLKaiB+jnO7KD0A==
X-Google-Smtp-Source: APXvYqxIE39zAlBtOLnwoQLvlFnDbL/8J/jVwyItl3tmpNLBZGHI2ELHNeRRj0/In1jSsHyHzu+hDw==
X-Received: by 2002:adf:f250:: with SMTP id b16mr28991427wrp.24.1558646127084;
        Thu, 23 May 2019 14:15:27 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x4sm307214wrn.41.2019.05.23.14.15.26
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 14:15:26 -0700 (PDT)
Message-ID: <5ce70d6e.1c69fb81.ab061.1cb5@mx.google.com>
Date:   Thu, 23 May 2019 14:15:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.18
Subject: stable-rc/linux-5.0.y boot: 139 boots: 0 failed,
 124 passed with 14 offline, 1 untried/unknown (v5.0.18)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 139 boots: 0 failed, 124 passed with 14 offline=
, 1 untried/unknown (v5.0.18)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.18/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.18/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.18
Git Commit: 8614793dbb41ccf8699ac1aa328702b47efb3b8d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 24 SoC families, 14 builds out of 208

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
