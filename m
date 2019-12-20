Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA281272BF
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 02:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfLTBYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 20:24:53 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36237 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfLTBYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 20:24:53 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so7579096wma.1
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 17:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RA+gXYZJ0g+K3M3DQNTJnvbd+pXel8RoSV2e1nZbK04=;
        b=AeNpLx0japu4ycb+IWldSG5ntHB3157HQ3duTxTNUAOhKZR/hQeY+080N5r2bh1J/6
         d3U6jUuqYZs50tZUCQ5lqYdrEsrXfQh6+CjAff3Q3cZ7bXwpyxc1Vie0b9nx6dZk6Of5
         EZUxckbMbK1F9jZwnuTqPeoc51bTEr1cGYy1YEqC30YKCmYlAHZKlbW7lb4LrZzso0GA
         +4D1qLRJ/pbTkAfsEo0rFJ1uqggWbOYImfIropsoVblOubGn3xXKmzzL0Iak5tIQR5Wu
         xMGEVzz9z/eEcqka2k6dp6kn9YAnV5A08leCnAw4nMSZ+5XDtw2g2s3wN4rL+exAGcHs
         /dtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RA+gXYZJ0g+K3M3DQNTJnvbd+pXel8RoSV2e1nZbK04=;
        b=nGbfw4AWZsvkwzyos7Q3pRRENUGyWC25vsZtfTvP/0McJu6xAwyWOpDX5Wd2Ig7jzi
         e+ytVGJR/Jyy/5d+TKXGJ9HYF8vj/1bZIViBv81V2kEmNPMyJzA9phE+rG9U1qp9WX1s
         WCR5TR2sH4HWdjM31TWxRWW/7rfnZu0b8aa2pOuOMlloqhwND07QDw4f/twxckva9svX
         xdgoQOi3jwVQ4kkmzeRxgm3xRdSeQtUdBi4Gb9TjqN38+NWBXkutzr5xM/xioP9onc+P
         9J+Dbjn6XakOQuWMn1UFirnL4N8yIBttmg5wO09xyqNMC8cGdq5q1pVnLcOt2QIJ+0Bm
         gOCQ==
X-Gm-Message-State: APjAAAWYdOUvJ4jiGBqpmQAeZNbNq2eAwq4QpuLMt9E/+Bg0Os4xIdx7
        vt0iaDSkHZDCxYwac6J2NenY/HY8ASv1fg==
X-Google-Smtp-Source: APXvYqyxO+i09YW8570ihI4p7YfzLEc7uekuGXN90itHTxKTk4H2mZIw0L+dKWPo9UWnNg7G1MyNOQ==
X-Received: by 2002:a05:600c:1007:: with SMTP id c7mr13804334wmc.158.1576805090585;
        Thu, 19 Dec 2019 17:24:50 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y139sm8567319wmd.24.2019.12.19.17.24.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 17:24:50 -0800 (PST)
Message-ID: <5dfc22e2.1c69fb81.f4294.c192@mx.google.com>
Date:   Thu, 19 Dec 2019 17:24:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206-163-g9fe78e96326d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 81 boots: 1 failed,
 75 passed with 5 offline (v4.4.206-163-g9fe78e96326d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 81 boots: 1 failed, 75 passed with 5 offline (v=
4.4.206-163-g9fe78e96326d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206-163-g9fe78e96326d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206-163-g9fe78e96326d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206-163-g9fe78e96326d
Git Commit: 9fe78e96326d85ca140930f72dbce8b198001210
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 17 SoC families, 15 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.206-163-gf=
a8359d689a7)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
