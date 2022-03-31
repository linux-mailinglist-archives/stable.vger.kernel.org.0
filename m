Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65324ED3FC
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 08:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiCaGig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 02:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiCaGig (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 02:38:36 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91274103DBA
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 23:36:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id x2so22534208plm.7
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 23:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A7jHOMwbzGL65Me1g6XcLiknc5B+sKb+RIYfrtXzG78=;
        b=yfdYxOW3RX7WReKKaVzp8YuvxsZdX6wNGquSSyMotSEB7TDP0dWGUrz8stWwqKjP+j
         lbSvgTSJk/0f/IKIngvV5EA8uakWSKTZhGCxvKrizhW1zQcUi2xWvULEwLm6bQ5X37RG
         LWM82+lC/I4zJCMy41ck7IKNRSR3EMp1I7zB0u8vXbJVE/6mc2bjiMZRwewFup4kPweR
         3BeWd8xKYhHHEZeeSQuv4IPma08AF/5QD7d9WiVzmS1kX8+XFlb7cGlSiYEkTmDHvlhq
         Mtbxz4Pg1Kio9CKQm40ytZWNLnTiYrm1nhvubcy1JrqqXopNulJUbzuTrZupANmQio5Q
         2WMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A7jHOMwbzGL65Me1g6XcLiknc5B+sKb+RIYfrtXzG78=;
        b=PqR+2ezvXRoAtY7QkzqHHCC3ABCmClbCAWNKow0OOWKp28I6JTF54bOzVuFMgykmnE
         nvi/HOpKiIa6Lqm8eqlMZkCU5R3mRDTs/kNeOEOzZ/UpMerKZ7ZpVSEjgw7oeNZ033B/
         54KXBVd6TEgmhxobm70f3r9Ws5zTRwGEfqZyeQaz9Ph6v4DPrNYRibagO0pzfvIafL6s
         2OyFJ6jL0LMp+8aAgyIgmDejUIwlQ/utuTjs6Qvi945HhUgQXXFD2hI3m3c56i880RF0
         GlfzQRpL/7koNZmbji3/BQSvTlmaAlMj3tKMB46LCzOItfaCY3DDcG73xLpexiztJgBK
         d/RQ==
X-Gm-Message-State: AOAM530tnesT2744nTTJ7Hu1IkuBSRXRFpUJOSntXyhpbyeS6XIahcRj
        kIN8EeQvpgTMR72Yj8vhDhe+8V3+fqTUHCiBFRQ=
X-Google-Smtp-Source: ABdhPJwn9YR4GBFWzgLC471IhSSoSlrlxCzc55wwWoLNd95uyopEEU1XywDtHo16fy8LqglKxKZpAQ==
X-Received: by 2002:a17:90b:4a48:b0:1c7:bb62:446c with SMTP id lb8-20020a17090b4a4800b001c7bb62446cmr4504656pjb.146.1648708608930;
        Wed, 30 Mar 2022 23:36:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm28365897pfl.141.2022.03.30.23.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 23:36:48 -0700 (PDT)
Message-ID: <62454c00.1c69fb81.8328a.8f77@mx.google.com>
Date:   Wed, 30 Mar 2022 23:36:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.237-13-g5afcc2452dc0
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 96 runs,
 1 regressions (v4.19.237-13-g5afcc2452dc0)
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

stable-rc/linux-4.19.y baseline: 96 runs, 1 regressions (v4.19.237-13-g5afc=
c2452dc0)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.237-13-g5afcc2452dc0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.237-13-g5afcc2452dc0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5afcc2452dc0afe5a1909c5df4e7169368d8227e =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62451c23ff2e4afedeae067f

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-13-g5afcc2452dc0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-13-g5afcc2452dc0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62451c23ff2e4afedeae06a1
        failing since 24 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-03-31T03:12:26.992508  /lava-5985566/1/../bin/lava-test-case   =

 =20
