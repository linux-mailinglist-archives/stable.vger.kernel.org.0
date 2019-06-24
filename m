Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328E85103A
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 17:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfFXPYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 11:24:02 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:42717 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfFXPYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 11:24:02 -0400
Received: by mail-wr1-f42.google.com with SMTP id x17so14343535wrl.9
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 08:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3k/9ttyeiY3kX//P+0wekSb9hiL/xE651wpr0JfFC/M=;
        b=eGtcBq8Thlp49oz+xsUXGQgn7I9M3wwBUZzQHX2otyfe0RvVPOVcxzIqOn4jUB37c5
         Y6C9Vsxeg4mTFrkka36B6a1mHR9XYM+dImwvlJ3Dn6UFgVxEHPtjoz5m3NgaFIDlP1Ou
         8lAdbKd40caMN/KqwBaPY0Yz3BJvSTxiqPREcNu3jGKHp0ksCPZDSfQ1Fwrynic3srrN
         cbRn4RH4jk64it5hpEcBpe7ilZDlJRbUDRWvOuDzlLAOq/e+uVnzMaW85ff3co/r7LcT
         i0yYeYtFONveoj6BirF5+M9iQ7GBvoWmU8z2zPFEyIn+1JM7one9qljhM4f8Ga5VlJ1G
         2MTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3k/9ttyeiY3kX//P+0wekSb9hiL/xE651wpr0JfFC/M=;
        b=FtL8/RRcFuZ/CPP8kNydRyAi6n4sdSi62/+HCqzVG9dxJLd+hrzK/7BlEcJmIloU/U
         dzo/mS6ezQx5y6oQlN4rcXj5reSM/x+SRCTYOCCH9OsGMXFpJVC7TT0Co/YOItHPu56/
         lsYKADg/aaIwMhh3OmKiv9OsfIf6iIoHXwuxaApN0+SA4lvq4yzXaVQvXNC4dU4BwIfS
         2L3Tz/Lo9YMKu/qN5BQJn06OJylSz1TdPHpGhG8z+hUP2W3f+nmKK+EqXnPuvhfYq763
         IaJfOgIKEY9Xh2t8HXBm4oFfmD3GA+zJZNQkqCiQXCPXyrzvTZDKG03Y9qdDtBurZ9AD
         /Amw==
X-Gm-Message-State: APjAAAWr4jNIlZdNRq3+he3qzexui8yq5bi5pKM68BeTWz3qrijluewa
        hnSQcQ8n9Z9EDw0Aq3DQCCFKPKED+Cl6GA==
X-Google-Smtp-Source: APXvYqy2rkDD2PAwTFqf1cmeeeg5YgBv0/ffES0ExHeyVclPtesFnmdM4GbY5azEpyS8CS7M+poYuQ==
X-Received: by 2002:adf:9bd3:: with SMTP id e19mr32544361wrc.38.1561389840631;
        Mon, 24 Jun 2019 08:24:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z19sm10540986wmi.7.2019.06.24.08.23.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 08:23:59 -0700 (PDT)
Message-ID: <5d10eb0f.1c69fb81.23005.8c2b@mx.google.com>
Date:   Mon, 24 Jun 2019 08:23:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.129-52-g57f3c9aebc30
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 116 boots: 0 failed,
 109 passed with 7 offline (v4.14.129-52-g57f3c9aebc30)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 116 boots: 0 failed, 109 passed with 7 offline=
 (v4.14.129-52-g57f3c9aebc30)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.129-52-g57f3c9aebc30/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.129-52-g57f3c9aebc30/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.129-52-g57f3c9aebc30
Git Commit: 57f3c9aebc308dc826ec1191e750fc853e79fb3a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 23 SoC families, 14 builds out of 201

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
