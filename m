Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9E9383F6
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 08:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfFGGAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 02:00:06 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:53494 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfFGGAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 02:00:05 -0400
Received: by mail-wm1-f51.google.com with SMTP id x15so671941wmj.3
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 23:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sJ5T+Z5HRLuJZN0gt3pR40uH2qtZesjRQTuawwndF/M=;
        b=l0290XLkMMEXEIIGYByyJVuk6cybMHlFxiKOPpvbsi3rnIU9sUa//wRcHiS6w/fHA4
         q0YazKD6W67peF+adA9gwPj21FtBkJ8RiqL5jlR5V336OCi/x061VLpE+MMLTL1SokPT
         a2M3nFUyAlSrH54hLL1dnDYzcYzPuXqKWBXZaoivWtEOF25lo6Fn+kNhwPsWfj5HGXJ9
         i2lg+auMGqYU0kbLUlu25lYNFeQCyuytoTRaawIpWVmyuz1rid3xMJr9wN6oNcS6lVKX
         sAiWyCtc1qsg2RR55FQw8yW0yCcP5XD95idYyQB+S0AbiB1HbM/jUo0/dyK9N+8fZH6Q
         oAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sJ5T+Z5HRLuJZN0gt3pR40uH2qtZesjRQTuawwndF/M=;
        b=PVGDpehMdC9NWWiVyfLI+ALCTLTwtcm5Ki1nE3E7WpiBqQfjutBWyeXadLk+1Mn5WS
         wWHSRlnIfDBPZjE3RfssJ6fUYVhoHQIFZ93px21hnp/lpjW98AXCrm/0BQZAr7TzlHrA
         /t+8+KSyU34rd9ebm/RTJbXPPRsJOp9LIVc5/fD0xfirGlRbghaT2QtS5OEtGtLXP/UK
         1WB3UUZt25vUZkCZar8l7c2uGpODSwJkWJGkqVN68Qz/ecIwRPjNubWNxOHwgeFInuDG
         9uDpycMLeFIT/ttW+poT581gOBJI2aOruHT1IxLzvjKt8W3Jl56bDAN22il6cmTzhJ9f
         76dQ==
X-Gm-Message-State: APjAAAUX/J0nOl8ng1xmunkSjoHcNHOs9yqBneUuDT8tgc+ShVsf6mbH
        MALaTaskBuSPSzmNiYoVw7UmHWo39rKIow==
X-Google-Smtp-Source: APXvYqwUPNND/Wcm5YG3hH5Co606yu9KoeoeZaO75ry3SdHMiH886ipa4X6CpQnsW8MWBzp6kaVnSg==
X-Received: by 2002:a1c:ab06:: with SMTP id u6mr2187059wme.125.1559887203255;
        Thu, 06 Jun 2019 23:00:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o13sm1116431wra.92.2019.06.06.23.00.02
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 23:00:02 -0700 (PDT)
Message-ID: <5cf9fd62.1c69fb81.13470.5750@mx.google.com>
Date:   Thu, 06 Jun 2019 23:00:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.123-69-gcc46c1204f89
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 118 boots: 0 failed,
 108 passed with 10 offline (v4.14.123-69-gcc46c1204f89)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 118 boots: 0 failed, 108 passed with 10 offlin=
e (v4.14.123-69-gcc46c1204f89)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.123-69-gcc46c1204f89/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.123-69-gcc46c1204f89/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.123-69-gcc46c1204f89
Git Commit: cc46c1204f89505a33f1fb42e719ae0c8586cb68
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 23 SoC families, 14 builds out of 201

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
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
