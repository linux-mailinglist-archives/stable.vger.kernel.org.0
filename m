Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E9157EB00
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 03:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiGWBMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 21:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiGWBMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 21:12:49 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7CE8AB3C
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 18:12:48 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 6so5662669pgb.13
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 18:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b8vmKkUF6iIg4PbfSwRTrVHPefu47tLhJSmZXocdWOk=;
        b=hTAAkskcZTkO3fR/oM4TU5DSlrLSE4kAhfWvuqPkmAPYIdWfevpzW0tlaO/q7vt/JG
         6X4FbmQyKa5BT1343XBSbGdiP2J7S4erhkC7SjIZAM0kJPcrjVvq3mwC2LZpFgk6+iK8
         uMa+v986nhOfdjvbiEPo+H6BswAlStqW+V1Ol1TjiGZaPSkUzOlf2gWjKZpWkTWijxIW
         W7TKm7k/JY2locAg78XpcAF5OQue9waH+nYNzfpiPok/adW8JcYGAwfCJJ8o6ObHK28T
         oQZiERzO/eLLejnbbUjrt5My4f9qZ5slCRB3+nZbjTmuvjZ+dIOEmrBgGW6JQw96LZwj
         rONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b8vmKkUF6iIg4PbfSwRTrVHPefu47tLhJSmZXocdWOk=;
        b=QsGg2zF7j4X8WwxbcFs/sAnzfhvpvpbBmEJqTbBx26gbgxHidav6JnWqVuKohjGumW
         ddcWN7BNwuj+IxudBP6voDNeZDLzmWXRn5Qh0Tr3GG4rntYcsCbXKnBykdO16VqhKBz7
         loY3vZwKg4xUnBMe0pUsYVwDiJiSPN2xKIkzMIvG7JMknAGyhLJx3ksoKWOI9+dSlzdT
         wy1oKZU3k9BrgnuTwve+pXIzvfpNt2L4120tXHlauHA8fdB0dSSemuq2qS6XrzraGt1N
         s+GritUFPtTZY9CV27ujiDq38rZnRxBMxBEmuFJHUjiOikiBo+mJE4AGdl3zPWKuQXq5
         J+oA==
X-Gm-Message-State: AJIora80gn28eG0UB/jPyMf432qG6jpEABmLYYXe2gieBTscUx+snY92
        aQy3iwB28NPau7X7VIyJJKzHVDfbhZ0EBhWS
X-Google-Smtp-Source: AGRyM1sm1HpzsGYQhDm9pLd5GED2b85bCdnYUqLF76Ku4M4VWzAdxLehJkG3EpIACaJCNfifpuJgZw==
X-Received: by 2002:a05:6a00:815:b0:52a:dea8:269b with SMTP id m21-20020a056a00081500b0052adea8269bmr2504735pfk.66.1658538768090;
        Fri, 22 Jul 2022 18:12:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d26-20020a634f1a000000b004088f213f68sm4079176pgb.56.2022.07.22.18.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 18:12:47 -0700 (PDT)
Message-ID: <62db4b0f.1c69fb81.1f2db.66c7@mx.google.com>
Date:   Fri, 22 Jul 2022 18:12:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.56-90-g377c0f983cd9
Subject: stable-rc/linux-5.15.y baseline: 173 runs,
 2 regressions (v5.15.56-90-g377c0f983cd9)
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

stable-rc/linux-5.15.y baseline: 173 runs, 2 regressions (v5.15.56-90-g377c=
0f983cd9)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.56-90-g377c0f983cd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.56-90-g377c0f983cd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      377c0f983cd943f563003e5be4947692afba815c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62db180b5c053b8c26daf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
6-90-g377c0f983cd9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
6-90-g377c0f983cd9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62db180b5c053b8c26daf=
07b
        failing since 71 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62db19913d28b58732daf07f

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
6-90-g377c0f983cd9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
6-90-g377c0f983cd9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62db19913d28b58732daf0a1
        failing since 137 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-07-22T21:41:14.543860  <8>[   32.821880] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-07-22T21:41:15.566809  /lava-6872419/1/../bin/lava-test-case   =

 =20
