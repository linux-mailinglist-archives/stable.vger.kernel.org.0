Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0D3B2630
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 21:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388736AbfIMTjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 15:39:09 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40091 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388393AbfIMTjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 15:39:09 -0400
Received: by mail-wr1-f68.google.com with SMTP id l3so10447269wru.7
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 12:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=ZyJCNuOAdc3HwIafydT/ebM1uCX5N3TqLtB8kuskFZs=;
        b=SUD42aeXFnXHJaLyp51bT2MlmQEQ7QDV+2hi6y6yEdBaCsF/RmmxIXgMfFYZUCXS1B
         q4mup8CXz8RuwNf2zHrEHuaaJpSljgp61OSA/KlEeIUGKeJs5tnIN8slNL4g/yVfdRSA
         9tYSsVaA3TUic1zQBoHfuwvfAwPhcBhGz3oS6HXyEPY4DqPjy5b+JGr8cC+Pknobzwv0
         6huBoHtQ6SzVrsNKzwpXTS4vLRdc/DrNP5Gqp7KycHe+kAmLl8thsU5t5MdWfJJ+sREP
         QXtr/+z0tdM0pqnzjHp//Ru2ZZytRJk6tePRB5Rk2G/u9E6AxgsrweW1UVegJ4qTnzeg
         zWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=ZyJCNuOAdc3HwIafydT/ebM1uCX5N3TqLtB8kuskFZs=;
        b=t2P/RHLrxlr8OzYibbOykZPIEEsBSdrbhxTS/H1yckcFeYnTvShvNY+jR6YSepxtUE
         hPWwE1dSi7MX+nvD86NtKtmmRdSqCUlQlZt9D/gXkbphIBTWREliPHwSK18V255fJ005
         KPEWHpb6IrpMjzRYlfsOa5AfT/UOVuZ9scCzosSAMguwaHGOxr3grrPzuZfPUaUmHguT
         wucOieXjk3Ekrih393M7jffPwQmog748KxiWr24bAfIlonmSeorJpKaDqY87qO67/68G
         IqW+ionuzw7TLXC4IDMpgT69uWPl2t6/hwaT+0Gm4qcCo/WY5CszSp/3DykWBH8kKvKh
         S8cA==
X-Gm-Message-State: APjAAAWiteiBIcw+ofnWnwWXpyu8rHON5eePmLlvLvDicRVNlY+d7pdZ
        AuOQ6fngkYiGuTfucOBpb85bbw==
X-Google-Smtp-Source: APXvYqz8Wu/Nfp31mYpgGuNcvvmcgL3pdExhbyEzWv4bt55l/lu5dxmPgYsU/ZULUZTH536sQo5yew==
X-Received: by 2002:adf:fe0f:: with SMTP id n15mr3373655wrr.343.1568403546055;
        Fri, 13 Sep 2019 12:39:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g15sm2523966wmk.17.2019.09.13.12.39.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 12:39:05 -0700 (PDT)
Message-ID: <5d7bf059.1c69fb81.b7fb2.bc5b@mx.google.com>
Date:   Fri, 13 Sep 2019 12:39:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.14-38-gda2614d2744a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
Subject: Re: [PATCH 5.2 00/37] 5.2.15-stable review
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

stable-rc/linux-5.2.y boot: 146 boots: 2 failed, 136 passed with 8 offline =
(v5.2.14-38-gda2614d2744a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.14-38-gda2614d2744a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.14-38-gda2614d2744a/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.14-38-gda2614d2744a
Git Commit: da2614d2744ab16514a2288de2039732935749d9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 28 SoC families, 17 builds out of 209

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab
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

---
For more info write to <info@kernelci.org>
