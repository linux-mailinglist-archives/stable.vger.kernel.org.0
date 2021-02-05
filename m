Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3AA311188
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhBESKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbhBESHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 13:07:06 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D7BC06174A
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 11:48:49 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id f63so5004936pfa.13
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 11:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pwW9z1O2rxcHslFvui/svyJEKXrQdPHKzk5UcWEOuCk=;
        b=OAySrovI32AjeJWqok/hmq2CCxVQocL57La7bp1+YWADxAnw3Ds4O/3eoPH8BkMwKl
         Dkx49AB+Mp4f0mzDgsW8q93XxhSaqoyP5IR8lMhV0OvD9j0cKwmHs0ZxHRAbBei4S5P/
         O04xLxvV7AxTSHCvnh/oEOvb/Bn0gcV0QHPKyO+qW6ldYEL+p4I46nfiRz97JH4XT15c
         TfKhISGY3scIroAoZZF3QjefK9nk1uMPB2ug67TZXAX8mcQNvodLubrVZk5sT4elWvLu
         KWHHkK6B3xA7v33go937pvwERyr4O4ue88Vew7I5JeNRKxap8UKP/ZJBAvb5ZMHV2+zv
         3Taw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pwW9z1O2rxcHslFvui/svyJEKXrQdPHKzk5UcWEOuCk=;
        b=dwj5vcHQZGjus+kcJ7u22La+jMCqfHpFHVLsvdDGo8pACETaYO6K2mkjZHymRpgNEo
         JXIv6in9kdSmnXa6uSRzzx2fecQ+qqImzDHyuMjPCfY0DMd1+05evvoHpik2H2cu38vN
         6s1ODRJ0QcbOzFQprdiWV1yyncGaRxfT30bgZPpBizd9iX+p0w0LEztnHSl7S7d7b68Y
         ZZWjzn7oNG29K8qkXcnvpuhANURFteBjzIv52IvgA9QVOnuz4qwqMyJA0UAk0S9+EnOg
         VE6GZbfm6NkU91EyMsksr5Px2kenvVZuktbRD1DYlHfd7+BwcDdsorfpJL7L0TguPDGD
         Vqsg==
X-Gm-Message-State: AOAM531msmtWoOsh9Ey/he9E5yqXXEq+uk4WGo+t25rxUzciOcKPj/Fy
        45XzN/r9qc6QuwZguY49hIIgktm2bV2uyQ==
X-Google-Smtp-Source: ABdhPJxduEbzaNF1PGMPbAsX5XHxqnBBVnJDlocVVtuppn0Ru8C6Mm4RMrq0AtClOvy0GcE+bju8kA==
X-Received: by 2002:a63:4644:: with SMTP id v4mr5904359pgk.440.1612554529084;
        Fri, 05 Feb 2021 11:48:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a37sm11373631pgm.79.2021.02.05.11.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 11:48:48 -0800 (PST)
Message-ID: <601da120.1c69fb81.8c092.825b@mx.google.com>
Date:   Fri, 05 Feb 2021 11:48:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.13-58-g58d18d6d116a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 161 runs,
 2 regressions (v5.10.13-58-g58d18d6d116a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 161 runs, 2 regressions (v5.10.13-58-g58d1=
8d6d116a)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig | 1      =
    =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.13-58-g58d18d6d116a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.13-58-g58d18d6d116a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      58d18d6d116af323f12152b2e84a9e859a6d52dd =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
imx8mp-evk          | arm64 | lab-nxp      | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/601d7006c3004d513a3abe87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
3-58-g58d18d6d116a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
3-58-g58d18d6d116a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d7006c3004d513a3ab=
e88
        new failure (last pass: v5.10.13-15-g62496af78642) =

 =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/601d706725e5d9d9233abe6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
3-58-g58d18d6d116a/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
3-58-g58d18d6d116a/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d706725e5d9d9233ab=
e6d
        new failure (last pass: v5.10.13-15-g62496af78642) =

 =20
