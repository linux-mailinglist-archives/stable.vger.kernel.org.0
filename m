Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDAC5EE16
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 23:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfGCVIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 17:08:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36790 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfGCVIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 17:08:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so3836314wmm.1
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 14:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ca6303oTf1TuTiE2IMSeWv9deNl29GjN0R0NbQSMaAs=;
        b=1eP6NzAhBWu/Pa4WEXD3hIpxccbnjuBjeJzO1XTYzszH7+NphYCKau9EofWKtCeUsk
         REFE+ic17RNi0VI6ju5M4m9ovlxz9Bgquay+Ej5iklX5NCBoy2ghdQFsrrJCkmrFD+zT
         dWvuMHy4cpmxywqTNTNveGBsqrf7rcmmr2rkW7nETopsf15zY/dPSrCl04jzOIKeJIgS
         lkT0Hs+zTOh17R/+51QrCW0Mi2w5R3fhrPei18WkRhTTZKZxi+5fkU+TIC26+zGG3Cb/
         szoyKevkeg9v3G5lXFG5Oy2N9Z+L1iqhxJy99YdrjXa1XT/ULkEYXPqNplt7ofYZdagG
         dGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ca6303oTf1TuTiE2IMSeWv9deNl29GjN0R0NbQSMaAs=;
        b=UQdB0RHxsx5fu0jeNeCLCvhai3pfDRPsDTe2uU6qI0l8n9WpkDA9xNH8wU6kdzJnHP
         vlxNfrCg6GCoweNVQdywuOV7YB4RjzxwAezzQt//ooBVlr30C6/mlSeSJFRuMuyZQFd/
         NeVz+kQBPdC8W3BiIYuivVRjHKHXA7yVFvCw1Dn4vAroEPWzKRIoLojU4PT7zTPTTRhY
         nlW4vx81oBSwlfi6gUdapOiYC85RKWCz4T4sAC59NSM4igCKQCcXpTRQHbDzFqOr0Hzz
         q3wpwsbt45N92/bLx3wLu2oEQRT1c1IQwQOAz/GPc2zHHP/fcroqaU+7vfnY2YZ9ysej
         DC7w==
X-Gm-Message-State: APjAAAXXHyAGWuTHkQN7V6a0mbA0bYRL40nrlQiZYFHW2CgCUBAcJFuL
        x5B4Ml9h/PzZWuDOZ7nRy3l3VUcncIs=
X-Google-Smtp-Source: APXvYqzEikMtY2AofQXHC9WM0nZPfC5DS4wsNmUQL+U4KgKU0F0uDFIOkYY3krw83ZkvFt9V4KybVw==
X-Received: by 2002:a1c:5f56:: with SMTP id t83mr8620896wmb.37.1562188127028;
        Wed, 03 Jul 2019 14:08:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h9sm3066514wrw.85.2019.07.03.14.08.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 14:08:46 -0700 (PDT)
Message-ID: <5d1d195e.1c69fb81.42902.1a84@mx.google.com>
Date:   Wed, 03 Jul 2019 14:08:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.132-2-g69aa9e7d0127
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 127 boots: 3 failed,
 124 passed (v4.14.132-2-g69aa9e7d0127)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 127 boots: 3 failed, 124 passed (v4.14.132-2-g=
69aa9e7d0127)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.132-2-g69aa9e7d0127/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.132-2-g69aa9e7d0127/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.132-2-g69aa9e7d0127
Git Commit: 69aa9e7d01274bfb470177f982b30085a78515e7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 25 SoC families, 15 builds out of 201

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

---
For more info write to <info@kernelci.org>
