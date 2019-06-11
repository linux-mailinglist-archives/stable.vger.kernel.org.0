Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B890F3D5DB
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 20:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392116AbfFKSvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 14:51:22 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:39899 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389470AbfFKSvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 14:51:22 -0400
Received: by mail-wr1-f54.google.com with SMTP id x4so11548220wrt.6
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 11:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dIdIfomjYXe1ofjhjaA/0qYfQgICK6le0Y7qL3IqhHM=;
        b=rA4elLbB7vgMaCN6m7IrkK0l6Dptk/vleZy5xWRQREts1DCUL415YHr38rZGofj5Hq
         hnZhE7v1mdhFFbUXz4aWLcHfyaKZ86+sv/Z+g5wyPRFY6sh4GeBG63vVWeAl3E7rVd/l
         33a/zoa9YLE/YVSnmGJEcrtUuhwcJddjo/mJUJnyBmsMbnYAO/MA8QXtYJZ6rC7oGajm
         eVZ4PGCQRR1YbA+ilkKj7nK2uYypvV7FfgHyOlA1PlravkSJ0BW7ue7TebBHBzWIkY09
         uBVebFbY9Tq7TLGzhZhJrXZ8pPAaG0rUXOPRhRU7xri0OnO/ACJEMQFX0ip/ur7iJl0O
         /jOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dIdIfomjYXe1ofjhjaA/0qYfQgICK6le0Y7qL3IqhHM=;
        b=LS4It4V8slAlacFOhtscOQV1yl/ZIjjXs9BgC6inNMFWiWyuqIWrAtYQD3u5coBPmr
         teME/lpDVQDmpaudLcrISoLBNrRs4oubpfhksKovuQPNZ943/5tG3I3UWCM/6HKjAxnB
         +uvvHGRFz4EkUIdg/XyEOFBeamJnDfMfa2WM80IdiFHolmBvybylvC9cJkh4zUuwOIS1
         HDnTgEXMkS57jgxOppf4eNN8XToGFXUniBrPtDTncbJl/vpVahP3330RSDZB6kU6zoTG
         SRYrBhtA1rQnHkGzyDWBXonO/7sEuRzo7d/hai59A9zV4l+pN0lJT/F89wRHUkAtTLmC
         ASqw==
X-Gm-Message-State: APjAAAXGnNrkpIwPxLVZaBdH5F7L7wLlQow0voW382bhte6+wz7M48Bv
        pUZpM91s6HDpqrY+s0Ep+8t8YmsKzsSHDQ==
X-Google-Smtp-Source: APXvYqytasm7dskZZb3cf17y9ubO2vmCVzqLPw1S5+2NQmOVW/hlVHZ3QMYIzIDV7z14mQaJ2PlPwQ==
X-Received: by 2002:adf:e2c3:: with SMTP id d3mr23564080wrj.314.1560279080293;
        Tue, 11 Jun 2019 11:51:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v204sm4769859wma.20.2019.06.11.11.51.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 11:51:19 -0700 (PDT)
Message-ID: <5cfff827.1c69fb81.2c243.ba40@mx.google.com>
Date:   Tue, 11 Jun 2019 11:51:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.9
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 138 boots: 2 failed,
 134 passed with 1 offline, 1 untried/unknown (v5.1.9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 138 boots: 2 failed, 134 passed with 1 offline,=
 1 untried/unknown (v5.1.9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.9/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.9
Git Commit: 2df16141a2c4ab648b5eceb6cd1ca8c72061c51d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 24 SoC families, 15 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxm-khadas-vim2:
              lab-baylibre: new failure (last pass: v5.1.7-86-gcef30fd8e063)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-khadas-vim2: 1 failed lab

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

---
For more info write to <info@kernelci.org>
