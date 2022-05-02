Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D223F516E88
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 13:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiEBLLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 07:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384927AbiEBLJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 07:09:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C21114080
        for <stable@vger.kernel.org>; Mon,  2 May 2022 04:06:05 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso7072344pjb.5
        for <stable@vger.kernel.org>; Mon, 02 May 2022 04:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tw9t3xVx4kmM1kmVV7DIODfQqOAh9NnVSHOclrJ7TPs=;
        b=hZfitWBZvGjxeBw6wfz6RTpGXoYdeGW7hzG1V7dMpmuaPJ6MDvmmscRpdaPkk6BZBJ
         3W6d1mWBOnUermvG2uZaPVI3ZgYamktRSrhMXaRW07vzm5IFaojyhIJ0qCGyDxSTpzxb
         WWlsAeVGKmMxik+4+VUMGDkIj+r1Zs630fo9ZxZSzxZhHkVbYaQ4PRloxnFiFCWqqR+o
         csXJi4Ssw5QhgoaDLw3PJpMoW007klzvVuv52TDoQ46gK3XjN83Lfs7BUZqBRrdkWEJ2
         F0wyMMaqmMXerVIRhFZqlXZEXo/8Q3b7HjDeh0dLhkrjMvBQLic5DuPf6trcNQg+Xq44
         9iZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tw9t3xVx4kmM1kmVV7DIODfQqOAh9NnVSHOclrJ7TPs=;
        b=W8Ab/Rwayw5IXdBAetKdaxMgPKb7zDs6tMgBZhGAGw5A0AN6ZdNu2AAPNFYV/sqWWQ
         ZWb7MxnMJcMRsbS8kNXIfFB5h5Dtwv+sTZdJkLMALJ5rQZQ2IAo+V/M/4s/hGdok9WOD
         SaIcDmzQnlGaWGg5/ry95omnmErCrSSanWDeVURLkRvXWxooREGVWqsYKjuVWhlxyFaw
         UPUAOwf/lz53KXzdyXO27FuBRVMT7ZpWM26pj7aZcBTJVyMxqY1H3AfRt2JIfbA6az4e
         ETFaNIoQe6XWqubgHSB9dJ1U12df/Qm32jXrTZwaWGpgWf+C6JaxwyfroAFtwZoOE+Yn
         9Xdg==
X-Gm-Message-State: AOAM5334QOkpz0T5F0LXjASPHg4POBPvg32v50t4KA753cecUNsEVVM/
        ZoOmvi+XysODW1HkPQNwUG9OJuQgoBrJBKLhlII=
X-Google-Smtp-Source: ABdhPJy/BiWCGU3MCjEOhM4bkv+0jaX5SWWEFENJzpgOtlFEE1aMs6ZFIDqak8FZMOGRx+9fwEsK7w==
X-Received: by 2002:a17:90a:e008:b0:1d9:2f9a:b7f1 with SMTP id u8-20020a17090ae00800b001d92f9ab7f1mr17386320pjy.173.1651489564769;
        Mon, 02 May 2022 04:06:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10-20020aa78b4a000000b0050dc7628177sm4425004pfd.81.2022.05.02.04.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 04:06:04 -0700 (PDT)
Message-ID: <626fbb1c.1c69fb81.d713d.ac06@mx.google.com>
Date:   Mon, 02 May 2022 04:06:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.113-12-g24a08a16e1e1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 120 runs,
 1 regressions (v5.10.113-12-g24a08a16e1e1)
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

stable-rc/queue/5.10 baseline: 120 runs, 1 regressions (v5.10.113-12-g24a08=
a16e1e1)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.113-12-g24a08a16e1e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.113-12-g24a08a16e1e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      24a08a16e1e140c0e27e9eb5a29747ad39fb0a00 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/626ec359f8b7db84f3bf5fe1

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-12-g24a08a16e1e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-12-g24a08a16e1e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/626ec359f8b7db84f3bf6003
        failing since 54 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-05-01T17:28:50.450341  <8>[   60.068855] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-01T17:28:51.473953  /lava-6230012/1/../bin/lava-test-case   =

 =20
