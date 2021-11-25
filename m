Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7867A45DA37
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 13:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349406AbhKYMpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 07:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351837AbhKYMnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 07:43:43 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46132C06175D
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 04:39:02 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id s137so5139277pgs.5
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 04:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EJzI2W5hvT0dWWrH6CT63ZmtEoT6/ZRx79M5jiq+sIc=;
        b=bRgSHX42LgKli02g3L6lrjddnbR5W/Z/qbysyBdUPC4GK8OalZsyP84uWWnYVHE2HS
         AMWCzBSIoBWYNRQugWIvmLy+YE4zTGBZXsexQe1IiAkDJvkIRiCJcoyLJopAYY3Sa0o7
         UpJgBYpSU0TTYcL6sYdRdCcB6NlKOC3QmjfFv9exflHw3gb8JmIUg5BgNPvvQ1sVwYc4
         LUnWnMBa8BxbPtTrwSx6IdbIUqKZkOlC87vGYHtbhLI5NwMTozlAQCahiLrptmcHfelO
         gefMsNvmqCcGdnUOe3tFEeF29qr5+vCqtGMbYm0xFd2eNfOJmT9TywDKqmblu+uBIUlG
         M2Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EJzI2W5hvT0dWWrH6CT63ZmtEoT6/ZRx79M5jiq+sIc=;
        b=HNB7PG43QldqRHZDLRFaq5lzK9gpViAZvWe8e4ciRSMClnP/Oi6w+5YPqSL7QVZf2L
         sapniVPEZtfgy5IpN3RWO2cEFB5A4DT8ybydXnOj326NvdJafGwC1RK0VjBsuYBjp1Rq
         niadWYDlPqklip5O6dU9+96pYlgW2B4YVmxtdoFaRhGNN/Ml40rz/8t7PoS1VqyOEZFK
         HHiOf59XbDNmP1Wxq00ylZSxbeTXeZYx3gx5Y544iH7oHDl975hB0sUpX6te2jifpvez
         gFgyfyp+ePQOYuUpn7PE8jlfjMrOKKqqMy8Qc733PCrVzfYdnTO7Vss7/xX6gSUwIUjS
         dZfg==
X-Gm-Message-State: AOAM532FrxAFgnApDJj6GwetSz8FTG7z0dgOr+T8QnExOlgrhP1aJyLZ
        lLvs26bqDgb5pRSX8LTR7uDQEPeOqdIM3p8Qq1o=
X-Google-Smtp-Source: ABdhPJxUU/Djuo0MwyA1PzmfugE7aMAExOrf1uCLftb6UsZqhYsq64sGGziAqgE7ifGJW6470/aVHg==
X-Received: by 2002:a65:6150:: with SMTP id o16mr16211890pgv.254.1637843941560;
        Thu, 25 Nov 2021 04:39:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm3445775pfh.86.2021.11.25.04.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 04:39:01 -0800 (PST)
Message-ID: <619f83e5.1c69fb81.fe81.8936@mx.google.com>
Date:   Thu, 25 Nov 2021 04:39:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.161-100-g6e3817ca165d
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 159 runs,
 1 regressions (v5.4.161-100-g6e3817ca165d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 159 runs, 1 regressions (v5.4.161-100-g6e3817=
ca165d)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
beaglebone-black | arm  | lab-cip | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.161-100-g6e3817ca165d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.161-100-g6e3817ca165d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6e3817ca165d17f53efc706e890778be87ded113 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
beaglebone-black | arm  | lab-cip | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/619f4e9cff0d4e0b8ff2efc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.161-1=
00-g6e3817ca165d/arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-=
black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.161-1=
00-g6e3817ca165d/arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-=
black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f4e9dff0d4e0b8ff2e=
fca
        new failure (last pass: v5.4.161-100-g849988eb3ff4) =

 =20
