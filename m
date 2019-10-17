Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED681DA350
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 03:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404217AbfJQBmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 21:42:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53367 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391802AbfJQBmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 21:42:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so721479wmd.3
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 18:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=2/BQE6F3y5aL1teTaZDy6buval4vv3GU9ONSJI6xLxU=;
        b=fbOwqr3f1yonOH0EUAEULr/cF8ezgOzn2jzCFjy4f/1dnYN3YPGJ0h4MznGJUcqkXI
         eQ9LR/fOaQ9P2OIhHYgBc9bohUXOp03hGTevE8Nsb4xTg1eAZPk/emaMjE9lJDDqtmfr
         MuGbQPzjdzBcFIwGZKKhugymzu0tyOtP6FE7nVg56JV4YtqjJ/5XjYFPC5PPA8vTkBUq
         Yg8Szh+OLHCrSSeK1mKgPlRtPzRF/WhkhG6cxZjJLr2Ic6PI1G6sMU3V+s4qk2N5WGjZ
         QDXSp+Uo4PQlHK0L/tqwwn+fgNRpUSktDho+PSHTMInJctudfZui4v6vF2C3bTKJnfe2
         3qlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=2/BQE6F3y5aL1teTaZDy6buval4vv3GU9ONSJI6xLxU=;
        b=fcTVu/pK4gAA7zjg/3Mu3UvOJa/tZXpxcinhbwNsQXFJNwIDW5NsUj50k27wd5JKtn
         V/1eWU5YlmKLUNwy1Fe6/qkdrME97I6ANV3ZYQyJBe95zvzqJTyfnOQsCNJ8uCY98n6u
         xKJUlakupK2FLhP5Cfws4wAzrTNcg4rF/uxfZK2f1SbnIE14qV6iRHVFPoZcbEozP+ow
         nRxdUHzfjAaV7K/v1zeKvcqUhKutsBWbxUGVCBCRX+fNOqEbVDcebToxU0zXN7DV10WY
         DtTHJVV3hYClJouIFnYDxTeAd7zkgS/NeDPpzvIJkI7rKQbF2RAyub1oA0mgSF6NSRJP
         uorA==
X-Gm-Message-State: APjAAAXBd/nzWZeWRO/+uQRfHK+hBzwf9/S0SEvrnwHxuO1nGF71NFO+
        DNI/9w0zB9pJoW77VZljdVrmYg==
X-Google-Smtp-Source: APXvYqyeK3Q8YOSiK/Dd4vFWZkX9WpxTOHBZZQ3hhBCsHHGgkJNZamlZGeW8O7+ksYCrhLcXPI592w==
X-Received: by 2002:a7b:ca4d:: with SMTP id m13mr505817wml.95.1571276530678;
        Wed, 16 Oct 2019 18:42:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o18sm726884wrm.11.2019.10.16.18.42.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 18:42:10 -0700 (PDT)
Message-ID: <5da7c6f2.1c69fb81.51d2b.325e@mx.google.com>
Date:   Wed, 16 Oct 2019 18:42:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.196-80-g645def690295
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
Subject: Re: [PATCH 4.4 00/79] 4.4.197-stable review
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

stable-rc/linux-4.4.y boot: 80 boots: 2 failed, 72 passed with 6 offline (v=
4.4.196-80-g645def690295)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.196-80-g645def690295/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.196-80-g645def690295/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.196-80-g645def690295
Git Commit: 645def69029558d1f5833e6b95e81180671da907
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 17 SoC families, 13 builds out of 190

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

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
