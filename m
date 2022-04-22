Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1369550C0A5
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 22:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiDVUPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 16:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiDVUPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 16:15:51 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F8623957A
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 13:07:46 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y14so8178197pfe.10
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 13:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yPTFoKHW+Drpvjy1hhoBoLN6u0m6WdnqjYstQFNUaS0=;
        b=cpJOGMz/cIdLj1RX222FCZmFAaEjvQ7m38bQzEgZIV3Ca1m/cOyHqvsZJgRAqiv240
         D+9545cJFDPUEQ+gKGmK1cqFSNACIhe9FMo+W4HJjGhSV7yQTHTuC2+ggN4qdCFDC36t
         xIJub90az2q9kGhnbIh47XuhLqh9dpSBKEM0eOms/n1TpPF+0e7lHQd4TCHkU5IO66kS
         RffI1SMXuzufPT9+lWvV4B/6ZueRE+r/ONRwD5UBuP3vyhwIDSwjZTCSeLW6u4Z/iHZP
         ejQo5Q+hNMh7BRmqwH4XjeDrtOQkKMlvoK8Uo6kabvxZ4U2bM26ww/VRg4O+c2D23ZfI
         Lx8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yPTFoKHW+Drpvjy1hhoBoLN6u0m6WdnqjYstQFNUaS0=;
        b=rFRVuHUCCktMYrLYQU5Dn1u6To6J466f5x/XnLtTOOh99qCamwxMGhHYWlCY09mtf0
         hyffEDuVR0Gezn27TjM+SpqNnX2FPwy/LrETLLuSDV+yMPZfvgHHpvK3mUgczM0cLmQs
         Is/kUid1YfFxKTrjuLdPiAO6V6WvZMsiEAk8R47APmz9zzWp0rBRinsthGtmcLv5T+iK
         MdIDosbVPJAqadSi85CjrLfuTm0ecTaPBGOcWQUQqi/Ah31OHSxAHD8+p93lsjaRRd9y
         /alDSvcjgtrgWpXYbLFxk2nYm5j3SXoLUeGYjAbo4LBdtv+OSTccxQ3W3QNtxfufyeiG
         GRRw==
X-Gm-Message-State: AOAM533Y3KrxhjD9Q07Eb/lgMM1MxSXwm195bjlXsmXwRFtTQiux6P8F
        DCBCMDwICAaYBZlyuoSE/FBh6M48OjKzyfhM8jk=
X-Google-Smtp-Source: ABdhPJxvUDV2nq5iouEuW8VnxBX3xVLSOj2g7qr87fnsNQ63oWYalhBRsVDnJMXBzTc13qe6v+rS7A==
X-Received: by 2002:a63:e146:0:b0:39d:1b00:e475 with SMTP id h6-20020a63e146000000b0039d1b00e475mr5281577pgk.537.1650656971948;
        Fri, 22 Apr 2022 12:49:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10-20020a056a00088a00b004f7ceff389esm3644159pfj.152.2022.04.22.12.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 12:49:31 -0700 (PDT)
Message-ID: <626306cb.1c69fb81.78b3.8d75@mx.google.com>
Date:   Fri, 22 Apr 2022 12:49:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.112-5-g01ffcf58029e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 97 runs,
 1 regressions (v5.10.112-5-g01ffcf58029e)
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

stable-rc/queue/5.10 baseline: 97 runs, 1 regressions (v5.10.112-5-g01ffcf5=
8029e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.112-5-g01ffcf58029e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.112-5-g01ffcf58029e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01ffcf58029e1cb991048a6e4a7806a45df360a0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6262d7be974194d8ffff947a

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-5-g01ffcf58029e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-5-g01ffcf58029e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6262d7bf974194d8ffff94a0
        failing since 45 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-22T16:28:31.915332  /lava-6155508/1/../bin/lava-test-case
    2022-04-22T16:28:31.925709  <8>[   61.083902] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
