Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 230C7CD9DB
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 02:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfJGAQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 20:16:33 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43104 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfJGAQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 20:16:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id j18so12282821wrq.10
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 17:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2L6tu62CQLvhfmYfpH+nP8vU0QMy44jNC1xZXtr0hog=;
        b=Fi0CLoy8mQkhg0qDy0m5IbS6ctkqzpbw5fBOt/O2Xd5wAY/fdFU0aVKNL8lIAAPpDJ
         S7DUDqr8DU8JBZHdB+rHpBR2G+Stsp+FgKqefzALVOWesJEnKHiB1hFKHXVyAQUkWnbn
         R8tv0tkdI2+ZaDuHKOcBzLzFhdhGyn3giOg9VrVYIDM74rkyq41eJzqNEEFTu5M0zDpb
         nFdZE+XdUShkr8bMjqQnTwL/zHcY9xLoibTTtnBe/MuN44g10VfkeTIwv7HJ1Tfv6F3w
         /eosZau9B436Pzk5S5YONFotZJbAKM6p51Bk1tMwnNBNm2PVvu4Yscpt6csF3Jemzsri
         2d7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2L6tu62CQLvhfmYfpH+nP8vU0QMy44jNC1xZXtr0hog=;
        b=TCbdoiQ+0HHdleMGQXE/V67Zn7175ZFu86AavGgQQxP8ijXOFf3Gy7WKxxayvkPc+d
         eTs78QPxOCmGfmMdCJrePQG7zU3NQaTyUoMBAIvG1qv9rP881JUqpM9qMzI3AamBEB7V
         eS5uTPLlvIKsT/V2A43G/q13YThUlunyXW4P//VzrTXykDqpCIwSVkA/U2GqPEDkFfra
         rI/o7hjX8aLZPcJ3idcKgs6k3af9PUY5G5zvNlmNFRvIK1QfzL9Ls+lSwCg8L9NM1fZ8
         OsddosVwvSUh1jN/RB1G2QHulxKpJNpIJg20FYmV3u7iRXRFF78gvqGRiESCWAuf1HQj
         iLnQ==
X-Gm-Message-State: APjAAAU9iQLMp6la5eXik8fUlYyli4WbNbJg8oL6gPcgxS06WPETOd6d
        pv0x+nXg0b5WER4YExjlk7ILeSj2NLw=
X-Google-Smtp-Source: APXvYqxjp54hk0XYt0M8wtWG+fi9dvM2y2T6GB9yiks7ukOeZ+cYCnbLRhOrXJNHNj02uxNScm02eg==
X-Received: by 2002:a5d:458b:: with SMTP id p11mr20875644wrq.196.1570407390071;
        Sun, 06 Oct 2019 17:16:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm22761675wmf.48.2019.10.06.17.16.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 17:16:29 -0700 (PDT)
Message-ID: <5d9a83dd.1c69fb81.7f5cc.88f7@mx.google.com>
Date:   Sun, 06 Oct 2019 17:16:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.4-167-ga2703e78c28a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 62 boots: 1 failed,
 60 passed with 1 untried/unknown (v5.3.4-167-ga2703e78c28a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 62 boots: 1 failed, 60 passed with 1 untried/un=
known (v5.3.4-167-ga2703e78c28a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.4-167-ga2703e78c28a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.4-167-ga2703e78c28a/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.4-167-ga2703e78c28a
Git Commit: a2703e78c28a6166f8796b4733620c6d0b8f479a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 17 SoC families, 12 builds out of 208

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.3.4-162-gde3c43ffab5=
3)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v5.3.4-162-gde3c43ffab5=
3)

Boot Failure Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
