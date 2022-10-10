Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69C75F9662
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiJJAkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiJJAjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:39:12 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A358852DD8
        for <stable@vger.kernel.org>; Sun,  9 Oct 2022 17:20:00 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 129so9069560pgc.5
        for <stable@vger.kernel.org>; Sun, 09 Oct 2022 17:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=p8a0DSO9VM6VeaQFNTvlObRr3yba6aZmeQuBhrMIKzg=;
        b=yqkEovuSiKvG5G+wzOF5S/q0YvZzw4KA1MJpkLsxTZ2e7SgEPnGt4nIcrd/qCQ7AS1
         wcpOTrYj8s6CqDGZ4/cEnHo02OFtpFbdaGbPJ9Lj1GUcarb+Q5QT3PYeGP7d6bkpKgVO
         Z23AsxNwOtCy81+3e7loicGKV+OKa8t2k+C1B2oz/JrLrgN6NgncURyqKiyXc/nK8mVV
         ppu9t9iONgiwk1/kgVK2d7o4mqieS3aTGADPJAEGXe44BQINY0GA1i6PXcZPMjBbEvJr
         OawmLUnqzT/L7fq5GikmVBEvODfPiLMfhrpKLHFDUQ79UUE2Q7NL8EuX488QqS5XpQbj
         Xppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p8a0DSO9VM6VeaQFNTvlObRr3yba6aZmeQuBhrMIKzg=;
        b=YUeMOMpkDhMti5jDd2yn8n0lkxoe006AdSje4okD0NOzMDTcZvcjAmznUPc8vvPgy2
         C9zlbAw46pH2HvSlKUFNFQVJsFI1jab+VL6bRzmUgvdjkln47gLZXjwEwud6E6TTNIPe
         KJxSLpHb5HtmqQ6QlXSIXUHlnqzPG9wgUgjeuVUeFkNH/Z6RUOaREN8OtUCylpSIp5gt
         M72GwXUFM0inQysYJ1yHu75jpt6NgB+XWMoIc1U/PhHfMip8ESI3sZL7cYTacqmZh6Y5
         ZX6ZlfCI1x8u4xy1MFQqVA05j5hTiLTyvu14eeLnlTfpmyHRpXU5TNvBoKDAg45IGk8g
         jt2w==
X-Gm-Message-State: ACrzQf1BG7lmQcnVr8wUM27JyyJRHjH0LGV9D2XI0C+NSRJ282+Pvjer
        1dRJPrhA7fCGs37lfHjkRCitpEdp5Yd+c/64coM=
X-Google-Smtp-Source: AMsMyM7iyb9x2zBT8iyeJdZICeivBhkm52VLWYkBSvOQC5EgCH0N6GtgcagHbVzYt232TG/4De9JSQ==
X-Received: by 2002:a05:6a00:14d3:b0:546:e93c:4768 with SMTP id w19-20020a056a0014d300b00546e93c4768mr16424206pfu.36.1665360997242;
        Sun, 09 Oct 2022 17:16:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w124-20020a626282000000b00562784609fbsm5428759pfb.209.2022.10.09.17.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Oct 2022 17:16:36 -0700 (PDT)
Message-ID: <63436464.620a0220.6b355.93d6@mx.google.com>
Date:   Sun, 09 Oct 2022 17:16:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.147-29-gfbb6653388ae8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 112 runs,
 1 regressions (v5.10.147-29-gfbb6653388ae8)
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

stable-rc/queue/5.10 baseline: 112 runs, 1 regressions (v5.10.147-29-gfbb66=
53388ae8)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig          | regressions
---------+------+--------------+----------+--------------------+------------
panda    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.147-29-gfbb6653388ae8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.147-29-gfbb6653388ae8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fbb6653388ae84f7c6179e59659be5107b8f0578 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig          | regressions
---------+------+--------------+----------+--------------------+------------
panda    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63433311fa4be260adcab5fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-29-gfbb6653388ae8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-29-gfbb6653388ae8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63433311fa4be260adcab=
5ff
        failing since 47 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =20
