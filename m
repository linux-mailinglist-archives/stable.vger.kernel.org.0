Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C594E555B
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 16:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245195AbiCWPfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 11:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245317AbiCWPfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 11:35:31 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7D07C15E
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 08:33:58 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i11so1876772plr.1
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 08:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Yy0Loivc2Nq9XzhyW2I9uSKFmlFqNqDPXRMMy6rmn5U=;
        b=Tjn5kzXkOM7N4oiW3+TC5R0vYspNZTVJTKKMNx1kMQnxD/f9AuHE8bgwgvJJuQsoxL
         drZ4HED/mlLLr2B3TaG2rXZjlpPfGMqwnbOfN6vM+Jf8XUIycs3ieaCFGjxgfOVlXib5
         N40uoWNRGZoBztw1kB6r7GMRg2wObYGuiHTD73U0eSqckTaf25643sna5Y2An75J03d7
         uB8rqpKfMSXvKcfGhdGtcWmUdUIp1bGarWlCt8ggbKLbA2cmQKUO+Pt+GpyxvQCZ6DVT
         RBs4bbRm6XhSBneYWBHfdyxRIS1B5vwrUiNHqMmuGa2FU5Id8Nj1k6rn/0jsQsoQrxRL
         33/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Yy0Loivc2Nq9XzhyW2I9uSKFmlFqNqDPXRMMy6rmn5U=;
        b=xXtnvwwsT0bhcrEuKdu8ajgKGvivvWo/OKubTOxtHd4uNwm5x2Z9NJYqJf1U0eIRR4
         DrL/36BFYk9oyNcnlL7g6AJm63Pweya93k9vPBU5jarO1URBPovGWRTQdj6XUMJKXyYa
         jS5ZTezjdVxyxZ+rrxsIld0c5p5pG3hwU1VxF+yEupJlhDVOPP4jXpDzNiQZUA6Y6h7e
         gcucQnObN03NwtalNoJ0YxoY2LgC38vbTNNI0F5oOalhi3EeLYJ7FWmmC5KbxxPmGo0t
         Usj0u8Mpxl9VedlJjkovpd7Ayn2nZ6n/2EbKfP98h3JavBfmoLt4VX07GGU5CISOItfd
         Dj/g==
X-Gm-Message-State: AOAM530gJ3m5QhVBd5vt9+ZE3iUmx6uJRnzJBEdkR7lWC1d+ydkiLN8Q
        LibkcfrLMDSuePcM5dPQSEaEENRAUgh++PhcWT0=
X-Google-Smtp-Source: ABdhPJyoVrhRQ3VHsx5aPL3KeTU+PGhdZ2wYU+AnAmlcdneXcvrWiZVFoyMZ3z0apKjGMNPd79jIvQ==
X-Received: by 2002:a17:903:124a:b0:151:99fe:1a10 with SMTP id u10-20020a170903124a00b0015199fe1a10mr588565plh.87.1648049637737;
        Wed, 23 Mar 2022 08:33:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a890c00b001b8efcf8e48sm6493780pjn.14.2022.03.23.08.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 08:33:57 -0700 (PDT)
Message-ID: <623b3de5.1c69fb81.7af74.23f4@mx.google.com>
Date:   Wed, 23 Mar 2022 08:33:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.16.17
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.16.y
Subject: stable/linux-5.16.y baseline: 62 runs, 1 regressions (v5.16.17)
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

stable/linux-5.16.y baseline: 62 runs, 1 regressions (v5.16.17)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.17/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b90df4ec299a1dbb7f7164b0db27406643329597 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623b0e3dc3e464be28bd918c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.17/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.17/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623b0e3dc3e464be28bd91ae
        failing since 14 days (last pass: v5.16.10, first fail: v5.16.13)

    2022-03-23T12:10:13.686039  <8>[   32.573650] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-23T12:10:14.706708  /lava-5931982/1/../bin/lava-test-case   =

 =20
