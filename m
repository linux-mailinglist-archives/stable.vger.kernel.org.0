Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B656267BE5
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 22:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfGMUOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 16:14:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39295 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfGMUOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 16:14:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so13155768wrt.6
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 13:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7LD1AAOCXi0GwHnK9+Ae5mK1vwQ2bX9lIpOI1HgZ0i0=;
        b=Ei0htGZTK2FozWN0grRTbwbdWtcJ2tqWVoRU0d9eapimOVDh246Afoe81gU7DkEhWu
         F2PN8OzzHHAphmeJeLPEC5OzGGzGwqFSL/ch0KybrFt8Xv5fI9LoS+MY7YkN3za43uWk
         ZxCcwuYZT6ME9U+5jV4ZxA4NN1s7lBmpO6LIjBOw08cXPCk36afGVKJdURCEAKzjBR73
         u2C/+vApYDKX1mVzp8RWIX/D6TQtWrRRzngA0N1J/bplbpofjOFhPYW4xd3/A3eZEL7h
         xbyHq0YxJNQMmnNSI1G49ynCuU4rkzFTrXgLdDyKeFFJ01NEQdhMgpnuAHiNQP2mz6ps
         vk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7LD1AAOCXi0GwHnK9+Ae5mK1vwQ2bX9lIpOI1HgZ0i0=;
        b=JX48JoTS2nBbPMCKBF/JXZpoRwElFgywEriKCSJ2leSEi1W8gNWiR47prU6WZTOTYW
         ullJnIAMxKfN0L0hVOYZ367EMMLqk9+bjrh0xT21h359nrK2tP2KCz+OppuJRSR8INH5
         g8LQ0K+maZjEZpGinzVvbS0RFrPEk706Xj3Xy22uTslkzMPWRfCSQn3mAdVOUGSh2CoM
         8W/VQkyiE97JjxBaUGpVQjjwAozldJZR5Tmc+pBVrQAD4d674X7rDdJYdPBJuqK6So3M
         YWvLDBseq8g+fv77IgrCBN6PsaSNnSJaeBnrJ+nda7HUaUNRAeDUl8X6KdNWkbQwZk6H
         KPdg==
X-Gm-Message-State: APjAAAWrnB99pk/WOO0IsCEXGeem7SsebASqFmdRY+ox7y/JRx7AyOjL
        yhCz694nzMfJE2ErGCclI53ZavqTLm0=
X-Google-Smtp-Source: APXvYqwUVaVCopoj5uKMIFXTSnONosXrR3uiURV7Kr/BbiG9kOPyY4wdMhq4qsnSJjsIPO7nSMlUBw==
X-Received: by 2002:adf:9bcd:: with SMTP id e13mr18768769wrc.338.1563048883114;
        Sat, 13 Jul 2019 13:14:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c30sm19996461wrb.15.2019.07.13.13.14.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 13:14:42 -0700 (PDT)
Message-ID: <5d2a3bb2.1c69fb81.80c96.5149@mx.google.com>
Date:   Sat, 13 Jul 2019 13:14:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.185-40-g021d259b6536
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 102 boots: 3 failed,
 97 passed with 1 offline, 1 conflict (v4.9.185-40-g021d259b6536)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 102 boots: 3 failed, 97 passed with 1 offline, =
1 conflict (v4.9.185-40-g021d259b6536)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.185-40-g021d259b6536/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.185-40-g021d259b6536/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.185-40-g021d259b6536
Git Commit: 021d259b6536429218c71d8205fe55898b2a84eb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 22 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            qcom-apq8064-cm-qs600: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
