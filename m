Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B9F4706DD
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 18:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhLJRWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 12:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbhLJRWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 12:22:40 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D6BC061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 09:19:05 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id q17so6676890plr.11
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 09:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NWDU0nMdQVbn8JAqTmM4+nhf8HAnL3cCpS0XM9FgwzU=;
        b=FkmxY5R0uEfEDYDkLetspdewu31uiboxfZv6aPFmekHQ1kGmD7dSTGDGeiVVOZLqcC
         kFCCBieTrxpQga2ycjlB0mz25OSaPpjXTjt603Yqojt/D+Q/uMK25F8vXG+yH9+w8IoO
         BPGE08FuDpFAmpZz/91bQjqBV24c1CEDavD37sozcdiqp0QdxDlrOeuRg1R2IBwh8g6d
         7oWidyS+FRPF2xi7QR6PCOPv3JpoL7AEbiXRgzhGRKQjcCPRWZ0NtVgCMfSK2BU87nTJ
         aHVR6JjAY4aZRSAozaI7gHnDSzD8MQdAjwIeV5UkTefIvgOH3jSI5NueW85oevA80ndQ
         7SMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NWDU0nMdQVbn8JAqTmM4+nhf8HAnL3cCpS0XM9FgwzU=;
        b=Ia05cl/o3MSIEjScnqkAlFF3rDbgORwZJQ7TMRBT40N1LMqYZjFqhaFvOH1UL4j0Iv
         Adue8BK/aW34auHhnJzhSWDptUbkcnkTZvPY34WMcRJ6VTuUcIAgBMIyTd/JzR2DSACm
         /RBA87U76Qwe4np9VHzbCzaQ1ZthFfMDl2EfoFLfRDV+AOALe+vxgSyzzCjFw8mO1TNa
         jOOnQxg/DNij6X4vpceQLF0qrG6jYpsVfgX2sQFaqXYUkfzpfMy3JxKbiGz5/kWEVtHn
         PLo623jSez4nnfAvgPAst9cu6AMdkYSaS6dWhX8sA5M20dtRLhAM50hLGoianvOn0FYt
         +a3g==
X-Gm-Message-State: AOAM533RAnzHcr1AmixkhmdNrpoL94PPUfFRou2jBVKQW4e889Ya8htP
        Lk52SHc7QqCsLnaqjwsldNMNWGfG4NLfiLBG
X-Google-Smtp-Source: ABdhPJznvWNTgdqJFGzJSFrhaRLyLaAONcxIfe9UOm0o0vYbXClbxc3p6g0bcpKigLECP2dCnk3ujg==
X-Received: by 2002:a17:90b:3890:: with SMTP id mu16mr25780189pjb.73.1639156744678;
        Fri, 10 Dec 2021 09:19:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p20sm3670249pfw.96.2021.12.10.09.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:19:04 -0800 (PST)
Message-ID: <61b38c08.1c69fb81.a4b84.b30a@mx.google.com>
Date:   Fri, 10 Dec 2021 09:19:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.7
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 204 runs, 2 regressions (v5.15.7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 204 runs, 2 regressions (v5.15.7)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e8c680af6d51ba9315e31bd4f7599e080561a2d =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b35289d1ec46d89039717f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b35289d1ec46d890397=
180
        new failure (last pass: v5.15.5) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61b35492b4990a3a48397142

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E=
3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E=
3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b35492b4990a3a48397=
143
        new failure (last pass: v5.15.6) =

 =20
