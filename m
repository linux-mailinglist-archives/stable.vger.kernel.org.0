Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4212CE10
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 19:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfE1RzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 13:55:16 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:45920 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfE1RzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 13:55:16 -0400
Received: by mail-wr1-f43.google.com with SMTP id b18so21189585wrq.12
        for <stable@vger.kernel.org>; Tue, 28 May 2019 10:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=da1BD6cLbR4Nx5UU9CNQ2gYA/bPZPr1DKQ15choVGZs=;
        b=D8ZwmaGNPycQ2AJXY5j0pzdRUtDKcMpV/LW/HwbJbUhpSi61nsCdRMl2CfS9TKLac5
         OFlkuWvCRaobMZGAj/V7tzeiRrxzaIIBEoqxOGGTHJmtp6UXGxKdNlwhi9WxJZ87D1Rp
         2bCb4Uc5ClnTTX0i1fTekiII8k4sFBMjXKdKVMEyhqYbqiRj30NjrlLy/yzt1X63QQuz
         FVQIscJalYCiouyPOHYhSTQTM/tlCvnHzoDuGztxlZNBeVYlN8Wb4wR0DKjz5IJuV/8l
         0V950HKEAYCu5KNVQ1mAtzb3f8h9d5mmu2JfHmv5zDtLTmINs0Tye7e5J7HvyIEwnTIm
         KDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=da1BD6cLbR4Nx5UU9CNQ2gYA/bPZPr1DKQ15choVGZs=;
        b=BOhdJkSVPw7+cV5oRV1jaEWhiGveA+XraU/GV26qDYvz7LP9qd9bEbKeU7czm4LTlY
         fp/nvhySTVfAnMsAGgv9a8BenM6Z62QEyJUyjf003isaubYUTh2i+RfnzjhLXBqbe/aj
         MssJiul/E51OQeIyAWtZ6v3mp/irkpulvuo/n6+rX3zydpNaIBd4Z9iXg3BodUC1DTnX
         P20FullgAEKSKh90BHud/OVz4uVg4hMTPUtKeQUwQIovmqAH9/8ddZOt3cLLvac9ols4
         ksne/GCJWi04bcRmX+SPGbHza+Q7SZdujLsjWQ6UQvaxwdE09C3X4/UQL4a3iJBXyIv3
         u06g==
X-Gm-Message-State: APjAAAVzyD9hpKSWUWFNO1lInOByp1Ob6FjrvjW40VE3RW8KNbT+IHIF
        lwRDpj4nFr3mcsTdceRjC/5wVip/4iDf3A==
X-Google-Smtp-Source: APXvYqymMDkdLA0zOUFVkKcKgzXK/6Fc7SSyejILLr9XCQwb/pbSfCW0Tv/ndVyLZbYkHaGi1w3gGg==
X-Received: by 2002:a5d:6108:: with SMTP id v8mr23517355wrt.150.1559066114243;
        Tue, 28 May 2019 10:55:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u19sm8894979wmu.41.2019.05.28.10.55.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 10:55:13 -0700 (PDT)
Message-ID: <5ced7601.1c69fb81.a10fb.d43c@mx.google.com>
Date:   Tue, 28 May 2019 10:55:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.19-29-g62f77c62dd4e
Subject: stable-rc/linux-5.0.y boot: 128 boots: 0 failed,
 114 passed with 14 offline (v5.0.19-29-g62f77c62dd4e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 128 boots: 0 failed, 114 passed with 14 offline=
 (v5.0.19-29-g62f77c62dd4e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.19-29-g62f77c62dd4e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.19-29-g62f77c62dd4e/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.19-29-g62f77c62dd4e
Git Commit: 62f77c62dd4efebb90fe6c7d2d975f75b25eb0d2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 24 SoC families, 14 builds out of 208

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
