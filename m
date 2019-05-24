Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE228FAD
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 05:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387660AbfEXDnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 23:43:45 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:40660 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387454AbfEXDnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 23:43:45 -0400
Received: by mail-wm1-f48.google.com with SMTP id 15so7679068wmg.5
        for <stable@vger.kernel.org>; Thu, 23 May 2019 20:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v34blGR1BOyMj6mXuwgkwlptJtpxjWKG4dytKI5nL7Y=;
        b=iwA3Mcb9QQqnXnvFxwnKe0FrlQXQJOEK6NQ2YZ5CbYw17UeiT+xLVySNkCFqhFvvzB
         9AEz87dV1J5TxmOmiW1Hnc2IIyLojVcuQL9j7oBmsr2vPjalv70n9JsxL0FdHbQIc5Un
         +R1d9xCe+PjD006G3VroY+AZ2M1kNCtXJzZAGvm3a9VKdootmnPPr427iZuPZwb9n/Ra
         Kw/o5+yAI/u8VZPEso/4T/SRyfMi4HTkxEZhhx0rNUqhogQMnh33Se6Wll6u9KqN7LBX
         cNX8SjMswW/XgUc9lAAUFbaXxxi3uco9P3zV6A6eW43sjxcfK8Ah1iHPJ5MtDFpwso+3
         oXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v34blGR1BOyMj6mXuwgkwlptJtpxjWKG4dytKI5nL7Y=;
        b=QaOM23gVX7JuMiDtsFy3K6Yh6KQn8/+U8gvXYkl/8poeeBVnMw7PnO9VGe+lHwmRNU
         qw9OQ1q7btHOJEXqATkXUor+GKyfcSBfy5OohSsKnAiOpzEReUc45UOqKeasH/HLx7Cy
         bAhaulJBgbNIPv0NePSMoHTWdPjU3znHnbidQ1DTnzKn7GQ1XJ9ke8yFyrlgsrBwlt9k
         6OpNbxcXDcymvn0dBsPhoNSasHGT5qZEF744qBh7x9SHo/+/hgjuIxpuqbCZBlTrEvlh
         zrAHRr9SBfbxYYdWanu1lY8SYtLMbZMzNg7bSoo7itgTZpqS2OT//l43ly3JZpt0mXsp
         /TIw==
X-Gm-Message-State: APjAAAVss9PwuuD066jfqNIyCMEWJWxC3xiHC8oOCIzU9iyBRpyL3LGE
        DNBAuzufaGaUz1de6dLHntMp/4WkFJ6uIw==
X-Google-Smtp-Source: APXvYqypXsy3pvJhgt4QQXPbTsPlZx8apSKgF+9qOQqKPx47WbPYEowENWCp8oQzt0CkdJvaLQwEKQ==
X-Received: by 2002:a1c:ef10:: with SMTP id n16mr143539wmh.134.1558669423420;
        Thu, 23 May 2019 20:43:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x4sm989700wrn.41.2019.05.23.20.43.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 20:43:42 -0700 (PDT)
Message-ID: <5ce7686e.1c69fb81.ab061.508b@mx.google.com>
Date:   Thu, 23 May 2019 20:43:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.45-115-g071ff9cc9849
Subject: stable-rc/linux-4.19.y boot: 125 boots: 0 failed,
 112 passed with 13 offline (v4.19.45-115-g071ff9cc9849)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 125 boots: 0 failed, 112 passed with 13 offlin=
e (v4.19.45-115-g071ff9cc9849)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.45-115-g071ff9cc9849/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.45-115-g071ff9cc9849/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.45-115-g071ff9cc9849
Git Commit: 071ff9cc98498f489abc097471549b19933ba3e2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
