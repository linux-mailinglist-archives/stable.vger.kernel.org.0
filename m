Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304BE4AAD95
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 04:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiBFDFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 22:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiBFDFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 22:05:12 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6579C043186
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 19:05:10 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c9so8515738plg.11
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 19:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4sbfC9spKTdX+uyGaTWw3IYwZXOGhNvQj8/MX7SjPnI=;
        b=6YUiBoi3uKMHgf9pWILdRI618FBuIoZE4jffd8KuOPmBBzkjaUsCqqWeIb1zPE3yQc
         zXKvmQPmlUH0/qH64JSxAdFjhrK7msdhdpdRDISqYrPVBQwAcMPX2tDMVmmO1DUuAZu+
         qNO3Vc3fva38Zlmqfna/eRw9ssV2CGrek/cfHvqI/gMmgr6zPxaNq27sA5nek4qr820i
         m9591cHr7UqWSLQD31l6VgjE39bjwsHkVGj0pEaQc7GfA3ked0OlUo6fUgJnLNQs01nP
         ef5mwYfMpcgkFqkus1T9eRU6lNmc/AT8xB5C4Km89mKSzaM4necAotx6awCxxo4wTGW2
         BkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4sbfC9spKTdX+uyGaTWw3IYwZXOGhNvQj8/MX7SjPnI=;
        b=hPqtX7+fa7fq/RibqefUN3OmVwbEKdXUQwkLjWbmxR9J3pt5mUjsE1i1Xfjwd530Ue
         0lIzdNlrN1IK3Pupp4vsAEWfHHVRVE8tM9uTclcZ6McWOaP+wvVFp0HbkpfY/s31DM+F
         YkctKQbnFnwh29O4i5pvJJr9RxKF3EcXr/tqopD7ISHKrZYeSmBMs7wVyjqa7nvVPe5u
         EsWiUVVLy4x6+zUL6gLegSzPCUxkgBYCCG+4tEWGmTWWsrjOK4wT1Mt4o9AL/e8L5Qxb
         aWmC3EGCFakAy5WMoDFODrrO6rHRe4xAVEKVn3npSRIPUwk73JB4gw40J3oDAzwLrH01
         p5Aw==
X-Gm-Message-State: AOAM533kLc5FHtb7Ww5KYHspwbSIPoA5fNO2TT80J0Nf+S8vE+sZgK2Z
        DWuO5ipIPWEFGCpMMgCu8Av4ovqJJIy3MHum
X-Google-Smtp-Source: ABdhPJy/maTlrok9cyieSAaSC+1yQ6YWxuT9NPUzT+/zHK2xfguPV+XIT5/sMeh9Vn3YoLWvA7Mzkw==
X-Received: by 2002:a17:902:a50f:: with SMTP id s15mr10598067plq.118.1644116709899;
        Sat, 05 Feb 2022 19:05:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d15sm7073355pfu.127.2022.02.05.19.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 19:05:09 -0800 (PST)
Message-ID: <61ff3ae5.1c69fb81.a4344.28c1@mx.google.com>
Date:   Sat, 05 Feb 2022 19:05:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 160 runs, 1 regressions (v4.14.264)
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

stable-rc/linux-4.14.y baseline: 160 runs, 1 regressions (v4.14.264)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.264/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.264
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b86ee2b7ae42b6b37a918b66236608e2cc325f59 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f546512d40e78244abbd2e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
64/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
64/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f546512d40e78=
244abbd34
        failing since 15 days (last pass: v4.14.262, first fail: v4.14.262-=
9-gcd595a3cc321)
        2 lines

    2022-02-03T10:16:06.746905  [   19.899017] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T10:16:06.789117  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2022-02-03T10:16:06.798688  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-03T10:16:06.814693  [   19.968353] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
