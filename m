Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D8BAC4CE
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 07:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394288AbfIGFvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 01:51:20 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:40612 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389786AbfIGFvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 01:51:20 -0400
Received: by mail-wr1-f51.google.com with SMTP id w13so8574406wru.7
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 22:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kziw1AeYVSe++bgoaxT0RF3UdZM6wd3R7T5kjuueKyA=;
        b=1S7riXa+kr+lIioz8f8khO2OrP7erV8IcThZ8FqumFmSDZV4E9E7g0FFy+G3wdJQp0
         i8K6+IXuU9gFRr6/cOD37YFVdBzSFbe+puF9Z/03vxjXKQubjlKlq68ru9gC5M/WWlwU
         9nCiUpGzIVzdodq9eicAn8YUz60Ah24vMo7+q6EMHHwcW8iaQESI35xoAdsTUwGdcxBR
         hzFs5aL8UCb0k3kK9xdOFLeed6B5bF4nhIRnouNjtnKi8OAmxwjvuTFTPmjhTr69cV01
         7/gm6W5OOwrOlrMqIBAR1Y8uBmEOa1gnsPAlLHFI7uLhclfyMiTuXTcDkpt3VjjDvEnO
         6oGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kziw1AeYVSe++bgoaxT0RF3UdZM6wd3R7T5kjuueKyA=;
        b=h+XdLye5CweIoMmoy8B3QXuuBrtcGigPRSbm/L0g7h1W7tbo6pv2KOfdMdCsgEkS9q
         2+SQ5YSN4KOF64CORQMu2yyrENv9sf8n1HZRAlcdbpt7Tzt2kn0/k8M3nit5eydS317s
         K1V8Xm08kcUqpgvCI982riAWO6VjgGAI268vkd5sYlYte2rei36ZFjqZ9y7IZbKkjOlJ
         QdCpgWrc+Ylrj+eaMHBgotYcciqq4OFJ1a2DsTvg1yNtOU7T/qcqJYckThFgMAF8Qd0x
         yAlQwHKybKrA2rhbxVIvNWMPO3Pt2XspaP7LvUcKhaoS+xW6ofAQwk1DPP+7iqDUJBMh
         6OoQ==
X-Gm-Message-State: APjAAAXJQOONwtwE8qeBQMQMgAFuqut2w6VpPP/rpmTV+6FUmZa1gLk/
        10oT1389nfZsgc5/qyAQUUGt3UfIjWNSsQ==
X-Google-Smtp-Source: APXvYqyrPbkRva5mNypIfdA1elNvuR/tWLHXhR8fqrAN4iQytEvmOMPZsTqW7J++EUpMnXkRe3rzrA==
X-Received: by 2002:a5d:6987:: with SMTP id g7mr10121812wru.306.1567835477498;
        Fri, 06 Sep 2019 22:51:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q10sm8307342wrd.39.2019.09.06.22.51.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 22:51:16 -0700 (PDT)
Message-ID: <5d734554.1c69fb81.f83dc.603e@mx.google.com>
Date:   Fri, 06 Sep 2019 22:51:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.142
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 128 boots: 0 failed,
 120 passed with 8 offline (v4.14.142)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 0 failed, 120 passed with 8 offline=
 (v4.14.142)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.142/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.142/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.142
Git Commit: 414510bc00a5fc954d8340c170083f518d09aa55
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 23 SoC families, 13 builds out of 201

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
