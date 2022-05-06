Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292AC51D57E
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 12:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388382AbiEFKVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 06:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387875AbiEFKVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 06:21:42 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3E05DE54
        for <stable@vger.kernel.org>; Fri,  6 May 2022 03:18:00 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id x12so5751113pgj.7
        for <stable@vger.kernel.org>; Fri, 06 May 2022 03:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J9QXSVh/YY82+3pAsSbar4lcmzandPPhV4BIeeJS/0U=;
        b=4lZ2RMvPx9fCFE5LXq6S5UqPFJhJBIJXSJG+VN/CZ2iVZ9w3kvYEPYQY3TPiUtlKQL
         525OQKbP6nBYic/BEKqjGWBt7CXdYxomKs469Q//siGSnU+ADJI3D9/1ZG74ny85LP3x
         CPPnOvwwnBOZNyNZwqE5FjjTf3RaDXn4hNykz7SaqfTiAB6mPIJr6LxUt+M8p6SJXMnh
         DVsFnWfQEjOg5GNWok1e++E4KdFecCBOfke62VcX+PoZ3kd5gHlH2lXKinNu+n75VIUL
         UkY2SHJmdjf63zddFOrmrhOyRuPDgKG/vN944tMsaRcv7QpgFE8Ajq5YOh0vGJ4G3fk0
         1ieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J9QXSVh/YY82+3pAsSbar4lcmzandPPhV4BIeeJS/0U=;
        b=e6+mxSX0Nu4yr69nR2woV21am+cF8PtSrc+yx4ZYlEXWUIDRAAN8hIWJSS7Db1S273
         2v8ReBtEoLdOiYkOAmjux9Mc7WNRoZ3ottw5ReRl1K47G/mGkzAcbfCB5WQ4Y6Asr/Mj
         HF1KrtiJ7zB2EQN5pvrQ4MDWKe/t0iAoscPDy3p70G/UzwYrOm7d3eQWEzl5KNzjmxWg
         Xgfc1QPfQQreFXh2P800QCkgWcrzLqvXlQ127qNohdLZcBpFCSyAIpJ6Ku0mw/WoaNeo
         nvApVINcb3HPTXCozw86XkHlF32g/WjhzCvhhXHDsPr3nd94RIwYn0xNGUUfyo0o0LJf
         bKNg==
X-Gm-Message-State: AOAM530FUCWu2XMjNSKISyxMhSsT2BWL35Xb+22n/wUBPAmy2Flg6pFo
        dHTqDBKrJKgJhEcZST4igqNIxJiGOBU9OJW5WvE=
X-Google-Smtp-Source: ABdhPJyFNxF7ahtAVrTeFSVAZBXAXj7G5fWPPPzr3YPoYPJamG9Req30ZFMApXmhuqd9gp6lGvYoIw==
X-Received: by 2002:a65:6c10:0:b0:380:437a:c154 with SMTP id y16-20020a656c10000000b00380437ac154mr2131525pgu.549.1651832279301;
        Fri, 06 May 2022 03:17:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d90400b0015e8d4eb289sm1273581plz.211.2022.05.06.03.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 03:17:58 -0700 (PDT)
Message-ID: <6274f5d6.1c69fb81.57947.2dbb@mx.google.com>
Date:   Fri, 06 May 2022 03:17:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.312-43-g5b8113699dd5
Subject: stable-rc/queue/4.9 baseline: 76 runs,
 1 regressions (v4.9.312-43-g5b8113699dd5)
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

stable-rc/queue/4.9 baseline: 76 runs, 1 regressions (v4.9.312-43-g5b811369=
9dd5)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.312-43-g5b8113699dd5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.312-43-g5b8113699dd5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b8113699dd5bb7fae72bb0a6f88d6be99a0ea0d =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/627323d479e1c1554e8f573f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.312-4=
3-g5b8113699dd5/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.312-4=
3-g5b8113699dd5/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627323d479e1c1554e8f5=
740
        failing since 29 days (last pass: v4.9.306-19-g53cdf8047e71, first =
fail: v4.9.307-10-g6fa56dc70baa) =

 =20
