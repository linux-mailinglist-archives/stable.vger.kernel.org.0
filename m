Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11ADB9E00
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 15:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394129AbfIUNRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 09:17:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35839 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389497AbfIUNRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 09:17:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so9446964wrt.2
        for <stable@vger.kernel.org>; Sat, 21 Sep 2019 06:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lPaDGDveMEBwLPSR9Xx9OSApXDzSPMlJU0e+UxnXHLA=;
        b=F2KDAdih1OEoC4txtQwpj4fg+CjujL14AxURpr1mFARBOUI+YlDzjGdr5zo6nB1/Bh
         G1tSQj2tT84vNS5oBAzLyfmTr/0kbGrLBWgpFeO1gxga9vj+jomCGkgfvSr4OaEaIkBz
         sQzYdo6S4gGzUMsY/amEQ084q9i5pX4sO3VGHLLqAEL/FkTAy4/kv/VmsZyftr7mQD6K
         05hNATCl0XXAWXsn0srSkPVHdfeYnu6JpXng1sryalT6wNQDRXbI/O7mwWdXb2gdnYrZ
         YAkrIxHFNXnJPGXbNTPUIf4XoRlARm+e4qxJ3uxQxCobTdbGti0xeIxq1hpxX7dnYlsP
         C6Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lPaDGDveMEBwLPSR9Xx9OSApXDzSPMlJU0e+UxnXHLA=;
        b=naa/TsukWOBJVJqsx0suS1+tpM7fA19wDXcgO7ufX/yVH5wNbYv8xhe9EjMtjWb0/d
         l5dYdQnBvivw9xhHpmVIpbVspd7aIaasVNoZKlPrrziCoYCgLc0r8B0WgTk0RlvFVuO8
         WDgmR8sezVLItsdpVsBXPmsjan+5nwWcpiFBTGzeUqB+RPbn6fsylKLvg8tnPMlMqaIy
         v9tkmL9JXpVrdEoZjqyMCA5OjwKOkVdlROe2SA65yi59FCsIHHLyTRb46czEw7ybsBAy
         iruUqHRhWGqyrIUapnuGAdzN5PP7l3uC/wa9RIpTby8uqMav+XbI5zu8JgfCr7AtzhGc
         gUwg==
X-Gm-Message-State: APjAAAU/6J7+tsrITZuNgYzTT3jqP9D0786/fNvpoCKljXVDI9Lht2dk
        ZXUk7uCyRYQ8pVOlL6wjdQLhfUYxDDynag==
X-Google-Smtp-Source: APXvYqw08iAM67ajkANagKn+bfp1cYtW5iCPQDq6AP0AfQzQAFu3vfIF59Q1QBw0ZMHBzqlegDmS6w==
X-Received: by 2002:a5d:5643:: with SMTP id j3mr3215711wrw.357.1569071850191;
        Sat, 21 Sep 2019 06:17:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q3sm5364331wrm.86.2019.09.21.06.17.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 06:17:29 -0700 (PDT)
Message-ID: <5d8622e9.1c69fb81.f3261.b1ce@mx.google.com>
Date:   Sat, 21 Sep 2019 06:17:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.75
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 129 boots: 0 failed,
 119 passed with 9 offline, 1 conflict (v4.19.75)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 129 boots: 0 failed, 119 passed with 9 offline=
, 1 conflict (v4.19.75)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.75/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.75/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.75
Git Commit: d573e8a79f70404ba08623d1de7ea617d55092ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 24 SoC families, 16 builds out of 206

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
            sun7i-a20-bananapi: 1 offline lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        tegra124-jetson-tk1:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
