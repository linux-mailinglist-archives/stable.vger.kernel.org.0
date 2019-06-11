Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A290F3D564
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 20:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407029AbfFKSWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 14:22:22 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:41887 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405802AbfFKSWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 14:22:22 -0400
Received: by mail-wr1-f49.google.com with SMTP id c2so14110230wrm.8
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 11:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yKrcUwqgbpT0LrwHCa6jpgsKgZ59zietLV5GF3HitCo=;
        b=EiimeU3mbyswsEmWk1RJfef+BLfzUEKYeQbO9KaMQj9exWGbc/hsOMjw68JCh443zk
         iDFSlkyfVBVzKZrn/LOKk4RJ87yc8OhYSm5u/YOi1XSzuLky5RdtB9ntvNqnIBtpQcC1
         OOmJoKa2fMj0qJuwkYPbfzI/vMFG3oy4tjo7uB3Z+j3mlqclruqiN/EM7DkVioSGBJmy
         puOYf0H6jAC6edqtcSFAmmcVpv4Q6+erFCsH1ONcLUDg5VBlMsSsvGPJWSwws0KIVGTv
         /ZQLQiZtWn7A4MWZmHE6tdHCPXte4Ng0bMm+4Wq5wg49mM9O5R0QP+R/iWT97RgSNc3g
         cMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yKrcUwqgbpT0LrwHCa6jpgsKgZ59zietLV5GF3HitCo=;
        b=T+kvODYN8L3iVY0GuNWx5k18h6045H0pmg3aOF/TsQI6Dy+LMUvZnhz5JTs4LlW5O8
         L5f8Ss7UUg/c3WX1z7ptR8Wu3XBcTRCmx4rdIUovEAHAt9ZKc5VhkhV+aaKWpsoml7uY
         scFxYQlSjZ+tjVwdJ3nggubjBESWgEwUPhrNwcontBdsxLEQ6ndnRZl1j/VEfSQwf0zP
         Tc+ZMEJGV0hpwN7440Avaz+kpDHwSeP1CbpJm0idO1EI8ZZSIhe/FPlLleoLoDQ48G9F
         MQNFBSBcMFj4PinKSyM0kYQ+JOVTIaGIz9akFMIkORqg44J5VGC+iJm41vxiuRogCcE5
         Ihmg==
X-Gm-Message-State: APjAAAUyCIaGlBO+spImAQeUZd1y2l0SjzLrFoyirWFY85cRhA2xC/6a
        FCWigKxYyw//60C5bBJoTShFXU3439TNTA==
X-Google-Smtp-Source: APXvYqx2YRlxFI1gfR0luV4ITiz+PRwXj/Qm3y2Sc2e8q5CtO6t2LmnhLiwIxrBfrtV6tvtASGLbGA==
X-Received: by 2002:a5d:67cd:: with SMTP id n13mr38488223wrw.138.1560277340777;
        Tue, 11 Jun 2019 11:22:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm14219028wrx.39.2019.06.11.11.22.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 11:22:20 -0700 (PDT)
Message-ID: <5cfff15c.1c69fb81.15320.0ee6@mx.google.com>
Date:   Tue, 11 Jun 2019 11:22:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.50
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 129 boots: 1 failed,
 126 passed with 1 offline, 1 untried/unknown (v4.19.50)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 129 boots: 1 failed, 126 passed with 1 offline=
, 1 untried/unknown (v4.19.50)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.50/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.50/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.50
Git Commit: 768292d053619b2725b846ed2bf556bf40f43de2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 24 SoC families, 15 builds out of 206

Boot Failure Detected:

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
