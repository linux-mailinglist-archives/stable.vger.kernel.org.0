Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6536A1CBB5E
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 01:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEHXqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 19:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgEHXqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 19:46:35 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF24C061A0C
        for <stable@vger.kernel.org>; Fri,  8 May 2020 16:46:35 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j21so1601680pgb.7
        for <stable@vger.kernel.org>; Fri, 08 May 2020 16:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tZ6hgdG53wnvNpfraUGTaSGPdLMMlBKpB/QyjLM2JqY=;
        b=cx0wADVyjnM8kqLSX6kuq+uzBnCE3bpzqB0Asegnsu4J91oQKfq4CsDbYLT4z8B25n
         7cM7RaPtSi+vhmcu83xpx4bpO2e8df1clzRjv082UJmjg4NfsoROVdUWEqPQAgDF+Z97
         icnb+7/yXP73hlmBOU/hBm1EmmNrc5i2gga/kJCKWBnQo05H/DmBSV03Iz+eQahpWXYZ
         oQpFKn896/kdNfqrBSHI1LVn3dXNLbV5VjnWXDzVmF6f6RwxOyaTex+GjRDhVRUwZIep
         me0UI/57RqW8hWwKuyy3UWvelvN9koz63FqxbcIz3mi7aE2WoUPsWfcWNHKtqb2UbKwV
         4y2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tZ6hgdG53wnvNpfraUGTaSGPdLMMlBKpB/QyjLM2JqY=;
        b=GqShFu5P6a0qBhV21jFfHO8U5I0StAN+qZfQfm4PRFe6hrFSaCokw5SUoXdsCfufdg
         vI7JIO0o6QrvKRbCPK86rAyxZCA95l30RfiwnGNa+WbNL0IDwh7CyF9dGkdXNxigctp8
         FAHt8DnDWSgClLmR7Wvh+HJ+g52J0S7U9bM4DA3dHlQIolIflp1RjjvrrpqNeW6v58ZQ
         gAzmpBtDp4y+mcuY3dJTCh/2C1au+xaMaUyPyMssYiSThSpiHcyAhHW9l8xyR8CrcRCw
         5it3M/9wHb9nsnRj7Ur3BC5LFflvfwNDqgwcGnLa5bLM2qR04LlzDVqVB21BOtInLJwA
         ccvw==
X-Gm-Message-State: AGi0Pua8k/WRv4N7kx+Sopmr/StOR33QO8I62Z4yHPfSUVer5baiWwSs
        wt5VTygXzg2dQmqAmp7pnXdXwglGCMQ=
X-Google-Smtp-Source: APiQypLgw1R85dm9c3VEgsbUkYHqlsmY/s139V7UWxDKk9sMHcJaC84SxgUFdEwtrtcmgVxeMr40Sg==
X-Received: by 2002:a63:bd42:: with SMTP id d2mr4067643pgp.214.1588981594723;
        Fri, 08 May 2020 16:46:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 207sm2175737pgh.34.2020.05.08.16.46.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 16:46:33 -0700 (PDT)
Message-ID: <5eb5ef59.1c69fb81.69759.8fb4@mx.google.com>
Date:   Fri, 08 May 2020 16:46:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.39-50-g695621e78832
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 148 boots: 0 failed,
 138 passed with 5 offline, 5 untried/unknown (v5.4.39-50-g695621e78832)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 148 boots: 0 failed, 138 passed with 5 offline,=
 5 untried/unknown (v5.4.39-50-g695621e78832)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.39-50-g695621e78832/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.39-50-g695621e78832/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.39-50-g695621e78832
Git Commit: 695621e788325e527588a26f1a9c6c526b69a2ee
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 92 unique boards, 24 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 90 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
