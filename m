Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACEF4FD33
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 19:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfFWRIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 13:08:54 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:32870 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfFWRIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 13:08:54 -0400
Received: by mail-wm1-f52.google.com with SMTP id h19so12570752wme.0
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 10:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KzUp7Ukna9qHkBfGiI87WhhXwhAl90qGac6Dbb+dn4c=;
        b=RFV0vqgNsD7688F4ehO4ThKA5Bfw/ORrl+8AMoPgNIacFCjED/W4foSlq4LJGm7WNa
         yTMep+3+zxzvwtCdByFCAJV7Kz2nAt5pVwnfzulmHSUoeQ5ZxUJ3OxlCAQBr4nS7Lm/L
         bEib7ZFgw8bynlPl0wFwk7fNz4V/VpSvDRmsJH7t82O4LfMLMfCx9I/jUwIog+cgYrcw
         kVUzNv0HyUDc8+rBq4RXkq04IfkY6j+RbEHGtiS5vC+fXIojz/EU/Pg+yiFbFA1NX+7J
         o2YseAvP7JZXmVkn737vD6Dhi5rbdtJ1a6OpTB4rZoQvz+ct/DWI8ZM10jbBy7GAya0V
         dG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KzUp7Ukna9qHkBfGiI87WhhXwhAl90qGac6Dbb+dn4c=;
        b=g1M+awIArJAtev6GihmYMAiWl0RoSjChWRTOQ39lGx60mKPvKZJD0tRRlyBVSg9KaD
         XJfpPR2fnam9yHd+k3dBOLMzcYsuBQ15Ev0tBUwskf7ZQefJqz0wO+XTHBWVWAh37Asj
         WQec7CbpvM9c78z3aMJBeSC20qZgOxa9Q9xAlNvsv0yPPC5vpuYhyIKb8B8VSf5CMWme
         BntEJRJ0V7x74MAGCIfmMLxIVfZSpiII8A7EQc80VKSvITH7f4YpeO2dp/s4Xj/qqDO5
         OFtVPS4zEORiIxpduREgI0OuvzAOksIAUK3PNAMsA40jyq1WUrcfCDdZCgDHV3B5qSbD
         fF7A==
X-Gm-Message-State: APjAAAXF1UYZ7F4UYN+mNcXGUSRdPVjukym30TqJpZ2cLYgcACjeCnac
        TKQznghOL9Es3XlVlj8dqVtQHigHFFM=
X-Google-Smtp-Source: APXvYqy9eZmvP50jxG8D7LRwmUiT9XtCj5nJiyDAEqrjDn54USsPtMBQRFwnnMJazolnEjFgq8FIPw==
X-Received: by 2002:a1c:8049:: with SMTP id b70mr11888400wmd.33.1561309732565;
        Sun, 23 Jun 2019 10:08:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 90sm18746647wrn.97.2019.06.23.10.08.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 10:08:52 -0700 (PDT)
Message-ID: <5d0fb224.1c69fb81.b010f.6f09@mx.google.com>
Date:   Sun, 23 Jun 2019 10:08:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.55-20-ged5d16b9e4f4
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 120 boots: 0 failed,
 113 passed with 7 offline (v4.19.55-20-ged5d16b9e4f4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 120 boots: 0 failed, 113 passed with 7 offline=
 (v4.19.55-20-ged5d16b9e4f4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.55-20-ged5d16b9e4f4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.55-20-ged5d16b9e4f4/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.55-20-ged5d16b9e4f4
Git Commit: ed5d16b9e4f4532f570e8885c1b36ea55189f092
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 24 SoC families, 15 builds out of 206

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
