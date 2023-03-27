Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7766CA89C
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 17:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjC0PIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 11:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjC0PIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 11:08:14 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5CE270F
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:08:13 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id z19so8739744plo.2
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679929692;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JXEopFddMwVAOFvttqzsTfsy8UlEI3cV/ZNutTHKppY=;
        b=TPtw0ije4+kGWtBbzgoCmyOJVmENaXvZ8kI/jUC0mqNAwnEg0H8nOWiHJL5QuPFTAv
         iEZQKFbSmQ7MaXJMQK7yVYuH+chU7TYOG8XVq6+/05ELgLGfVHnlcj7urd67rxEo+a2S
         wHNtmOHbm0i5vkbHxabbf5JOSKQ2CXVtgdoVjS+tpE+bj9OE9FZtn+A4XQ+xzZ72pF+W
         MCkpwTRchedURYbEtgyJF25TpZH8AjkY98LND2Kt0Cre3NNWS8aafdo0zBymuNvB/IDq
         xjvxZ+5t7CUQqaXQpweQhqsjxjvRchP768fW9/8EQNjgNJ9k8RwHdB477piv8qDkTNZ/
         A+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679929692;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JXEopFddMwVAOFvttqzsTfsy8UlEI3cV/ZNutTHKppY=;
        b=Y+5Az5XUVXv/DiDy91Boc7dCVV0SKzECgC05urcf2MGDNnfNYiZ9ZbZAyQ9XYO3Xu+
         tdZBBrxnzw7fBeft/EN2nZPXFbaIgLvB7KhKK6F3Jqtu553xTGBO7WWEXbgXpyDttila
         4jZyKxxldoY7fVawm99iwnXcSiO76X/vYJJE5QZLwF99PHV0y1Azy8Y5KtuvpByQtbtW
         rNEbUJlAXHHIbrsMaI3p+gEZV4KEN6j4qCsrJ1lLIJs9Qwm3JljsdGDf4hi76sk/Yfax
         VGiRtZiBmnSyKg59+Ym3E3e8aZjW00fQ4SCTiMiI254ZPcYUmX6C7WaOda3+EBHsWCxd
         OxdQ==
X-Gm-Message-State: AO0yUKWdvxD7wJIrhTI0Q74OqIWF6JvpnM9W3Ko7+wmOSoiGutiTsTxb
        +rsVpozDiOSu9nf9+GUGLciXLwe+OR4AESZtlJP6IA==
X-Google-Smtp-Source: AK7set+AZLfG2AOB23pyBITQ0eChSVF2JZ0cOwcN5YOVq2qPcSCkxXOQscZ3jbYL91rwEBu3DX7JyQ==
X-Received: by 2002:a05:6a20:7a98:b0:cc:868f:37b3 with SMTP id u24-20020a056a207a9800b000cc868f37b3mr10608587pzh.58.1679929692690;
        Mon, 27 Mar 2023 08:08:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n15-20020a62e50f000000b0062cf75a9e6bsm4264994pff.131.2023.03.27.08.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:08:12 -0700 (PDT)
Message-ID: <6421b15c.620a0220.4b2af.63ff@mx.google.com>
Date:   Mon, 27 Mar 2023 08:08:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.21-104-gd5eb32be5b26
Subject: stable-rc/queue/6.1 baseline: 124 runs,
 1 regressions (v6.1.21-104-gd5eb32be5b26)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 124 runs, 1 regressions (v6.1.21-104-gd5eb32b=
e5b26)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.21-104-gd5eb32be5b26/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.21-104-gd5eb32be5b26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d5eb32be5b269f7eb1237be53f2628d1a6a38d7e =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/642174fafb9934c4919c9533

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-10=
4-gd5eb32be5b26/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-10=
4-gd5eb32be5b26/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642174fafb9934c4919c956a
        new failure (last pass: v6.1.21-102-g4da819332d9b)

    2023-03-27T10:50:07.741742  + set +x
    2023-03-27T10:50:07.745435  <8>[   16.692334] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 234838_1.5.2.4.1>
    2023-03-27T10:50:07.860323  / # #
    2023-03-27T10:50:07.962840  export SHELL=3D/bin/sh
    2023-03-27T10:50:07.963434  #
    2023-03-27T10:50:08.065008  / # export SHELL=3D/bin/sh. /lava-234838/en=
vironment
    2023-03-27T10:50:08.065697  =

    2023-03-27T10:50:08.167945  / # . /lava-234838/environment/lava-234838/=
bin/lava-test-runner /lava-234838/1
    2023-03-27T10:50:08.169795  =

    2023-03-27T10:50:08.176516  / # /lava-234838/bin/lava-test-runner /lava=
-234838/1 =

    ... (14 line(s) more)  =

 =20
