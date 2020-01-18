Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84055141707
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 11:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgARKqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 05:46:23 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33924 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgARKqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 05:46:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id w5so11179278wmi.1
        for <stable@vger.kernel.org>; Sat, 18 Jan 2020 02:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O1w+ADeC2YIhjpikyZvFaPyeJOLwmYHh/pDRaWK2t/s=;
        b=lEf5WzZtj7/8Pb/x22PkQfvFesI8NZH2Mlq87RxjmZaG+G/2HsJB7lDTYRxXL+faHV
         DF8T0OByHfpjIsQWXvnC9mVyL/HIf6WUdWM9AjcBc0EEEiIIwBqckZj+lUwMop0/L5T5
         OAK+mnE4OvQkspEUBfr5kZEdK835bjxiOeiD+YjsoF6WIkCakocUmpiSqxZux4qgVm2V
         V0+umqnpiOx8O788QHiVFZVFwFtj4lLAaiG2Zi+vPMtjNNuKJzyqaPsoz8qBml8qwo62
         mcz9J/IzEo/ruzDDXlqNj02Aq06wBA9jXljNYTofJjuHKKVdXXXDcMi21H3hvEci4Arv
         ut2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O1w+ADeC2YIhjpikyZvFaPyeJOLwmYHh/pDRaWK2t/s=;
        b=fgw75lBpvbY8vPfmFakP2ZzyWRaqsO4ZSSepZCgRiYr1HKRo+g+FX4IDg1xTieg6sw
         J+bTWATNOZnR085uKJcxHh3WHIu0rtQXp1mbWknmJrU6fe8LCsf/LXVnRWoKyWo7keSL
         SmMl3yflT5f+zO3vFxWtUisqcnGeD9DTStcgofOShQ0uCbXjZBe2sWbb9LdmhaooMso/
         gJwBbvKVr8gWBzHo426UOv2gWtdBy716u5QazRXwfJyMCOr5hnqAi/mUHEyPiQyc6ezM
         TxywodaW80lN0u5wwjfwy0Hpm2sNI7J3arXDXWmpRvEDcxtmtUzTajB8Lk3BJ9YvDMSl
         QQqA==
X-Gm-Message-State: APjAAAXjXwoo6T/nJhYiAMrAMSa9I935R3wa1v6/n1FbjzP4S+VtZzev
        aJd8bkDtr/ychqYZq9mmCSq5BOLFW/pJNw==
X-Google-Smtp-Source: APXvYqy9Xxr7J32+/88Io1DhoLIwrrUsDhbj6NGT9T5z4c3RSYz/fT16l7hkE9mLUCX14fet5DYyXA==
X-Received: by 2002:a1c:4b09:: with SMTP id y9mr9183771wma.103.1579344380931;
        Sat, 18 Jan 2020 02:46:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t125sm14212253wmf.17.2020.01.18.02.46.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 02:46:20 -0800 (PST)
Message-ID: <5e22e1fc.1c69fb81.2624c.6623@mx.google.com>
Date:   Sat, 18 Jan 2020 02:46:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.166
Subject: stable-rc/linux-4.14.y boot: 99 boots: 2 failed,
 90 passed with 5 offline, 2 untried/unknown (v4.14.166)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 99 boots: 2 failed, 90 passed with 5 offline, =
2 untried/unknown (v4.14.166)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.166/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.166/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.166
Git Commit: c1141b3aab36eb0d9b2bcae4aff69e77d0554386
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 19 SoC families, 15 builds out of 193

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
