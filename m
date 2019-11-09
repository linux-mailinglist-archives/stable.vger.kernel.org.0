Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F082F5C3F
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 01:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKIAR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 19:17:57 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33431 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKIARy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 19:17:54 -0500
Received: by mail-wm1-f65.google.com with SMTP id a17so7719173wmb.0
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 16:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=f8UQyvuvWgpEq2N3T2nQEuiH1x2TFVpMkfEXRizzQ10=;
        b=kifbxcf7r6iQxcWOuC2GnK3N0XbKtmpi4dtHVb/XLUjv1uqCwGcG/9nKNzJfu4HsgE
         zX9abmDfp6gr4ZhpFWm4kdq1+RQ7pxgAkJBN+NOeOGT/DOAH43yxqy++PrUc3FVWvKH6
         HKBonW7JL6UYdoHKh+50dj4qMjY42HaAtVy0zjvZ0wEu5/wVmxjgz6BlpnCt/rp0xq2U
         h0WPGYHQ+GaNDqssptLnGdyzbrYdfnool8Sku7Q5zzSiWkG5tCnsEK7jEzGZzQCTlQde
         LYKWpWAIwjzyvU6FUG13QyWR+H+pgByMfp4QzxIKRv+yVY10gRd2G25sm+8iVxZDiKkr
         ooww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=f8UQyvuvWgpEq2N3T2nQEuiH1x2TFVpMkfEXRizzQ10=;
        b=Zd6ZplUdmeM+jJvYmmJ1iJDN2ooCkyASf3Z9skc4GaZ8c+3bfnuVyOe3OZPL4Ce2qc
         vZn4GodfLmrZJLL/sfoLZAuKMemuMb81XXYViUDGX9WsTxCmxO7abpKj/yxYMUyt3ygE
         NKGcLBRnbxAD/L1id3cm2HshDKaGU8ORFmZ5JsZff5bj5VBQPAVBQf7nA/PzQh/oFRfm
         s6EA1yEHxcf894v/q7eYq0CAzkgEX2Dp9RIjAUkci4Cnw+OAbISA7NqzLnENlc637zES
         TKRuo8PK/yXVGAI+cs8js7ar8XF06RujD8VP/OV87ZIGws+z1k10qo+zQAQIs8zVzV2B
         bZ5g==
X-Gm-Message-State: APjAAAVPU1kedef13qtkhS4bevCu/sJmALxpBsXeZXLUc2Y9q5oEAcBe
        m2UtdabBLsnEK+ZOGU98ziZugA==
X-Google-Smtp-Source: APXvYqyJzUxFWdrtQ5K+rpDq8CiT66LKyvHwavR3VDIHZsUs+aXX6Nnt9OlL3aWDJ5a5owoun46sXA==
X-Received: by 2002:a1c:a107:: with SMTP id k7mr10244182wme.146.1573258672098;
        Fri, 08 Nov 2019 16:17:52 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v9sm6594032wrs.95.2019.11.08.16.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 16:17:51 -0800 (PST)
Message-ID: <5dc605af.1c69fb81.487bb.3ce7@mx.google.com>
Date:   Fri, 08 Nov 2019 16:17:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.9-141-g11077993d891
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
Subject: Re: [PATCH 5.3 000/140] 5.3.10-stable review
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

stable-rc/linux-5.3.y boot: 126 boots: 1 failed, 116 passed with 7 offline,=
 2 untried/unknown (v5.3.9-141-g11077993d891)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.9-141-g11077993d891/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.9-141-g11077993d891/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.9-141-g11077993d891
Git Commit: 11077993d8919cb6ce838e60002b129d8321ac80
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 24 SoC families, 16 builds out of 205

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-khadas-vim2: 1 failed lab

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
