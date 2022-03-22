Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888CF4E363E
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 02:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbiCVB4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 21:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbiCVB4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 21:56:13 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C4D434B3
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 18:54:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso866632pjb.5
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 18:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ganxjRshiw8P/3iRtJn63Qp2a++laQRFpGZw22uZaRI=;
        b=iCsbQ1YWF6BdTEv7cF5CTXl+zw/6wbiZ5kLqrodOvmG+RFnVtaRfnv1EQ8orcHeEVF
         cNapWSalAmwH7yEyWHX9oMBt3xEFO4gXfPXbUYDRQ4MH5fma0Ya69+yS79lttDLcGq+F
         cDtRaljepa+lkLIQTWr0KIdZu27kw1XGc1UYJQ3gnn94kPqUtECGZiedpOihCgeQQUWk
         cAw2QnNM7S9joONh2amfe48geMvThmiMVNN+EVfWQRnek4HIqeQ1KMvlAIP2dADRF+Ka
         WmpetUrUf/x3M4sW1h7aqkB86UHGb3nz1hrk/FQZUfnbX48MmbFvfBba43Op4Ezyia6B
         3g0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ganxjRshiw8P/3iRtJn63Qp2a++laQRFpGZw22uZaRI=;
        b=Zc80AxjItdbBhVWl5DGp84pQC4s35yu55fIlCjJV30HeUqnx/nsHn6TR5nFaJyl/R7
         uH7Bzh+MS05VQyGBSAJM6nJ4bMnpPiTzLGBOl/wNwbO4uCMELG3pTfz197CXaxomRgKf
         q/b2yl9MB38hO0VV2SIYpdPHWR6soDvvXjZKS+At3UJlfDbyk1M3vdgbyMHVa6ATomjb
         Rzt05hjNg/T0XHsZLjciWmTEEnXJGP4oq0kO5n2GiKOvKVx4WCzgbFy8QR6tmcc5gYk9
         pCrF7+ukXHlw+Zm9IffZeNPzPXMUsReM5XCw/gaiP1NBfV8HjB6eWcHqwjigQsyaiEuX
         MUsA==
X-Gm-Message-State: AOAM530fS1m+1SnbMzUW9Jy37HLSuPsqs6wO9aQwXA306A+gxtttEXzD
        vWw9kzTlEG/TkMMtpOEQmeSBN6LROuhcR/VRE2w=
X-Google-Smtp-Source: ABdhPJykqYJ5RsJ+giVobeP6XRj/Noh9Psa+xfp5fj5X/5IAO7rudI8HD/S2bD6RHbeNBcd9lkuu0w==
X-Received: by 2002:a17:902:ea0b:b0:154:7f33:d558 with SMTP id s11-20020a170902ea0b00b001547f33d558mr1977877plg.1.1647914084620;
        Mon, 21 Mar 2022 18:54:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a001200b001c6320f8581sm657848pja.31.2022.03.21.18.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 18:54:44 -0700 (PDT)
Message-ID: <62392c64.1c69fb81.445b9.31bd@mx.google.com>
Date:   Mon, 21 Mar 2022 18:54:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.16
Subject: stable/linux-5.16.y baseline: 97 runs, 1 regressions (v5.16.16)
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

stable/linux-5.16.y baseline: 97 runs, 1 regressions (v5.16.16)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.16/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9aed648340400df7f403d41d8558244afd6d69d3 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6238fcd42a2580a396217362

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.16/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.16/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6238fcd42a2580a396217384
        failing since 12 days (last pass: v5.16.10, first fail: v5.16.13)

    2022-03-21T22:31:24.898768  /lava-5917630/1/../bin/lava-test-case
    2022-03-21T22:31:24.909721  <8>[   33.247959] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
