Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F9AA9791
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 02:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfIEASP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 20:18:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37995 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfIEASP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 20:18:15 -0400
Received: by mail-wm1-f66.google.com with SMTP id o184so670532wme.3
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 17:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=MCwGjVWQ8geMBz8XA4P4QY9ik7qf8xcDkwmUNH/Zo/w=;
        b=rs3yPZVDnwfsTeL+Lusgr1V7QSSD+D7X9BRtvMawntpoFEESYIh0qvfZLElmVuZxLV
         5ljRB0l/1BAj4jPwMcMeNSN3+50uVX5GOyhknYs48SNEfHCDoyJHWjw1ebh0CLHMZ7bA
         nTi5OLq+ZTVCN5Yey69p1VzzsbFRJ4jrqBVbudbbsEGlhGh8rZWxGauNdd+3EcTxx2do
         827U5uRk62+4sH9MrwU/zuGzOWQdfDltAfnjRiANg5ZZlS8UG3mJKXLqgvPJfPcesCvV
         RzmhoGGOZJMYWlykAPBsxmxpsOEeVJakwZfE3vco9Lc2Hyb5jYWZVb8kphDfIxyNV4R9
         VM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=MCwGjVWQ8geMBz8XA4P4QY9ik7qf8xcDkwmUNH/Zo/w=;
        b=div6t5CgCYknV7AjAtMutJfcutfohIwdI+Q8WiK1u4limHoRsRklf7PpCFk3R8uOLJ
         mQ7OGN7BDARQALo5qbQ9ftxrfi7VZin9tC5FwWhaj4XRsunuU8tle8N5vaz+qK12iHMK
         lvzmAgPVBZG/9bQAH6DXWAen6dObwMbJLWM2XLcZECOhQe1jY74agO/dJw2MB8iWtbr5
         Lc7BNqpged1MUjkmP9YxtqhmkgiSa5nQFNgK0OamZDrgX9eSstCoaGDQ3sQzJsMmRYu6
         wwnbJktmhQBFF8LIke9va9UCIaCsnBYSmraG1biSSbws/KWxsuxw/kPJE2cylUI5eIew
         +YBw==
X-Gm-Message-State: APjAAAVKU4SMk08bfjcGS12OplFxUiheN3YCk9N/J+sKwFH2Cl64ljQO
        5mtfnKe5BD/tkwLuyVk5li7q9w==
X-Google-Smtp-Source: APXvYqweHPDI52RBMILSReOxOpg//glYE0g2TGq/ROtfN7rtrbELR/fepS9zH1a38sRN6aewxq31Qw==
X-Received: by 2002:a1c:ed06:: with SMTP id l6mr570512wmh.167.1567642693352;
        Wed, 04 Sep 2019 17:18:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w13sm407488wre.44.2019.09.04.17.18.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 17:18:12 -0700 (PDT)
Message-ID: <5d705444.1c69fb81.c4927.1cd1@mx.google.com>
Date:   Wed, 04 Sep 2019 17:18:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.141-58-g39a17ab1edd4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/57] 4.14.142-stable review
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

stable-rc/linux-4.14.y boot: 144 boots: 5 failed, 131 passed with 8 offline=
 (v4.14.141-58-g39a17ab1edd4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.141-58-g39a17ab1edd4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.141-58-g39a17ab1edd4/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.141-58-g39a17ab1edd4
Git Commit: 39a17ab1edd4adb3fb732726a36cb54a21cc570d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 201

Boot Failures Detected:

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 5 failed labs

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
