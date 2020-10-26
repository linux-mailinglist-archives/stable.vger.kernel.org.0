Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011D22993B8
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 18:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1787753AbgJZRZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 13:25:14 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:45819 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1776000AbgJZRZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 13:25:13 -0400
Received: by mail-pg1-f180.google.com with SMTP id 19so6425839pge.12
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 10:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3+7ihcA0ZTWLAKr5jwEKenvGMsBdf6mbSRjFKeJnJ9k=;
        b=O7UjtgKOdfNMEEWhropo75O8IfROegi5+8eRDZwiEIZ5Z47vuNU3kc2q2t0EMvhjgW
         B/iXO+OCE0H3huTFmdLdOXpJsROFeU1Pt5P9R0Yc0NewCZjRbibs+62qIQx2uER8tgvp
         wk7U5QFtAuVnKx4mTqd46Gzdy3ATYny+J81fGWda7LBDjkwWNr/D+HIqlBsomxy1l4Fu
         8rfeU6SVovVcInmOcQGDNHxaqM7SVOf5qf+rvKihxrnHA+3eOYARYUna7t285YKOIMWS
         9fCmGga8yUfAseqIrdFu3Dijfht3GruGbbOt00E5QqMZLToUPXXtRGZjT6da1iNdxUk1
         78dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3+7ihcA0ZTWLAKr5jwEKenvGMsBdf6mbSRjFKeJnJ9k=;
        b=MUm4INMXP0U8p6fBfkROy7k9nBig2VbMob7HnHf/mAZIEorDdT/+CQRP+I+WP9xrmJ
         s/lXU6fzcgbtTKFgtONTxgauVVZQl7S0Nk0A3gAs4OFa3qU8L/n9q53fOYfjhEVAp13i
         utqDiHIjdd/+IdILxKBzIrX1i/FbZiR1HJ3G4ZPvMGykDbeVpMgV/LpgKlqnphD/J9XP
         yCy0bRmCWZtYawWer2V1Ekc9yiCwHmiTiU+X0Y0vJDiottS8Hi7ZRitaVQPxRDbN+mLe
         IufJ4Rq670v5gx722jFnQxr+aDVJQYCDNTmDQywokSRbvzCxVW2ukaSGU6ivDfiQbDWk
         filQ==
X-Gm-Message-State: AOAM5324kKReihOAJfLCHp5F0YnsX5n7za8LV3XUjomQUhVPsZJ0iFnc
        hQjB6OS65U3g1PY8zdv+0J3n0Mnbhss5MA==
X-Google-Smtp-Source: ABdhPJwwZama5RdfdpwbC/7plRSjbaQghzK2cBc52FLcQ/H/KKlJaneqsNWUEpbqziJFeaWWfueQcw==
X-Received: by 2002:a62:5c06:0:b029:160:1b43:14ed with SMTP id q6-20020a625c060000b02901601b4314edmr13285339pfb.11.1603733112547;
        Mon, 26 Oct 2020 10:25:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm2293717pgn.28.2020.10.26.10.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 10:25:11 -0700 (PDT)
Message-ID: <5f970677.1c69fb81.6e650.4f22@mx.google.com>
Date:   Mon, 26 Oct 2020 10:25:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-626-g572a2b0651dc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 198 runs,
 1 regressions (v5.8.16-626-g572a2b0651dc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 198 runs, 1 regressions (v5.8.16-626-g572a2b0=
651dc)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-626-g572a2b0651dc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-626-g572a2b0651dc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      572a2b0651dcb8abfe489510f64a8bd80a5cf5a1 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5f96d362c7a7a9d430381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
6-g572a2b0651dc/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
6-g572a2b0651dc/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96d362c7a7a9d430381=
013
        failing since 0 day (last pass: v5.8.16-78-g480e444094c4, first fai=
l: v5.8.16-626-g41d0d5713799) =

 =20
