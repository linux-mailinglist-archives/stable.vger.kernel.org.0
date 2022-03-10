Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410084D3E25
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 01:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbiCJAai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 19:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239037AbiCJAaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 19:30:24 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E645F125537
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 16:29:20 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id s11so3646206pfu.13
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 16:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZCLIKGN5d3PuuuWJaC4Ihmja+j5dOY4T8XdUQtt0reA=;
        b=5qXaQI+CJmepA0LDXsscrSVRHMZJzi6Tqh16zlKfu8FJmQU5qiKXGSoPnayXYyUZ1U
         SaVDwUCGBrcsO7yHFAulUL2/tut/ZmI/NtDBaKbwYw+ezP8krbwk3L1aXUemHb9aa5eu
         KpO7NIrlgOjClmKQu+5SwMZl/pJfFaJqLx426kS8xjwnjDZ7UfCf8e/S4zzTgQwnR8+K
         eU53kztOYF8fFPjTRVEPLnnM7DdL+BkMIE5SRBfrf6x/XNMKB0zedwfRLWYnVLIAnt4L
         68oZ/kyOSaxZA9HREjfIKuQWbsT0OCmgIO4mKPfFOx8AX3PE5jCxIKNfHfolVW/gnGN5
         3ZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZCLIKGN5d3PuuuWJaC4Ihmja+j5dOY4T8XdUQtt0reA=;
        b=MNgqM+lT/1omWuLU1LTEdIrqq3T76KzsdU5ue2bP63JnTPxMBfakPx+5CK116d6Vax
         wrqFrfkiqQkI6XqAi+eNuuUFrCAD1ox8CU2ZBKclvd8v1CTRateI1O5M35TZ7QikX0LK
         /TCU+H7/hmOtw177wBLSE3chR/dUJR+CNQTv4sFjiomNZ1cY6lLt2Kudxe6wNyPoaBEP
         q0uvGFZi9ia/O9gCkM8Ds9gkACy/n1TmIcG/45M12H/lqJ8yUcA/PYWP/N9L4zg25z1C
         LPtnBF6FhTF+VH+JznUSJ4My2O8dE7ui2hHK195yHaGZieydk7gonMzGKZxLRsBkTwY0
         GkKQ==
X-Gm-Message-State: AOAM530Lljipw50vPgPbs7DhaC1lGdCmuuu41uClqCndudi9vhmq+tfU
        CZao8QaqOKbd0shsJnl0PtOgZ96mWGbcSG0w6zI=
X-Google-Smtp-Source: ABdhPJx4f9YtzfIrIzVBF6kc8xOTd/WMIHnwdXufdg6fCHfexLQHVUSm2mDSeJG8b8DaYuDWaH7Clg==
X-Received: by 2002:a63:4560:0:b0:370:1f21:36b8 with SMTP id u32-20020a634560000000b003701f2136b8mr1839701pgk.181.1646872160151;
        Wed, 09 Mar 2022 16:29:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w5-20020a17090a6b8500b001bf564e624esm3772408pjj.39.2022.03.09.16.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:29:19 -0800 (PST)
Message-ID: <6229465f.1c69fb81.3021a.9df5@mx.google.com>
Date:   Wed, 09 Mar 2022 16:29:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.233-19-gbe15501ac1ff
Subject: stable-rc/linux-4.19.y baseline: 19 runs,
 1 regressions (v4.19.233-19-gbe15501ac1ff)
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

stable-rc/linux-4.19.y baseline: 19 runs, 1 regressions (v4.19.233-19-gbe15=
501ac1ff)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.233-19-gbe15501ac1ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.233-19-gbe15501ac1ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be15501ac1fff96964cb8880d44736bd1653295b =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62290f73c816048bcdc62985

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
33-19-gbe15501ac1ff/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
33-19-gbe15501ac1ff/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62290f73c816048bcdc629ab
        failing since 3 days (last pass: v4.19.232, first fail: v4.19.232-4=
5-g5da8d73687e7)

    2022-03-09T20:34:35.790227  <8>[   35.864746] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-09T20:34:36.801185  /lava-5847814/1/../bin/lava-test-case   =

 =20
