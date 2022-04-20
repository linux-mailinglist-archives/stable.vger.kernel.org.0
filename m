Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C731A5087B1
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 14:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378394AbiDTMJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 08:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359487AbiDTMJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 08:09:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4387727FDF
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:06:49 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q12so1407877pgj.13
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/MAwSAm3221Clv6a2hw/u+Cc/qAoSSNG8o5aY2Xv/00=;
        b=0A1QufAFt0tN/wAR3y80NfEUmIWSUIOqMzUqIR52GNfx09cPASm4HJp8R2oMeDLerD
         qFsPOEkjc8C1KaqBtYn1+Lwt8TXpFA24uiA3WOJZWycjYBveQ0Rd0FxjULWKuRn7kjDc
         nm8R/ecTZsf7kn3+G3s8y1TLBPlUOY/PDfaIXFoa41lAjrYSfaQeVfmTdy2baqlIWd84
         zMeqPxk9g5gONSA3AXghJpbSYhtwgRAQjyq4n8RqjB7I1hxB31w+MeQbAktZO/8Jcg8E
         XHtAl4PVFArfdx6/695k4Rwl69YYtp8+jYgOQjJZdjVZg/D2sKeup1SM+4s/c+e8NusP
         wk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/MAwSAm3221Clv6a2hw/u+Cc/qAoSSNG8o5aY2Xv/00=;
        b=IP6Ftx7xLwTCmk5imhNDjUKezT/hR05cypKPBOJNr0Ai80VZH1FtyUK7MH27RxVSD2
         urGMEgYz0LN4ZRXLWrT/0SZwqgB51MFL/Hb5wTZQtG2db/th9lWG7z7BH2jA5uTBmSBR
         5/oJ2HK0cuuyfUknF2HHZB4zOaO2XNge24WI0ttPV/Ulmb5YBc8aD4LjO6m714PDLP8h
         2DAyYf6mQ5+J6YzKPH8wwW4FpW+/hwLrbJC751LvdsySLD4a+X2z4Y0wfkBAdKLvK88t
         8IYlMmS7a9kYC5P8aqhvM7yl+7DgDZsfpQ/ZnljQIy1AeS1RkUqZ8yQhDMOSn5uS35Bt
         RDdQ==
X-Gm-Message-State: AOAM531FjtcRj4Na7NcclFuFOrbE3TSH2Bh29MdwR1AnkBD5jm+LQosb
        pLVN6L80BK+9rzKxZN9R6ULKOuBhrinrRlWA
X-Google-Smtp-Source: ABdhPJwymGk5mnse9b7iz8yY2aOm4v1Q+A+GJQUT+yr++sOrRo1vvr/7OqeobI2u38vojOUY1IUxog==
X-Received: by 2002:a62:e302:0:b0:506:1fcb:20f0 with SMTP id g2-20020a62e302000000b005061fcb20f0mr23029793pfh.72.1650456408616;
        Wed, 20 Apr 2022 05:06:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c16-20020a631c50000000b003a39244fe8esm15215481pgm.68.2022.04.20.05.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 05:06:48 -0700 (PDT)
Message-ID: <625ff758.1c69fb81.aa38.200b@mx.google.com>
Date:   Wed, 20 Apr 2022 05:06:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.112
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 134 runs, 1 regressions (v5.10.112)
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

stable/linux-5.10.y baseline: 134 runs, 1 regressions (v5.10.112)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.112/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.112
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1052f9bce62982023737a95b7ff1ad26a5149af6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625fc6a3a5d6a39aeeae06b6

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.112/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.112/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625fc6a3a5d6a39aeeae06d8
        failing since 42 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-04-20T08:38:44.028222  /lava-6129291/1/../bin/lava-test-case   =

 =20
