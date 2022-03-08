Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C154D0D5D
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 02:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242796AbiCHBPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 20:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbiCHBPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 20:15:41 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2E436304
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 17:14:46 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o23so15007722pgk.13
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 17:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xiQFdSgkds/QpZEZGy0i+xpLIefrqwjv4cjvLXpfg7E=;
        b=ckJo4gfnh7MpZcC0ey62qrim65ZfaIGBFd7cwtqGFnwIeAhwiPsgdLvXyvMrMKSpS+
         H2vHmS3nSK7J1fzjnG3NeEbN147UavhD/hHSkkNaB73oKJn2EYTEzcXIE0htfDzN74+1
         gQlJQZXxafXg2XSLx6n1ELr4wsKCyhikrYUeCcUaCavIglOjTkKxndlBWoxL2KD6H7dZ
         /lfGZJ0qR9dscjIFGsxUbgzMnG8looQLvGCrVPmtg7FGcjeT39q799Sad04cxT0OzIIL
         LphiU5T0/jYewjoxoX1NNu4+Ja0jXAqSm4MzppuTyZwbmL9hGk/knXWjQvSp9Gzcukwl
         wTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xiQFdSgkds/QpZEZGy0i+xpLIefrqwjv4cjvLXpfg7E=;
        b=Hok+6WbzhunOxz05RvKOGLl5TOKhBnMCh7hbg/J93ztVTgzZiBUqcGGx4MaiJbU+zt
         oUbo9bKdDf3dLFX3JhyS4dcahtd7vpRogfNKG8Nk0NAvqAXX0RXm7f7Ilwx4P8rS3Fge
         fKvnzm47S4PJQLueJuyls3y8AfK9kXhQ6djjFcwOhS4WjQ9nfnLkYmc//lpL411USXYC
         ww4YHErV1vaXaeg1XzW0I8EBbTr6hDvwp4LZBHwDjf3hgawfN5/2065XHKYvC0CnIw+a
         OQa57d7X7KQUjADKOwDSlIVm94Kumhf80p1BpMVUujmnNGNe/uv/h95ntnnGPatDBm6a
         eH6g==
X-Gm-Message-State: AOAM531tSvy/xg1rvrRkmJTRGlYb0DgTAVxBty5z1JB24+Lm229lzhLG
        BEqbVwD3kxkXQHRBURiu2cb0MYZ+Hz8xF/7YgVI=
X-Google-Smtp-Source: ABdhPJziOlxg0XfAb9epC2PQtwUPRz/OKQu4n33GClQW0hQYZUUOXIDgfffy04ZHpT/yC44HMSWG7Q==
X-Received: by 2002:a63:5f53:0:b0:37d:f237:b822 with SMTP id t80-20020a635f53000000b0037df237b822mr12076908pgb.294.1646702086151;
        Mon, 07 Mar 2022 17:14:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1-20020a630c01000000b003758d1a40easm13119127pgl.19.2022.03.07.17.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 17:14:45 -0800 (PST)
Message-ID: <6226ae05.1c69fb81.c00bc.20cc@mx.google.com>
Date:   Mon, 07 Mar 2022 17:14:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.232-52-g77cac508ebda
Subject: stable-rc/queue/4.19 baseline: 86 runs,
 1 regressions (v4.19.232-52-g77cac508ebda)
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

stable-rc/queue/4.19 baseline: 86 runs, 1 regressions (v4.19.232-52-g77cac5=
08ebda)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.232-52-g77cac508ebda/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.232-52-g77cac508ebda
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77cac508ebda6a4b835d670c84cfa1b748f53b68 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622677f159527cf156c6297c

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.232=
-52-g77cac508ebda/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.232=
-52-g77cac508ebda/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622677f159527cf156c629a2
        failing since 1 day (last pass: v4.19.232-31-g5cf846953aa2, first f=
ail: v4.19.232-44-gfd65e02206f4)

    2022-03-07T21:23:47.505016  /lava-5831397/1/../bin/lava-test-case<8>[  =
 35.816265] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s0-probed RESUL=
T=3Dpass>
    2022-03-07T21:23:47.505277  =

    2022-03-07T21:23:48.520393  /lava-5831397/1/../bin/lava-test-case   =

 =20
