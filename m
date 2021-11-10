Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106F044CA0F
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 21:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhKJUIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 15:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhKJUIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 15:08:10 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621F3C061764
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 12:05:22 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so2600661pju.3
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 12:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oIQSOoxs9HYURg/6h9TyKD7e7CMWt47Tp/4wVSl8fXI=;
        b=kTnmPulA3dxPg7FEkEsoSdYmPI8V3+28H/2HbLdotSjn8fI5EWL6s/xcXuYDnga0/0
         6+e2SivJsca3PhFHGentwjApT+nYVR7j+ppekgijeyuStkIv7Oxu0RCsITQJ/r+4zDH3
         5KQRwel2EHhOPyhzdY76D4y5BYMbzu2O0VYESxehdnX8Z3HfirNyi+X7TF2n8/LveDAb
         KXatIW+p44tHmDdcnI457jA70ipE1dCn6dZ/y3S47TCWltVRWyeE1GslDbT+OB4fKuvm
         AiQPq395YHqZ1H0nAcWc4fQYCCfy3pUWslAwbZDv0n0iu6jX9RvVqvhUL1yfoztfopcB
         2JNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oIQSOoxs9HYURg/6h9TyKD7e7CMWt47Tp/4wVSl8fXI=;
        b=UC3u3ZBJbGQTYSxDspF0Ijq/42CXPqyHo9dNIFGYmX1BAJ5fpA6U3uT2AlZYec5zbH
         NrWLjqA1G0p63kYGpRyNuPA/P9eAtMIi+b49OCqNJ+thbdQuq44mJjEIR91eLm3ZAfJp
         8zkyCEb2BlfbVXTO2r2u5W02fegnsRNH6F2fLu0HPkJbdV/Vp+LqdvfzihenxlF8Bu0w
         URCYVXFwpB4gEWyO2LMLc5GaXgbPwYG+SwKCVbhrwcWioufqH3GEtHQvp8J4jsPq0B8l
         KD9jW1hlAPsEBwzdo5NSCVV6mGcXZWnfdVQEZTOmemkJVECoE5sPVDCxZqyxUJlzwNhg
         3MfA==
X-Gm-Message-State: AOAM532/TRvGXHloc2pBFEk3EiSVceqorvKp1HG3rMRkohPO++1VWeQd
        3xVhaX3Uwn9N+ujZvXgqN4mUxMAX5HoXzxnUQQI=
X-Google-Smtp-Source: ABdhPJxXPviYPpUz6YoVyZa3rm/IvV9Dc62aiTVRQmVZDne8t1KWE7JhPuPpqGvbzr2A0iL1PXsZVA==
X-Received: by 2002:a17:90b:124d:: with SMTP id gx13mr19981185pjb.106.1636574721734;
        Wed, 10 Nov 2021 12:05:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id hg4sm6357514pjb.1.2021.11.10.12.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 12:05:21 -0800 (PST)
Message-ID: <618c2601.1c69fb81.5a77d.3d49@mx.google.com>
Date:   Wed, 10 Nov 2021 12:05:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.158-7-gae53c49d452f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 192 runs,
 2 regressions (v5.4.158-7-gae53c49d452f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 192 runs, 2 regressions (v5.4.158-7-gae53c49d=
452f)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.158-7-gae53c49d452f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.158-7-gae53c49d452f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae53c49d452fd1353e3b4e47eae2b7398b24d3e1 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/618bea7ac4cbc6039c3358f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.158-7=
-gae53c49d452f/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.158-7=
-gae53c49d452f/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618bea7ac4cbc6039c335=
8f6
        failing since 0 day (last pass: v5.4.158-7-g3d2f6a19f136, first fai=
l: v5.4.158-7-g478246ff3db2) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/618bed696be51976f13358fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.158-7=
-gae53c49d452f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.158-7=
-gae53c49d452f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618bed696be51976f1335=
8fd
        new failure (last pass: v5.4.158-6-g899198caf534) =

 =20
