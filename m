Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739BC533F13
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 16:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbiEYOZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 10:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244106AbiEYOZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 10:25:54 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668501EEE8
        for <stable@vger.kernel.org>; Wed, 25 May 2022 07:25:53 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id z25so6671322pfr.1
        for <stable@vger.kernel.org>; Wed, 25 May 2022 07:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NjzGOC4UMJaMFLCvkQThZU5ivFkcuiOBuqXbKxToTfU=;
        b=Tib9sSxSJA2SgV5y3pm/QNK0O5AhpCiW6OUPLH2l4CP06tKEQLt5HJV/i6cn1cl3w/
         ZXcPhuxc9ZKyu2Rj2lgyOQ2w7oOhseHp9UjhlJslIjWkJW6BL9BKhfIeBjgNKt4/DPs5
         SLfP32FK3+yzbwGWdCtGjITw2UtfK1pq34UXWILkjwIGwrd7SsgvdUsoLCGEg3XKP6Cj
         Om75nlJoy/052jKMq/3tT38Ke9d+xCJtY7k4GfI3j1Oujre5EDDwKWIf7ZthRnSbykdk
         G9EVRujkV0K12vAP1BE+V6XKI1hSuKzlxZM/qNljnaA9yXyi4MK0zCqEu+CLQZl+RTHQ
         bIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NjzGOC4UMJaMFLCvkQThZU5ivFkcuiOBuqXbKxToTfU=;
        b=mKQXuWiDJ6hhwRGGY26TWZcWgTktw8acSASnB/RLVeYLRYWx3WN7Uiy/+C1AxY9iHc
         F9V348v2a9yRQaZ4fz5LdvoaaeCk3T+TAH7rnABeuSzw6ec1QAtLkySRaItL2p4FGgvG
         HJ9eHC7cWvEgyhAulkaqJyZn2tq94Jb4V6uqwMWEyyFf+5R2lUrJQZUboX8YNUy9SFxd
         beWBDBQe5o1o+JOGn9aRLaBvFaDXsQ8uAanU5dKpHPchX6l466vmzeT3JqC1sgFh81Mo
         xfTVOXey2Mof6isw/PaIvcY38c7fb+1FVVCPMHE67wOZjw4WXSMp/EPRz5KMv77p2cFU
         wojw==
X-Gm-Message-State: AOAM53176UmqFE/WSDN9GXQ8SZPwK5njLoDD3CwZ6ZzcxRHnEQVmxneR
        uF3MRp9IvuRDYNsHLTXVz6sGpxuwXRUN/6xtUFQ=
X-Google-Smtp-Source: ABdhPJwdDQe6Q+B3y6XxFrxLop4BTS/POQdxb84r/ln7T/ZUYlshZ8ktJT/It5pwEoWt628CZEHZvw==
X-Received: by 2002:a05:6a00:150e:b0:518:d45b:a41d with SMTP id q14-20020a056a00150e00b00518d45ba41dmr7209275pfu.44.1653488752627;
        Wed, 25 May 2022 07:25:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2-20020a62c702000000b0050dc7628171sm11512812pfg.75.2022.05.25.07.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 07:25:52 -0700 (PDT)
Message-ID: <628e3c70.1c69fb81.714af.b28e@mx.google.com>
Date:   Wed, 25 May 2022 07:25:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.117-97-g901121443947
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 45 runs,
 1 regressions (v5.10.117-97-g901121443947)
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

stable-rc/queue/5.10 baseline: 45 runs, 1 regressions (v5.10.117-97-g901121=
443947)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.117-97-g901121443947/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.117-97-g901121443947
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9011214439474de8d184f0e11444331ac968da7d =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/628e0b7a9d46661c05a39c28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.117=
-97-g901121443947/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.117=
-97-g901121443947/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e0b7a9d46661c05a39=
c29
        failing since 1 day (last pass: v5.10.117-94-g0958739a182f0, first =
fail: v5.10.117-97-g61f264fd7dfaa) =

 =20
