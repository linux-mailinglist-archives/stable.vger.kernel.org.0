Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB964CED4B
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 20:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbiCFTEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 14:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiCFTEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 14:04:48 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD044A3D9
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 11:03:56 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso12264551pjo.5
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 11:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2Ary8xL4SDb624dFugqDcXTklM2W3GPCCcIysQYaSCc=;
        b=xAtylBcjXFo3B3JNWy+Q2UZvu8uZZAi5P+GYo2/k5akqkiRzLqKa8wrkkDzxa6DChB
         j1DyWpAM3v8XBZ5C9CTXiIuJcNYOZq1SuMC8NMoRibyuKAfUgoenSFRKc4m9iyAjiyYi
         C+H4EoAjlOZ10GYo2MDw2Xi0SqV7cX0tz+X/6pS7fszgBHvivXgbFECYShjqO7tfTkuB
         B/oHsRszEpuWJ7JNIJ0HMYY9cRcnGSSD1gXyqp5xfrGOvodzLYJSIbeW2kLGHdVpDBBe
         R7vo7fwMfSLOhh8A2nfms27fUNnIj/uN4Bh23g4lQPAKtZhb/a0s/XSEZTtifOrJUSgo
         WEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2Ary8xL4SDb624dFugqDcXTklM2W3GPCCcIysQYaSCc=;
        b=cbvHlb8oaqPHN+nGTNYRfZ7qb+x7uzv7XW6SUpMwqzKuoIWi1s6B0bt4mzvCZHxKIq
         d2jwqgqoscnP4OR3gNUbiBBY/lukSAFSVv370dh0mBOxGbHPRUwHbGW3J6WEcIHuIT40
         wcGqmYhGXI/F9wnUcPiLv5m/V5VNgWdrJy45Yhs94J9wm5xEqM3a4PKrQlv/5YBenAs3
         XNKBhMk9e7MMEGQjUZWPEz6FJKVxpUb2EPNvpmY8tm9QhOVkf8GbARs9wNMgoEjtzpMD
         GQ10o2z6n/iSkZVDYmc0ddtPyaFbUS/Wmlk07awfsbywkY0Lw5Q6Ewex7GrN+8XsBw1Z
         9qVQ==
X-Gm-Message-State: AOAM530GKIonDqdMvBKw1rvF7+DmaXDuyP1erGBqO+JEL0ZF3S2g/fQY
        +lZAFgFk2U0Athr8yoALmoG8ljwzDOBu0hlqA4U=
X-Google-Smtp-Source: ABdhPJz0Hi2fzc+BpYOPFLsrdKW2ZdgurooMzkZOytn4auC71fNZgox+voSFHeaZBH0oFJiN5D5qog==
X-Received: by 2002:a17:90b:4b84:b0:1bf:5d4f:3577 with SMTP id lr4-20020a17090b4b8400b001bf5d4f3577mr2429546pjb.242.1646593435967;
        Sun, 06 Mar 2022 11:03:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13-20020a056a00114d00b004c122b90703sm12537303pfm.27.2022.03.06.11.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 11:03:55 -0800 (PST)
Message-ID: <6225059b.1c69fb81.515b0.0049@mx.google.com>
Date:   Sun, 06 Mar 2022 11:03:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.12-166-g373826da847f
Subject: stable-rc/linux-5.16.y baseline: 112 runs,
 1 regressions (v5.16.12-166-g373826da847f)
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

stable-rc/linux-5.16.y baseline: 112 runs, 1 regressions (v5.16.12-166-g373=
826da847f)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.12-166-g373826da847f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.12-166-g373826da847f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      373826da847f662ffdca402f358649752dc74aed =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6224d1ed7216c95edac6296c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
2-166-g373826da847f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
2-166-g373826da847f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6224d1ed7216c95edac62992
        new failure (last pass: v5.16.12)

    2022-03-06T15:23:17.697125  /lava-5826037/1/../bin/lava-test-case   =

 =20
