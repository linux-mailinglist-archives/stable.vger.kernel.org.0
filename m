Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1193347288
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 01:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfFOX3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 19:29:36 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:33554 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbfFOX3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 19:29:36 -0400
Received: by mail-wm1-f48.google.com with SMTP id h19so1900323wme.0
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 16:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f9T/eNg+p5LtWJTNT1FpaBcGmEmCKOeqxzqjmmRVZPU=;
        b=dMB8n2aNTCc5P0M8oljI/obd+icPOH8nIk8WoyNeFTyALLUH7JRqCFA2t8ML8wUkgT
         3WLg4TObYvf4A/NKALAgLjjoROqyl1X4pW1GFGrxtJP/8EKjQEU7K+aBIhq4UDVdJole
         +8ESiMIHTqTRKoxRpk5PbkO3rSGf5P/gYHntfgeL6D6joh/B+B1ejkcAEl2XNbuGqyvr
         AGAhUY0QsPpZxRqPuFDADcuXu4EzCUYS983RFhVUYRMHxl/CEDE3/uv6AXt8n1nQHLMf
         v5XUNQzYjs7637hjuLUXg1jRgcujm/EM9pbq9+JEZFcGTFL9u9Mz1kS81y3oCL0zQwIG
         tKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f9T/eNg+p5LtWJTNT1FpaBcGmEmCKOeqxzqjmmRVZPU=;
        b=YzNJ5g4KWrnws6JLM0eREbAIKouegO9OLZQb2IRLHiRnyqQUaHbrWiWu2bzJRGxk9j
         9Rvs9Q7ej+Ytu6lE+RxH9V1aTCpDBBqv39G2gO0/Mr7Dy2rsGd/bJW8oHwgMt88AulAX
         AduTq0aXJY3Ireqkzp3eqWxdTx54C6brDXF2GbgEbZpbZZkMXsNgqFLf4mjtxeAZ8Ihv
         yQAj7v1Yv4Ocj5aiPbKmBNS9jpB3C8+CveucklYxKQLEKBr0oms+a9HSKIN7I1IBQ8Zm
         Fs+xrd0icSs30r1fMBozyKeXrPdZwcEDHv25Z/lgGYPUC8AIADS3njdLeqkNhi9CCXsK
         K9Kg==
X-Gm-Message-State: APjAAAXzg/H6qhuoN9k0LBEBRc9sz1kLpK9y3uZCRPcOozv/SADL50m1
        CqkOvHfS0EGisHhd60ofSIApJfwCRljs/Q==
X-Google-Smtp-Source: APXvYqy+eMSQqutAxAYK53S+JI+Os+O2xPgHjEvuV8otus6eZOSr9BpLgJR41Gl4QXvHtY9QJm3vww==
X-Received: by 2002:a1c:7a15:: with SMTP id v21mr12848192wmc.82.1560641374002;
        Sat, 15 Jun 2019 16:29:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g11sm5024380wru.24.2019.06.15.16.29.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 16:29:33 -0700 (PDT)
Message-ID: <5d057f5d.1c69fb81.a7b14.a2da@mx.google.com>
Date:   Sat, 15 Jun 2019 16:29:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.126-22-gdbca872b791d
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 107 boots: 0 failed,
 95 passed with 11 offline, 1 untried/unknown (v4.14.126-22-gdbca872b791d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 107 boots: 0 failed, 95 passed with 11 offline=
, 1 untried/unknown (v4.14.126-22-gdbca872b791d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.126-22-gdbca872b791d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.126-22-gdbca872b791d/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.126-22-gdbca872b791d
Git Commit: dbca872b791d48894e4b6399287ba2ae61cbb1d8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 24 SoC families, 15 builds out of 201

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
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
