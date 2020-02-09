Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCDB1156A0D
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 13:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgBIME3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 07:04:29 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54450 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgBIME3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 07:04:29 -0500
Received: by mail-wm1-f67.google.com with SMTP id g1so6873106wmh.4
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 04:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ShGUcuA+XIqniLG398apdwbfpTR8U9U6riW93XxfmMM=;
        b=DiSV3m8lT3cmbQHFQqw8l18EvvPAAXa7ezsmqGLXKgJ7B5KdklxqSteMPl89rkmuby
         W4Pm9HkfUxtrvELUt/j5KdXZjnunj7lw+BYH7BMX+JOS8VzCZC+l87I/+yJzGKY2HWIU
         HnvXnW5jkP2PxAaJJJARzawZbjdYecryYdZ19TiJnTZ/pBEzQIb/NkP+XTMic47EX1FH
         +FVcidP4lb53dJlNOignD4wif1ycN+jgTb+Udvod7vM/C0Lnovdy0Q+dSDCDy0kklfnQ
         tKiXeHe1HDW5kTtjA72uRQwsuM/z9V7whCB3Uw1manA5/El8v9dMG7D3IWWxDLswLdJJ
         4w3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ShGUcuA+XIqniLG398apdwbfpTR8U9U6riW93XxfmMM=;
        b=mnd+qeEECPpXglOldNYRaMVhw1ytvzbekDeZ8plQBDbytRW9uZi31eDbS1EMPGYt8G
         q8+gadk75je+Xp0iQfgub4PlD/FPp6etrgsMXlktqp8Y/sR4S7h+A21gevrKR2B2tu85
         pMF4U8SBNnOI9oYMdIECghuc20yHhDRe9Dd81wq9hxEof1DMCYcmQtmI2mnMEQvZnAnf
         3tTxnOMovLCTZtWwk8SPZ4yKNBM1lKV3Be+4DZzEYRr9eO2SuQQoh2giP/MhoIinV/fH
         deA8o7Wxtxc4tfqwsH3ic2kmZG1MelcgsVKsAVRJN/KqPzBdfTXe5CKo5xQCSTMrgm9q
         dwsQ==
X-Gm-Message-State: APjAAAXA4P/HJgbmoVTdOlplQRvVmLNVPvy5wKm2o5gOklVB4LCZJY2Z
        2CdG33Wl4PEzX/dWnqWt3UDbTh0cVGQ=
X-Google-Smtp-Source: APXvYqzdljBvGZFGsaPXhzom4U1KIqzQuCOQab12ZG3tykoFsjDwOrocGymH9Jteq99FT4J1p8CswQ==
X-Received: by 2002:a1c:cc11:: with SMTP id h17mr9338963wmb.19.1581249865995;
        Sun, 09 Feb 2020 04:04:25 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w20sm10975722wmk.34.2020.02.09.04.04.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 04:04:25 -0800 (PST)
Message-ID: <5e3ff549.1c69fb81.9b25f.e4dd@mx.google.com>
Date:   Sun, 09 Feb 2020 04:04:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.17-260-ge3082a4e02b8
Subject: stable-rc/linux-5.4.y boot: 58 boots: 0 failed,
 55 passed with 3 offline (v5.4.17-260-ge3082a4e02b8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 58 boots: 0 failed, 55 passed with 3 offline (v=
5.4.17-260-ge3082a4e02b8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.17-260-ge3082a4e02b8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.17-260-ge3082a4e02b8/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.17-260-ge3082a4e02b8
Git Commit: e3082a4e02b8a208957ee183e72866caee83f2ff
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 19 SoC families, 14 builds out of 157

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.4.17=
-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.17-238-gbf=
fcaa93483d)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
