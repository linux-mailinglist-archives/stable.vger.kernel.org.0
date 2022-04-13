Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D334FF8DA
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiDMOYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 10:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiDMOYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 10:24:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38EA5EBF7
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:21:45 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id md4so2160945pjb.4
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=35y01FBMD3hUjyk2E72SQwJ0lHYEl/QllKr/EpW6KOU=;
        b=hEAFoINdTo4vgmYp4kyT2+FnV1UhnVvFGKFl3XuL+m0myTa3IFJUXMkxoXLgS8qjPI
         eo12Vg75Achil/SLoigbUyO1gWuK0vkgyMD2BxiDnN3sRl0CqPKrpvsmz/VuWVvnH7RX
         g9gx/9dSyPjXwcBZtae25wckNlfUpMdMU1rIVcnWdv6ByIOdSgjwwnzszwlG+f+z9NF3
         bTZFiQ4j7DeiYv65B9oMZnoCF66xhO4S6+HcRLgAcYBlVqT/wMQZufRHj74BI68LvNDo
         BF7wgpWwFs7OWjIcF0dAE4+A3MUdiucdQ2omwzGHi6e8TbA3jQVfuUUY/y23H0WqmHPD
         XhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=35y01FBMD3hUjyk2E72SQwJ0lHYEl/QllKr/EpW6KOU=;
        b=wqLwXAcyNj47yqrG3RUox9aqxKMR5uoy2nawDTGMo9N25Fgr4hxE7L7vxyxEqNoerz
         BiauoGMWeNoJRqRrlWFHywbmL23dcHOF0Hu7XG5E8NU+6Idheq6clpsxuwY9v1Ryn91o
         7MjvOj8dz2ZJAAz3kZTtsO3dif1XFtWe+BfbUj1NkPusXJyjFYO75ogItfGXVCV0yDi1
         v8vJU3slVSyATbLFIbnlzS2DtVetray4seq5SG37wleTi8e+XD1hP5paCtygLIZhylyP
         8rqpb4htdM4TGu80NiQYh8BCBXdM36zPWc3tjHeaQ1EBLzq1JH5nDi0iCO9dk5m1SdyY
         5s3Q==
X-Gm-Message-State: AOAM531F8KogMYNkT5hR2co10xJo6sBQCHq97Z+M7MNwUvJKehCBokVu
        iesFfgFyDQU1rW0zg9V9SydcruSe9ZjpfkMb
X-Google-Smtp-Source: ABdhPJxSf7w98qz2ejZfPu2phfveqADQolJPMd0KN1UKigAnbZsn03z9ugLP945Fnuxqzjb/H2xSsQ==
X-Received: by 2002:a17:90a:ff17:b0:1cb:a182:9b05 with SMTP id ce23-20020a17090aff1700b001cba1829b05mr11165684pjb.1.1649859705150;
        Wed, 13 Apr 2022 07:21:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o4-20020a625a04000000b004fdf5419e41sm34917613pfb.36.2022.04.13.07.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:21:44 -0700 (PDT)
Message-ID: <6256dc78.1c69fb81.b4fe6.c427@mx.google.com>
Date:   Wed, 13 Apr 2022 07:21:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.33-278-g1ad810a5a7643
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 78 runs,
 1 regressions (v5.15.33-278-g1ad810a5a7643)
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

stable-rc/linux-5.15.y baseline: 78 runs, 1 regressions (v5.15.33-278-g1ad8=
10a5a7643)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.33-278-g1ad810a5a7643/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.33-278-g1ad810a5a7643
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ad810a5a764358347407720dd6ea61e771cfe36 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6256ace361835048fdae06c7

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
3-278-g1ad810a5a7643/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
3-278-g1ad810a5a7643/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6256ace361835048fdae06e7
        failing since 36 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-04-13T10:58:22.672278  <8>[   32.743442] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-13T10:58:23.700701  /lava-6075632/1/../bin/lava-test-case
    2022-04-13T10:58:23.710886  <8>[   33.784268] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
