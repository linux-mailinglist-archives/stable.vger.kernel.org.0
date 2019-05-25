Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9652A72F
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 23:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfEYV5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 17:57:54 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:35031 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbfEYV5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 17:57:54 -0400
Received: by mail-wm1-f54.google.com with SMTP id w9so6200234wmi.0
        for <stable@vger.kernel.org>; Sat, 25 May 2019 14:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bp00/TkXrOJw7KdkFrh+hb6HrBFkd+jpMWfD5+TI5KY=;
        b=Qb16ZoBXQCXkNKKNld2gwl4VWo2BkJLn1VSemeGq7Tvv34f8Jn0sJ8I9808bcJYiox
         4Xw0dMsHBip9+jLjooMpBJ/Z4ygAvBYyWm8Py4X0ZBi8loRyQpQxM/1f5p4QBrfvrmOe
         PiC5/fwVQEI8CDRwynTmzAC4GwyJwqQqMXvWQv5x3rmnEZ4by5iaVwQ1V1UpGI8WY8yi
         4gCoVAcTzl6ZH5t7XT/v4iTLBHxI6+M9AuzhY8ZLPtBABU2pMukaB/5Zs/gaK01h1vBW
         hsPau58GOQQiVss1I38pyAi76ii5J125eqZeoeXD4RvZ2eIF2AwaaZSjHs05ZCpV13sy
         CgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bp00/TkXrOJw7KdkFrh+hb6HrBFkd+jpMWfD5+TI5KY=;
        b=OVHf1t5G3bfk1pnwibN1RsQMBOaXnQilmWnhjCiGV9dJtP9JM0wgLkHPRCeywnl1et
         O7WpRDIbDGWd7j7xPvoePWshIq/LM/6S54UsJsRXvqZkaiQBjeOnOw7DL46Nh8AYNwqX
         51TWTYXxXFntqPkQfGhdOEnAQDw0CgAN32+J2qc/PnGsiPHHHBMagiBG3UisLUzY/S0j
         Worw+aDH35X2Ltsiv4hB1+bwL0yCNovEktqiPjl/65v2xPS+wCdf/8EsmpvY8Rod3iB4
         46qEi2f1CDvcoatUeIRhiciR7u+zptPYNSPGadxdBzrnpVyX6OvHNUs1+pzs4G/IxCaR
         kQew==
X-Gm-Message-State: APjAAAX4JfRFG/8jotLzgGFyfXelHFiicKgSHibsxhLRIeySAU+u57po
        uurD8E5zfgG8e6ESlmNYzxuGfOk3wjA=
X-Google-Smtp-Source: APXvYqwbyhBNSegKlllfbZvZBTWYoEZ50Sv0GUu8y5hZrCLM57FLAC62r/l0UxKN/nQXi6qhKQzeLg==
X-Received: by 2002:a05:600c:2289:: with SMTP id 9mr21792020wmf.106.1558821471563;
        Sat, 25 May 2019 14:57:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z8sm4693271wrs.84.2019.05.25.14.57.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 14:57:51 -0700 (PDT)
Message-ID: <5ce9ba5f.1c69fb81.1f5b0.8664@mx.google.com>
Date:   Sat, 25 May 2019 14:57:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.46
Subject: stable-rc/linux-4.19.y boot: 121 boots: 0 failed,
 105 passed with 15 offline, 1 untried/unknown (v4.19.46)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 121 boots: 0 failed, 105 passed with 15 offlin=
e, 1 untried/unknown (v4.19.46)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.46/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.46/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.46
Git Commit: 8b2fc005825583918be22b7bea6c155061e2f18d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
