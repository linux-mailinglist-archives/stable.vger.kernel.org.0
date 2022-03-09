Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA504D3D9A
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 00:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiCIXeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 18:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiCIXeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 18:34:02 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732EA25587
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 15:33:02 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id m2so3375379pll.0
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 15:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MSsfWXRhHZjBY5Yxk6JaUkqWZXwc7v5RQu3U8vtOQN8=;
        b=hT2+HY7FLfh23WuKyeOjHgrOU04B1FXOBO12iFvvZmNKy4U8gK594iSFmqm51Z6V+8
         9lAdGvn29SLjBttXMZLxc1am5lsfZLCV9FqteepoJ8AGDtgQS/cRhxt31waAeH/dZjiP
         B3XSVURigFX1gYS/5LqYYjy45khEmYZeupoc89eiX6zBqm/JPL9rj5QasqyxV0A36v0O
         Yp+nNRS2QdQnjJnJAmj6Igw0dlPZags6TytCRaIM2+Qpd/ZzNMTmQafPPvs20bkyYq8x
         wXFrel2uxZQvS1SlBe3+L+XLI2U7KXn8NcmH1e+aHkbi4Dv5lx1k4Tno3U3GkDT05htD
         4EOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MSsfWXRhHZjBY5Yxk6JaUkqWZXwc7v5RQu3U8vtOQN8=;
        b=MB+5MzwdTCUwSEug/uIgTE3DTp9zTC0b7cCe4GWtaxhJXOH0Ta1Aw1oVu7RDPY8xTi
         EkFaWb0AEhJLIznNHJ0cC3LDxsd9nxM14x1vM+KWePLFFFuYmb2pwQudebKhSxw2Bs80
         gms+fYeAG3ClE3wux9gCMRTZT2tOcAuZZx8+4nSmYljv9XJu4vOIUlKgtv2T4BGaaQuc
         XLzsyg67d8wciRSdrqtT64cOaJTqXDo1xTeIMrkhTrxe96V5Tpa2waqN9q8byxKhdWhx
         WvwF5/cFqdO2ob+QwM0jMaHhBFhFWnqelOgPESO5lHIRZqD0JjZwNBzt0ItcNi4HeEx4
         FeTg==
X-Gm-Message-State: AOAM5302sY2GNa0ki9QOIYuLFua7L0VP4uWwL17XDLBoh36FGKUpHmm8
        GNcYnTmaYLGfwFfCS1AX230fxSwNQbBlIAiTFFg=
X-Google-Smtp-Source: ABdhPJwI4O/P3TSXjcCEZ0takUbNP1/IkWeAfTne9x/Y/eqvAp0zaoG9csaNkmqPaIEVf39jYYKYtA==
X-Received: by 2002:a17:90a:5b06:b0:1b8:b705:470b with SMTP id o6-20020a17090a5b0600b001b8b705470bmr1969391pji.168.1646868776828;
        Wed, 09 Mar 2022 15:32:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x2-20020a17090a6c0200b001bf6c74bdd2sm3863858pjj.1.2022.03.09.15.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 15:32:56 -0800 (PST)
Message-ID: <62293928.1c69fb81.8221e.a275@mx.google.com>
Date:   Wed, 09 Mar 2022 15:32:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.270-19-gb0e99fb90471
Subject: stable-rc/linux-4.14.y baseline: 62 runs,
 1 regressions (v4.14.270-19-gb0e99fb90471)
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

stable-rc/linux-4.14.y baseline: 62 runs, 1 regressions (v4.14.270-19-gb0e9=
9fb90471)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.270-19-gb0e99fb90471/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.270-19-gb0e99fb90471
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0e99fb904717023cd79d1eb8251a47db658e9d4 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6229077ece127170dec62999

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
70-19-gb0e99fb90471/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
70-19-gb0e99fb90471/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6229077ece127170dec62=
99a
        failing since 23 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
