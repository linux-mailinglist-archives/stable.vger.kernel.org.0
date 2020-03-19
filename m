Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E35018C0A0
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 20:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgCSTnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 15:43:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33237 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgCSTnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 15:43:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id n7so1984983pfn.0
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 12:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mJ9kmLtyXQgRg6v5IscF5E49nGtv2Slwbq/3FJrMUos=;
        b=A9aHzeHWz6wT7Yk7uh7LljBO85cMwXRdfTFXRGANYeqKWFb4RiI0tvC1GkxTfM3yH4
         igcY98OqahZ9j/VupDTVGPS8eOsKmOVorIcPqk7W/gl9LkN9GZyjofxjObbHs/k6E4BL
         idxBofg8H342N9MmNPLDaVIfY+7X3ieCOZfKsFDNOmxi7StoIcnMUkqKD+ppHL2dTQVV
         EB5fgq0zO1JRNuKSuYZNin/2DTfet54MMJ9Utgy01yWUZSp553aOy/6viQQ+DTMPlsLr
         Qcidb3wQ59aQEc7GVih6N4ie2+53povn1kLk5m4IlADyvY3L3nuWY+XP3xEcUwV+a9l3
         l/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mJ9kmLtyXQgRg6v5IscF5E49nGtv2Slwbq/3FJrMUos=;
        b=CPUCzEirwaN/M+ZF74mvciXJR44AofPsREWcUyWrOwGYOMVpHsHkRfbqa9uRDxqHGJ
         EZj0AtnqcCX/2XVGSHrCed67G+R4ji7URIJrx4W7zFNugzYM/ajwhXOp+3uskWzNzdEm
         rWznbNp/66DNAdi9haTb1nTYOt5QIZkeWybq9bXHf07SqQ1wvREjrLXRb8BEfYKgPDOd
         oMeay3qX9vQI6QhbSuDBX1nXCI3iJH9/GV5MJXGM7K8VXqPZJ3lUWo14OeSTXl0r+qnu
         t0c2+3b7pikIe54NJOIGkmSZlKme5LcexngaIY5lPayMfuINzCusfzDvAuOQgK9+HCeN
         /5FQ==
X-Gm-Message-State: ANhLgQ2O5gZG9OTQbsQIQtNlCTa3Ui1gKSRLS+YRLP7B+47V2sIjL3Bn
        BuXBZTTSSz9wwfmyXdcGnfyadKJ03Uw=
X-Google-Smtp-Source: ADFU+vsZmoByknC72MHIWwb07f/j6Cx3fRsXpxuzMH7llgrWWL0sVe4W+cf2wqjLk/7CostIZuAe6A==
X-Received: by 2002:a63:7b4e:: with SMTP id k14mr4811025pgn.434.1584646982913;
        Thu, 19 Mar 2020 12:43:02 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b25sm3223866pfp.201.2020.03.19.12.43.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 12:43:02 -0700 (PDT)
Message-ID: <5e73cb46.1c69fb81.27019.bae8@mx.google.com>
Date:   Thu, 19 Mar 2020 12:43:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.25-185-g83dc55fe972f
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 163 boots: 2 failed,
 153 passed with 3 offline, 5 untried/unknown (v5.4.25-185-g83dc55fe972f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 163 boots: 2 failed, 153 passed with 3 offline,=
 5 untried/unknown (v5.4.25-185-g83dc55fe972f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.25-185-g83dc55fe972f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.25-185-g83dc55fe972f/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.25-185-g83dc55fe972f
Git Commit: 83dc55fe972f75439532a43662ebe1f730fb6460
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 99 unique boards, 25 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 40 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 3 days (last pass: v5.4.25 - firs=
t fail: v5.4.25-58-gc72f49ecd87b)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.25-124-gbd=
9158ff941e)
          rk3399-puma-haikou:
              lab-theobroma-systems: new failure (last pass: v5.4.25-124-gb=
d9158ff941e)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-puma-haikou: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
