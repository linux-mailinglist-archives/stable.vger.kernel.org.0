Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A7CFABD5
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 09:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfKMIQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 03:16:37 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:55033 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfKMIQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 03:16:37 -0500
Received: by mail-wm1-f41.google.com with SMTP id z26so940961wmi.4
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 00:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z27InAcd/n5lBzQP/LzLnPx/f9qDr11ZPOe5gWTh+NQ=;
        b=XDdc99YwVmnS4ahJLZzl3NHW7WrDNfHC4kfb8wfwQlz8zf0fKhqtiMTMlHVRqz/+zv
         mC4Fx8d35k85cakbYYLP26gSBbzNpB0ryQ25Kk8dbYQ0TUxy2ntw1WLtNq04FMmz+OWz
         1twly+qS+/MYF+GUWVBpjKrTyJ7mAUoBCgNZNCVttdS5n85QudR20SHIxXWSH7pZP+3l
         NJn2apPjl8/f9+xgJxTuCapyvw58XTZpaaaYgdRIN9Q0R9g5Ao+d+AxyU/+ADMsnLbLD
         qkLDX5kNjdkpKDlBs6UHOl4wJP3t840PAgSKQIb+18tI15i8thWe5YFBzyW9QCTTAviP
         qFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z27InAcd/n5lBzQP/LzLnPx/f9qDr11ZPOe5gWTh+NQ=;
        b=qIqY2OwPPYN1cr0E4/uQZzJw/bpP1Uk5v1W48uKR79NOJkw3SbjVHDhcrn9A4lCD2B
         Rfgdq9jkCpqxc4Vec+FYt/T+RZNnR4u33Rm91R02uCQ64vmadBXAMYhUBVZbFe8mU8UJ
         xj2sVN8HKvUHMI4oZQsCsUH2caWjuyb6q8xfAaAq9j1nuzZJ652Nc8M94wRVP160o0NJ
         drNEQ4prvORi95hiudsy1SGmxE9OO5gf20Dn9uVmZZ4MsIMGwVblAhqLTWF+7LdZzSDr
         aABKgui4HcBJU1cFMs+WncjtQTCCkTqjXEDxPm9awdfU1Ue6/wIEDyXAa0uzcmxm+mOQ
         JMCg==
X-Gm-Message-State: APjAAAV1lAwRRbL7MsWJfoseO+81keh+eQ+bpSK55JV4AYlVFs/eQfD9
        Ir08LQrQK7fCSwuKzYvQBHHFYhoOQkLyTg==
X-Google-Smtp-Source: APXvYqyfWyDdCm9OIFMAVGP4NRvOH/FLkrUMO2+NPfQqEdtfC//a5DiXFi0T0XGJWvFMcdySCuYiqg==
X-Received: by 2002:a05:600c:c5:: with SMTP id u5mr1452772wmm.35.1573632995003;
        Wed, 13 Nov 2019 00:16:35 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o10sm1908646wrq.92.2019.11.13.00.16.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 00:16:34 -0800 (PST)
Message-ID: <5dcbbbe2.1c69fb81.b6d3b.7e1d@mx.google.com>
Date:   Wed, 13 Nov 2019 00:16:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.201
Subject: stable-rc/linux-4.9.y boot: 93 boots: 0 failed,
 86 passed with 7 offline (v4.9.201)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 0 failed, 86 passed with 7 offline (v=
4.9.201)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.201/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.201/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.201
Git Commit: 9829ecfd824adba0396cf5fa8dcc813f4c0ff754
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 19 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
