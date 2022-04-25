Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6DD50DFD2
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 14:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiDYMYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 08:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiDYMYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 08:24:16 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECC82B1BF
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 05:21:11 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id z30so6701836pfw.6
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 05:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8UUEP+lkflBX8EDNFFO8tfh0+Xklsy1Jo1jcwsP+l0w=;
        b=eGOya42hv6u9gAdZOcCwzNureMhST3cckmN+5RtyCsL1NNKoemcfED3Ut0KKaoeaDr
         XxlWhAuSbBPN7p+ybv6t8uJHrM7YSh97wQQFcSLkIYRTNj8WM1fTFSy9JUQiEQhtgumT
         VNgLEW1618ivttbAK0/8qAlL//Q9TIFKzu7k8AY2x0Spu7rcbo3JBWwrSav9TL1djouu
         lftM6HDD9v0P/5baML5RewIcfa1PMpiFm/PX+7QU8KeKiD7TUlGlKgyMJHp/FPYYfKNI
         lu0zPsCDhyoAmlXEAj8qSeowTuLhFbTMLeugks5eRI//aqoe2stmgHRKxrtt/xrujDF0
         RfNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8UUEP+lkflBX8EDNFFO8tfh0+Xklsy1Jo1jcwsP+l0w=;
        b=G3PKLWlowjUaaPzH46NC/7ZvvyGtnqqUqoHJH1F9MESPBBGw032bV/T+krYqD0Jct9
         4RiWrFb4YhtM6NQJLD4dRPXKq40PWrW03/CP8iVC50fpt/FYu866DEbkfr+fzM7Gy24w
         4vp7Eet+ZQhI/BXcpP4dySggccZJKGWBHvbrbW5uJ1iNn+8sKE1pkwWpsSD02LCnP8F+
         DzGBPjx5+5tv3C/G73VuCkozFTv7kttq9IaxSlEaxdQZgUxyBo2jZtwsIDPSy3f2BY85
         El/VavmNkPwOk8NQ8dPTXHxQJ7lNP4VAD8R/l91D0eqBfvVxZwIe2JmyuEoSG9unAx50
         tqEA==
X-Gm-Message-State: AOAM532H8aw+SGzzsUNwSqdoOAeyb3LtWTkLCn2i1X1PrGgavqaNgFCG
        sqwDfS4kk7wiigzd1tI1IO8t1vfSZiGRQc8l0zg=
X-Google-Smtp-Source: ABdhPJwQbFtwTt/8N4aYgFTLcGiGFnW8xAvEQqa0e2ruMbOWRZHSs43ydZfjjY7lmDeCKUnhQFRDDw==
X-Received: by 2002:a63:6e0b:0:b0:397:f965:64a7 with SMTP id j11-20020a636e0b000000b00397f96564a7mr14668647pgc.581.1650889271248;
        Mon, 25 Apr 2022 05:21:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p13-20020a056a000b4d00b004faecee6e89sm11243137pfo.208.2022.04.25.05.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 05:21:11 -0700 (PDT)
Message-ID: <62669237.1c69fb81.4164a.a96f@mx.google.com>
Date:   Mon, 25 Apr 2022 05:21:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.311-4-g84b311cc6e3a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 88 runs,
 1 regressions (v4.9.311-4-g84b311cc6e3a)
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

stable-rc/queue/4.9 baseline: 88 runs, 1 regressions (v4.9.311-4-g84b311cc6=
e3a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.311-4-g84b311cc6e3a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.311-4-g84b311cc6e3a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84b311cc6e3afc8077295286d8d042481066f597 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6263e998e169a57f4fff9465

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.311-4=
-g84b311cc6e3a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.311-4=
-g84b311cc6e3a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6263e998e169a57f4fff9=
466
        failing since 17 days (last pass: v4.9.306-19-g53cdf8047e71, first =
fail: v4.9.307-10-g6fa56dc70baa) =

 =20
