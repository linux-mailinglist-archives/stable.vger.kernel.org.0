Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77EA811225B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 06:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfLDFXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 00:23:00 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46182 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfLDFXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 00:23:00 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so6832295wrl.13
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 21:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ubyN4PJ9h348rYAtYPdhmHp4mBXmKLrIPA0+fpLnI0M=;
        b=C1cvhY+CC9ry3S4cCre6KlANV3rtvHHdiHOnfhJnmPS5Gvve0FWWM5FBWCI0Ae2fCc
         jBoOYk+EpbI2k9KPerzmspyZTugViTbNdo82QoxPq+DEcbd3sCexI+CoPAMY8OgEYQEQ
         YYL35OTCKdof7AtSYs1FPzAew7FLXlpTIe+QtA6xJQK6hIMx4Mbo1Ua0C/+6z9K0MCwn
         a5N4OffeBCdHvAFSnij9w8e8ZA4DhW0+HDxYRAbKngLNhsizw0BkAd8CnpPAD2yIhndK
         54d0pGaBD0hAS2IppJ1HmSdCjsLbjbJlz+zPCyLPF/Nw8RE94WEN5/NanInsYfXRWzLZ
         4R7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ubyN4PJ9h348rYAtYPdhmHp4mBXmKLrIPA0+fpLnI0M=;
        b=gZe9QLPIg3aZ6jVK/JT6gJcn6Fr02vwQblMu5ZkR61QuMp5uyst8LYVIGSKEbAx3Hh
         U7q4gCsqCK3DhLH0Hzx/DWHe+zeNKrKEiHsNUKh2lpUVx+vSLEAiu6RIKPNBf+tzvJkE
         c4+KIcqi4LHjDrvtFBmWULJtOMQXHS9aSgPolS0E8TkszyzlE7BPCO8tGH6k9H+HKta5
         QrhgtwyDchz3BGanl2ZUgwlYV0Z5bggaK9ibAcUFhQKYrPiwJ4gMBnly4JboazVJfTss
         dmjdPDp2oKQfSVM4VjX0nZeNafAL8GWlPsvxSjAyy4KblS/kFi7X5Zm5aQ1iq50g63NR
         lv6w==
X-Gm-Message-State: APjAAAXDhE009N4A7llKlR099psta8Ne3nCe249ieBEUkU8+qYDQUt+k
        l0ixQEmjeYItDKx0Gwo/Edh+pQxpMxRBKQ==
X-Google-Smtp-Source: APXvYqwYfGP1iOFEHwlgx1aCMa+8UC3PS7hrPtb5KpaNKft04jj8p/z1IDs4rbb4OS07q2jJmgijtw==
X-Received: by 2002:a5d:5091:: with SMTP id a17mr1727386wrt.362.1575436978175;
        Tue, 03 Dec 2019 21:22:58 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h97sm7124685wrh.56.2019.12.03.21.22.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 21:22:57 -0800 (PST)
Message-ID: <5de742b1.1c69fb81.ade93.2259@mx.google.com>
Date:   Tue, 03 Dec 2019 21:22:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.205-125-g32fd05a6e791
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 32 boots: 0 failed,
 30 passed with 2 untried/unknown (v4.9.205-125-g32fd05a6e791)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 32 boots: 0 failed, 30 passed with 2 untried/un=
known (v4.9.205-125-g32fd05a6e791)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.205-125-g32fd05a6e791/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.205-125-g32fd05a6e791/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.205-125-g32fd05a6e791
Git Commit: 32fd05a6e79145a5d0532e68d0bb30b4a556a079
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 22 unique boards, 8 SoC families, 10 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.9.205-122-gb1edc48eb=
b5f)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.9.205-122-gb1edc48eb=
b5f)

---
For more info write to <info@kernelci.org>
