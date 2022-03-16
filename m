Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB62D4DB7C2
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 19:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbiCPSIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 14:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbiCPSIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 14:08:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709184D9CF
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 11:07:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so5751341pjb.3
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 11:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nWp+jyPtLUPJs3sXoyYeV+ZYdf9WNUw6IkCu2ywBh8A=;
        b=s5PMiwBfS7nUmi8FHqjHZP9QtlDfN5XnRXqvHqo+Ii9RpaID3qeSmySMXIVHcna2GK
         RnRa5SHTFc6uZfDDmoPNB1SMjbI+7XpVwdpOrtHIv7uKVTjW8NiFujZzk2zqU3cI/ddm
         LBqsvO376az2bhHCLOma8PYuEn9UE0kfD15p1ybEWKeLtR/1INI8H1MQjT3jJBQ6md9k
         hEVhMWrIfa9FvBwIhHqS8ykKsusUDyM+zVPWYvs6E9jvKKqRFxWL3McuVVJtDndAUILC
         S1yK3+HspEYSxFjcovmUT+l3RFrce/5ghPKzRHN2tBi3A5TrjfkvxMer1bw8Zq1L/Bqs
         7BGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nWp+jyPtLUPJs3sXoyYeV+ZYdf9WNUw6IkCu2ywBh8A=;
        b=RS7ooBJywYocB0Qsh3xEhN79bpQOGnWxku9G/yWhdp8wQsGnpBjyNXc4iXKcSGECrC
         0XImAG53h987UgGlBiF/2Jxli+eripjI5uT9d8cl/vG0lRe7lJpRPqqgpZsndjJm/iOC
         pCB+i87p6XPCYqLZLB8DwpqyPhpZY6+h1jywjKu79S1p2pt1zILMLbyidMKuG+TXuL6+
         h0FmvGy9iDlsvpMzvMElDPviG8NQkOHrXJr9qr/8MmWP8jQMFC7Qfe4+c0dh/ed7M3Vr
         cCc6gJGDA9LjFdIGox6d7YwscLTwhs1y6tSnGjeyqqlmRaZ8UFU3bjvprm02JW/QPsbK
         jqeg==
X-Gm-Message-State: AOAM531d/fN048EMGjPj1bq6v1MfX+TQP18gQ7bAaPRPBZyPTZEMwdOU
        ewp2DpFlO/wEneX8mkToAJkxVgV9ssDHhbSe7C4=
X-Google-Smtp-Source: ABdhPJysAlxKfpMgm4BgFJkUHYFF9nYTKu5AKpyC7oZ7CFbon0m/94Bad5Na7r7EFAnSPcr4OLG6DQ==
X-Received: by 2002:a17:902:6b8b:b0:14d:66c4:f704 with SMTP id p11-20020a1709026b8b00b0014d66c4f704mr1147645plk.53.1647454055786;
        Wed, 16 Mar 2022 11:07:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5-20020aa788c5000000b004f7a02d2724sm4301219pff.50.2022.03.16.11.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 11:07:35 -0700 (PDT)
Message-ID: <62322767.1c69fb81.fb65c.9f7b@mx.google.com>
Date:   Wed, 16 Mar 2022 11:07:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.235
Subject: stable/linux-4.19.y baseline: 75 runs, 1 regressions (v4.19.235)
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

stable/linux-4.19.y baseline: 75 runs, 1 regressions (v4.19.235)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.235/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.235
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6b481672f19259632a852d013cacd5655e8d7da8 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6231eece0b757ac6c2c62992

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.235/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.235/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6231eecf0b757ac6c2c629b8
        new failure (last pass: v4.19.231)

    2022-03-16T14:05:55.464773  /lava-5890887/1/../bin/lava-test-case
    2022-03-16T14:05:55.473602  <8>[   36.726455] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
