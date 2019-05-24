Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B00C2904D
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 07:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfEXFPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 01:15:09 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:56061 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbfEXFPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 01:15:09 -0400
Received: by mail-wm1-f44.google.com with SMTP id x64so7911284wmb.5
        for <stable@vger.kernel.org>; Thu, 23 May 2019 22:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RFTpgKRph5hKN4zTxKUj6Kr/SwTVEIL9u2TwViKkFZk=;
        b=TgdryHlEdPYx1wzbgdjlElExQY2I2KM70fG310F7WwOlcEw6mPa2lcc6wb79zw9LCi
         /0gQ97cQBByv3gU/Ht1c8bAcxQ1E9L0MJodr2TLKvIjvF73JI93uw9SiyMN2RubW2nd6
         FrdV6rtJH1jKqWAj9O9lI0E+A53CNqOBajHyGyekjmRI4hyjTtsbFALZl9zG1yAROwiU
         7XZYgcPPFenc8+AyKuMwzvELVThH16crkWwR4BmCLL1eo5xj+kJoJJFDLKsrjb503RSS
         vL1vLdiKsMkEtOtBSST9kct6jvGdbZ1ivO5UPfxWkheJsAD+6Dh46VjzFhwS6X9I0TS6
         uuGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RFTpgKRph5hKN4zTxKUj6Kr/SwTVEIL9u2TwViKkFZk=;
        b=HxEvRu2+1521E/6pja2eObjEPmuGe5xj+ZWAvYOdlO93ejSpeWHAhyg+HxKi+4VB3T
         HYe2PiKg9d9GIY3oHm+/ed1EMgdj8RxWFoagk26ypMPtM+DPjo4SlHe0djmB27dqO6vV
         R6TYgswRLsW7KJUgoYlI0oZRwfnKvEr9rpSshWWoaHJkWosJu++FB6pBSAT7Za9mbvJj
         EcAQ/3EK0chmD8Lg+lGOsu+4yVnmCRJyGL0wJ99602DFKScXWXncBv/BuyOZcCLnwnAa
         cAkrWTp37E5VHmJ/9/C1lvggcgQzvyUkMOWT647FnDZqlNAhxS52CpZoFL2DDFnEyMQU
         Rq0Q==
X-Gm-Message-State: APjAAAUFNiqeJfW7spD6VTXs0lhaDGJWR9KRc4QGSxRGfapyMfp2Wtzg
        kQPNG5e4VdX07734I96ZYJF+Uu8ZC3W71Q==
X-Google-Smtp-Source: APXvYqw9F1VQzj+Cl+OEQKwI4F5ATTKjEFjvZhOtdk/o3PnGSccMhtraHzw260zBphsauGHFS00NYg==
X-Received: by 2002:a7b:cb01:: with SMTP id u1mr13886591wmj.153.1558674906207;
        Thu, 23 May 2019 22:15:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h188sm2200633wmf.48.2019.05.23.22.15.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 22:15:05 -0700 (PDT)
Message-ID: <5ce77dd9.1c69fb81.cf712.b7a5@mx.google.com>
Date:   Thu, 23 May 2019 22:15:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.178-54-gf6bc31d8c3be
Subject: stable-rc/linux-4.9.y boot: 107 boots: 0 failed,
 94 passed with 13 offline (v4.9.178-54-gf6bc31d8c3be)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 107 boots: 0 failed, 94 passed with 13 offline =
(v4.9.178-54-gf6bc31d8c3be)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.178-54-gf6bc31d8c3be/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.178-54-gf6bc31d8c3be/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.178-54-gf6bc31d8c3be
Git Commit: f6bc31d8c3be3e5ab957341b3f99f8b45fcc646e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
