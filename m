Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3D26F3E4
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 17:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfGUPPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 11:15:23 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:34422 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfGUPPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 11:15:23 -0400
Received: by mail-wr1-f49.google.com with SMTP id 31so36851930wrm.1
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 08:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D+ZOx3acHWwJa9YEMSImCDo0wQfln1PmJbeXaYw0mb0=;
        b=Gxg+NpKdSzxPpxHB+qQBuDGN2u0Adm0TT7Qef5S0qHmBq3ckD+yRli/5cwX03rflru
         vcbZhGcUGvnIO//zatAYBWdxtWvcrXlTu0+I1ZHCSAZfylUL0OZrtVFrGkOCGhSm9ivK
         cwmOZEyjqguemZYd5GXCzGgic3FN54plXjnEDT4c8R5w8d0kEn7V34RuN59rhgHyvmYa
         VX55uPud1HpZMvS/Z+95KXo5YGgZUlHjoaaSQmSykLjO0iEqUWSul1lWxxCMvV0FJNDe
         bF8f3BGZwjzK3xZx1l9K6KF2avXsIg1aH6ptDKwTPtjeBP/bdM2VyObmt6OBs3KWawsx
         Aijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D+ZOx3acHWwJa9YEMSImCDo0wQfln1PmJbeXaYw0mb0=;
        b=saxzIPNgEPYEUonpEahk8+d6lYijJWPtAYljYljI5DMD3bzocY6xSXOQ+Cj6alanaq
         mqN3xZ4e3laRNftZFNc63Z9fuf5At6UE4+7AhAnLIk66pl7j6mXNlA/diVEc2ysZcrvW
         pPT/Tl6w4A2EfpKA2KShp9E3sKo1yHQG/5VwM3kZif26J6lDrCBquMKQXrNbd1hDn/5B
         bsk9dO2OLOWyc7r9evbkFxRMfpBHE8WIBSQQOkCo1Z1iziVzmktDxkpShM4Kao8W3NTv
         jtM30S6jTORG0GkQOF+E9OZjOWyQJZlFEiUwONCK4p+UbT7ukYmceS7TkE8mzCuwPMTc
         Yd1A==
X-Gm-Message-State: APjAAAUSy1BbnywMYyzZTVeK4WCJLU+yrvkt9BMdBzo0SeehO0tW75ip
        7kUtKaukuV54UmvHWl/9PPFMvRKs
X-Google-Smtp-Source: APXvYqymqVKN3aI7A3v5FktfVn7cDd/O4EwCSVoctxyHM6UcVFEZw1P1jTLBxVnScsop610LCJa0bg==
X-Received: by 2002:a5d:4fc9:: with SMTP id h9mr40135648wrw.349.1563722120911;
        Sun, 21 Jul 2019 08:15:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z1sm39529288wrp.51.2019.07.21.08.15.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 08:15:20 -0700 (PDT)
Message-ID: <5d348188.1c69fb81.feef2.d33d@mx.google.com>
Date:   Sun, 21 Jul 2019 08:15:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.134
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 103 boots: 1 failed,
 101 passed with 1 offline (v4.14.134)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 103 boots: 1 failed, 101 passed with 1 offline=
 (v4.14.134)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134
Git Commit: ff33472c282e209da54cbc0c7c1c06ddfcc93d33
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 24 SoC families, 15 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
