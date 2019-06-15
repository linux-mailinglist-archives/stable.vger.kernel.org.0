Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1B646FDF
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 14:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfFOMNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 08:13:13 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:33037 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfFOMNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 08:13:13 -0400
Received: by mail-wr1-f47.google.com with SMTP id n9so5198096wru.0
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 05:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yupTmkmwb2bbbGrsudPw2ftlvzvNHeDdMTqyxhSLBRU=;
        b=gGvrPt9ANhIZk5I+EeWKtLMRu6jGi8DL5dGOKEZNlE1NdfAFKgt3erS+CwT7U/JvaB
         jjGAV2Te6oL2e1EDczNUDeQxH8aJrIl/lTEXaN1J+n0kQ3nqgFl2v/pwsBn0fcTE44kN
         MSHkJdZ47oTB9gRW7RjZNEyV7T1cyWN98Jm+iuXNdZwUrpMicdrusDtyU2/o2jAsfcC1
         QrDNGzJQ0pruYOrg1/C61H3iVSo2oOVmIJA/U6vHmNGEcmgeoHQqlAmcTwsMRxOG5hA6
         hQKMOXo9+acuMKuvpVUIssOo8QwasweAdc3lL2Ou+9Er31cIKShJ8rgffcUbw4Mb+i8f
         1GwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yupTmkmwb2bbbGrsudPw2ftlvzvNHeDdMTqyxhSLBRU=;
        b=TNLB8WLZBz7G//F6vyLmwR3UyZr/5hg0jUezyv1Q0dVRUyWaJLDNULNjEIIyfgvU3Y
         DZA8M4lXF9QfMgy+SrU9RYsCXJzyzygx+Qz3K+wb0owcbshwt388VZmrSACx1RiLgsuO
         xxjRG2XHF8etdsGUdv+qwJUs84hkJ7U29kElz5dBuVF7PY51nRBrVERkN86J3DDOoYQG
         hGJVrrYUrtZ5kMfnLjAgKsf37AzMj9xeV8NkQsk4o8kgGH1R9RDoV7E9hpWiv3iEPR8s
         EXjWXH29NtYiRnM3O1JqwWCbO34ityGYhXvj1JTD9e/265xxhJXu+zbzImNK01FKL/+m
         wzKg==
X-Gm-Message-State: APjAAAV4zRMmAccJEDlpUg8wsAY95wmqGYHFXDFEQ2UiLAcBGt37sn0m
        X3/CTVC+CSJ27mV/q5A6y2F5FAoYRae+fw==
X-Google-Smtp-Source: APXvYqwEK19z71tpdMr7ZeyNapoBTz7Il1bJO8kuhkxJX35QXSUaUQCl+32LJn8aHff5AQhMLHgmAw==
X-Received: by 2002:adf:dd51:: with SMTP id u17mr52461120wrm.218.1560600790690;
        Sat, 15 Jun 2019 05:13:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v27sm7952854wrv.45.2019.06.15.05.13.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 05:13:10 -0700 (PDT)
Message-ID: <5d04e0d6.1c69fb81.fcfac.9927@mx.google.com>
Date:   Sat, 15 Jun 2019 05:13:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.9-157-gf8eff223138d
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 118 boots: 1 failed,
 105 passed with 12 offline (v5.1.9-157-gf8eff223138d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 118 boots: 1 failed, 105 passed with 12 offline=
 (v5.1.9-157-gf8eff223138d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.9-157-gf8eff223138d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.9-157-gf8eff223138d/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.9-157-gf8eff223138d
Git Commit: f8eff223138d119472359fbf24b6318f5cbc0f74
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

---
For more info write to <info@kernelci.org>
