Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B71518103
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 11:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbiECJcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 05:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiECJb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 05:31:59 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415A43630A
        for <stable@vger.kernel.org>; Tue,  3 May 2022 02:28:28 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 202so3345329pgc.9
        for <stable@vger.kernel.org>; Tue, 03 May 2022 02:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8iUUEQ3Hqk76bDrERxaH9oyl3DtuYqYhn85GgrGw7gY=;
        b=y8xE1McOEPLeA+26a/CIuvNHrLNXQjM0YhQSxy26IaMakomAgyYwWi6/KyBpJUlhNG
         QolcB57hkNINvXk1tSTdPvvu9RRi+Z+6ru6hR89f1W9CMXazn9JkLAsztoIWO5BER+Xq
         AkgfYIOCvGnd9CzwreFaoYBPW+JPPC/iyMFMFPHCiICL8CB1O1lZwVeAjSUOR39u+DCD
         IW1MeiFFUdqwqASatXN0cXpU5DC2jsEPov5OG1xJKTlup41EnVWZarzL5MlQl0DE7ZrL
         CE0jRwctuzs00nXgxBv+mGgPUkNMRnCs81qCRI7hILlfn+qUcezrMu5f3ZOxTSItcQxp
         eVzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8iUUEQ3Hqk76bDrERxaH9oyl3DtuYqYhn85GgrGw7gY=;
        b=a73Kk5mux5b9Yaf0ufW8xBxxbcEteZxqJ7ztOCUnHCuAnBrNnJgxNzZtiA2f1OaF1H
         5V2Gw7rh2mdRhYj4nYn492pjWhJR5HTpUUcZikiz7LBUlf6oqYx2b9pRc8gf6ajIS9Oj
         Gs0gcra0T+45O3L/3J9ofH0h6EVfDt4r/GQd7SHLNvdB1mQLB+4kolxUdVFl65xIEpS2
         qwCsGBvVbqYCx9aMs10bjcXKLPqEwvxxoR7Vq2AFtzRkix3VRGCgP0XFb7fTSlyrIMYP
         udObiYIob/yzk7v2OIl1XpmtZ+dM9dygl26TZ+xjdQgeQ8BwsLb3JsLhzxNHenRx/XaP
         dIGg==
X-Gm-Message-State: AOAM532dIGwXTxQTFkb1eX6kuZjQZZCiTYGHnprkPbNOKE4j8s2Ra2ZP
        tCgtfZnZls4VAGotlOecLvaEQniGbMGyP8gf/kc=
X-Google-Smtp-Source: ABdhPJxbBPjLtU3ZA10kamW/jaD424fSyx+d9PQH4Ek5JQ20QyKssI2tOqWlgZDYP2JPDkuZ7fYIow==
X-Received: by 2002:a63:8641:0:b0:3ab:4191:b85f with SMTP id x62-20020a638641000000b003ab4191b85fmr13008350pgd.380.1651570107611;
        Tue, 03 May 2022 02:28:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o18-20020a17090a9f9200b001dc37aef4ffsm991254pjp.48.2022.05.03.02.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 02:28:27 -0700 (PDT)
Message-ID: <6270f5bb.1c69fb81.9f73f.2d94@mx.google.com>
Date:   Tue, 03 May 2022 02:28:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.241-49-g667276a8c00e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 52 runs,
 1 regressions (v4.19.241-49-g667276a8c00e)
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

stable-rc/linux-4.19.y baseline: 52 runs, 1 regressions (v4.19.241-49-g6672=
76a8c00e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.241-49-g667276a8c00e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.241-49-g667276a8c00e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      667276a8c00ee222a9bcb8f6ebe880529a538bb2 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6270bcf267739af9f2dc7b34

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
41-49-g667276a8c00e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
41-49-g667276a8c00e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6270bcf267739af9f2dc7b58
        failing since 57 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-05-03T05:25:51.301370  <8>[   35.639415] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-03T05:25:52.311901  /lava-6243324/1/../bin/lava-test-case
    2022-05-03T05:25:52.320631  <8>[   36.659785] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
