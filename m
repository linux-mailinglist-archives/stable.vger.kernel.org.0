Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45043659A48
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 17:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiL3QBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 11:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbiL3QA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 11:00:58 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1125FEF
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 08:00:56 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id 17so22318335pll.0
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 08:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=czl74uK+zpLc1dynaDMGW+IFMXqI31hiWfW5gVpLb0I=;
        b=vg+vQL9DCZnY8w8Pel9PPwXsqkB5kSfIFRI8fHFq1NZz847chA/MQB1B8Qozqm7LDQ
         7bbMMk8/ZAWLV3rRGS4sM9yHfscPkG/Ool708Mgw2oRXSd1DVumJRNggkQjQqhJ9ukla
         WoYWq//3ntPZJ9/jb5zsLBOXruGngtLg4TcKC5M2Q/sMqH5soekIf5vqCOMRg5zAEA5H
         ycWl7k3a+PJOWTnwfk5GKreLNE/9wWl3qqulIAS9HW1c372aI62QXb20A95e3z0FgFyQ
         VSfGKkgd4AyOD5jOW8GWTd3g8KXMBSqFOEuuSgXDc0wejOyycO/mGcMwqyAOjSFmbH6M
         Rj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=czl74uK+zpLc1dynaDMGW+IFMXqI31hiWfW5gVpLb0I=;
        b=itHg1Pga+4P95jmlK2WKbsy02xRij8x+v9b0ZRfX+fqNRNEUbemv5u44lztBIFqYXl
         XwNGLgtTZAB5JYPiMqQWbEvzs6FCTRpgLIiYX2rUvDO4Sh8DHPDeoEzB9lqN+qjV7ST1
         nI5c8gIZ4WNY4OUg4dLHKxU9Q3fXsDpx8ZexdhXBXufay0avhUGoyPMUh0v/PF/IhBHj
         gCTjbJBk8MVodwalWAv5nQ1ihPig7oq7H0BW5hjKUkAhy/id16kncJrXrnw2uVyEWJIG
         6sbhTAhNS75kacUZinK6NAQgzriVLELx3ucdQNV/RQTHIK3zYBgJR4kr/2jern11FfoC
         xyBw==
X-Gm-Message-State: AFqh2krdPYnBcX8V5Bjy2sLZqzrMqiXcZe0yBE24oHjb/R8HnLd97kYw
        XNB26dVWrQwGgmutt+oc5idDe3q42DjXnC9B5Yg=
X-Google-Smtp-Source: AMrXdXtlLOaxZmCSdE6oHLjZvMS0cwUppzxdd8DnPAOwEANBfi4k2JYb0Az03nkkRpvyz1C5G7NIhA==
X-Received: by 2002:a17:902:f254:b0:190:f5be:89cb with SMTP id j20-20020a170902f25400b00190f5be89cbmr27981742plc.20.1672416056103;
        Fri, 30 Dec 2022 08:00:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902710900b001869efb722csm15095686pll.215.2022.12.30.08.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 08:00:55 -0800 (PST)
Message-ID: <63af0b37.170a0220.f0a41.9455@mx.google.com>
Date:   Fri, 30 Dec 2022 08:00:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.161-575-g1e5df46609293
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 128 runs,
 2 regressions (v5.10.161-575-g1e5df46609293)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 128 runs, 2 regressions (v5.10.161-575-g1e=
5df46609293)

Regressions Summary
-------------------

platform          | arch | lab         | compiler | defconfig          | re=
gressions
------------------+------+-------------+----------+--------------------+---=
---------
at91sam9g20ek     | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1 =
         =

r8a7743-iwg20d-q7 | arm  | lab-cip     | gcc-10   | shmobile_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.161-575-g1e5df46609293/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.161-575-g1e5df46609293
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e5df466092934adb3b29631fe2588f31e321a96 =



Test Regressions
---------------- =



platform          | arch | lab         | compiler | defconfig          | re=
gressions
------------------+------+-------------+----------+--------------------+---=
---------
at91sam9g20ek     | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63aed98fc30e0dd8d44eee2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61-575-g1e5df46609293/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at=
91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61-575-g1e5df46609293/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at=
91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63aed98fc30e0dd8d44ee=
e2e
        new failure (last pass: v5.10.161-575-g2bd054a0af64) =

 =



platform          | arch | lab         | compiler | defconfig          | re=
gressions
------------------+------+-------------+----------+--------------------+---=
---------
r8a7743-iwg20d-q7 | arm  | lab-cip     | gcc-10   | shmobile_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63aed55b6681a3837a4eee3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61-575-g1e5df46609293/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61-575-g1e5df46609293/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63aed55b6681a3837a4ee=
e40
        failing since 1 day (last pass: v5.10.161-561-g6081b6cc6ce7, first =
fail: v5.10.161-575-g2bd054a0af64) =

 =20
