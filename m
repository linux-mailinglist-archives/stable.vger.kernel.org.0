Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6EA504F06
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 12:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbiDRKyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 06:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiDRKyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 06:54:24 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0441115FFB
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:51:46 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c12so12044486plr.6
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UBjn1WZ2Kfz+52hOEfxQm/6Lk/BaX9M4mOzqhmluOa0=;
        b=bqh8/1zKirPsBb1YTUuTqsyhoVwl1No+HBDMRWAdSiSnpHJttCzCTzhXGpX5NloqLP
         67K+1/69igFlSHkdQ35f+fO9CCS/25lBRokHMXHmnzRVPrjwdgFE9OHlOGpEUZyv+6zf
         EzCR0KD0iWdBCBa81DBsp4Rqn08ksXDkUKO4GWIYoXxz6p0kh3t+bCvkJvv1C9hcO65d
         eweZAlpE5QOTwH31m7GSeYCoMarqYGHNRMHK2QVLkq4mq0iLUKWiJoL3wcvdgjzq8YjW
         M34V6n69hMaARzCsIMLuqdTSZdUvNh9VyVrozgTsNrzxJyuweg+ks3s4+Ld3egz93J/9
         3dbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UBjn1WZ2Kfz+52hOEfxQm/6Lk/BaX9M4mOzqhmluOa0=;
        b=tmL2HAEF7K7Mr/bQwJZyyXWTfx6V9/trR0sKHfQCEQYJ2CVHfnMalTNeXL1LNPIECA
         7AOn/x87cq+SLOsqQj6TQpwhR5P74jZn85OZqhA5G47B4yuxYrZfFSAMnTLN03bhbrBu
         KgSckztYiyr7LB0POI6H2+31ynJkJ5Umdx2v+ER1v5aHDjOQ4el90n6wsdbTWNkpgYMg
         0T3d4cl2apypCmGxR7SWBimqRbVHH85zorfIGtxKghrIXzMSXWviGPiXfoKQ5bXmulYr
         vHqMzBDNB5yQ/Rk9C3V9c07meFVrx8DorgaX73cjNU+VDmsA8Iyt+97WtmEIkRwGmAdr
         ktag==
X-Gm-Message-State: AOAM532J+FcJDyVl7poLeCgSVFD5tiETGiI0b+OZ7CMrFa+bn9RvIgZ3
        TOCVu9n5eXdfbXGFQPL7LJgNf7L0Yoacycbo
X-Google-Smtp-Source: ABdhPJw6geV79O1jlsHtpVaMHoxrGwN9SPBPRsEdI3uAsiNqcLqeYln9Mz/mlU6UNMiSA6mexNF9sg==
X-Received: by 2002:a17:90b:4d0d:b0:1ce:ef5d:f1ef with SMTP id mw13-20020a17090b4d0d00b001ceef5df1efmr17443109pjb.91.1650279105453;
        Mon, 18 Apr 2022 03:51:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cq11-20020a056a00330b00b0050a78cf1859sm2728309pfb.181.2022.04.18.03.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 03:51:45 -0700 (PDT)
Message-ID: <625d42c1.1c69fb81.7afe2.5ce2@mx.google.com>
Date:   Mon, 18 Apr 2022 03:51:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.111
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 122 runs, 1 regressions (v5.10.111)
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

stable-rc/linux-5.10.y baseline: 122 runs, 1 regressions (v5.10.111)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.111/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.111
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c8e5cb264df8e9fbfe1309550c10bccddc922f0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625733fcfea02c2639ae0680

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
11/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
11/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625733fcfea02c2639ae06a2
        failing since 36 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-18T07:56:35.235686  /lava-6113701/1/../bin/lava-test-case
    2022-04-18T07:56:35.246470  <8>[   60.632575] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
