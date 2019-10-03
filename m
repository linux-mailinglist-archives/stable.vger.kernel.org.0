Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75140CB218
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 01:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbfJCXBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 19:01:01 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35591 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfJCXBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 19:01:01 -0400
Received: by mail-wm1-f67.google.com with SMTP id y21so3809991wmi.0
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 16:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=5XLyElFX3eltdjc+ovCaDsZywZC9OfTTs7UKklg4XX0=;
        b=erxvtT6ZFb9Eu7cVHwac/j6pivdDtyRzr8hKcOnRno0vrBX8TIP+cwIHjtviTPG1kx
         PJ67xdpOdkqnzwl3uGFfGhwv7pKNhs8H5FZ6VvKEsexoPHvSuSEzqE6D3o7rGcnQaeFh
         7osmM7mLajCu/1p3ZMzuKRJ+b6lpymitwXK4JlWUhs8P1gDsnAzZKFuEf3YelpVDRPxx
         f0tkRhizjwA6th5Z1ZyNC+WfhnvGKXF5/CJFkIw8r5hhPK55Dpbi3c90Ys/72C2FJ5eV
         DG2TF+8ry7gWIPVdUI3EtchrUZPHbFqKUTVRZOvrx0FOTNbeu5FLOE4QiHWRo8Rs8gge
         4JAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=5XLyElFX3eltdjc+ovCaDsZywZC9OfTTs7UKklg4XX0=;
        b=KRJZJib6BaMmFnkBIz1pZgA4jDhYJD/wJ/oonDEVMsd2bmuD5w/jAacKFZIhVSnp+h
         +TSIu6PvguQjdiwHl+m4MCCVPCQE+L7xPbEzRCF0XYQykEfrh9+DEo9sas6hWdBYZgso
         pV6BMhN2wNaANfRSgKMnYXAISJniDOC2ashAVpchYyMciE1zcyYZmSxqNR8QuQxWCnLy
         AIpKfueshOOOkYJGWr6ZJ+K5zbqFC26HWr6RJNzPHoFfs3FUsX5WYeVcfQa28rOou3mj
         wmeXR+2aFDPm6PKlW4KBVZzyPFZ+iTQvaa7oXMTtK2Q1w/OqqUJEwvS9GHKF85SMI7tu
         T5ZA==
X-Gm-Message-State: APjAAAX11CjlOXti7lXNs2ENuCQybO02E2CF/KAxNUyELM3GHlNGTwU1
        Ifu2FSQFHiJMvbYP17EA/Qe7Iw==
X-Google-Smtp-Source: APXvYqyQlkaKNllhHPvHzcYbbxiOPFgcTzemMHF16bDZQTm2UPhwzpdStCDe8Lhn2f/dV6R72uDWZQ==
X-Received: by 2002:a7b:cf33:: with SMTP id m19mr8898549wmg.143.1570143659122;
        Thu, 03 Oct 2019 16:00:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i5sm4074923wmd.21.2019.10.03.16.00.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 16:00:58 -0700 (PDT)
Message-ID: <5d967daa.1c69fb81.174c7.399f@mx.google.com>
Date:   Thu, 03 Oct 2019 16:00:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.18-314-g2c8369f13ff8
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
Subject: Re: [PATCH 5.2 000/313] 5.2.19-stable review
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

stable-rc/linux-5.2.y boot: 136 boots: 1 failed, 126 passed with 9 offline =
(v5.2.18-314-g2c8369f13ff8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.18-314-g2c8369f13ff8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.18-314-g2c8369f13ff8/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.18-314-g2c8369f13ff8
Git Commit: 2c8369f13ff8c1375690964c79ffdc0e41ab4f97
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 27 SoC families, 16 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

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
