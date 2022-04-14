Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B07501914
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241033AbiDNQwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbiDNQwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 12:52:13 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0C6136FC3
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 09:20:56 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p10so5041881plf.9
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 09:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5RHopVtiMebEiinXAohKyzZsmr8Q5MFnKgwZl1REhUw=;
        b=DFc6MKK0MR4YQ5xXgpQZMX7e1rnMcQ0aD3j2JR49ckDmDdiFGFJNS2Xuu0cvgaBrqi
         SDJmErpk8xjojDRAMFB92V1HS0nP+cLtfbhgexS9+/i5wCnA40ukwHOQYhSENKsxpIcq
         GfxSHXPlch6P7L8wX0PECZ38iamJXJGqykRSwHvpxQL8axe2nRX0C0Lfv1ScLuTNo6Mc
         RYgECTe/t8OlMdqjkCOGJtq081htfAqvwWAm2Lj1I7MxD3PU6FvBCzoEUUntYcIIauDS
         lydfo0iUv05PcWiYQzz33CsyNzywVCs0P9/KI/y5Y4KW7Gpcx8HIINWYRO08mLcSbcjS
         rnsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5RHopVtiMebEiinXAohKyzZsmr8Q5MFnKgwZl1REhUw=;
        b=PHOjzOhNFBPtxIMRgEwSW/KOIqFlKkK3ZU/OAnPyXJUpknkma2qq27qv09U/6Dq4z0
         vB/EJULsZDd68KZxTwocnDakxQs8sPfd867suVVh8OnKmvXMUlS/UvxCSPN44t1b34+U
         xP+70vIDdVDn4K9L+uXmgKWIrBKAayfaF8AMu0+xefYFPsJRdpAvXrDLrlFfJYoeZ/WU
         B2T7HQlSeRIHxuhVkr7RgTsaANlRul0cu7g8Xh5gtN9he/cyna8zW9YCLnnKmOt0XMHp
         Rz3voBugvtlyQkEa2D9TqX6l+TfBs1/89XTNmzJOdjqQJFYcYT2sgUVWxPzowdWrw0ji
         lzvQ==
X-Gm-Message-State: AOAM531o7nESmSOt8p1quSadIUaJJ7kUd2mPKozCCnosudNsAmnvOsFh
        UTadiGhdGdA+Y2O2nPEOEwWPMMQ05nnvOgP2
X-Google-Smtp-Source: ABdhPJyARF2yo49PQ3dGyUWD0YQSZyvveb9T8s5yrt16iHFdHOwKxrm1A/A3Fpry7IXWg5vdoBDJBQ==
X-Received: by 2002:a17:902:c412:b0:158:72da:6fdd with SMTP id k18-20020a170902c41200b0015872da6fddmr17959261plk.165.1649953255738;
        Thu, 14 Apr 2022 09:20:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u9-20020a056a00158900b004faad3ae570sm364226pfk.189.2022.04.14.09.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 09:20:55 -0700 (PDT)
Message-ID: <625849e7.1c69fb81.15963.12b6@mx.google.com>
Date:   Thu, 14 Apr 2022 09:20:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.34-8-gd6f092f2f017d
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 108 runs,
 1 regressions (v5.15.34-8-gd6f092f2f017d)
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

stable-rc/linux-5.15.y baseline: 108 runs, 1 regressions (v5.15.34-8-gd6f09=
2f2f017d)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.34-8-gd6f092f2f017d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.34-8-gd6f092f2f017d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6f092f2f017ddcc67f6933c0ed066120393e9a3 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6258192f1d64a16e09ae06a8

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4-8-gd6f092f2f017d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4-8-gd6f092f2f017d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6258192f1d64a16e09ae06ca
        failing since 37 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-04-14T12:52:38.377222  /lava-6089767/1/../bin/lava-test-case
    2022-04-14T12:52:38.388105  <8>[   33.578730] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
