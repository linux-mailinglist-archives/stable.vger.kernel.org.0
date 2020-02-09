Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9FB4156A8E
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgBINKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:10:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44235 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbgBINKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:10:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id m16so4169453wrx.11
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 05:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+akR6CJFJqAy3WI41lw56slYwVIgEtVNi8mNV6ubze8=;
        b=q6F24R9Zny2YLmYmziMejG2lJ/L9RVnkPnuGbS4waYSUnfmH1qOIKVWdsg5tWJuVLJ
         +ek2Xj6mk1uKMimpd66zBsd4txjjmS8gJV2TaiQkcHdnqXccgaorHxFhIE3XULA6azIv
         cEpPjiyc9kQIlVln2G0OwakD1cx5m34NRCRdu8HzIhjeC092Cyi40nXdU80oi7XpG3H0
         FEIWlwJCPLh+qIcDTMQbZHkMYHT+6e4lE5yisiQT/Y42N7xKG64yR4gQnU3xgwsA/HiP
         n6prMzY/HRsGdGGhbc+A/TX2B2lv2iFIdhVVn3s9P9WUdOjeSDVAqw6Hx3NoLYI+/4Mv
         0PZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+akR6CJFJqAy3WI41lw56slYwVIgEtVNi8mNV6ubze8=;
        b=Lyh4xCOAIWKzdvhIqnkQZw0/XX87bfTdSz9q+jF3OxwMlbifqAzElRhE1aGMXuQ9BH
         BFhbyjeKDJ5qnAeE6gsS4lLl5h2TSRGAwNRkWnlTJiwmrwvKOE91yAwi+s6RdxSORrmd
         KfZzxcaYj+9B3Q8+GUbwkxObSK4I7UkvqHad6Lq0wHe9VSpJI1oLuJ8ArDuWfD61xihp
         06hdyCLBsgfamovZNlaZSE5iHtN5TLxAO5bnoAunxCQC3XZOf4zQjuxoz08KpqfZMDGo
         t4o5OcB0/VIPSY/4+oaeWKWMqhoqYu0Auge1UDworbR1DBTUKlqrGVrahHV/uFe4zgAC
         OdRg==
X-Gm-Message-State: APjAAAX+R1A+poGaNwKKNDRcdRxIHahYeuHSjjXzSI8lMKFisu3V/+dU
        lYLaq6brABSJJ6ahYxm3A1xSLoDhqqE=
X-Google-Smtp-Source: APXvYqwV0fKykqRwVXIxQPsUD9uKuNPhBgWfYiskaL/kwccuhHoQeoWxLIxjUBdyg90sDgz5tn0RvA==
X-Received: by 2002:adf:b193:: with SMTP id q19mr11109969wra.78.1581253831677;
        Sun, 09 Feb 2020 05:10:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g17sm1884826wru.13.2020.02.09.05.10.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 05:10:31 -0800 (PST)
Message-ID: <5e4004c7.1c69fb81.1a3c4.7425@mx.google.com>
Date:   Sun, 09 Feb 2020 05:10:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.170-68-gda3078f1bb35
Subject: stable-rc/linux-4.14.y boot: 67 boots: 1 failed,
 60 passed with 4 offline, 2 untried/unknown (v4.14.170-68-gda3078f1bb35)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 67 boots: 1 failed, 60 passed with 4 offline, =
2 untried/unknown (v4.14.170-68-gda3078f1bb35)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.170-68-gda3078f1bb35/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.170-68-gda3078f1bb35/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.170-68-gda3078f1bb35
Git Commit: da3078f1bb3529d949184f5a93e5266e87c5cf45
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 17 SoC families, 13 builds out of 165

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.14.169-92-gb4137330c=
582)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.14.170-62-gd6856e4a2=
c23)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
69-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
