Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D8EB629A
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 14:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfIRMAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 08:00:02 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51366 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfIRMAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 08:00:02 -0400
Received: by mail-wm1-f66.google.com with SMTP id 7so2304222wme.1
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 05:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=ADDEHritjAAyr1Uf8VLuPhIliMxd6VsivOVJPdhBhS8=;
        b=tDTrFG9OO0SQ/j4VPPw82dJXvs/LchdfBItGZfh+YI65BJkwxeV5YeeQzZ69Hj0fqM
         oGBWGO75/1RCTKLJ5QISvrPTZR/Ukl1M13hfBaLptFu089jOyG1dTijDHJtg0krv/9CD
         zl/TQrSoHZpCqaIRxREzZfIMzngi3O4gsuOxtTs4iJtODcaky2erBKiJ2ysuC1ApwALh
         yck/Gagf6Iw+VmHxRpwLSLvOqaTh26/5tModzOBX6RBhuT8eo6PKhjyTycR5uw6zaL/F
         SniRRkdpdUJIn3K/y2zaWdZN0FLEweV7OuhfXTAj9jXGbVW6/AZv+C+qz0B7pSuWyU8Y
         lVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=ADDEHritjAAyr1Uf8VLuPhIliMxd6VsivOVJPdhBhS8=;
        b=UQYpjalhKb+J/PyHmYl+413uTfvBTPTmQuFzZI7zrE/6l5S3Lm3XmJSgR4vaYr3Iga
         w8NylMLB/7qixmDVtz7pTVFbPTYG/EN9Bu73MpQrUM4NX7K0hUrnYr5GeW4zMI8ekzd/
         cshCeFI5Di5P7sPpoovPtrjEcXGwgukkOmF20rJT5zd39rDOgJFOyAalzUDb7Xyd79Sx
         DHW7qK/k0S3hAh9c/+CxwnQScPdI3iMbzEWOItsxE/jtG/cLkgipGYjd/DrDg3yr4qyE
         iBovLJltmSzVhvidBUwDIfjB64h4LRQGd2br/8hMRQ1QRRZqoxOb7of2hiNgxeGyoRtw
         f8uA==
X-Gm-Message-State: APjAAAVSZpT2gpqtyxk76CANsCiCBt8rR/Erdw9RVyMenFKoGQrgbdZd
        PZLc+WVnq2/5tr0EFLGm09wPEg==
X-Google-Smtp-Source: APXvYqyOf9bAl2LHcY6EVznBmlNQTlzJOxTHOTgqToVP1jNH0xrcB5vTOsxeGodHednmXUrv+jtx8g==
X-Received: by 2002:a7b:c758:: with SMTP id w24mr2314538wmk.148.1568808000676;
        Wed, 18 Sep 2019 05:00:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z189sm2945227wmc.25.2019.09.18.04.59.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 04:59:59 -0700 (PDT)
Message-ID: <5d821c3f.1c69fb81.2b5f2.cc58@mx.google.com>
Date:   Wed, 18 Sep 2019 04:59:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.15-86-g2f63f02ef506
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
Subject: Re: [PATCH 5.2 00/85] 5.2.16-stable review
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

stable-rc/linux-5.2.y boot: 145 boots: 1 failed, 135 passed with 8 offline,=
 1 conflict (v5.2.15-86-g2f63f02ef506)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.15-86-g2f63f02ef506/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.15-86-g2f63f02ef506/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.15-86-g2f63f02ef506
Git Commit: 2f63f02ef5061324ba168b1cb01c89fd89a0c593
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
