Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5344FA756
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbiDILlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 07:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbiDILlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 07:41:00 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1616565
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 04:38:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k13so4874294plk.12
        for <stable@vger.kernel.org>; Sat, 09 Apr 2022 04:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v2N+xCH8UlhqrPY+cBnkr3/N9HsM/MgxJ/yZpqUpPI8=;
        b=5YhGCSb/4HV+oyFOu3OsM9BpNmsuGd39gOOvPDJxxYFCCnsMzbeoQ+chXE1V9jDbAJ
         1rrl6F2HpwHs8SHO+lmiY63k9BfsePHm6Q2kSwzPW7b18Uu4EeVVQ07baKZw8mPYo+gI
         2iIQIxDMywLon3fxjN3xXVV772yWyFGu3X9wqFA7Izrov7RFhnUtaqe4EifZomaiqhaO
         h3R717LvQBiZzL4c8YO7Mo989CInPz44/V6Wptc/LauBNdLcYM3Kk10Up9iXPz5clp/l
         DWDSzUpEVeAYNjn5WdhG8/aStrFcfyStqOlAjFiuo/ynMSltCjXcjQ7pOSdqv7P5d6DP
         y4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v2N+xCH8UlhqrPY+cBnkr3/N9HsM/MgxJ/yZpqUpPI8=;
        b=jFXqWmBZBRxDrmsw8N5D5f2TkWMdOuR/QCOq+W/OVzAYN2ZM9Y7xk8mQGJfLbqdubw
         2y6Pu+LnVWFzyhl/fhkectgISgOCoY2ALfg68RC6akM8TC/3zDU/R/XJnQvLqz+YEAbb
         LwuLKW19BLt510ZgovkrIpq4Q4t+NLSYz6d1fJvjeE6Tpqzc9VkfjZBqJR1SRd4BkOjy
         DjSGBUOZg3GqrlD5LmYnhYsPfU8Wf2XT0+Lfrm++o7R1JLB9r0oxdRK+Au5VLYgH9t6o
         YZbo1K0ahoAO8BQJ+XSZCcDslHXCjYW03/PV1B3xO974z7AJ8QI6DD8j4EOWiIjSxUPb
         ipJg==
X-Gm-Message-State: AOAM532HW0Cla+R/5l4yfAA9HDjjml44NETupRQSWJpXWEEJlLdDhKtm
        vhahaL01Wh8oxNnh4XmlPQNgTevXg81ieEyz
X-Google-Smtp-Source: ABdhPJxmSe5GoDW2zR6VoX5HF97TuiOCmSozfVmLBD8DtUy7ZAA8OztI+Gv5X7tIw99gBWcUDSPi8A==
X-Received: by 2002:a17:902:868b:b0:156:7afb:2ce2 with SMTP id g11-20020a170902868b00b001567afb2ce2mr23569764plo.27.1649504333265;
        Sat, 09 Apr 2022 04:38:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a26-20020aa7971a000000b00505a16f73a2sm1810023pfg.163.2022.04.09.04.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 04:38:53 -0700 (PDT)
Message-ID: <6251704d.1c69fb81.6ad6d.3944@mx.google.com>
Date:   Sat, 09 Apr 2022 04:38:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-255-gc54ac0d392ce5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 77 runs,
 1 regressions (v4.19.237-255-gc54ac0d392ce5)
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

stable-rc/queue/4.19 baseline: 77 runs, 1 regressions (v4.19.237-255-gc54ac=
0d392ce5)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-255-gc54ac0d392ce5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-255-gc54ac0d392ce5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c54ac0d392ce5504d442130c0dc7c003fa5333f6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624f6c7932e8add42fae068a

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-255-gc54ac0d392ce5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-255-gc54ac0d392ce5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624f6c7932e8add42fae06ac
        failing since 32 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-07T22:57:53.673589  <8>[   35.871878] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-07T22:57:54.687470  /lava-6048441/1/../bin/lava-test-case   =

 =20
