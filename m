Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928254D4154
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 07:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbiCJGuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 01:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiCJGuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 01:50:10 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4D611AA17
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 22:49:09 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m22so4449997pja.0
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 22:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q08gXsZLXDPKO1UMQCX73ueEwVJwPjNwrbJQrFQaU+4=;
        b=mJ+3f1c6XwNWikEFlJsS0t6787onRrS2armc7KCA0vLebC9cWrdDp9pKCGtAOSy9De
         k5XciMxZyNwcCr2xYEY2SbsauA63L7E2WfTxDAOulbmPEYMuX/RXXHeCFi1QKsH9u03s
         Gw4wOMKfn7b6E2lGNX/AoFjXQDWpmXMyfjFk6PnOZe5+HK4A+U3ZtNdYn/X1Xg8u7H91
         Kghht6wtWF2GviPiWO5VFscJMmlTFu1gZodpMVjBhFP+zrO2zS2D+UN63fbeq2ufQNaR
         4N0IIrfY4eMIpTVdLtBA/HW24ZqnoBC8biu5SGCmJzSQ2rfwdYyzncuhawYET+mXYaoH
         Tmzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q08gXsZLXDPKO1UMQCX73ueEwVJwPjNwrbJQrFQaU+4=;
        b=iiIpLlEM8p/oHARyenv6/RSMMhStMQya7ta89ATHBrLo/cTOQVtdOak0sLw+Hm93re
         hnE1URtDhdcF0o1csM+oTf8/Y6vHcQYsxJVVqVDtoDHJ6NlySf2FNzKUTCPh75zGxqq0
         kOGE/hQPrd7Y+FktjFkClulmBCrDOkdLBezPstmVXS+h0rUMKSDwnKhJuxlp/tzJNqct
         Kdhyhs89AGNn8BoiFpY9pmORfMs2+jQvnvznNq0mhNYMSOvWJG3w/XJ9PsfWDeTK8R82
         77mwBknDNOcYxXhVsEYz3f48bEr/roW/OWtwrSHIhgxRxn9gqp86Q5qDYlMnSQiQR6uv
         UdBg==
X-Gm-Message-State: AOAM532AkyJlM9ojiXM7mtiVO2yWYyyKRL3HkeTgsSXXsg3MdXjyweNc
        9oVAWIrASkjYLZtgpRsPinoWG0H0+xOD4r7mAhA=
X-Google-Smtp-Source: ABdhPJy5BYPGqcctW4suL+Ev4cmwBe3cQI/lSFukjP6sVCPNn23vS4ty7zaaDh3Ylf+14j/u18EA2g==
X-Received: by 2002:a17:90a:ab08:b0:1b9:c59:82c3 with SMTP id m8-20020a17090aab0800b001b90c5982c3mr14264452pjq.95.1646894948634;
        Wed, 09 Mar 2022 22:49:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w6-20020a056a0014c600b004f7374ac18dsm5480535pfu.195.2022.03.09.22.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 22:49:08 -0800 (PST)
Message-ID: <62299f64.1c69fb81.b2245.e784@mx.google.com>
Date:   Wed, 09 Mar 2022 22:49:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.183-20-gf25ab1df23d1
Subject: stable-rc/queue/5.4 baseline: 45 runs,
 1 regressions (v5.4.183-20-gf25ab1df23d1)
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

stable-rc/queue/5.4 baseline: 45 runs, 1 regressions (v5.4.183-20-gf25ab1df=
23d1)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.183-20-gf25ab1df23d1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.183-20-gf25ab1df23d1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f25ab1df23d12ded00053b3a43df86ef1eca2e78 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62296a64dce62d18c1c62968

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-2=
0-gf25ab1df23d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-2=
0-gf25ab1df23d1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62296a64dce62d18c1c6298e
        failing since 4 days (last pass: v5.4.182-30-g45ccd59cc16f, first f=
ail: v5.4.182-53-ge31c0b084082)

    2022-03-10T03:02:46.193310  <8>[   31.590516] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-10T03:02:47.204929  /lava-5849179/1/../bin/lava-test-case   =

 =20
