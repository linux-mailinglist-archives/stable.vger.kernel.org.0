Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABFE13BDD
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 20:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfEDSur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 14:50:47 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:44001 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfEDSur (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 14:50:47 -0400
Received: by mail-wr1-f45.google.com with SMTP id q10so3226987wrj.10
        for <stable@vger.kernel.org>; Sat, 04 May 2019 11:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qGZpk/ABSGoznlYfQpD04wj7ribtOVz9K2+scKDM5Bc=;
        b=zyIwIiNxhsQBP5NQiwVAHDU8CXW2B2zR+T6lmsy+9FinXwXpbNYeqG4gln9HOzGLbW
         hZrIOmFA+Lqasc/5gcyW8Dcm20SEBB8xO5ssaZmq2gzYxMZIvaquahkUpQWMlpnSklsO
         IHm0Ycw/sVEJpa1z7kW4TcZEvEIFMf1pksOJov8BPLgxqKTHJYBTUkqkmXTlCrR3CZKx
         WlbcRFKaZyK40aiISf8KGojqByrpWYJhHkY7n3cdQmbmYNZD3HR8TNZYGLd/1ehHWOQH
         FXqgLw+Pp/75D1y+zB2BGzWC/Z2uzZ6g12/EJNpRet0zJ0fEG7KiyIXvrXRKFAFr5JMW
         adpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qGZpk/ABSGoznlYfQpD04wj7ribtOVz9K2+scKDM5Bc=;
        b=qSzmoBzuIrEqgVTgvMwoNVEth9riqWOxOshk8job4soMrUPSWHgJS/zcZOIvQte4tG
         2GueW4/edByo045KLPS6jMlZ7ESZ5lQ//JNLBCcgFO3f/RPzbfX8Q+7v1EfXy2MuWSDr
         76P4ZIKfvI1YOL2EjkgX6c25rSBhIVeplF3mEVFbPLKuTZdUUlxs3ZDudPEQ2PbB6DhD
         WQTyOfyLi5nUkpFnxWRAcPlNsoeJsxt24xGfzKTQjPZ0Etd5DOUG7KIpmk7VHNFaXRYx
         J9h43wkr8Jc09+M/GWxHlHX3xUdU+NwSN8erPm7yLsZUEZTjaVDO1fAYoKjExD7ai5o7
         3/Vw==
X-Gm-Message-State: APjAAAV8SjETktspFACq2SHKks9yGcpu4FTa9zj8tIVzb2awTx7Vw+B/
        nAZ3Gy8amktM8PLELzA8/1ndp7Fw3MA=
X-Google-Smtp-Source: APXvYqy80I6/dGQV4HXeE3pMJVeEJsE+4ssakdICTodHBONkOqYoeoX+Q/SceIF8zGu9yFVsGbkezg==
X-Received: by 2002:a5d:4b0c:: with SMTP id v12mr12364992wrq.330.1556995845609;
        Sat, 04 May 2019 11:50:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v9sm10489933wrg.20.2019.05.04.11.50.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 11:50:44 -0700 (PDT)
Message-ID: <5ccddf04.1c69fb81.7d15d.b5e0@mx.google.com>
Date:   Sat, 04 May 2019 11:50:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.173-2-g4fb0b09ba389
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 105 boots: 0 failed,
 99 passed with 4 offline, 2 untried/unknown (v4.9.173-2-g4fb0b09ba389)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 105 boots: 0 failed, 99 passed with 4 offline, =
2 untried/unknown (v4.9.173-2-g4fb0b09ba389)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.173-2-g4fb0b09ba389/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.173-2-g4fb0b09ba389/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.173-2-g4fb0b09ba389
Git Commit: 4fb0b09ba38945f6131468549f7e14410b2bc6a2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
