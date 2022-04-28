Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B05F512AC0
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 06:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiD1FA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 01:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiD1FA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 01:00:26 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE6698F60
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 21:57:13 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id cu23-20020a17090afa9700b001d98d8e53b7so5296488pjb.0
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 21:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+fRWd7aw7a5qswfF7/eBoXrhUD0kI7I6A5e+8TTYXJY=;
        b=NqnOqvkf7DG4K2+1K2FrlGyUrcBDhNtbnAYf9HcFUsdphVaxawWPfRXBb/WGZD8Pva
         b5ONHSZIMIs6dR1VJUQWdcyBgvvWDm2xfquxBe4A6rn5a/GhKlWYuezFm/cbHozN4RRH
         R4ffNpMb2nnwJMqP6wxG7C4dQxeMHik0PJ9VrJ2wfLRO3fVwne60YxjyUxG8lzqZpH3c
         gb7pQbKYuS02IeEY8kz8Wtio37hr/ID0/wSrsNkVhQD2FnFjqe7jn6ASHbyhX9yB2LcZ
         GyISruajFik/iIML6Wfu7mtmQUTettzFU7yyHYv99Q3M0tkktI2nnrvYysdW0/fsaTqy
         13Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+fRWd7aw7a5qswfF7/eBoXrhUD0kI7I6A5e+8TTYXJY=;
        b=C1Un2/OlzHYXlkN61t+i3Y2dDrhkMKBNo1tJ7MJn7Aj2Io04XwfqAEc3uEaFq7F6Uy
         1ro8P7oJlE6J3CsG3SD/OOtS5XbyOloAn/BEnIi005avouNDDaClxCSmspMFu32jpTJk
         NP1YoUNvjn2Rf/XMfmaz8cl0WNfhNIoVIBKH4CIvb3di+xWOoGbKuirBxm1WJoGuUg74
         jXPFODmjl7cdiBZ/ZOMdt1HNlpV2zpSvih0Xa26YYYF1cb4VKHOk5H+avzCW3ZvIc+tC
         eBC1LsL1B1wGmdWFemIX7Z7dyMEw2w0O1Y9i/NkO6ArSMni9bUC0mNlb/Xl8agpuNr4X
         TG6w==
X-Gm-Message-State: AOAM532oTxDWTJvy4il7VXPfYImeL68CDwMp3ilsArIEAWMlt6ZWOxC0
        GDkymkYw5n1/Sy85f7AiSDvTPwJySBOVukr8EVs=
X-Google-Smtp-Source: ABdhPJyE6zZWda0tiOfAbr+9YLvCNCcnXnV7jq+qQ7JBw1p0P6gfi2YG4/FhwB8A5tABThuL3uIVfA==
X-Received: by 2002:a17:90b:4d08:b0:1ce:8d09:1c58 with SMTP id mw8-20020a17090b4d0800b001ce8d091c58mr36861756pjb.168.1651121832442;
        Wed, 27 Apr 2022 21:57:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h92-20020a17090a29e500b001cd4989ff62sm4493110pjd.41.2022.04.27.21.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 21:57:12 -0700 (PDT)
Message-ID: <626a1ea8.1c69fb81.f681.aa01@mx.google.com>
Date:   Wed, 27 Apr 2022 21:57:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.113
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 78 runs, 1 regressions (v5.10.113)
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

stable/linux-5.10.y baseline: 78 runs, 1 regressions (v5.10.113)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.113/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.113
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      54af9dd2b958096a25860b80d48a04cf59b53475 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6269eaa19b98a869c3ff9480

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.113/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboar=
d.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.113/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboar=
d.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6269eaa19b98a869c3ff9=
481
        new failure (last pass: v5.10.112) =

 =20
