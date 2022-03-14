Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3704E4D8FA4
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 23:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245675AbiCNWkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 18:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245672AbiCNWkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 18:40:12 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D6524BE1
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 15:39:02 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so755757pju.2
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 15:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qcLFzfClO7x9KsySTjT34XHRjmwj3h/6rz8UncMd2uI=;
        b=Xq2plfbYrYnmsoEBbfE3bd47piYnHeCx5vm/L1q69dvTH/Cwi5CMFEd3rG4ulBR4uv
         QV9GYOerJ9WFm54gvQpl5VMpkuU53m9WIO7siZTTMc/eWn/ZkiSxqnIQvjOpsteowRK9
         PDzUK5Fkx46aZrpoge6hOype46eSnXVDXP1SRYkqz2Ey4F7271HEv5Hc7yLzJh7DWXPs
         5BRmnnulGRoA9zdRo+V52sxc94hq4DPY565t2RBmugGpncGzAXoR7goG5xM8OtUv9Y9M
         gpFdftnXZIzh+l2DJz2CokO7NmgnvTW9uN+66Ndbcaih6/GInlW2csNHrQiRtNZYRTD9
         5ykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qcLFzfClO7x9KsySTjT34XHRjmwj3h/6rz8UncMd2uI=;
        b=op2THgCRN6hbxfEX0U8Q3izg920Xly1F6tHjyDOKnkotYy20NqhJYQx7shuvTJP3cd
         d8WOhuyHHX/KOazFjOEtBFfL6HNeh1aLvllY1gAr2HkaB7Tq+k8qcUGXx5Q9YYJJMfCl
         pXZZtdK7zmDnnKs6ZZFYavlsVOLA9bwuWYOrCf9/vwfKZZdiRZjDiaGXDtXgROmCowC5
         A2J74cRHL8whUUvS3Sv4v9VHc28FQbf+QJewMNqeJn09RMYiJWkfYBvCtUboVsMGMtm0
         vWSFwmYDMzltRgJ5BfMk7+hPvrPkNBhV5cKQI1cy7RUJxrJ1x1jYmdHLmnmKbrh42Jzm
         WlYQ==
X-Gm-Message-State: AOAM5309mTEkLl0NPeIKulZs3Fm4fQGN1wb7vYNrmG4suJvJ0tEAQpmP
        q4pZWY0FeTYUQMlwlVjkMrq2Z5oSoZ8nGdxMU5s=
X-Google-Smtp-Source: ABdhPJw9PZCMYGJugm5FreQdIabDgON8QT38vVxMpYb6MPfhgr6R+sfm3nv1FU5005W7uCO0iC8jPA==
X-Received: by 2002:a17:90a:3e83:b0:1bf:3160:7f45 with SMTP id k3-20020a17090a3e8300b001bf31607f45mr1372713pjc.224.1647297541969;
        Mon, 14 Mar 2022 15:39:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004f73278d1aasm21428846pff.138.2022.03.14.15.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 15:39:01 -0700 (PDT)
Message-ID: <622fc405.1c69fb81.7b8b8.6678@mx.google.com>
Date:   Mon, 14 Mar 2022 15:39:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.271-23-ge991f498ccbf
Subject: stable-rc/linux-4.14.y baseline: 72 runs,
 1 regressions (v4.14.271-23-ge991f498ccbf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 72 runs, 1 regressions (v4.14.271-23-ge991=
f498ccbf)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.271-23-ge991f498ccbf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.271-23-ge991f498ccbf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e991f498ccbf4fc46e0525c0ca02e4134f253706 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/622f8920ccf5a1ce5bc6296d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
71-23-ge991f498ccbf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
71-23-ge991f498ccbf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622f8920ccf5a1ce5bc62=
96e
        failing since 28 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
