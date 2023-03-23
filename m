Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986FF6C5D4E
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 04:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCWDg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 23:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCWDg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 23:36:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A111B10EF
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 20:36:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j13so20322778pjd.1
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 20:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679542611;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2bByHu+YmqFeLnD5MBcGr2Y3Bx7JwzLibwZG5i8Qt10=;
        b=z++rYckalgJC08I5DBb6pLATjiExZprsHuNelWc38jp0cvEwhQ4fh1qOv0TOA10jr3
         qNJPD4wgbjuYAqIvWxJzh0SdVYd9R+PnBKOA25gJwfpNLiXzGUEQ9r83p1/PhdNPQb6Y
         n9rHPPuBjLYw1fJ1vZ+VsIBS04arvw7zeXO+0YOtD8IRqNB8cT5CQLVQsz/kiMAM7dDF
         2n61Ez7+7vFuLrfgOuC34ouKd0UZQW7wSsQJAbtRp4x2Sf+ju1xYsgowyGJhTk2fHetF
         oBr43snijYRXUhmLfTYdd917rSwxSmW+lOdbXk8nST+wYnIbjnT2NTyOgUZc/VP30Y3L
         S7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679542611;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2bByHu+YmqFeLnD5MBcGr2Y3Bx7JwzLibwZG5i8Qt10=;
        b=zqVm0ifc5Rnoh4QOC7gzQ3Jnxldv0AGbmb9Xo05VqBsWpwFQpG9DOUs5hxi6/Y4t68
         y56GntsR6hi0DEqYLw4YvotsMD5fpfJKZRU1l3QhqjTbDVQpjUkk6b+JPRGPz1em59Gy
         wgAFcMG1kMpUEryj2GSGv2Pmk6JU2grfuxlABGUohy6PUntkyVwtLpWgjWFEmsuMxoD8
         KoG6WfkaOWAp2oMd2DmURSx7XjAt1UBKOHKHZM0+ZfN2MzoK1ElTe3+iaWs+PaOt8npl
         opg044PWt5D/91XzuvgTAqEUOqt7rzAdh3MWhJMWq7qwe/R8WK90DLN07wP+GY25pp8m
         EcVA==
X-Gm-Message-State: AO0yUKXos7kJv5z5XN5tfSvEW3+qak48Pmnu2yF7yGmiq4rR+4JAXpn3
        924y8niT9bWZhh6r2jPkv6QlToT5tHFncyNgU76+Fw==
X-Google-Smtp-Source: AK7set9IMiyBK4ZXL9iN6J9pJpJtW3JAWv+f902lM8I5LAof5TWq75hwZYWIPI99XUH+oVy8O1iYnQ==
X-Received: by 2002:a17:902:c9d2:b0:1a1:aea7:6d4e with SMTP id q18-20020a170902c9d200b001a1aea76d4emr3893251pld.34.1679542610868;
        Wed, 22 Mar 2023 20:36:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e27-20020a63545b000000b00513092bdca1sm564317pgm.73.2023.03.22.20.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 20:36:50 -0700 (PDT)
Message-ID: <641bc952.630a0220.b9e04.191e@mx.google.com>
Date:   Wed, 22 Mar 2023 20:36:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.21
Subject: stable-rc/linux-6.1.y baseline: 181 runs, 1 regressions (v6.1.21)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-6.1.y baseline: 181 runs, 1 regressions (v6.1.21)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.21/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.21
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3a87a10f2591f296d1a50c5af6820e2181d564a =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/641b9829f76338fa9c9c955d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.21/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.21/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641b9829f76338fa9c9c9=
55e
        new failure (last pass: v6.1.20-200-g2152cefff654) =

 =20
