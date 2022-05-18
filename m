Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A2852C26F
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 20:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbiERScp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 14:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241418AbiERSco (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 14:32:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9029D15AB00
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:32:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o13-20020a17090a9f8d00b001df3fc52ea7so6434830pjp.3
        for <stable@vger.kernel.org>; Wed, 18 May 2022 11:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vo3hGH8ZU4yoZHJwgfYu7nXSM//D4R7riFADohiY67g=;
        b=lse7YDhQPPHL8sa9326wBUYTei2oj3oOSOy+PMRJFgsH8ieF3pCLIVqCyF2suX+Rzd
         uO4EMpJehbmakFLOgcjq8q0yGlH8OhUNk7la3aaBpURnxFpexPDha6+7fHCBc9LukVV0
         oCFuA/peNBo6E0blstTf08LKE7K36qQf6icxX+fMDxjekBrLh7m8h/B/60X9H3AdfRl0
         dI51XigZdpPl/zOR6QA2LjG2jSd0HukCHKPusxVelwzAEWktmphrAjIdQeCj7c4Ngl2j
         9gi+ToDX34AptPl45FY+Qx08yhHQfNkGX2Jju7ufotqvMuiLMgLx50NYGUaGIsTaMgaA
         1oCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vo3hGH8ZU4yoZHJwgfYu7nXSM//D4R7riFADohiY67g=;
        b=i4adryi7hrQosnQXguVE07Uwv0LlfubXiMANp7Q5O3+n/VXpivy0dlYoomynUKkZ6I
         BJehV6G9g3Vh30rb828LFNQBtB2+EdDDz8j+bOJVHEDo9qajW0vQGbgy45pc9+ncAsX8
         jQ4GXFS6yTEa3zmZv5ZQqogL+9yXCmwzMX2oFcycOuA/6thb0TwJGyhVrhCS3cduNVav
         cUmKvpmL3mQypVx6ed5QR3KG5m6Gg2wy0ZJRvxJLMijQ5p7jkRvCdwLR6G/zcJJ7PqWk
         UI471HDDm+x7ci2GtEFoQh0a4BjRKKL/dVcq6ICBlhfWureZLnDTAk5PU1shlruI5qIH
         hsRQ==
X-Gm-Message-State: AOAM530r9cgnMY4p9k8nzPDKf9KnL+7pGvzttIhU9qviEQK9vj4EE/OR
        XQDKhLz3GKf/bQeHy9YIU6PyFJLexzuaVHBYxbM=
X-Google-Smtp-Source: ABdhPJzQRVWmmaIqgthUjygrJ7QFzsZkgrne1QZnZSJxKR2ky7YsUewpXJsUurG10d6e8xuHar1QBQ==
X-Received: by 2002:a17:902:e948:b0:15e:cd79:2a1a with SMTP id b8-20020a170902e94800b0015ecd792a1amr659195pll.109.1652898762892;
        Wed, 18 May 2022 11:32:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l17-20020a629111000000b005180cf8f8c2sm2131667pfe.169.2022.05.18.11.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 11:32:42 -0700 (PDT)
Message-ID: <62853bca.1c69fb81.c449b.57a6@mx.google.com>
Date:   Wed, 18 May 2022 11:32:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.41
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 158 runs, 1 regressions (v5.15.41)
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

stable/linux-5.15.y baseline: 158 runs, 1 regressions (v5.15.41)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.41/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.41
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9f43e3ac7e662f352f829077723fa0b92ccaded1 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628507936f6fb66caba39bd8

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.41/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.41/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/628507936f6fb66caba39bfe
        failing since 70 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-05-18T14:49:35.565308  /lava-6414869/1/../bin/lava-test-case
    2022-05-18T14:49:35.576376  <8>[   33.512514] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
