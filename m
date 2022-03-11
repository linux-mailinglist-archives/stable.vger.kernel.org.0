Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1484D5B59
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 07:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344996AbiCKGJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 01:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347302AbiCKGJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 01:09:31 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B40F9F8E
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 22:08:24 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso10297433pjb.0
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 22:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eTnbRWC7TxzN1NLalAbF5zuJ/dydEbuRIrHy5sAgKvM=;
        b=zbbMrjcDcgaXumxMYqYFJhVNIpIX3ZYhSfqVpdtbzW+zPpxNBvXFvxwQBYNLHqDyOU
         u0gVnsGKAEr2oWgdhDpViWTS/uhaI2kkgAMZXTx90kc6aLOzpsk6i5u5pqhN2CwfvbZY
         BBuEIIwZrjDjbi1VUrByL/k2f1b3sq9LbaoBzt1hnQbdeKdE7VQ3ZVtSb5kvSivZor1W
         F+hHOVocxqjyRwjoAZ6XtesZGes1eNgWhJduLMKFrJyohLyqxMOqyrioUYUqKpG7dmCr
         5GSiMb7bchwBv0cSiNPpGPDDB/5EAsaCuW48l3u+gO5UVN2T4Q377pUS/9EUrLgZTtSn
         nexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eTnbRWC7TxzN1NLalAbF5zuJ/dydEbuRIrHy5sAgKvM=;
        b=p3kF2ax5j/vyUOvwjvOQCsZVqZhx/VtN4FF3txL11wlt7hcklnoBIVRJjnzVNyu5O6
         Qa7d9Y3+LjZm4IH7z6E07f98AELBACztHqVfjBkVB/2HmJAeytfmOVj4zw3hMrjHluar
         TcycqDzHuVold5MCeMao1AX/G9lSY43dRxfkKq41NvU61++PMc/HLwRHRITWtM+sp2gi
         jJbBie7s/kGbltFkslXRu3Vz554blEF8aNma9fTrVEOA6E8oZZ8th2sKcIGTvVOalQlz
         MeaDdOBAL/uBDFNvwuEf4S28jRgtqw2tErtUrExkaDj+gtiENYdmwAnj9Qnc9NXF6UkA
         8ffg==
X-Gm-Message-State: AOAM531B6k3Bsn4FISKL1ku8YhnOs+EH2BS6R3JFWQQq0DH/ne7YfHB2
        UlEfmR4Xr2yDzM50pMvkxRKNaISheH3HC1bKP4U=
X-Google-Smtp-Source: ABdhPJxsPDm00o8a9dC2Mm/P939FeK1PBvcsRvBb9LSu+YCeOXlWX3eAw4ClI8Npm613vR80jWvkHg==
X-Received: by 2002:a17:902:ec81:b0:151:f1c5:2f9f with SMTP id x1-20020a170902ec8100b00151f1c52f9fmr8768992plg.123.1646978903946;
        Thu, 10 Mar 2022 22:08:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x3-20020a623103000000b004f69e65c1b9sm8939062pfx.123.2022.03.10.22.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 22:08:23 -0800 (PST)
Message-ID: <622ae757.1c69fb81.6ff93.7d0b@mx.google.com>
Date:   Thu, 10 Mar 2022 22:08:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.104-58-gb32a9684cd06
Subject: stable-rc/queue/5.10 baseline: 94 runs,
 1 regressions (v5.10.104-58-gb32a9684cd06)
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

stable-rc/queue/5.10 baseline: 94 runs, 1 regressions (v5.10.104-58-gb32a96=
84cd06)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.104-58-gb32a9684cd06/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.104-58-gb32a9684cd06
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b32a9684cd06bdcd1dee0ee8cf407000f49d0eb9 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622aae909b2f291f85c6297e

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-58-gb32a9684cd06/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-58-gb32a9684cd06/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622aae909b2f291f85c629a2
        failing since 3 days (last pass: v5.10.103-56-ge5a40f18f4ce, first =
fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-11T02:05:50.204647  <8>[   32.711827] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-11T02:05:51.227754  /lava-5855790/1/../bin/lava-test-case
    2022-03-11T02:05:51.238854  <8>[   33.746387] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
