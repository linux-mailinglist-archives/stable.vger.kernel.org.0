Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3ED3ACFC4
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 18:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfIHQih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 12:38:37 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35014 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbfIHQif (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 12:38:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id n10so12012684wmj.0
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 09:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=xgoJ6KIl9oObahyFLTn9w3P2px6DYCxMWHv1maMbGpI=;
        b=qj2UgfxxCzcOcJa6/Bf1AZo3+PmcpyibJkQXvJTH2/bLLLq2eIf/iVzHhQsh0dn9VZ
         Ci0QMJ87qpmkNc/DgdwrxgE9/qBvdc0+JqY2IW8lPbAXTbpskWPuetHBk8Uaia0JGtB+
         6iUXcXySPWNEVzyfUyPEq6IFkRzATQe0XfVnesR7LStF3cFpkdQabt13qPlnGMZroSxY
         Ugy0Kdn6GwtZumdsRqcqXCZDvORsnq/qO9KBFTzw9CUk2LIXf+h2WHijid/1ffIzX/CQ
         i0uWIytNI0GRhQzFMrMu81EvMYGR1vumYm8ceQUcqiAnNdZnWE5hJFUKqroTq5wZWz2k
         PGng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=xgoJ6KIl9oObahyFLTn9w3P2px6DYCxMWHv1maMbGpI=;
        b=kIq+OBtwmay+rW7YV1VEIXAMnvanmF3IB5VGv8i2CNddemIojRychA4S1Fav6VNsBr
         4IJJcoyGORJTRzuqf7Ry5+o99AwXTxDQePnoE5eTG2yPdbuly/8HSFvERKLBrzXRdChh
         ozFGKj5aNLbelYXAxtn7ZWhPNRYPg6JSB6JrKpxE2vMlLnZOnRRU/5Olxv0WzCiUJBRA
         8mEegFF1jXQb63jiOMJ93VWRydgPacXlRXUc6MCOVbNV9Pb6ZgbOeTP0kRKCnPXisLWM
         yvVKg/fln3jOPiBa991ttc4rAXsGuezWuuP11R1ruucwQ8Inzl4NC78GJS8X+kxo5UbN
         /1Tw==
X-Gm-Message-State: APjAAAUFgZVrdwNH0lzDTSF5s4lEzzo0rBOq14vrHXq2jGIJZWIclWr1
        mVoiokxcMdiIe8mDQriZwaft7g==
X-Google-Smtp-Source: APXvYqxdUu7kZRYRvJ7H22JxmcwUXD426MjMr8+ll7si2tX39yabmfPrqxhELDamDFkAUlUQuy/tAA==
X-Received: by 2002:a1c:be12:: with SMTP id o18mr6164106wmf.128.1567960713807;
        Sun, 08 Sep 2019 09:38:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y13sm24998128wrg.8.2019.09.08.09.38.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 09:38:33 -0700 (PDT)
Message-ID: <5d752e89.1c69fb81.7c68.5f57@mx.google.com>
Date:   Sun, 08 Sep 2019 09:38:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.191-27-g77779f048861
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
In-Reply-To: <20190908121057.216802689@linuxfoundation.org>
References: <20190908121057.216802689@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/26] 4.9.192-stable review
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

stable-rc/linux-4.9.y boot: 117 boots: 0 failed, 108 passed with 9 offline =
(v4.9.191-27-g77779f048861)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.191-27-g77779f048861/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.191-27-g77779f048861/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.191-27-g77779f048861
Git Commit: 77779f048861f050cbe941d81d4674c7de3008f3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 22 SoC families, 14 builds out of 197

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

---
For more info write to <info@kernelci.org>
