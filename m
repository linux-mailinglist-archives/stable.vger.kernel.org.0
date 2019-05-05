Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CD814203
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 21:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfEETD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 15:03:57 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:33677 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfEETD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 15:03:57 -0400
Received: by mail-wm1-f45.google.com with SMTP id s18so3646993wmh.0
        for <stable@vger.kernel.org>; Sun, 05 May 2019 12:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uA1sIXani00cLIMFO+GLNWgHZ2nf+pSR3JFhBDwEhs8=;
        b=1db4BS6A6qTyM02Tc1Ve7zGGKj8Ia6JygWHMYmIrKGXwnsmXIU/bUo0V4M77qihgzq
         //NgUO90Z97QlVS+62waoMrxtxmeGTRHKwl0wzWYFKeXXhJagRU4b13FTa+fJSG7HvoW
         nrBa19LbqCYBgy+lP3mpHxVzXJGvC/5RkCrlLYkQzW2tckksD/HjxrzpASposr/8B6aG
         SxfZpXApAP7muyi7jpdINGeA8aenWvME8Dsk6oWAgPhO8K0NgGcZAXM/FquEL0lb4TD6
         G4hY4eHO0h3c1VSFVJ7CYtTVoj5i8q0IakHOZJJYZuPp2WTIUY2CAPaskRpcoQR/4Ki/
         twUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uA1sIXani00cLIMFO+GLNWgHZ2nf+pSR3JFhBDwEhs8=;
        b=NC8SZ4D3nm4EMGMr22U2enL3MzOQQggA4JjO9YYfE4a/Ua9esedsuHxq/dQTdVMluI
         Nts9BFDTERNId/AS84/Sdj3GKxPLHPSNMNd/LM5WEnX7VPIVV7+bfgkYjTOjMBnSIR3Q
         DjfY7XLAxwPr/BAO47El19+LKEEOmJDxz5w1AhzCVpEBbp8ZkiwrYNeMB8YWMrJ8wUbI
         0CndHCtJVb09/KBU47GMr32yFdMwajwwSjQfTrLjxhGpusd8yE2dJi0uaUGxyslm4V0v
         i0pn8xJpilTx2p/g1XyEHW9qTn4D8ZAdWVXBWXISr28tIcPBqY6NSgSXcRhmG23TtPn8
         EmVA==
X-Gm-Message-State: APjAAAXQduF4JAFO6GVJl6MKZxFyaP/92TvRPlRbOV+mQLaykksd49e0
        s/N50M8NmMFqiHycNoPncd2dPakpgIE=
X-Google-Smtp-Source: APXvYqzDV0neKa1jzlzLmD6/0uaspc5piEwgLKUMXUneMXTOjQKP0OUBIwezfPmb+aPgvWLatzAYzQ==
X-Received: by 2002:a1c:f70e:: with SMTP id v14mr14587720wmh.74.1557083034990;
        Sun, 05 May 2019 12:03:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b10sm17672971wme.25.2019.05.05.12.03.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 12:03:54 -0700 (PDT)
Message-ID: <5ccf339a.1c69fb81.b1584.0aab@mx.google.com>
Date:   Sun, 05 May 2019 12:03:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.173
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 104 boots: 1 failed,
 102 passed with 1 offline (v4.9.173)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 1 failed, 102 passed with 1 offline =
(v4.9.173)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.173/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.173/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.173
Git Commit: 4b333b9c99aec82a0ef41f23eb4cd2e3b3e46026
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          stih410-b2120:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.1=
72 - first fail: v4.9.172-33-gd35bcd092304)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
