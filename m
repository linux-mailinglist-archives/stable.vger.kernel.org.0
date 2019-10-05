Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776E6CCC75
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 21:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbfJETMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 15:12:03 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34601 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbfJETMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 15:12:03 -0400
Received: by mail-wm1-f68.google.com with SMTP id y135so11922649wmc.1
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 12:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Zv6JqR5YcSQUhN/LN3fAC9wX7aWNL81SVtJMhe0b0Ss=;
        b=DJdSFsgOrn2L15NqTwHsDyI7hQvwK6hMhIPJuRaJLQKmCl0Svdzp/+A5ezzOFomlbi
         ZEQ6LghXvafJiHSzjnZdstCPJMcWUdVIvbbR2B4N88NH6Orf5kt1QME+qs9OisKLNieP
         7A2G+JR4e7D/tLRW9i6+t+UMQ5bt6EmXv6Hem8mgclQFdYij26bRIxLx2eWUUjFGGjKT
         kVepiN2/YTFOJOb0oTnwGZ2tpdKgi2lSyAEuZMLNVYOMdPPEC1c2J5QQjGsuNNX5kDpw
         /VwrJ2JWTbYCXxpydzJG4bbyAKFe6y2Y7m0J1XqGan67djDJJdRa9gqu/F2UBMCWZF8F
         d3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Zv6JqR5YcSQUhN/LN3fAC9wX7aWNL81SVtJMhe0b0Ss=;
        b=sIgYBAkoRxTFxuKHz7cVlfTbJsUtckNUMusXRH1vqJqHACz8JKzIIxJ36Jd1D7THs2
         AMWiF4GQeOov/sD5FTf2UR//YdGl+f53zPusFV4aOQdFD1pzES6YJY8WI0z5/V3/tgRP
         Fi5pSGM3AT9WEkvmtVwvGgiAZAxq/wlw0tdK5AswwjC+zXNFS5oNCY1FJIw/IFQkveyx
         xOuPPOkxtqyPPpVoRuU+3Kw4QK8UpS0udosHXj5CPa7gbcn6qzS0cUUKP5PxqsIU8DZg
         Af1SqhmynQYgA+1CrpVKTOT3TF8V1NU5T5FB84oVpDuDXls4DMAtXKOpDOuo6k3WE58q
         Gp1Q==
X-Gm-Message-State: APjAAAUXfuFgZo43SoGdcyi+6mxqCeQ5HJ+JhmhYgmadi5V3H0K/dGFo
        HT/rq6rg9qT/5PeY63Qcq2nOnmEKqvo=
X-Google-Smtp-Source: APXvYqxmt4MW2EXwQc2n5hR/4gDf1yJftimT9upZwwW13ERnWfzyaHCTEPTPtnCywS4ogdeGEy+y+g==
X-Received: by 2002:a7b:c8d6:: with SMTP id f22mr14262608wml.173.1570302721132;
        Sat, 05 Oct 2019 12:12:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o22sm25827053wra.96.2019.10.05.12.12.00
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 12:12:00 -0700 (PDT)
Message-ID: <5d98eb00.1c69fb81.2d5ea.3466@mx.google.com>
Date:   Sat, 05 Oct 2019 12:12:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 64 boots: 2 failed,
 61 passed with 1 untried/unknown (v5.3.3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 64 boots: 2 failed, 61 passed with 1 untried/un=
known (v5.3.3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.3/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.3
Git Commit: 5a4dd7cf7b980093d507d55571e342ba702cb336
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 17 SoC families, 12 builds out of 208

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.3.2-346-gc9adc631ac5=
f)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v5.3.2-346-gc9adc631ac5=
f)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
