Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32C5A17E0
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfH2LO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:14:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40029 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfH2LO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:14:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id c3so2995754wrd.7
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hBzPluJvSGLx2PMWURbF7ojBEeWBudeSE9YlZGTG448=;
        b=kAVam4XUYLxwSP2gzZ+s5ZnmnfTc7FdKzP7NkiGUEW1nrc4JdhvCDtTQrcKH1imGB3
         B/7WvRhA+GPloFXdZeLChoarLFJN9gHIEBh6qJxqw1m/ZVfXxYh50umGvLCxNqqw66yo
         ueH/hYuTIAKodJV3g4d3RIyh3mZKCTp2MS9IkX7CVcteTtipPV/45hwDznDrDmpW+cw4
         IGQBCm3ZzX+7zR2Ko6ua9BEa929+vDqonVGvLe+15PruElSKGYusRkM3vp8hGx2bE5SG
         bWcBecOh8ZCB2ziT909FlHEwDbV/19ezWBWU1k4nx5XVD+x4d+nEi2dSBPnKOruXsr5h
         FZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hBzPluJvSGLx2PMWURbF7ojBEeWBudeSE9YlZGTG448=;
        b=oJAwqbbrFrj+CpyW370ITNOR4cTOIxW/c3amQ1TKNmiiy//AOEAoAz0JFh2roWP/CE
         McdcIWg4rZH/A7urbROUP+a0VJZRINQlS43oot5i/t7L0SW1q3BkuFS5G/NJ8ZrOv998
         TQ9LUZ5+31+0cjTGk+dMOO/wP/DOBKtvglKUxd8Z5ZezFsCRD1gUmK0Alr1KZBOr9s39
         SMp4Bjz4JEJZ25H1g0MFs2dk7qJwLDwcULgE58CzGJ0C4v+2nj+wKH/i4EQTLabNYDlb
         B9IIghTrkKfluBvlTRyqzNmW5SQPKCPNKQEoqFI+Ma2ZZ37dZmmEzvCOwMbhISyBpnh6
         HW3g==
X-Gm-Message-State: APjAAAUuJokWhR5f7pP10dTDLwBJ9f0aAGC3BPm0yeef3kRxPpQrB4zV
        FqJKa4C2ERHuFxN+O82SvsC8nPUSpYP+xw==
X-Google-Smtp-Source: APXvYqzJ2dsZrcpB3L77LDTrsk5bf1hR6sGDm9D/aF8eZPvB+7eIQG3NAdrmXBhB3TnbRterehj8AA==
X-Received: by 2002:adf:c7cb:: with SMTP id y11mr11157887wrg.281.1567077266503;
        Thu, 29 Aug 2019 04:14:26 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g14sm4592215wrb.38.2019.08.29.04.14.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:14:25 -0700 (PDT)
Message-ID: <5d67b391.1c69fb81.1061d.41e4@mx.google.com>
Date:   Thu, 29 Aug 2019 04:14:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.141
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 71 boots: 1 failed,
 69 passed with 1 untried/unknown (v4.14.141)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 71 boots: 1 failed, 69 passed with 1 untried/unkn=
own (v4.14.141)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.141/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.141/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.141
Git Commit: 01fd1694b93c92ad54fa684dac9c8068ecda8288
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 32 unique boards, 17 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v4.14.140)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
