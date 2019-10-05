Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04BB3CCACE
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 17:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfJEPbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 11:31:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34742 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfJEPbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 11:31:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id j11so4672178wrp.1
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 08:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Tp6Xi60Lc0k1zELurI6HmfP6kjZfrXSw163Gob2QYC8=;
        b=JiKgHPkPREri0ykGhmzt/xCst5gr8Yz+Y1CQm3xsR8eD8/BNmPckkk9Tcim7G9sXMS
         U5CYRHLOo7WJ3r0Q9QL10p92H3zaqw4SWKY/u0wcHK4R42f9U7gou6lDICaMycWquAcj
         qmeaTn3hDEYtMcIXIN7KJon1oYyUoQXZQeMBisU+D59LZN/Fq06Pqi6+OSip4raYfSad
         1VTTucPsGlx7+zihqlT7f8VAVfP3x7O/IvOmPMdJPcVMweAi+IVx8eKEdyy+YDQTxeif
         Nk0Wad8geLQyEuB/QynsJ78hfeht/dQcAR59VVKzWStXT6JMy6g9CehupKnNntWoFT7k
         hXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Tp6Xi60Lc0k1zELurI6HmfP6kjZfrXSw163Gob2QYC8=;
        b=k3lqe3A74DZgKyiJkE7EcskjNUOhkenUyjqxNDOQ+QQJdgY90fGSVCRykKnWaHRVVw
         dSZLEcxDuJHwjwlBfpl5HQQorU4tn6vttEwtvYBcO53z1dqigMmMvNWhTL5zETOzgfGY
         tHf5TvMgk5LtrCFga3/qN6PF6arDIe0C5Xfai0v4EUG74Xg8Y2jCwm8UCn8oiAbXUviJ
         BnqTJVtYmMD4Ce2PQd1xEyBCgcclMBvEzrKUrSooseOXEuntqsEChdstkfK4814Z5vKR
         dlOZTEDLLKS66Q7XUCo0S91JcdRDJjAF/zA4K9BuoL/0bAvTOXHcYvcwX7Uf6s6CtKsR
         20Bg==
X-Gm-Message-State: APjAAAXORQq9KYgJtjE7U+CreXOiUH1TtHQ/nbyLEaZq9WPi09J384fd
        L8wshY20qTBmr0FAG5VF52+9T2HqVpg=
X-Google-Smtp-Source: APXvYqxVXOetBxIMGY5DsZ/LtSrYPWe9MAKvzjfM4xt9aAF1hE+vmYGcqP04dUx1LtmImZbNRhghbg==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr15995846wru.205.1570289507721;
        Sat, 05 Oct 2019 08:31:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o4sm12172894wre.91.2019.10.05.08.31.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 08:31:47 -0700 (PDT)
Message-ID: <5d98b763.1c69fb81.cf4b6.2f96@mx.google.com>
Date:   Sat, 05 Oct 2019 08:31:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.195
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 40 boots: 1 failed,
 37 passed with 2 conflicts (v4.4.195)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 40 boots: 1 failed, 37 passed with 2 conflicts (v4=
.4.195)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.195/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.195/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.195
Git Commit: 5164f0c3740d357ba460b44222bedfa2475ca794
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 10 SoC families, 8 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
