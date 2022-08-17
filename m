Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619AC5977ED
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 22:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241507AbiHQUYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 16:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241633AbiHQUYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 16:24:14 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF222660
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 13:24:12 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso164925pjh.5
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 13:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=JX6XZ18Y77/NltP1/bVVn5CCvVeHgddvMo8YCH9WeT0=;
        b=xCUgXBUnK/WRPlxk4qsX0TSVutJ45k7s/KqzaGw7kGJ+eVPB55EsIw06bcvggW6KUU
         w0b8UfdovwoJSJXpFOxU1ZPx2CGAVZXm03t9HwQ3WLWati9DM2SQZmrtiEsTap7gAT20
         mHGRc+0M2SEmh5IhWWtFGFqYPphFPHk+vV9UsO4JG41/MooE9mx+WjxhZRwk2QGa10El
         CvFPWK2BteCtzxHsexrzbOPT5YJR6bK7rbqE24QnzOjY7IvJ+KCo6zUGqnSHohe6bhbp
         oNpzVm4k7E+ncYoDqmX5n0DWRLEoj8qClrmlDD7Wqisz62FVz/0RwpkZOBItIe4SHafE
         pcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=JX6XZ18Y77/NltP1/bVVn5CCvVeHgddvMo8YCH9WeT0=;
        b=jsMk1kdnxiUm5JrGk0jrjZQTjcxQBAEp+tj0YiJE7e6JwNpcadE6RWE0V9H+1L/Ks+
         IgG36Z1x8te01x1P8aVLHiTaohmBs/5gMfJGhPAV8v8E3mRkb6TNeBpNS5IuK/36jvCE
         BJHFFnjKNhFV25NgAPjsuFLDd7SBiu6paXkJz5DO/3Jq5cAFLfpz99K9rAzJvp1aLXaL
         1zly9wRSHDReIrv0J66GsEhb5z3aqEzV/XJu934rTPQd/snRSOGIFgD/jnT9rOjQClwU
         b8eaE1fV6DIYKOpHSa2lMNvqt5s2AqKorvlvY1eB7zhiXBv98xWYSFtHv7E6cKORk4Wy
         6anw==
X-Gm-Message-State: ACgBeo37nfu/LVfzJkn3/X47kXZTb6s/wmBEbfaiQx+sO7b/jHmysNXH
        U9ss5ahd9DBTp8ivy4FS7w1xEpe6Dlo0iFN4
X-Google-Smtp-Source: AA6agR4pqDPyjR5cng71hgsZdT3wpCNEalFS/O/mXygTrJSGwOzPJaHzfzFLvuLXIVrrwoEp8Ve+fg==
X-Received: by 2002:a17:902:d583:b0:16e:3d42:896a with SMTP id k3-20020a170902d58300b0016e3d42896amr28332547plh.87.1660767852178;
        Wed, 17 Aug 2022 13:24:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13-20020a17090ae4cd00b001fabcd994c1sm1302484pju.9.2022.08.17.13.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:24:11 -0700 (PDT)
Message-ID: <62fd4e6b.170a0220.4fcba.240a@mx.google.com>
Date:   Wed, 17 Aug 2022 13:24:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.18
Subject: stable-rc/linux-5.18.y baseline: 45 runs, 1 regressions (v5.18.18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.18.y baseline: 45 runs, 1 regressions (v5.18.18)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07e0b709cab7dc987b5071443789865e20481119 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62fd17394614f7974b355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
8/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
8/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd17394614f7974b355=
662
        failing since 1 day (last pass: v5.18.12-232-ga04b1a5cb7d28, first =
fail: v5.18.17-1095-g8e2f0ee8f479f) =

 =20
