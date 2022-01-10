Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6189A4898A3
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 13:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245509AbiAJMcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 07:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245519AbiAJMcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 07:32:17 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039E0C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 04:32:17 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id l15so11688411pls.7
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 04:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wA3O5gKA2Xmw5eqrsgRyJU3YHLLTKNhn+LTpzj+1DC4=;
        b=0OiZDfrArBq6rLgrtPocaQJVt5i+EqA83rrXtBo76JtYMq3iBAIbyNE2q8+D6k2BC0
         qU1BCSYr1CRQArDMAKHy5GHZ5Xn5rvVSrBRaKZqpLtEQCDj1adGiqTXTnIuD/i7P8p+u
         YY2wdaDNx6IPdhJ2Bqgn2xridsRWcl91cp7c0h9Iqy500waW6x/q9UnM6S8h1YgVHL6h
         oNITXnaPZha8+SJ2kom2ULkDQLjz3F8crd6YY9XFzg9V6CZza5JPgCNCmxbxddfA8Ph7
         c6amrY6K43hNAxkpSgo+uzO2eINZQJp/K0ifQ6RAzhVV53+IHQYyhxCgI1D7UTHR+bmr
         bGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wA3O5gKA2Xmw5eqrsgRyJU3YHLLTKNhn+LTpzj+1DC4=;
        b=JcS7oc88wuO8ClzcyoMfYX6reurMFhTAYD/JV9MIMupTinADOmas925vk9NGwcL+Iz
         hc3HAzGvwhiczlqRDM1k/3NVPZOd5aca7YtCtwbzGWHd7BmlFDnj4gXnrYXTrU1Ka+Yf
         OAipbzHWmS3AIZc/jU7mv+OjAqRrgI8cz8o6eCIaIVEucq8uHYvnmmyP0RCaLMyuarRD
         5vD41OGFMekHGAY5OFlwe4uMJV2ZefdiQKttvvqryClqauK6EW+7mEG807A9JvkQafoJ
         yYaU8//NajkOojatAWi+Bm/KDpek1hrzgcYKZSQWkOsRf7DrelCW/hrIoVqtpDKV5DcC
         lIKQ==
X-Gm-Message-State: AOAM532JNcX/hkfrnMpSBnDcRn+cuzsUE9WPsalONywZ1JtllmoMO5Ww
        0EhkJHOlwZQbIRsy3dnEtp9RV4XOe6o78ZnR
X-Google-Smtp-Source: ABdhPJyLE3qgxC8vhVRlkEvjWn1ACi/AwQdhgRS1yZu+qdAsNCaAIEqZrEtLcnXqUa03CviVZNuUlA==
X-Received: by 2002:a17:902:dacf:b0:148:a2e8:2c1a with SMTP id q15-20020a170902dacf00b00148a2e82c1amr75401285plx.105.1641817936336;
        Mon, 10 Jan 2022 04:32:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3sm7209147pfc.196.2022.01.10.04.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 04:32:16 -0800 (PST)
Message-ID: <61dc2750.1c69fb81.61a0b.0953@mx.google.com>
Date:   Mon, 10 Jan 2022 04:32:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.296-22-g4b4f2250060d
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 107 runs,
 1 regressions (v4.9.296-22-g4b4f2250060d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 107 runs, 1 regressions (v4.9.296-22-g4b4f2=
250060d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.296-22-g4b4f2250060d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.296-22-g4b4f2250060d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4b4f2250060d9756a0b058c7537b77af86401c48 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dbe5f8afcbadd9b5ef6740

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.296=
-22-g4b4f2250060d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.296=
-22-g4b4f2250060d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dbe5f8afcbadd=
9b5ef6743
        failing since 6 days (last pass: v4.9.295, first fail: v4.9.295-14-=
g584e15b1cb05)
        2 lines

    2022-01-10T07:53:03.188594  [   20.405120] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-10T07:53:03.236296  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/127
    2022-01-10T07:53:03.245803  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
