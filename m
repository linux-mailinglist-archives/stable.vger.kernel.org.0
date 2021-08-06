Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAC53E2CE5
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241602AbhHFOos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbhHFOon (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 10:44:43 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFB0C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 07:44:27 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d17so7334826plr.12
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 07:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WH8UVSusZB2q+PkM6MIQG7RhZ1yeU3KXOQ1QG/kBtCk=;
        b=yqe5elNJ9LmNxaz8STuA1FVkmuD5sC3zBI6WkzZzeurR600ptLKKrM7N9UD6fiFVVv
         9eU3IftbO+ZMywJdrYFv/or9XPMMsMcFzPcN6I5y6VYP6Q9nyyJPRqYQwoCVHE8U1agu
         onjc6JmkHc1PQjbSTA2Oyjx/w+kOOVdAT+RbonfJa/sLfHVPYKkaUKEXXFQ/RS6Xx80Y
         d+Elvbyel/gtBHwoP9IKYn+kUkpg6KHFsf28OI6kdqKPZgz2GG4HBO9GI/urMpqknTpL
         AtfP1WGY9oGpJgF5jX/LQSMer9dX+yDHfV2V7wcG4ZTUMAi0p8hUgxoPNN/KPnOMaFw1
         hpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WH8UVSusZB2q+PkM6MIQG7RhZ1yeU3KXOQ1QG/kBtCk=;
        b=o6vka9h51tAoy4FCyVO8mcmGnYc1Io/oMEvGGBqNa6uwr+lqbAGFJLaadFDMpUN+r8
         tYQVAe6x9HgmNDHzmiPzvJUPFNcWw2a+gx3babi1ru6yeeaOQdKDdT8ePNrtmAOC9G+X
         8CqhKZeEu+Y34Zu7AZWPcrFaxOjfCFbtuEupAa73mV4XOxH3NiycAWqFJx2omb8pGz9k
         UAg5TA4B9F/IuGJV36z68f1VAvdLQV0GeZGgV/lqPCTQBM1g6kVKp/P1v4H+Wz0Dn2RE
         76EogGc28lQ8Iw3E165ZPLg4R+7LB4ERYI2zmfTWyE7/Hg20hohJSainlm0uACltvxUF
         TJyw==
X-Gm-Message-State: AOAM531wWFAmdMhVuELrcwywc6XlF8KlHW0ZBaB5ZXvUa5TK4asC+Tuy
        6hs0K9wrF9xoLphWPmG6XYoARIM+uggztA==
X-Google-Smtp-Source: ABdhPJwVmy/YUHjyiYJP5lRRHnPD8fAXmI1R6UHS3WkxDAq1OGQZWLD+fmJUlMw48dKVIOo8sngKlw==
X-Received: by 2002:a17:90a:c506:: with SMTP id k6mr21249398pjt.198.1628261066168;
        Fri, 06 Aug 2021 07:44:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s36sm13091711pgk.64.2021.08.06.07.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 07:44:25 -0700 (PDT)
Message-ID: <610d4ac9.1c69fb81.7c329.57cd@mx.google.com>
Date:   Fri, 06 Aug 2021 07:44:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.138-23-ge3ae776a76c3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 112 runs,
 2 regressions (v5.4.138-23-ge3ae776a76c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 112 runs, 2 regressions (v5.4.138-23-ge3ae776=
a76c3)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6qp-sabresd   | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1     =
     =

imx6ul-14x14-evk | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.138-23-ge3ae776a76c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.138-23-ge3ae776a76c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3ae776a76c326b5dcbe2b5a4b296444a71b12a8 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6qp-sabresd   | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/610d15c5a330c23b25b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.138-2=
3-ge3ae776a76c3/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabre=
sd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.138-2=
3-ge3ae776a76c3/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabre=
sd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d15c5a330c23b25b13=
663
        new failure (last pass: v5.4.138-14-ge260fd2fcbfb) =

 =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/610d15c9f1b92b6c09b1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.138-2=
3-ge3ae776a76c3/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.138-2=
3-ge3ae776a76c3/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d15c9f1b92b6c09b13=
66e
        new failure (last pass: v5.4.138-14-ge260fd2fcbfb) =

 =20
