Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981A5CFE10
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfJHPsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:48:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40775 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfJHPsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:48:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so11275363wrv.7
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u0VAEBRb2O1Pjv9C+1Sie8S6X3qYUq0lz1XToS858UI=;
        b=yj+EGtp+qEmlSAey2Lt8N2ygAYpisguWkckUYSG8AwRfPwcpHKtnA6uWsS38LPQTwV
         fhcBN/2IMl3sHeFgxEd60Ddh5VML/70mwpI69MXgbpcJpisvXSg6AS6G50bNlRmiDUy2
         T/lmrlWhpTjxHeeQbmA0doLFpz6f+qrNy+SOCaoYNqhDJILoBTD0Z3Pq84ueGVlmEKEI
         z2ZuA6v8vrW9vKd+rscZSSXeUENrHf982P/e3+J0OHlaYqLRCzHmTVNnj47cKvJxjyqa
         GXrxHefbmTZ5SHIXMtllh0pU678e+MzBw7Uzvk0QFHGd56RI37gljeyVPUbHNuX4SqwH
         zjeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u0VAEBRb2O1Pjv9C+1Sie8S6X3qYUq0lz1XToS858UI=;
        b=ARSj4LVISgK/9mt7f1gGfVVQcPp31LybKIoTXo2VtjurkXemf4q2qjX2nX/AALWIjB
         oLHBWarRGroN2L+xwxfcync4e4cci8w7s/JITI4xlxOgK+op3ZNsjuVaOR5SudyzzGhb
         psg5ILPdqR19+0YqEKVVC8UBmStcdTSFvAiK5fPrbzwX3RyBmHi6NUh1aCW+5/B6b8W1
         PaA3bPD1Mv49cDgnCBEBlyQ1ZRwRgsMNNqnVNFgUO+xJi1EGhIH53sdnItfE53CPSAQH
         WKg/VudcfCVA831QX6+DYE7nPfRE8uvK0EMKvAHF4Ge/08QbdXMDE/VBtBf+ZUZJxsjH
         uvxQ==
X-Gm-Message-State: APjAAAUlOKrTY7zpnrOj+cToG0oNYbS2TixAv2R6w2LJi2VXehGiAQTZ
        TAhLMtOegyV63UarYRsGF5ZlgIAVG/8FvQ==
X-Google-Smtp-Source: APXvYqwN5aLoIe4nTrptsh/cprIDpu6a5DgU7fdEfWpkGcYdEnvaJJ8sZUCXxLGYELXPOVUu4OefQw==
X-Received: by 2002:a5d:67cc:: with SMTP id n12mr26621027wrw.359.1570549681378;
        Tue, 08 Oct 2019 08:48:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h17sm3198079wmb.33.2019.10.08.08.48.00
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:48:00 -0700 (PDT)
Message-ID: <5d9cafb0.1c69fb81.eb068.f70f@mx.google.com>
Date:   Tue, 08 Oct 2019 08:48:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 71 boots: 3 failed, 68 passed (v5.3.5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 71 boots: 3 failed, 68 passed (v5.3.5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.5/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.5
Git Commit: dc073f193b70176b16ae3e6e8afccee07a13df90
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 17 SoC families, 15 builds out of 208

Boot Regressions Detected:

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v5.3.4-167-ga2703e78c28=
a)

Boot Failures Detected:

arm:
    imx_v6_v7_defconfig:
        gcc-8:
            imx53-qsrb: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            imx53-qsrb: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
