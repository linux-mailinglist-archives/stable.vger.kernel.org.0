Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7951473FC
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 23:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgAWWpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 17:45:24 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38138 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWWpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 17:45:24 -0500
Received: by mail-wr1-f66.google.com with SMTP id y17so5133850wrh.5
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 14:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nthS0FsB7WIOL+9c3dpKEum/AcHMiutstkuX/+DMcKA=;
        b=CdXarbFUqlw13OrQZnRGjK8rbdh4r7xp4OrfbHLMuKtgtUKFWrYZ3yRE39XpP/GykL
         6cM9ONy/Qgz0h3SNXPQay02+wst/hxHJQQXgZvLvhjAMA5oE+Wd5KrnYargS4Pv3a2oY
         LACOJWzeADrNJk333/TLZx0uD8Z5RyHLjH/GCVxUPIBjLfB/DTBr2VorUZoQ9L/B7wQM
         juUz0uyTmKCVjxx/Qwrb+PpAPxUTy3+Dp6CEXcIpbFZQ5tIHGvkzF8PxOP4ZdMemxt6W
         TxbWbyZYNgmLJczXKocheWuP7uPW6AGf3BjvWuB8EUpa8k4DRmXXLIcmwPjngdapMHj4
         FPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nthS0FsB7WIOL+9c3dpKEum/AcHMiutstkuX/+DMcKA=;
        b=byM/NpRGxVhWNZDyP5M255p74DX4Im42ArujISsFPWbUxjGfRnyFUkGV7cgLY351jz
         1D+CAK5jI13EE6rANHl350HYLj7JT0NY+SC5iUq31MxAiwBty5wTHCUYKZkTv5WstmEX
         JVKdzSAk1VoIvE9RhNpdRy//iF0tBtru9dISu6/vCXAGs2d/hjgq4UY8KnTmw/6E3Ro5
         K0qy53MdXos20+1E9kUynGnKZEcwzx4Bm32ArasYy0K11apf7jvL1f809XNsyo/tpMcD
         JoTuzFJS4Y80fwMJJGhZCgfBallijKxXrx03Pjp8uNfTTYMSLhg5Wo5WBsVoWPbDzuZn
         mwdg==
X-Gm-Message-State: APjAAAXstGFrx8rJDz48/F6KbmolsLtZ+yn9czrdi8tQwIclVecwKwiv
        Wb34FHmtRldzH1I+I0VEtNFehI/KkI8nzQ==
X-Google-Smtp-Source: APXvYqwEKRKcon1RbL0eTBMl1HfII9uiC2s/Zn7lz+tsXebxV6BlhZslCIt2EGsmCBcv3vS8wHkWjA==
X-Received: by 2002:a5d:4651:: with SMTP id j17mr337974wrs.237.1579819522065;
        Thu, 23 Jan 2020 14:45:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k16sm5369826wru.0.2020.01.23.14.45.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 14:45:21 -0800 (PST)
Message-ID: <5e2a2201.1c69fb81.d6558.6438@mx.google.com>
Date:   Thu, 23 Jan 2020 14:45:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.167
Subject: stable/linux-4.14.y boot: 71 boots: 2 failed,
 67 passed with 2 untried/unknown (v4.14.167)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 71 boots: 2 failed, 67 passed with 2 untried/unkn=
own (v4.14.167)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.167/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.167/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.167
Git Commit: 8bac50406cca10a219aa899243d49c57ddaf7c5b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 42 unique boards, 15 SoC families, 11 builds out of 192

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.14.166)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
