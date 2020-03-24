Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D366919054C
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 06:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgCXFoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 01:44:24 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38997 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgCXFoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 01:44:23 -0400
Received: by mail-pj1-f66.google.com with SMTP id ck23so926635pjb.4
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 22:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o+niWoA04XI9xWqRmDdh04x94/Ii6bmwSjjpH2bn9WA=;
        b=nd8RoASczLD6qYEXR1b9A2AyEuvtPeD/YVRF4CcXI6bXrd8BSul4F2VClbUgeM7Ko3
         M+suRpZNHh2gglyXpfVbbNQXyD0Tj9C7Z09iskrYjXise95ZKoWXelDrQFji2v/Z7F75
         uNF6JDRr3/3P8nbXJhIXsWJ8PL7EBNjRN3B7OM3GsFUocfQ95FR5YaHQMF8ouK1W6WqM
         T0iyC4K3fPvjkGsVDW96xA8uI+KyNiL9VK3xqE+3AaaeogxvkT840I7xrAmIzDWlADpd
         a4rSf/1Dfy43ryI2XlVrH33fhfVWKaKPicsHzDMuUuoHu1tPt1SyYpId1vESnYTbLbYM
         +eeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o+niWoA04XI9xWqRmDdh04x94/Ii6bmwSjjpH2bn9WA=;
        b=LK30EnYJwAHYNJa6cxP7HK0iIcUe0OruCZPQ9hvkEgANa9LxOy1UvtahEC2F1/lZYj
         fs3C1T6p65/NyYVYfSY1vFvQ+yuuOEQHjnWnaYWV6DSlSTCFiYv5WG0mYWq8lado2AkO
         1OdfoJ3dvx7R63fsk/vNA258qIjpc25uty2JGHPYPDDoJ5ZMqpmxB21qEbDbDB9vMSyQ
         bkkG0evFq1+uNZxe6HsIOfWWpcJ2MVxwLKLaIvJk4Z+hfpMLCS1oX9GcQTtU+3DY+XRA
         TrlYONATNL0PWD2WCgcq1+pNhbLIf5f2ovFH1d5WxLDnRp0yuFcKLdqz2LVUKRcbgtku
         nRCQ==
X-Gm-Message-State: ANhLgQ0jSC3kIOIkJFOKuHcLRDQg4uHKG2osE5h+vqz3W4Knb4sbZeHN
        MkFgpmCdDzgfsdtpq4MWzljAcjmTec8=
X-Google-Smtp-Source: ADFU+vvl/yqpKDwZRJWd9deSvkUGmus2xfO6bfmjyB0qNHWLn+vYibM58Mw0mL8NFwv7oUjLINSAWQ==
X-Received: by 2002:a17:90a:20ad:: with SMTP id f42mr3198896pjg.135.1585028662439;
        Mon, 23 Mar 2020 22:44:22 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u14sm991974pfh.220.2020.03.23.22.44.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 22:44:20 -0700 (PDT)
Message-ID: <5e799e34.1c69fb81.83ff3.69bb@mx.google.com>
Date:   Mon, 23 Mar 2020 22:44:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.216-122-g1fabd1dda010
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 87 boots: 1 failed,
 80 passed with 4 offline, 2 untried/unknown (v4.9.216-122-g1fabd1dda010)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 87 boots: 1 failed, 80 passed with 4 offline, 2=
 untried/unknown (v4.9.216-122-g1fabd1dda010)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.216-122-g1fabd1dda010/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.216-122-g1fabd1dda010/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.216-122-g1fabd1dda010
Git Commit: 1fabd1dda01059b560430363e4e4f994ea782303
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 18 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-119-gd=
e70109aa333)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 44 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-119-gd=
e70109aa333)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
