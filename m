Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708913E3F85
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 08:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhHIGJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 02:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhHIGJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 02:09:23 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4940C0613CF
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 23:09:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d17so15208360plr.12
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 23:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Pnp+NhaOyBaGU6MHe+xBDDVHOR17GqenKmtAoif40sM=;
        b=dIUgpfUXTIcL6sOEob1I36BUuQmd4JjHWGZMVKlCkW7olVaSYyhykDCMcK1ZrtdUL/
         7qruj/u3CfudyuGvjN7HL23Bw1hMJsIBSK8sCPQpVBnw6Wunm3UkOKlTPkAbNWQrax/c
         D0n1eKz8eYqydItiHVe0/7z78/39/jvs/12zkG74YvlCRHdkV8U/gDd4Wopxndbrkfw0
         7Eyl2+inQaa6O3O+++JLy2hJEhs61b5CtxR5BPTMFaq+g9/E7LDWRKD9yi/SXIUx297h
         8zuIy9RLeWR/WMOEY+1OK2TcEM7uT84gcuVGHequTRt7ys+CK9sncFVh2BIU3Qp02CgI
         RmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Pnp+NhaOyBaGU6MHe+xBDDVHOR17GqenKmtAoif40sM=;
        b=uUyd8os2ih4Ba+krXkWbrdTow/DAqRO0tTvaAnodIQPuWcsKyTEw+NfMkBDYhMS8jc
         H1TokmO61RpKClh06KBpp7Y4+Ur4D5YF1tY9DekwETCikHk/jVEoOXP+qbPcYqncflid
         qZ24FNhS0yTZBqeOhv6KiQjkqVy6OsAVGoAWlLPxtpLa0tJUL6O7QZBW5WCV3YMiDVbh
         owwvNaPDgOEVXa+PHYCXrgEabYJPGy1spPOHfVneCy8n51axU46WHR1RWZKzk4qzcz1J
         y15lbjcqJFSQ2WlueNRU8r7Sk3ejquxKKelgoCAyMREXJBqp+L1b6zVT1dHaJXXAk2+5
         NilQ==
X-Gm-Message-State: AOAM530OHBzZdyYOfdIAG9+wT0eHKUTOjqDobTsUg+Ob+WXgE8EwBW77
        MUWC0sjCi/kr/LvEGFy3GTfOr5qKei08Luvv
X-Google-Smtp-Source: ABdhPJwWxJQ4KFXtSBqjkswR+Lqsk7F7H9YKs4yo/N0NaUR106N56iKgPcDPTGfsQMNtsOVik/Yjrg==
X-Received: by 2002:a17:90b:3144:: with SMTP id ip4mr877702pjb.42.1628489339936;
        Sun, 08 Aug 2021 23:08:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm21175347pgs.23.2021.08.08.23.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 23:08:59 -0700 (PDT)
Message-ID: <6110c67b.1c69fb81.8eaeb.f43d@mx.google.com>
Date:   Sun, 08 Aug 2021 23:08:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.9-70-g402c62d4c96c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 132 runs,
 2 regressions (v5.13.9-70-g402c62d4c96c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 132 runs, 2 regressions (v5.13.9-70-g402c62d=
4c96c)

Regressions Summary
-------------------

platform         | arch  | lab     | compiler | defconfig          | regres=
sions
-----------------+-------+---------+----------+--------------------+-------=
-----
fsl-ls1028a-rdb  | arm64 | lab-nxp | gcc-8    | defconfig          | 1     =
     =

imx6ul-14x14-evk | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.9-70-g402c62d4c96c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.9-70-g402c62d4c96c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      402c62d4c96c8c5d4acff6063315190301bd41d7 =



Test Regressions
---------------- =



platform         | arch  | lab     | compiler | defconfig          | regres=
sions
-----------------+-------+---------+----------+--------------------+-------=
-----
fsl-ls1028a-rdb  | arm64 | lab-nxp | gcc-8    | defconfig          | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61108c2d35d65d1af8b13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-7=
0-g402c62d4c96c/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1028a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-7=
0-g402c62d4c96c/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1028a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61108c2d35d65d1af8b13=
666
        new failure (last pass: v5.13.8-35-g164564160b7b) =

 =



platform         | arch  | lab     | compiler | defconfig          | regres=
sions
-----------------+-------+---------+----------+--------------------+-------=
-----
imx6ul-14x14-evk | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6110925688158fa968b13677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-7=
0-g402c62d4c96c/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-7=
0-g402c62d4c96c/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6110925688158fa968b13=
678
        new failure (last pass: v5.13.8-35-g0d55d58934f9) =

 =20
