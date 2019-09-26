Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6FBEBF24F
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 13:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfIZL7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 07:59:15 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:53303 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfIZL7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 07:59:15 -0400
Received: by mail-wm1-f45.google.com with SMTP id i16so2432776wmd.3
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 04:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Rwx/p5jFnHMIJ1eDbzOqiJDxelfyxNadCyY1QHBnvuw=;
        b=R/K53252AVDJ87xsfD3UGNl1xS22h6cjg0Ri2rIS/DYOy2cRSLOuJ8fKIZkORGPVuk
         XA9XYxijsCAWtNIOW1yhxsKxPljWGPrQPvS5GxIco4qupksUvS3u5xHdMub1PkbqByTu
         oJFrdDATtvDGClPlwykf4AYabuemux7vM0YOGC5AcYtwQKXpRFfQhckLqDVr3UWIhIMB
         GhB2QFbfb8rhVJ38hpGcslFY2EEIhKh2MPXvTahPRSzRSfdKF9cn0R+qV+LxejeL+Q6y
         C9+u95KiRh6Y6xlKWxE2Ahzqvi1F2Nqw3pT4mUxogmG7xB5LG+hctRJwtTle8C6lo6SB
         vHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Rwx/p5jFnHMIJ1eDbzOqiJDxelfyxNadCyY1QHBnvuw=;
        b=XYx8lujnnwPmzz2Tix8xrL4dpcX9jtoZvGuG+ZMJywIzelvYsqSpDAV3+5HpJdnw6/
         Gnw49rbZHxjFIV20CraVOfAc9z7z78dWshYF/36RJHxU1IrCS9W21n76fkvBbSnugyoj
         eC7wz7WetS/zwiY/pMv6xc2uhArdrys8B/ckF/NNQlg5LPKh15TK1Y8WnpDWZ/wfJUTF
         1bT5brsxoQIa9R7HsB7UYisdn1OgFEWIQ4FvW7Vdeu47crOGNqMr25Tq2vnaitv8Q8be
         WLNnB0SYVMAcl6VEsSaZ/pS+3v6SvXbLZgJvf+qN9y5+AQLaMTdZ1Yl3jv6efPEtVtkj
         bS2A==
X-Gm-Message-State: APjAAAXJVJXlNvOJ4Om3SRWLCpuGAdV+k3eaVcJdSGvjEyNk0lJtRBzf
        aTS2Tw2vH/11Llx7GmWUiYzKS7ybGNMe1A==
X-Google-Smtp-Source: APXvYqyq6W2c11pQQjuC/erYpUBZrxFL7mr7dQdCuQjn7HPlb3K1umIuLPvP/7KngNPmT+Aj6we0QQ==
X-Received: by 2002:a7b:c00e:: with SMTP id c14mr2761484wmb.60.1569499153622;
        Thu, 26 Sep 2019 04:59:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c10sm4139536wrf.58.2019.09.26.04.59.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 04:59:12 -0700 (PDT)
Message-ID: <5d8ca810.1c69fb81.361ad.1864@mx.google.com>
Date:   Thu, 26 Sep 2019 04:59:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.146-18-gf0e4f7af6713
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 128 boots: 0 failed,
 120 passed with 8 offline (v4.14.146-18-gf0e4f7af6713)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 0 failed, 120 passed with 8 offline=
 (v4.14.146-18-gf0e4f7af6713)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.146-18-gf0e4f7af6713/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.146-18-gf0e4f7af6713/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.146-18-gf0e4f7af6713
Git Commit: f0e4f7af6713bb041e3dd4a84d0b429fe1f20dcc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 22 SoC families, 14 builds out of 201

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
