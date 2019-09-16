Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D4BB40FC
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 21:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387662AbfIPTSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 15:18:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37125 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733190AbfIPTSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 15:18:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id i1so626665wro.4
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 12:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7RLhxwOS9RjetrHNTLAGeO/qZEHSzY7+rJO6+RbcEdk=;
        b=ThyFcouKRLtyve8wYa8NQ+njH1XGFQjjkk78OiJjntradlT2m+fcm4GdBzsDwfYu8I
         iMnCmcQWiq8GXtOU+wnlRt1hPXGqYg5SL9UqaHw7zDXxuzeEN3Fr0B9YDs14T3TF8C1U
         qMTFHmwAEzcC+eU7V0kkMjLXGBYtNluf1Mw+oGmByjc/PzzQB6RMdOkdn5NTRqy3fsBR
         j7PAx8fp4IKHFWnxbXLl9J+RRLJfW9BgnGhixkqooLSUYk5xdi+zhRffYc8/c02ierfN
         6izOwPri6GPI7OCWhlpanBLg/IeogMzZ+Iz9caG2vhwYcdqVCvKYNpj2MTgjE/NstQic
         h35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7RLhxwOS9RjetrHNTLAGeO/qZEHSzY7+rJO6+RbcEdk=;
        b=BWLmvZU3Bi4SP1RH9yxjOwRmoV71JMM4xjtMu24+cgBkKuLGJbkRwQwyJUywSd9z37
         9DqXsJLnZzETmEf5/PhICxDIv3Yw0W8pHB/q1IKAPZHbXeAxCi/TUOtA9rhpy5EoVGH9
         1FqTWzGSstRP/lggnX/SwNQD5fmSkC1ZaFYqmyJg+UtK45gzuQOBgRChmdF35XL2rVJW
         7o6yA4k1hiltU1ogPrMAroKtx83byVOucElsWNFNa5EZAe+WiZLXfpYgtp+b/mAfcIf7
         yqwlRoLSiS+au7rns9CprIcmZiyCGd1pQz3zNyNX75iPMU0bQC92hrQC1lOqlw7rtj6C
         Jubg==
X-Gm-Message-State: APjAAAWhPa2JW46tq9oNVYpIbGYc8NIqPaB18dWLOWQkU/+7vDodkSnU
        OCjUh1gsU38EBD4KxSE/QTYm5nzyUR3xVQ==
X-Google-Smtp-Source: APXvYqwwGMvXOEDdx2ck0/Ly5SW5CHAkBAnDAKMjPG4zDV2Ohzw3p5ygvwr51JT+X+/Gfk7NOOgkHA==
X-Received: by 2002:adf:e488:: with SMTP id i8mr1013131wrm.20.1568661506377;
        Mon, 16 Sep 2019 12:18:26 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r20sm3650wmh.37.2019.09.16.12.18.25
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 12:18:25 -0700 (PDT)
Message-ID: <5d7fe001.1c69fb81.212fb.0059@mx.google.com>
Date:   Mon, 16 Sep 2019 12:18:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.193
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 102 boots: 1 failed,
 91 passed with 9 offline, 1 conflict (v4.4.193)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 102 boots: 1 failed, 91 passed with 9 offline, =
1 conflict (v4.4.193)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.193/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.193/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.193
Git Commit: e19c5132f78a70cc53745558c0e728fecc74030a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 13 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

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
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
