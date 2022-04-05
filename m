Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F164F47CA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbiDEVUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457513AbiDEQDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 12:03:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A83FF6
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 08:56:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso2997582pju.1
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 08:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VhB0YLMqNI0ODvOKJz0BNqBAsmeQobkjUwgXcJK9ZYA=;
        b=sqYcWCXfPfLbO2silYEbUhl2xta7WGLq89qpFDTBJfDxlWyqT53dIhbmeJy8NYR//C
         VKPLOJ2IGcOkKgo2Aqb+sl/SQtpWOtY639bqJcbcC4dSaHs5e0EpxDcyYIC8Zh3SjU+A
         YPjkBPzHCB99XYLXTgU/DzqHj8CQLqT9a1jRX/l6BWoxAWeA9Ivq2vWd85x0yfUcp3jf
         68anNDgcMQI3AtRIK+i4IhR7KucpWHtg065avPCiRM7a6hKxozAiLp/AMbi/+ykZYFAE
         SuCaU31aGF3CmW8zcuO4a57KstVHh5vKbVl2e8WsVWN1ioAfB11bhkM7kWgk3OaUuN8G
         267A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VhB0YLMqNI0ODvOKJz0BNqBAsmeQobkjUwgXcJK9ZYA=;
        b=c33knIpzSCvKL3e3q35Fp1s++IyR8/4yHxF0r5ndbQak1t7/svZyel2Ogi+rSy/uUz
         m3yc1ku8CFD3I531OBrmpB7GEddvP02uy7ZaPi9lgPNHF9erJ7eX2qZJ3H7BsyydFda2
         ucmqf+C2IRcFMjDvd88aLFrNFQNg6KRJYahxsi1+m2AVkg2rYpMpF05l2LLYjug2+cM/
         pMtOlb9UKBcag/rqzFzX3lSyvXbSZJn7GfkZ6rxYLS83Q7Xx9v0iRdqjH828We34H3mr
         wfttDsDls1gQiwhf9mVKQiyG3b4noRiY8HEqdYAjV5RPvz3GBxLynvSDazHbBLzj3DO+
         grLg==
X-Gm-Message-State: AOAM533qY0wo1lW71NiNb4bLJ/w0uMY8lMMWo9V8y4hy2FMn2+ydboIs
        QZd19CzMaKzAkbsnaLJZLOQUIymkEGGEBFNfAsc=
X-Google-Smtp-Source: ABdhPJyW1+dzwx7z+tpto2cxr9Lg+mUhuowPk1OsH2jC7+ehWek1cXNCoC8vACj7OioQDk+ipbPoMg==
X-Received: by 2002:a17:90a:ea0e:b0:1ca:c6a0:c1a7 with SMTP id w14-20020a17090aea0e00b001cac6a0c1a7mr4845687pjy.224.1649174206255;
        Tue, 05 Apr 2022 08:56:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78649000000b004fe3d6c1731sm3248383pfo.175.2022.04.05.08.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 08:56:45 -0700 (PDT)
Message-ID: <624c66bd.1c69fb81.cd506.9190@mx.google.com>
Date:   Tue, 05 Apr 2022 08:56:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.32-913-gd3d5141968f0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 62 runs,
 1 regressions (v5.15.32-913-gd3d5141968f0)
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

stable-rc/queue/5.15 baseline: 62 runs, 1 regressions (v5.15.32-913-gd3d514=
1968f0)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.32-913-gd3d5141968f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.32-913-gd3d5141968f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d3d5141968f03f7fa39771e6600d80c88c6af631 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624c4553e7938ee445ae06f7

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
913-gd3d5141968f0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
913-gd3d5141968f0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624c4553e7938ee445ae0719
        failing since 28 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-05T13:33:45.108971  <8>[   32.918507] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-05T13:33:46.131411  /lava-6026976/1/../bin/lava-test-case   =

 =20
