Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A29A4FBAD
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 14:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFWM4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 08:56:41 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:41463 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfFWM4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 08:56:41 -0400
Received: by mail-wr1-f47.google.com with SMTP id c2so10951225wrm.8
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 05:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2UvgD4W7NqTYGopygUkFGAngBuk/M8dzfpLBq1MQ3FQ=;
        b=ZfLwacFQ+7GHCjAwjLLqjDHxqQ1NYLtzrPfiXJ7Q5+477xTJjvZ7yPuQCXuJPaMFUM
         JjWgTbD70KgbGSdMguMBLw13RXgn2+o5x1ojtauXzXBDnKCcTnQPG431svWdQMl6jIKe
         +Sag0gK2gGWnkguwzSNHDXqQAYkR+doEf6TsJ8DV/SMe9Fr9iTs7eXaBgxfifn5fncwo
         ajUptDZGJgsVJqBn0zpRCCGzz7IzZVPGuP46DpDar4DJe5kPROGaaAN0f4omiJSeJaYl
         UsDquMAauDoh+axi1do1/Fyb3oqokUoB82IoDBz8LQQ5euyq2bGHdxXpTfrWVnR06IJw
         2DVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2UvgD4W7NqTYGopygUkFGAngBuk/M8dzfpLBq1MQ3FQ=;
        b=klvcs2ra3VpugIlXOJCCkvEzeNONx24fPgpnLVSiTaOx7VXl55qQkM29BMTmvT8mEV
         6hNdJmYRzis2HmDPJWmgQWbBWKJc57dvaD5iovWECLU1Zsm7S7tL77wJaR8Fhaf4w8VF
         Wyq84QI3EA/nEPQ8iDDexavPNdzLr09st8U0x0ZqOzA45dSvYepM7ceTQuOQf68vW+xi
         HvlC6CU3/UTvh8ljBXBumOdc8P9bQOLvfCm49c2Tw22RklFDD9H8nunKmcs65aoxLeJA
         qsu5EihlF8Z5SER1M/uGQ06l69LVYVG1DQvMl6Ps9ZOcIjhcF3aajpAk7F8dXlkHuCHT
         ZC3A==
X-Gm-Message-State: APjAAAXIxPAKbj6Hbqews079JGHYwd4gBHi9Lao37IUTcVY7DZ+BqVPt
        LrVOFWrVA2ATRLF5rHf6dP0X5OiHsVQ=
X-Google-Smtp-Source: APXvYqz7s8dXEmrBOn74uZp0VXEQJSmX8sjh/TfqJysTxBXDXMuUeUVLds3jjWi/DYEOCy/q90N7GA==
X-Received: by 2002:adf:df10:: with SMTP id y16mr18123407wrl.302.1561294599172;
        Sun, 23 Jun 2019 05:56:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a64sm15757937wmf.1.2019.06.23.05.56.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 05:56:38 -0700 (PDT)
Message-ID: <5d0f7706.1c69fb81.ac1cb.7d04@mx.google.com>
Date:   Sun, 23 Jun 2019 05:56:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.14-2-g97b5808a522b
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 128 boots: 1 failed,
 120 passed with 7 offline (v5.1.14-2-g97b5808a522b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 128 boots: 1 failed, 120 passed with 7 offline =
(v5.1.14-2-g97b5808a522b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.14-2-g97b5808a522b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.14-2-g97b5808a522b/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.14-2-g97b5808a522b
Git Commit: 97b5808a522b8af334e007c5e5473b7fb2fd5580
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
