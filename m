Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5660F75ADD
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 00:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfGYWqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 18:46:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46331 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfGYWqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 18:46:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so52343837wru.13
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 15:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4vIWNXEwPG5SzvIX+eO1oQdVEiDr5fZ4ZRmPcdsf/is=;
        b=igIQdtnmHT7di8sQ2jR9NZt+3PjdQ4q8A2tRJ0trZ1EM3TANnnwhZ7T+d9+9saYz3C
         olM/BkH0bxZnKrTrNPjPR1fBWLJs4Q2isf5WSApHYFdg1PcM7oBhySmNsh4FInfKHvBS
         5ODfMm8SHZt3cPXUSfNgOdkcIIy6z8mBILjtKrwwabhg9qZ/hiheJeLemBDOJ1AU5bvZ
         ioemomKwcBavTx+hNxUDzNSv++QcMMWNmljXyI+4KD54t74PQK8fUXMvH2WKUc/vHOcG
         04Mi9tHjbIuKyjO0N5Q4FydzznfOax/TUSW1F8bXoSkoKsOhtl2wd0Ur67O9lMqWypHa
         YFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4vIWNXEwPG5SzvIX+eO1oQdVEiDr5fZ4ZRmPcdsf/is=;
        b=VpvEA72Fy0RLq4A5D28WvRn91oIrnj2wQANuuS1kd126E+cmhz4ul8r4vjawgYie+3
         0Ew5mZzf2OoPOiN7AeKWMoVtJ8H0sNbtJP34YPnX8F0afOzJ07+jX/pCk1Eio6oYL/Cy
         OqHLO6+0Z8Zs1AYzfADSL8EGbHeAvSY1UbMarWSxYtmAltmCll4YV1PSdBXiSUES49o3
         dBZ7URkQ5V56T923eHAxWcDo1ndcVty5ja/3cju/Vzky2XotpFj0s7OCBeFNUQDTqnmz
         2ikc9m01TUW3+J//nGGjyVrJ2Gf4dFC+Cse7lVFpthYgfpz6PS3FABYWiee2kzDwdf9N
         9xew==
X-Gm-Message-State: APjAAAX5r8tZ5DhqKkuYaz/Jgz6fe3fD9eiqeBsgeE8E0JPTY01VWiqP
        UT2eV0BN4kR6pjJau9POMhIBW6chhpE=
X-Google-Smtp-Source: APXvYqzLt29fFduKswwmeUCN427VOagKful9ApacJyLTNIDCgju/GvcoG8EP+an2jlvb4GZfstTmyg==
X-Received: by 2002:a5d:540e:: with SMTP id g14mr11831191wrv.346.1564094805378;
        Thu, 25 Jul 2019 15:46:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f70sm62246119wme.22.2019.07.25.15.46.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 15:46:44 -0700 (PDT)
Message-ID: <5d3a3154.1c69fb81.3caa6.2a34@mx.google.com>
Date:   Thu, 25 Jul 2019 15:46:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.19-370-gfb6ea525ffcf
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 133 boots: 1 failed,
 130 passed with 2 offline (v5.1.19-370-gfb6ea525ffcf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 133 boots: 1 failed, 130 passed with 2 offline =
(v5.1.19-370-gfb6ea525ffcf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.19-370-gfb6ea525ffcf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.19-370-gfb6ea525ffcf/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.19-370-gfb6ea525ffcf
Git Commit: fb6ea525ffcf5a5339fa976ec38967b97526fe72
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 27 SoC families, 17 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab
            meson-gxl-s905x-nexbox-a95x: 1 offline lab

---
For more info write to <info@kernelci.org>
