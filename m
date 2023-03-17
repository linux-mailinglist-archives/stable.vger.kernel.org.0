Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB4B6BEA74
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 14:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjCQNs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 09:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjCQNs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 09:48:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BA93C7B5
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 06:48:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cn6so5172600pjb.2
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 06:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679060904;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HRSz4/DM25THElKTW09bGsrzCMs7JtpD/Q3Uydxisao=;
        b=BeunzjpRbmvF3VRx5ZBDmutln72TGnhjaXkW68G1b6/CFnPZXaNR9lhvnY9oi+/lxP
         EAWZIQuCHwcsj/7VgqjsJg3BS/nNghhVWVQrMEKxGNfAUAfMbY2JjKhwFG44pptiA2mV
         hCVlc83l2QfjL+/VlI+0Udn8h7YnfxyfMGGTBbrCvmOps6+ekinGEvJr0cVhIMEuoy7P
         2zzg6rJDxBPjMdgFwThG7smqs63AeIwmuq4CdMnIwaQwDMwYalM3EkiYBOSW7SMvTDSm
         i9dZ+PapGLq74tOk/Gs0l2pVbDKBkgNSNXepIGIHVY2p854MYNDQCYiqdyNg5W+5Mokr
         FIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679060904;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HRSz4/DM25THElKTW09bGsrzCMs7JtpD/Q3Uydxisao=;
        b=Dl+hchZg4yQIIFLM6UKIHXsN+DrnXvla2xC0hzonuIVLs/ctGjpuc/2oR8vqgI3BW3
         D4BpbFS9w1XS7tRIQbnbNbt35jkOZ5Yx+p+Nod6L67Oi0JTR8skHxOfcGy91b+nq4wHe
         53H+sAISCztUytK7vfbxE4FTFM0shfe5zeDBUT6Wukw/+sE68aY/fcehgIMogJZPS5T5
         9kYjpvbLK09dhyXdNFCQDYMfUGrzJ1GGAZTtKnBVKi3RSBFn2Y0dzTBAMrlwuzdhmOOd
         qUBJ9jZPYtLa3fyyd5YdjkMoyYdUZVUGoj3clCftD5CHh0Y95slxKooLW5HPhDS2dvd3
         JtFg==
X-Gm-Message-State: AO0yUKXZxI3wt70CkQsKemZHs6GxevkjvhV4vkOKzfKrY9vuG6uPqIdy
        iStW/cPGkWY+lRajx2N2MgCcKgOZEF1NCxErx0ahgA==
X-Google-Smtp-Source: AK7set84fs6BAsgBvytwyPxPT549KewKsuAvqKatCYm2FDYqJoj2nslWm3HneWcskBhoeyq20lOpLw==
X-Received: by 2002:a05:6a20:b326:b0:d5:fbba:c435 with SMTP id ef38-20020a056a20b32600b000d5fbbac435mr6132248pzb.42.1679060904682;
        Fri, 17 Mar 2023 06:48:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s4-20020a656904000000b004fab4455748sm1519013pgq.75.2023.03.17.06.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 06:48:24 -0700 (PDT)
Message-ID: <64146fa8.650a0220.c1d4f.2ac4@mx.google.com>
Date:   Fri, 17 Mar 2023 06:48:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.20
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 174 runs, 2 regressions (v6.1.20)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-6.1.y baseline: 174 runs, 2 regressions (v6.1.20)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 2        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7eaef76fbc4621ced374c85dbc000dd80dc681d7 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 2        =
  =


  Details:     https://kernelci.org/test/plan/id/6414378cda251184cb8c8637

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20/=
arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20/=
arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414378cda251184cb8c863e
        new failure (last pass: v6.1.18-149-g4b77c9dc7cd4)

    2023-03-17T09:48:38.765741  / # #
    2023-03-17T09:48:38.867691  export SHELL=3D/bin/sh
    2023-03-17T09:48:38.868217  #
    2023-03-17T09:48:38.969485  / # export SHELL=3D/bin/sh. /lava-297778/en=
vironment
    2023-03-17T09:48:38.969943  =

    2023-03-17T09:48:39.071317  / # . /lava-297778/environment/lava-297778/=
bin/lava-test-runner /lava-297778/1
    2023-03-17T09:48:39.072179  =

    2023-03-17T09:48:39.077412  / # /lava-297778/bin/lava-test-runner /lava=
-297778/1
    2023-03-17T09:48:39.141323  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-17T09:48:39.141646  + cd /l<8>[   14.479143] <LAVA_SIGNAL_START=
RUN 1_bootrr 297778_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/641=
4378cda251184cb8c864e
        new failure (last pass: v6.1.18-149-g4b77c9dc7cd4)

    2023-03-17T09:48:41.491359  /lava-297778/1/../bin/lava-test-case
    2023-03-17T09:48:41.491722  <8>[   16.922801] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-03-17T09:48:41.491982  /lava-297778/1/../bin/lava-test-case   =

 =20
