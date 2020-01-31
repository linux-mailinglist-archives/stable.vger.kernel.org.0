Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2466314F15E
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 18:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgAaRf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 12:35:58 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51847 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgAaRf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 12:35:58 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so8870079wmi.1
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 09:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nc/FRVHn/4Lw86zjiOeenz8vMlgyeo4rtZnqG40H4Fc=;
        b=oiEoEWr1OKe/i6L6HJEXVxycpgyGq91GHFGdKkyBLHAQQZL4fNhlMLytSpNBZk/zfP
         fqhXho2VkXPgJ5nc+4w1iDNaZ//Zqr5yopHhtyJN4x11GuclSzzikTdt3kWT3mRB6WME
         M8IhdI9kYCEPTBQnG/j3G43Z/pv3xLkfcyhCXomhn0eac0uzrDdZyH7CkRt3w8LIQyA7
         DJcRcTXPkUb6s6Mrp0rZYSXCxieglny39b6kmqb4Cr9wObwb4iaMNfsZSn0bWIKkkPYb
         pXBXhHUrs40SDhb7qn3ByyJyNQyaE7BB1GDdcKp+nDRya3QnYzD98mHus57jr467zCEz
         df2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nc/FRVHn/4Lw86zjiOeenz8vMlgyeo4rtZnqG40H4Fc=;
        b=tLzg/cDcf/PXwhizd3Rcfap2o7FQwCptRbhSVGpQNrbMBDXH4lqPklDHcpzzhIaNY9
         FvmzUyZiaAIQpHGJT9q3I7pRaGNI2J2sJzO1c81oUPsCREcLLVzrYaY7owkn3mGNZtPh
         rUTSjRYZE0K2/PAqz09yVwzki34wZY+Ow9WZwerUWAAu7+pF4Hp2vkxo0Td5K5+E1JaE
         16eyX/X/9CBHSqEHHioH/6wV10MYAc3vLdCpXx024NO3nDuaqbEMH345H12IJuTT1IJF
         AB/NwTmar1p3vwficsjz+xcZR7gV1JTjaCNObjwBpdsnK1qFFVGzlorQxCiwBbpojOxg
         AqbQ==
X-Gm-Message-State: APjAAAVNh5d8zOyOwDL1vjoPWPEuTlAWwGtE2iSK2TqASFH0ur03/Hpx
        AtJI7xmxLc+3/TXdxIWshN5QGIxT+9JGgw==
X-Google-Smtp-Source: APXvYqzLPYJ0v6f5ioy7dHRaZTBLhW98jJJ7ezreSI4U241QwkqbVeZgmz3PqjoYyBo32ipIDjjppQ==
X-Received: by 2002:a1c:5448:: with SMTP id p8mr13891810wmi.159.1580492155473;
        Fri, 31 Jan 2020 09:35:55 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c15sm12536470wrt.1.2020.01.31.09.35.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 09:35:54 -0800 (PST)
Message-ID: <5e34657a.1c69fb81.90d2d.8a93@mx.google.com>
Date:   Fri, 31 Jan 2020 09:35:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.169-33-ga3d2ee7a48e7
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 67 boots: 1 failed,
 61 passed with 5 offline (v4.14.169-33-ga3d2ee7a48e7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 67 boots: 1 failed, 61 passed with 5 offline (=
v4.14.169-33-ga3d2ee7a48e7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.169-33-ga3d2ee7a48e7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.169-33-ga3d2ee7a48e7/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.169-33-ga3d2ee7a48e7
Git Commit: a3d2ee7a48e78477fc9ad73102510602923091ae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 40 unique boards, 15 SoC families, 12 builds out of 159

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.169)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
