Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A66588BC6
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 14:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbiHCMHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 08:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiHCMHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 08:07:01 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214E0C0C
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 05:07:01 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 77so180709pgb.0
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 05:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4vdXhxcTTr2n1/W6nB3bJaXSQndANAlYEVyRcFJ4go8=;
        b=EM2tyARv9hSZxem5UqRXO9o0jlEJFmwnljIwQlUnrE3v4oIrK0kSYALIVwCFcLy7MN
         HQygbf3+rRv/YF42T1SMVwaJngRebyW5YZqRpVqPAq5eshhyKL8Ix4VJk9J1PHkY7mMb
         QBQzLahw9XtI5Bp4k708+CcQ85n2VnHCaWxkpscxvQWR8ZVdbSmBXm5PvVPIDHSVlmrG
         4wnTJ0AniRBI4WCS1f2Hwx5DTQILUBeFTs2ZcR9OCj1Y135dJAclbSIVXOkN/J2K0qGy
         wQK+U0C5u5UOR4EYHiEC/P8MsWYCzm2vAcoYceUzCC2DroulSie8RI0+4MmwZoASkvzR
         AVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4vdXhxcTTr2n1/W6nB3bJaXSQndANAlYEVyRcFJ4go8=;
        b=sZEh5/ROYHudpsT6W4FCuoUzivz6eO4vSux8JQU8dzFzVP4niyyTXW1YjCpKsEgxnS
         NeEBYWPqgCrvbbPqQFojNX4drG58Z7j3fOsu98/+7lCecCsb57dHp7nixEMGZ3Z1nA9+
         f1Jb3W+ysfDuAyYwAXEiXjRCcQ2E/8XiTLH/tgC8GWY4t5bhIEtdVqRoFR0jDT0qY1XZ
         y1w5LV5JmYbZY2hG1rqZ+48jVeArNbJWEWM6o4lhz2DylcTh3GYzA1sTnAAgnzIHqgWm
         0HdCf/s5+NlYlABXGogAN9Uf9a51CYqIMrd3y8diR2aZO0M1+XxqAWEnzM4gFfKWSI6G
         EC1A==
X-Gm-Message-State: AJIora+SiDiWrFxDYQcq2Irb95Gykmr2aJqasBOiqc4TV5zj78lQZ+Qf
        X0p1z8g2T7eOIsTUGVim8nzZNChXz+U+GrWYcFc=
X-Google-Smtp-Source: AGRyM1sNFEWbYCfCaNMy79upa/DlnqiOinUfWoJTukleW/kpGx720ASlJ/4Sd2TURlisbmOePqZibA==
X-Received: by 2002:a05:6a00:1747:b0:52b:3208:40bd with SMTP id j7-20020a056a00174700b0052b320840bdmr25116529pfc.23.1659528420432;
        Wed, 03 Aug 2022 05:07:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r19-20020a170902e3d300b0016d23e941f2sm1700904ple.258.2022.08.03.05.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 05:06:59 -0700 (PDT)
Message-ID: <62ea64e3.170a0220.38d42.2baa@mx.google.com>
Date:   Wed, 03 Aug 2022 05:06:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.133-167-gb5197bdfa29b9
Subject: stable-rc/queue/5.10 baseline: 53 runs,
 1 regressions (v5.10.133-167-gb5197bdfa29b9)
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

stable-rc/queue/5.10 baseline: 53 runs, 1 regressions (v5.10.133-167-gb5197=
bdfa29b9)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.133-167-gb5197bdfa29b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.133-167-gb5197bdfa29b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b5197bdfa29b981e880429ba4d5658c201706e84 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62ea2c8478688be841daf07f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-167-gb5197bdfa29b9/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.133=
-167-gb5197bdfa29b9/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea2c8478688be841daf=
080
        new failure (last pass: v5.10.133-167-g622fcf2e832c2) =

 =20
