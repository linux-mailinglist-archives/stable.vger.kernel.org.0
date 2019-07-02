Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9D25CF2A
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfGBMMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:12:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36740 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGBMMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 08:12:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id u8so754313wmm.1
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 05:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=CDsS5u+KDTbhhEMFxmDgcX1QIIeBg3cSM1Nwi7INntc=;
        b=QmQQd2Ip5d+cg9oHML77Yy8e5G1DAUyTI7QNJ7KoKUh7U+va7mztkOY4eR6lqFEqB2
         IkBJuwvqohI1cFYTp4CdPv2B63QD0wRktgeKY0O59cDHu6vhXJxPqBY/36KNiSNfrLah
         1O3mMpckKWV1gYSBqpLoByHZOvJE6qdgGbboEzt5W0SVpllLmY1GfN2UDiihqODyeKWh
         g3knQToLqeXWuRPsc1RdFKPg3ktK8Jt3sZEJMXIa2aDqT+uit5EbN0GgZaJ51jlMlbT5
         qa47xw9rCQ8O9mcjvqyvNor3+8F7jwOOXoMzU0iILFk+Bby7ZmbbiLR4dD9cyo+nu1Rt
         L0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=CDsS5u+KDTbhhEMFxmDgcX1QIIeBg3cSM1Nwi7INntc=;
        b=RcFF6kyqdlHWApNG/+IyHtemTt9UfKdWji24s1HRYbsxdRKbJ3s680UhCd1njwIwwH
         FRHUnknW/Rz1R2T6ATdmJFXlP22yL0Fpr1UNwE6Y7B1VGyiIyZ4FtXt0Iy1S87qmNuLf
         1/z0n+O62p7MhDasEQwL0kLR5l0e5qwZ3WytoNqRKgEcdzgSv4eE7SEmGbCjN27lmmTI
         4yYqmcC2OFcKmaE76xG6BdFNnYw2GjpTFGW7JTDAo3XQnb9A38+1pLVj+x61GImUkloz
         9J6+LCB06sT82L/TfpOGVun+H4UvU4ifufkaGfjBkdxsKnpr0GpJm1eVEXWW8fjMOAcX
         KT8g==
X-Gm-Message-State: APjAAAWJcqXlVe+0BgY6dgTbFHWrm7yommZPB84sMSyAsN1tyf3Uomum
        d2hSQJWr3OyFGFgTv5QsS/g=
X-Google-Smtp-Source: APXvYqzbJ9XA5Lx19RMbCq/HOWbEcX92eFuuAzbCPMuombttIhTwC0+RQCbpADQDP8YfDf4oKdXFEg==
X-Received: by 2002:a1c:f018:: with SMTP id a24mr3215727wmb.66.1562069527903;
        Tue, 02 Jul 2019 05:12:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c4sm13006626wrt.86.2019.07.02.05.12.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 05:12:07 -0700 (PDT)
Message-ID: <5d1b4a17.1c69fb81.daa12.d41f@mx.google.com>
Date:   Tue, 02 Jul 2019 05:12:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.131-43-g6fa18665b865
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/43] 4.14.132-stable review
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

stable-rc/linux-4.14.y boot: 128 boots: 3 failed, 124 passed with 1 offline=
 (v4.14.131-43-g6fa18665b865)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.131-43-g6fa18665b865/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.131-43-g6fa18665b865/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.131-43-g6fa18665b865
Git Commit: 6fa18665b865d4e0d0bbf1a0269e79a5f0bdc2c2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 25 SoC families, 15 builds out of 201

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
