Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FF661241A
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 17:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiJ2PIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 11:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiJ2PIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 11:08:01 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BD2DF63
        for <stable@vger.kernel.org>; Sat, 29 Oct 2022 08:08:00 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d10so7156910pfh.6
        for <stable@vger.kernel.org>; Sat, 29 Oct 2022 08:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vUqI1h1GgWsgJKVtsveFFJMzgnnxW+pNdWIrBDG57ZE=;
        b=gfjd9v/GXWwNQPdPmHWfzWreIq4M0MWlHsjqlt2lFaombb5qZmDrNA7mrNZhN2KV1y
         2RoZKcMI9MVHd2g9uWw1g6fTdKZHS2M6rVeLJHOJK6WaGo3tC1uCEplthiNuu39EA3mM
         41dYA1t6qh+vZbfsSuG32qelVVgBgeFujW3ehZFeS+Y/jLcPgXpo/BBPzH3psxbysPUq
         JJN9Y5GaJM/CjEm0EFHYesS+U76Bdel5wTSe+7UDHq8F36x0W8f2Cz2jZe+bGKkcXBn9
         4H/Z5byfTsjkeQ1ABAWnB2ReNIfMF2xAZ/JGdSvMeTFRZEHZNe0oh6YmzeA1/vVoq+NL
         tl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vUqI1h1GgWsgJKVtsveFFJMzgnnxW+pNdWIrBDG57ZE=;
        b=3PgweziAXFy4131xKxU8uFiIF7B1AwJXQH5rvc/ayN1OjwRsPZhpObVeDNxvFz/474
         x65O6bmFn9yfly/tkMNmRS/r9brs7Q045u4STVzFVDcPwNXb+8KH5jtKL1QF38OzX/IV
         40ROFKDi+uXvxBsbVqlL+OjNDbW/PzYj7Fclrjcm+KWceBjXJCwQkt8cHy8eG91JuYXn
         6A7bHbX2Ic4T1dBqcHq0CIXjIy6aMjhZtr/UW7KkPcDqcyjbyBwrDoKZj1UF6iFw6+EB
         JOAQXjaM8Hsv8OIkyfA4jcRptiFIr19Du+j38QJNOKjTQ20zZPFQDwi858UAVWWtNx92
         Goag==
X-Gm-Message-State: ACrzQf0BRT5x0vCeCZqU0a0HW/YdKxdhmo+ywTTAK91bUdF6m7JpUtds
        A2mFgbMDNj5xv0aGeziQ8kXJusKezcm2Aqm7
X-Google-Smtp-Source: AMsMyM4N0ynvsSnAmPnB6uGtMASCBh4pZ3g693YNFZgRsjc5Ajy02Q725sA2+pUOfAbTdjBXMzQJmQ==
X-Received: by 2002:a05:6a00:84b:b0:56d:3cf5:1031 with SMTP id q11-20020a056a00084b00b0056d3cf51031mr22080pfk.75.1667056080320;
        Sat, 29 Oct 2022 08:08:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ig14-20020a17090b154e00b00213a9e1f863sm1191935pjb.4.2022.10.29.08.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 08:07:59 -0700 (PDT)
Message-ID: <635d41cf.170a0220.2b42b.1bfa@mx.google.com>
Date:   Sat, 29 Oct 2022 08:07:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.76
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 132 runs, 1 regressions (v5.15.76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 132 runs, 1 regressions (v5.15.76)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.76/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4f5365f77018349d64386b202b37e8b737236556 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635d0d73dc334440b2e7db5b

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.76/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.76/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/635d0d73dc334440b2e7db81
        failing since 234 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-10-29T11:24:19.996847  <8>[   59.835042] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-10-29T11:24:21.026557  /lava-7772888/1/../bin/lava-test-case   =

 =20
