Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B461A67F11
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 15:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfGNNGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 09:06:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33203 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbfGNNGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jul 2019 09:06:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so14359684wru.0
        for <stable@vger.kernel.org>; Sun, 14 Jul 2019 06:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l/934ZJWF/QMF60/KUjuu6thLJoghjJ13FsV2ZSgVR0=;
        b=L6bL+nTZYE1N6DUxOmeMkPLnslqET5FBaolRl1zKuk32YLWW0tTKr8mpdw9oR7iNAY
         ufXOK0wt+sX3KwmgYD02JL6nKdPcYYKvYo8fXLpFCcvFZtTZCoiHlTeLn7wvpn/n7eIi
         JdM+arWDYHm9tPX3CKwHmyH6375LlqrUGQy1V8/l5g2qmtLMNuHjYvmB9eKqm4DF6h4C
         LuPsuB2KwoDpnavoIY3cMcRWW18SLJgtG7+4ZMJiIx7nPmmc7m9lC9/pJXT/wCmQVUKc
         EA6ultzXAnyQm5ILjISCag59q2ezA/12iPGeFU3XhCOcoflWuSLwTPGjNIL7uhqQpvRp
         nPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l/934ZJWF/QMF60/KUjuu6thLJoghjJ13FsV2ZSgVR0=;
        b=O1OGkCZCJlkn59A6i30cP8GRw7xW6fZytqLFU+hYvLDmGt0a5mXPITuA7fe9Bo0nSb
         kaVO2WDeKeCMeLKDyNCSHRsTKLKNsidUC7xnpTG8uVfe56AB8HqACrrRgWW5Yu9+S5F9
         Ch6GgoWClbygPvwvMAYgwZOfBD2mhhNn9FmWmZaMRd0Z4fowf/Fe3aZNhA+Blr2caLCT
         KOK8LyNVf9yH+I70LrNiGLFxe9D+Rb2kmILv7QapEUtjCaCM7jaAiNliMLreexRosQ5/
         YwJF0jRM6naY92KCcaxmtbSwNq8lpgryUtL+W3AIpZP6cx7+0qlc18H/cFUjajNs9kGv
         qVjg==
X-Gm-Message-State: APjAAAWvQr/hauMOxVZX2M2E4J+mPyjCyp89esoxEJnGwZSmnOFf0Pcn
        NnQPlB+1o/zZolDfAbdmRF7HhFKv
X-Google-Smtp-Source: APXvYqz3odzIddmurQhMrSkt3DXbLpLdvd6moLqRVxm2I7HWU1RjKDFyr2Wgn1pq7AEZ3tXLzHSLVg==
X-Received: by 2002:adf:fa42:: with SMTP id y2mr3283352wrr.170.1563109600395;
        Sun, 14 Jul 2019 06:06:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l25sm10580209wme.13.2019.07.14.06.06.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 06:06:40 -0700 (PDT)
Message-ID: <5d2b28e0.1c69fb81.4b11d.ada7@mx.google.com>
Date:   Sun, 14 Jul 2019 06:06:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.18
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 130 boots: 3 failed,
 126 passed with 1 offline (v5.1.18)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 130 boots: 3 failed, 126 passed with 1 offline =
(v5.1.18)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.18/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.18/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.18
Git Commit: 22bc18377bd45c060733e1ed09f34b769e4b4bef
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 27 SoC families, 17 builds out of 209

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
