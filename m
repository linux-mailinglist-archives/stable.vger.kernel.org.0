Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95454783B5
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 04:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbhLQDje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 22:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbhLQDjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 22:39:33 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93CFC061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 19:39:33 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z6so715409plk.6
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 19:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=98OW15Im07yfaJN0ze7g909dUUUaHE/pjFM0iVnkCAk=;
        b=UlEZUDFXmE1wUyX6fe9HfWrWw2jEe7rIYlgpQ2GAXZ8UMbkp5qIQ7RQWiKLjDxbwNL
         ZfgAK3Th3VO4vy2qhtv/Sk+p8SMMA7zS/wS4Cktko+SkxoK7oK6nuKAq2V5iKJbJHg7l
         4ROOYeiLpi+r9WSN4WeiXSVp7RJWCBJb5aXyU6ZBq8NvZ78brJzrHWFUTgLGBN/rN3bE
         4qEFmSiNmIUCwPDB9SBZVUNF71FJjsJ+PsHq0frCgGLalBa7kAEcSUsivStzxQ3Vv9U9
         rSj313yAfMDF73yBDQl2qt5IXZMpba+UDg8V4bH6B16eRxOGv6SJfNLbz9cCrIC8NE/i
         Jyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=98OW15Im07yfaJN0ze7g909dUUUaHE/pjFM0iVnkCAk=;
        b=7/re70UHoTU7H4dVxLyuyqxwrY5fMP5r7eQ4PGeaguMZr+Ulb3RQm3egIepKo76lGW
         W6sGx/iBXF+RPZyCyXwTK3XpKdL+ONAFt2HJv10mZQ3MjJygV8hoCfB7x0QtHjepB2UQ
         YnFy4uuVXXwKfpbt66q1m+bBekVrH201J3ixGsIIz3PZlvfffwN6U2CjCIQOy3hfvycv
         7uRFbYqFSdZiG/EUK/d6dTHLXE5pWUOnsU1hXJdOioZ0VL5Wp+SD3cALuaiA38wwjLFr
         xjfp5/UvKMtH2/JUKrDo0ZbIRVVQjFI1L+ZeSVJXL//Uwhl/i03NsGdSgKvNcdhJuMI+
         KlaQ==
X-Gm-Message-State: AOAM5331Sa2i6hO0HTlzT/WWw2TNuffzAW+d1ZUT/OXDkO5x4psXrpQT
        zBT7DGqBmfTLm964r/CcW6N9W5KHix4frolf
X-Google-Smtp-Source: ABdhPJzSFuTaT3HfFTKGCaGDhRtwT+WyVbrQ1lqU4o0NibcoMsXzd9xWVZOauea8tKRIZVt/mDj32g==
X-Received: by 2002:a17:902:db12:b0:142:3ac:7ec3 with SMTP id m18-20020a170902db1200b0014203ac7ec3mr1398336plx.2.1639712372543;
        Thu, 16 Dec 2021 19:39:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n6sm6567491pgk.43.2021.12.16.19.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 19:39:32 -0800 (PST)
Message-ID: <61bc0674.1c69fb81.98aea.3376@mx.google.com>
Date:   Thu, 16 Dec 2021 19:39:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-5-g889544f2e45f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 98 runs,
 1 regressions (v4.4.295-5-g889544f2e45f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 98 runs, 1 regressions (v4.4.295-5-g889544f2e=
45f)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-5-g889544f2e45f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-5-g889544f2e45f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      889544f2e45f12bd89be082a5c74d453f76c119f =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bbcf5ed92225387439719f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-5=
-g889544f2e45f/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-5=
-g889544f2e45f/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bbcf5ed922253874397=
1a0
        new failure (last pass: v4.4.295-5-g649b146b7173) =

 =20
