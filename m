Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D9A1AD2C1
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 00:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgDPWTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 18:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728221AbgDPWTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 18:19:55 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E36C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 15:19:55 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 2so73183pgp.11
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 15:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hBe+ejNKRwQ7ffLUUcILS3/27WhAaURaKo2CQPO6xUk=;
        b=ftrl/VB5Jx4y2AfZX1OnDu1ldBnLycwQnfIXhL4NIPOqhIEFNC6/Rdij3DrjeyObu9
         +F6vWMPD5a2RPbCNESz4vhdQs0OV6bTIsnNKyeJvBkioiLHXlfSFEsiT3yJ2H8uFsJKu
         3ClqkANohTOenuYn74IXL6EsxRfZhcIAXMCfhjaNqXIZOGgJrfbCH19SBCIISSavARPa
         RfwHak851FJs/EixAz1uHj9CFCXrbe3LmcJUOZILAdnXBEL1o8wGHvsENeR+zGy2I3lm
         MdHJ/3ZXJ9FfTXZQchzraUH4EpdaUc1ThQqPGEOWChmi4AHWAoOpbDBeorlGImmjNEOq
         BIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hBe+ejNKRwQ7ffLUUcILS3/27WhAaURaKo2CQPO6xUk=;
        b=JR9AhWmi1Xie7JKej+5B7UTNL6XHYZ5rwh9nB3KRyWqjpxrDGbDNrol2lIA0Abx7nf
         AfvEaF6bSUsQMsRwRv+Viey1WLdYqn1lxy4jMP7HmDixFOPooEXqGMuI1yIktS/yczb9
         rNfLUsjxApDe8suwYv4w4ziTdVYhcmHcIi5TOTavYyu4vjg1AUoQGRRVEHk2PxFToGfo
         sMl72m0C3gVB4+qAegeLN/GxO1kFad3BY5xSDNc3XrC+BdxYAORxQPdoo8TlSRLhioaf
         6fm1Wn7Kjxa/OS5TAXlU/KSEnuWiBMN2jiZI2F07EZiEcjpDi911a0q0YF9+w8s+jvKx
         1eZw==
X-Gm-Message-State: AGi0PuaBhzI1RTgcglyv/waxf/ywU0rSNa6s/6lS7OhSlu9tQZSm2N6t
        a2jTBwQtRJwzei+1KjwuDpE1HezdEyw=
X-Google-Smtp-Source: APiQypJ/nZcgr76YxirBR5IxfBSVSLt5PvvCfHZhwe/44AEB2ABayg6ibvkNP+UCGbkSkJuy4U38Yw==
X-Received: by 2002:aa7:8281:: with SMTP id s1mr32432744pfm.265.1587075594352;
        Thu, 16 Apr 2020 15:19:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a1sm17724751pfi.182.2020.04.16.15.19.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 15:19:53 -0700 (PDT)
Message-ID: <5e98da09.1c69fb81.9b3ba.dfaa@mx.google.com>
Date:   Thu, 16 Apr 2020 15:19:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218-99-g98ed4696ba7e
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 113 boots: 2 failed,
 104 passed with 2 offline, 5 untried/unknown (v4.9.218-99-g98ed4696ba7e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 113 boots: 2 failed, 104 passed with 2 offline,=
 5 untried/unknown (v4.9.218-99-g98ed4696ba7e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218-99-g98ed4696ba7e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218-99-g98ed4696ba7e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218-99-g98ed4696ba7e
Git Commit: 98ed4696ba7e03a240c553206551dcdca4bfaf4f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 68 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
