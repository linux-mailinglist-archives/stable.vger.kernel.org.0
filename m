Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A87B474E1
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 16:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfFPOAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 10:00:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34700 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfFPOAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 10:00:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so7124483wrl.1
        for <stable@vger.kernel.org>; Sun, 16 Jun 2019 07:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7fViJ59P67jvZYu/iDnNCPpnY+8fuCDNOaiLU2uSe5k=;
        b=RAG8Xdo8sXxNlyS7YzMMYSL3tb/NwWORq+DqbSbKnaKGCHJusvz29QAZc1Bb05vd3j
         B6mD5HPoFpd2xJo5pgFDxCAm7Vf63mI/Sb5bpeSKEn1UuYPxsXEhiTA7oNN+PvyeVbi3
         QeDa1CphwemcE2LYshUDLccKBbHMwu/sfYew2qM4q6GO4zOv8TobLzd1jJq0EkSqBoqe
         ulRFRB6ouQrTdoSO9WnDv9FksrXDwyjIZNa5qwLvR61AxHblt0re3nDk31bSSXxqlsCE
         OF07WrI/cwmt6n70cFXZhQgarpvlUvlhIZbhoRiE4LipDTcJyW+XG/O0i+glUBPBNENX
         q+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7fViJ59P67jvZYu/iDnNCPpnY+8fuCDNOaiLU2uSe5k=;
        b=Tl7I06Gak8ZPpJtwEvZ99PaetFCeSyRiaVgmkLEYqMGhAN9BJIbzKPBzVnHG1WnwjQ
         KAlBg5/pnqrwDJ72N2yZuIfIV6wMss88LuO3JecVMsDdc5sAA9r1CtOXx2kAg6jGbHcO
         N1hAmXf0L6AW3YftPRsY4sYCjXj7D9vmqymq8DJfAwuFDdM3OvMccg5z72g9k1tYLFJm
         9+RiaaHYgdBmUgxTLR9djgo6oDy9S2n/mcKmzB0v0m1CqsFHYuwvxQvh7AgUP26aHl7o
         w8ulWoO7C+CThInoBT9HmsdeKotgkuuZIv/6x6a3d54Ag4aZMScnG1b4+od7IxFp1v8a
         zQ1Q==
X-Gm-Message-State: APjAAAXwSHfNhjZN2MtlfODUHr1m2bPAMatwxARrS6JdgWvqZjJGsfU7
        Qh+pE+MSspIBTmvHmk6Y3PJ58JmXvWo=
X-Google-Smtp-Source: APXvYqyd7W9lMqnWfegL7dnCB7tTT4o9fse15RkbyKxtm1SAsBh7mWl94ettGcECZR7J1HqNgwrNsQ==
X-Received: by 2002:adf:e8cb:: with SMTP id k11mr70773412wrn.244.1560693637862;
        Sun, 16 Jun 2019 07:00:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i188sm13576864wma.27.2019.06.16.07.00.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 07:00:36 -0700 (PDT)
Message-ID: <5d064b84.1c69fb81.b98da.87a6@mx.google.com>
Date:   Sun, 16 Jun 2019 07:00:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.181-64-g66b52acfda6f
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 75 boots: 1 failed,
 66 passed with 8 offline (v4.4.181-64-g66b52acfda6f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 75 boots: 1 failed, 66 passed with 8 offline (v=
4.4.181-64-g66b52acfda6f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.181-64-g66b52acfda6f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.181-64-g66b52acfda6f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.181-64-g66b52acfda6f
Git Commit: 66b52acfda6f0ff2ee1fde91985acf267e14af17
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 40 unique boards, 19 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
