Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8D254EE3D
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 02:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiFQACV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 20:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiFQACU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 20:02:20 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E22562BF9
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 17:02:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e63so1139002pgc.5
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 17:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P0L2UAD1ZLAXlBGOXlxAVoSaWwJHTWdXijAhn1+nPLw=;
        b=I8vuAuZzvIaNoxfbhvWXJXbeU+zy6953eInZcjRtHDhJEXNUzZV29Ss34gJr4v8pqB
         Fxwsji4owmbxThyFQcClVhFFtXlyQ5zyTCiA47kwehElDvZwcuNHctsQxgppe7+toKQg
         5sI8lhYf1mkdR2bemRj4thWvots+iFhm4UUpyIp6sTaljiSFRMpLxYjOUWBtv4SsI13Z
         Rw3CtiXcH++LEwAx1KXQPmqYqOR5Dup6QiaIlL4w7+gA9NHWJm3NNy61aO7LtYgcBWlb
         T/PurE+jRG/rdGA2t77n3NCfKZ4TgqsvchpHcFBUfCQURsUTz6ZN8MadpJxrMme+cBRj
         qrwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P0L2UAD1ZLAXlBGOXlxAVoSaWwJHTWdXijAhn1+nPLw=;
        b=oymZ+2hpCb5Q5s8NMJiFQtisc0ILMj3Pf9C6gb1JjL1G12ezZeWDSnLf7S2LddOk8J
         mXeDEnBAv9AD6w73Ggc3eOxs+//hg4r1Fob6aiizrZSxKDHzycXaifjjVA7SQ5EvQ6oe
         u3PKHzPc/QuM+GjBQCuDz9vq8ul3DYqgRZRzJkTxTNXRErB0skWuVTeP7sTQszqcUawq
         WZWbZeuO+hyMbEF+s3rOXWcoos4SfSpE5UFjkl/PK9hnAZiLD0YaPfOWGscP7EBwf9Gb
         i5hwVG+wBeDiydL7oEnrRBy9GLv4CCKOERUcv0IUwqLA5KNme9Pvn/EebFCyTCRSMReg
         DBOQ==
X-Gm-Message-State: AJIora+71ljyt5TG5abIc0WUC8v+UyjqLY9dqg3+syXWJdL0wxWzznz6
        qggGm3Olv97On0L+KLsJR4zoq+OpNXkmqq+AhK4=
X-Google-Smtp-Source: AGRyM1uJYyjZMl7TaoxbYOeycac0936FW9kx+qs1ElafxzZmtVC8St5oJvFdKolmc40VC6N8cGOriA==
X-Received: by 2002:a05:6a00:893:b0:51e:77ab:8874 with SMTP id q19-20020a056a00089300b0051e77ab8874mr7035412pfj.21.1655424138875;
        Thu, 16 Jun 2022 17:02:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902680400b001640aad2f71sm2205987plk.180.2022.06.16.17.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 17:02:18 -0700 (PDT)
Message-ID: <62abc48a.1c69fb81.cb091.36f8@mx.google.com>
Date:   Thu, 16 Jun 2022 17:02:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.5-4-gf690b02795634
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 182 runs,
 2 regressions (v5.18.5-4-gf690b02795634)
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

stable-rc/queue/5.18 baseline: 182 runs, 2 regressions (v5.18.5-4-gf690b027=
95634)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
jetson-tk1          | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig =
| 1          =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.5-4-gf690b02795634/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.5-4-gf690b02795634
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f690b02795634755ae09a5b054e68fa9b0adabe2 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
jetson-tk1          | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62ab93005988bc07b2a39c2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-4=
-gf690b02795634/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-4=
-gf690b02795634/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab93005988bc07b2a39=
c2c
        failing since 5 days (last pass: v5.18.2-866-g0f77def0f4d00, first =
fail: v5.18.2-1057-gd2f82031e36a5) =

 =



platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62ab92d64f1bbbb90ba39c1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-4=
-gf690b02795634/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-4=
-gf690b02795634/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab92d64f1bbbb90ba39=
c1f
        new failure (last pass: v5.18.2-1173-g45fe14d45d6c3) =

 =20
