Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD319A209
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 23:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390406AbfHVVRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 17:17:06 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41776 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390431AbfHVVRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 17:17:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so6697618wrr.8
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 14:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=UmTogWn38PLJ5RM1djif2R8zdP7JFcbbHNWFqC/y604=;
        b=N8deesrExjlq7IPfaQJr24mRKM0LVjz3+D2X7UUlFxo3D/oPQznif5eT6DGEMaqvZR
         xZ63bEXl3Y/oiAQ+qp9XmrpwRdqHYBIGxuWOeUOhLKFEzJHH0bTzYOvKy2nKgXqnQEzX
         a2XqPunWIF4exa7qfaVLtNLRuTZP6i5Vf6sArHD/20/zBioqZfJMkbYd+6wVF6s27gIH
         djZWIal30RdFb7HJ+QbapbL6ZQPEuZc7lISCF6+E3qqVd+aj1iW99spm8BK2AG572058
         2DVwtFXZbZVX4dqjaYOP8B3DBnJWjm2OxFnfZpY2ZQAhwxq8afNpyQTdV6+2oVWkWg/2
         32+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=UmTogWn38PLJ5RM1djif2R8zdP7JFcbbHNWFqC/y604=;
        b=K3i0M9Um415HHa3CNVtLLRvRpD/acInzKnXvCfxry0BdP2sfJISNsKh6WtinYCfAX+
         RCrUd02LcaIhp0zqdWon/ZVuQatQVTEqs1+zNNN5YKQ/kvYAl4zlauj9DnKZ5u6qIqCt
         mlWADqaJhhsLW2o89GGSo2WjxiKSrXphUdKq2pOSN4J52zphUb+HO1tNc+SOlXDXw0Sa
         XN4y+YCIkE3xrQ0LotNvf4yF4v7HkKIX8/o1Oj8qrmK5IXjci2e8JXor6wcNlsaf8pgD
         5aRPZUHO2STIsuYYX5tZSkzk3twqlkL/WS/s3A4nGB9us8RIc7BSCMccOT0FLWzlTIRv
         GVWw==
X-Gm-Message-State: APjAAAXljj6wf3y9MDl3sD16eoYssCaZB/qxSOUqWnOj4tSTekFajig5
        q2PZ+1IpE6pl6ESOrk4eLx6DFw==
X-Google-Smtp-Source: APXvYqxEsZ1SOehV5Nd9GkT1FenNTuRHK9PCXSZlqC5DNkpNIpXKXRmzZK1QcWMEPMaUFaEbQUpSOQ==
X-Received: by 2002:a5d:4f8e:: with SMTP id d14mr975445wru.207.1566508623526;
        Thu, 22 Aug 2019 14:17:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e3sm1849223wrs.37.2019.08.22.14.17.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 14:17:02 -0700 (PDT)
Message-ID: <5d5f064e.1c69fb81.f049d.97d0@mx.google.com>
Date:   Thu, 22 Aug 2019 14:17:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.67-86-gd0621113bbe3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/85] 4.19.68-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 0 failed, 110 passed with 16 offlin=
e, 1 untried/unknown (v4.19.67-86-gd0621113bbe3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.67-86-gd0621113bbe3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.67-86-gd0621113bbe3/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.67-86-gd0621113bbe3
Git Commit: d0621113bbe36c937bc611248f8f7946f68fe7af
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

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
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
