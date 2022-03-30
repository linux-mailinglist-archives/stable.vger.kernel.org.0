Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6054ECF58
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 00:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiC3WJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 18:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbiC3WJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 18:09:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2173FBE3
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 15:07:18 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id jx9so22100002pjb.5
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 15:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nSTwU2bFNY4zTO6mOUZfs1jZtIdgKo40VloJp1XS3sc=;
        b=AZzK23Yt1vCDv4aJ5nb1Y2zOS7PKKSDQEzP8cVzez7wxlNyKc43JodtcOIWTm6CdYr
         A60yz1g48pXHU1tNFCgFpXTjPhV2BQcjrdKMDRBTuosxPtVmEg3I29zVeATscoFFLtZH
         IJcWAJ+dDgF2mFw9Y5chlysRjdkHWHduT+nC5HzoEaWK1unXZAjcpapwKhvgIyxqdd1h
         /pkDwMreYtTQ13nQsX+dZued/W21RA0TQjU9JwBYobR6ByN53SvOmLzOZ6Wnii8P3vsH
         4vIU2Eb4LynJgn+SUZ+njtv3XyOeyEjrWSQ8O7Fa/PC1XeNQma55oPiNQGKxZ5dAuCVK
         xMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nSTwU2bFNY4zTO6mOUZfs1jZtIdgKo40VloJp1XS3sc=;
        b=Xf96t8N4b6m5H8S2mJzxceIIRVVDdcV/FZrwq4mTeoCYQ7L/3CQ8s+1XCSooIPD2WX
         G7K2mDuRS0zZI7rP06VxEHXkuZfFcp6+UzlkSuxSoBlH3vomukLuak/OL1sGa3NjKCen
         CdzI5prcbY+dar34d1wE7Sa74fLcH847tjhYeeYTh9RZ/ATKo4kmiVkzBsUP0igLJrpa
         0sGwj/5aE/0HffvEO5867c99o5EBlXlqZ4MRqWSwFis0CgcVrMIVFbp/JLwE74SFn85i
         mDCTRe9zcgOwIG0Dy6T+lbWxXpRWPbwnCWwQfbKGwUx4uSrwsMgsB8rNzg5+R+TJul5X
         L8nw==
X-Gm-Message-State: AOAM532KIyFDNTERAXgE3q+9Bkn23rOw7ypQRLRMHS0gvl+cJmGmdRgt
        1mokeHEsIehP7rLrI012bR+hjdfAX43Gndg2OQ0=
X-Google-Smtp-Source: ABdhPJw9fvHwuqd2Wg82Wasw/0/FOZV/Oevl5p76SStU0nwPTTKVDC8nuwf331pMLr7No0EeAG/DwQ==
X-Received: by 2002:a17:902:f54c:b0:154:8227:a387 with SMTP id h12-20020a170902f54c00b001548227a387mr37238544plf.42.1648678037833;
        Wed, 30 Mar 2022 15:07:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3-20020a056a00168300b004f7e60da26csm25572784pfc.182.2022.03.30.15.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 15:07:17 -0700 (PDT)
Message-ID: <6244d495.1c69fb81.9b74b.1bde@mx.google.com>
Date:   Wed, 30 Mar 2022 15:07:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.32-29-gfa2f2eb2bbe4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 118 runs,
 1 regressions (v5.15.32-29-gfa2f2eb2bbe4)
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

stable-rc/queue/5.15 baseline: 118 runs, 1 regressions (v5.15.32-29-gfa2f2e=
b2bbe4)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.32-29-gfa2f2eb2bbe4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.32-29-gfa2f2eb2bbe4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa2f2eb2bbe4bb194e6b979aa6ea143491c4d606 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6244a43b2cd1770d66ae0680

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
29-gfa2f2eb2bbe4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
29-gfa2f2eb2bbe4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6244a43b2cd1770d66ae06a2
        failing since 22 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-30T18:40:29.092012  <8>[   32.727573] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-30T18:40:30.113729  /lava-5981814/1/../bin/lava-test-case
    2022-03-30T18:40:30.124701  <8>[   33.760584] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
