Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D560346E53
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 01:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCXAra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 20:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbhCXAqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 20:46:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2A4C061763
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 17:46:35 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id l1so7021055plg.12
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 17:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Suc2OpTd3Va07dBz2aUQPFAjVw2j8BTeFBiZL7fBpTA=;
        b=a0+Ao6nlOBMzVUrckaOoi3gLWoGqoTpA6JWSCoKWGXZ16vfD0sfXVLuQcDYZQFRrrp
         KsUbdvzLVeb0g/2oli5PMkbWGKNuODH4NEcF/juJPmNd++lOF+j+oF9tpc/iSZscJXZn
         3yLmTKiip8sPRSAqBwPGfWq82Bf5dzK6HTANTlcdAVVmqS95qXNSdXLpoMei7Lai3koH
         G1ceofxvRe7Th7k64Il7uZITzCzXm+4TsiQ6jvEMc6QNBAvFz4sNEfKujuAcabsuayWw
         i6oYmwrIwrhcz+q66be3HPCNqPM8sPRqM43HSLatQfceqpoQ9DGs7IZaDPf3BUMm1egH
         W+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Suc2OpTd3Va07dBz2aUQPFAjVw2j8BTeFBiZL7fBpTA=;
        b=FLkPtaERmc5fERhzb8Ygr62Pl/DuDfHBnEEmZuqAFfm95Bawt7akPBIAqQumZjoqhK
         MLClhBEz85uimxNDnq9qD9EYg6efknqRf0Mpa4aoQlcy+JQbQYmjZng5G6ayS8wWn+Jp
         /VebBPqDIoQSz6jStszYeHbC3Qb47etd0MSlOKhqYM2Yl1kUYnlh5KiPMcT/V7egnDBt
         kxoxzx+OVJT/qB6GHfmTSflDZ9s1TaocJEZhg8SVxn7sywgBqoonTr8OM9GRlUOFcCK0
         Ul7cASqJzvjLPlAhNA+YxeqgMXg5Ib0TZGUtV/Ac+NF88dv5U/uTeTrY2C65pjUkRWID
         MXbA==
X-Gm-Message-State: AOAM533GxKE1Hv0SUW/1GnT8bWgr9IFUPaT+Zhq1O5e8/v3ZBGpiNXIC
        mhB45qPWsgA9vcVHXGSp7RbmHzAZND/PYw==
X-Google-Smtp-Source: ABdhPJzfECxkm7TFcj41s/oTb+sWkJO3mhXUeMBusUXoOcEL2urHVzxKvPlrxzp00geu3voOO2MgAw==
X-Received: by 2002:a17:90a:f40f:: with SMTP id ch15mr712614pjb.128.1616546794167;
        Tue, 23 Mar 2021 17:46:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v135sm325659pgb.82.2021.03.23.17.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 17:46:33 -0700 (PDT)
Message-ID: <605a8be9.1c69fb81.98877.17d2@mx.google.com>
Date:   Tue, 23 Mar 2021 17:46:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.107-61-g503b9575a1d97
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 169 runs,
 1 regressions (v5.4.107-61-g503b9575a1d97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 169 runs, 1 regressions (v5.4.107-61-g503b957=
5a1d97)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.107-61-g503b9575a1d97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.107-61-g503b9575a1d97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      503b9575a1d97f971cd767d74fd9f19e93e9865e =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/605a577e299c045215addcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-6=
1-g503b9575a1d97/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-6=
1-g503b9575a1d97/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605a577e299c045215add=
cd9
        failing since 123 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
