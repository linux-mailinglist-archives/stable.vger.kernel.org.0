Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0C652076D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 00:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiEIWTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 18:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiEIWTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 18:19:50 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F291F40A3A
        for <stable@vger.kernel.org>; Mon,  9 May 2022 15:15:52 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e5so13156325pgc.5
        for <stable@vger.kernel.org>; Mon, 09 May 2022 15:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L9Mw3GGSw2I1PqOK6lMIg4N45Y6KkHBypN+dO1jW9O0=;
        b=Djipxr7RC632WaAj+fwIJ4QFJNZsyOG9bc9ecNEu2OjesdClXJc2wWLsXLr+Y9KM/z
         1Vyoc95h4XmjuzKj2XkeVqWdCIyBCa/Odw1CukZ1hUdo8XYb47qK+57NfVVkYeXQMOm1
         gtAydCif/JgsAgJhBcNiPZMRRBIsNo+/Ag+mKwrfoCImsFmF1Kfg2WCqFIKLFuA5Znbw
         fgC8j59Dm88vmcrxQMblftRIfFqy/syiJXPiyHZiGvDSnGNexQLujJAxDdxZlYRjMFv4
         UEOFultGJ9kGImupzyOOnr7NtzCgqnUjIcVvyFS05rgUDXCkK6G/A89+HaF3v82mm2Yz
         gIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L9Mw3GGSw2I1PqOK6lMIg4N45Y6KkHBypN+dO1jW9O0=;
        b=Lj9642qjiBpdfokJfpq0dKrCDzqRO+A3WgpgdvksJLsqu/HuhLgBmeu/D+TtMutHmJ
         S3zSumbcYGS2MfBqdi43Tj+qw2GG8oZvgrCwcq41mEHGz5gtRR0YDD5/wYPTlHEf0qlZ
         xJ4OvA8qeZh+IseJk/MtitSv5c1LDGhlVCvyUT+y/MTeQl1XQtU2mjUfkF6mFO05gW4e
         xBPNizJaeDihQmOkQrEGk4yBF3DgxR4e08iGaZDxiWcCUU6QxfEfQ5r0QYmYxLnxI71C
         44vnGqwu3nDterZmcgLo77z4RmqiW+uG9RgkVm8qAiW1YZmjt9G67GVflUkPcbvkanJy
         wsZg==
X-Gm-Message-State: AOAM530rm3XqwJ3DZWYoZVLBuIIcfKI3eGdaKUMZaBoYmBpaSagnpsBv
        nL2UK5mr3ccml3+duyqfsGZ3BLk0+GOYUjg78Ig=
X-Google-Smtp-Source: ABdhPJwbn44OmzeBcYtx33RYuuavl3UV23crHWDiinkrQCaUhtm+pjDFNW72+KfFv8h3LiZuDuhj9g==
X-Received: by 2002:a65:6217:0:b0:3c6:1571:b971 with SMTP id d23-20020a656217000000b003c61571b971mr14737196pgv.124.1652134552389;
        Mon, 09 May 2022 15:15:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u15-20020a170902e5cf00b0015ed19cbfd8sm362136plf.150.2022.05.09.15.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:15:51 -0700 (PDT)
Message-ID: <62799297.1c69fb81.e714d.1602@mx.google.com>
Date:   Mon, 09 May 2022 15:15:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.38
Subject: stable/linux-5.15.y baseline: 189 runs, 1 regressions (v5.15.38)
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

stable/linux-5.15.y baseline: 189 runs, 1 regressions (v5.15.38)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.38/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3fbf24b73f4a5bc8fd39a6b7a29145451c1039ce =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627932e1901a0fc92b8f5718

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.38/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.38/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627932e1901a0fc92b8f5739
        failing since 61 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-05-09T15:27:08.189167  /lava-6309338/1/../bin/lava-test-case
    2022-05-09T15:27:08.199865  <8>[   33.586739] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
