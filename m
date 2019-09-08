Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBDBCACFA3
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 18:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbfIHQQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 12:16:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40551 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729402AbfIHQQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 12:16:13 -0400
Received: by mail-wm1-f66.google.com with SMTP id t9so11947177wmi.5
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 09:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zwZ/IqQ+2B0QddH5RgbSKzMohwl82nEthp510ZqYE3E=;
        b=gAlJEG1/FwUc6kkFTyTp3JoFXZIYHa5sUiid7IQYfS/g+NrcNoO27kYZKM/2SRV5yO
         7CJdwVyXGtLeYP8QqdbEma6H126dueQ5QD5OIXT2D5riLPoc75MsbAgi8MYWipUAi5U8
         zPGoIsjEChJFbRXNZvydzk/87KpR50XRDYODI6kjI7pMpM8/1E4L+KyRoQFd/wMlAXmB
         SjShS8141VR1wzRxrsFMhvvLyBn+adacz0F9L7vjiONCYjYCQj0PqZ2idtvpf2YZPBaJ
         KzL/gIP1VLE2h7d6FqZw7n1jHvpzBO7WQH2x4Lf2cpZ6mRBHfzCvPGC5z34xvDrS/2NS
         JDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zwZ/IqQ+2B0QddH5RgbSKzMohwl82nEthp510ZqYE3E=;
        b=aAdJ8zVVH/iigyXMnBXcHyggGj6ZH2Um50e/0Rha0sv6FomHSEeeFXglp7vjfCSH9S
         nEGas6VqTscQ6pgnLJ9kizqmRktWNh1+yqx1vpfXb0e6zYdrmfIYTePHaC13azXic+/F
         2Un8UGebD3uTLhpea0sYTrJe2oUkL7KUhp8kOl1hhX4M2yTn+Ux/Bm/yzoDnROmUTart
         i05vwie43fp/kSjwHfTbFN0arL4iezjmbyvV+d0o5aKlKLzm1O7Z1vrBpkldwRm3mNut
         O7Cq/93hbdKQwxeBtyI9Im0uRcb/ewjHzMjVYqgpbEihRCPVnszzywsD/UessAysBnIR
         Diag==
X-Gm-Message-State: APjAAAXMHaenr/pvAgrezNfb+GGU1h6F13JY9A0FkrPyeSKUfWwiPJCt
        Ve0Rho9J4zVQFAbAMF+y4D2dkaNUiWI=
X-Google-Smtp-Source: APXvYqyYga3bFZS/JU5UtotSAM5TlQ7cE7D5yMt3ZVBp4HxOl82Tk1wYCxagtDP2o3/28XnlrOKF7g==
X-Received: by 2002:a1c:9889:: with SMTP id a131mr15736501wme.38.1567959371157;
        Sun, 08 Sep 2019 09:16:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r9sm21828274wra.19.2019.09.08.09.16.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 09:16:10 -0700 (PDT)
Message-ID: <5d75294a.1c69fb81.78cf2.6cdb@mx.google.com>
Date:   Sun, 08 Sep 2019 09:16:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.12-95-gfc14e8bbba89
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 149 boots: 1 failed,
 140 passed with 8 offline (v5.2.12-95-gfc14e8bbba89)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 149 boots: 1 failed, 140 passed with 8 offline =
(v5.2.12-95-gfc14e8bbba89)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.12-95-gfc14e8bbba89/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.12-95-gfc14e8bbba89/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.12-95-gfc14e8bbba89
Git Commit: fc14e8bbba890dc78a1b0f62191205922c3c0fb1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
