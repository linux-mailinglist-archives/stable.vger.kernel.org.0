Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB35C72310
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 01:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfGWX3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 19:29:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40595 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfGWX3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 19:29:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so44864037wrl.7
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 16:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hg710FC+Y+heP8JJo11Eh3MCHJ4GKCoA/ShbF1L3Miw=;
        b=fUMvCwoAXaeKxPJlJYqamv7kavWvrjUkXy5j1DKWerN5VcLAV9XYDymtCXXKlTTHY9
         XLfG6ZlYa/UWU69XbtTIkdifiD4IalL2QuJzROEEI9y3TOxqtv66Gc5dlJLkPVxiRe0S
         KMB9esmtbRFRci4raJiNZQ48BXaW+gkD8fvJEdSEvHref7QERbxtAGS5gFTKFbDnCBM5
         6F5UtsYae+clgzvWyFGx5Hla/5hF4XsfwEjtL9YZfAlAgeR/jrB7sVW1pExnSFunAkdt
         SEJcnW/CbRSg1u3wdDxiG860piJqK/pRiJKuEXVCDRfcuELqXK5Lhp81YCm3Xvgb4a+Q
         2ROw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hg710FC+Y+heP8JJo11Eh3MCHJ4GKCoA/ShbF1L3Miw=;
        b=qCYJAhOVe8lxB61vr8c0oEHkx+MpAFZURzNyMsGKg15Uk8O2+mrUQxYSQvPc7QedEA
         9Mz5qpWSJ0BX5rEfxVrQ+9DAxN8F+POtXqu61Q9Z9s+/08d+wbXzFSuOyZKtm8ThMYiA
         0ySH9FuQf0zXd4aPEsIfsEl6udCnCEfk5raaROnhbAxaD35Afkbe1BUnbC4oTGMi8Sqm
         MDrOUnN9hNnWfol71bJ5rhn0V6jFe0n4cB39MBclKWRzgGucAmlKWgUzZytlnKSOGKIX
         PBaybAUscJLD+GJMtZfOQQ2a8Ov6bPTxwQ29UzaNWRNZtX4wogkQ7eCbI/MlqR/bZqdS
         Im9A==
X-Gm-Message-State: APjAAAUziWw2bEadtsTOuLIX0PP/w0IIoLS97fnuvEmtU8TaxmDs68J7
        fswgBBReOpj/DJgQmdicdy2UM8/YbOw=
X-Google-Smtp-Source: APXvYqxvyk1bUQX+l8fYIwhAPJ2VPAzCAaiSl4kxBJ1twWmDfqhzTWqa8hSuAH7e7lvIHdWGq6hWdw==
X-Received: by 2002:adf:ea45:: with SMTP id j5mr8415289wrn.11.1563924590020;
        Tue, 23 Jul 2019 16:29:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 2sm57092850wrn.29.2019.07.23.16.29.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 16:29:49 -0700 (PDT)
Message-ID: <5d37986d.1c69fb81.ba0a4.14a1@mx.google.com>
Date:   Tue, 23 Jul 2019 16:29:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.134-165-g735ae2998a0c
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 117 boots: 3 failed,
 112 passed with 1 offline, 1 untried/unknown (v4.14.134-165-g735ae2998a0c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 117 boots: 3 failed, 112 passed with 1 offline=
, 1 untried/unknown (v4.14.134-165-g735ae2998a0c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-165-g735ae2998a0c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-165-g735ae2998a0c/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-165-g735ae2998a0c
Git Commit: 735ae2998a0c82f33e7e9009cd9ba9c500881251
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 26 SoC families, 16 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab
            rk3399-firefly: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
