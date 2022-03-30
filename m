Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1C54EC6F7
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 16:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347135AbiC3OrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 10:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347126AbiC3OrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 10:47:17 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ACD1095
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:45:32 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so164184pjo.2
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JAgFQrQI61uLPL2q5sJFs0Wfp6Fv1S+HDVDswYF4PTQ=;
        b=AH6d35Yn0hm0igYslIWjb4r9YB4e9TTiK45LGlk398T3IfctBST8Od9vCTLRCazpqV
         PjNJ/L8Isod6CV0Ve9aB1MhyH9kpoGOJGj4Kfs5vjWBrHe/ie2FkebUKdugs67YNXif5
         PGGWtrMLxVlV2JqEWSLTjsDfee/RBa9tckjUWr4pZhAiAs5VfdQQ21nSNhlvbfCshGmZ
         Iv7uWHKdauZEJRyUZpbDUBFQUKYk+Jihq0nyhcn09K03nHHIVXVJuzZQBtiKrNIwTqHv
         pTqD3lItjTBRq8Rw2Kql6a91FkfEi+VvTFC7atSzHYmu5XTM40aaRo/DQuejANqzl6bT
         aTUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JAgFQrQI61uLPL2q5sJFs0Wfp6Fv1S+HDVDswYF4PTQ=;
        b=Kv8Ezacgp7YPEjiKuxSlJ0bcR6xj7LyE8eqzIkizj+VOILzRxvzfVUa1qT+voAmxex
         O44AXojTFL71fZZx3QvlSdtMc03U0CkMosOxmvXFcOYnpew4Rtk4NAjH+piA4BIZMGTg
         sFlsAZTiHAYsofGaxOW8j7O54bzH7mOMl3h7pni1k1/KRjjX0TUn7HyIOiCezSuF0k3s
         gPTwPydaWydz3LHDEjG9U9OC1erCuJ4/Cfs4uyCl5G2MquVYZY3jrCETDdv6tf27TIbd
         2IdZAo1dp7KP75a8P4XO9354/oMTn6MfC7/IZqRW0/rQvgGK1qQJPLdenhrw7Tp5B2aB
         iI5Q==
X-Gm-Message-State: AOAM533zerfvdyPGYamxNWGdpWks9TgznZA27KLK/bjbplLbcn4iH2hd
        8pElivsdL2KFoOOfeZ/3xFG592bBn4BtRN4H1is=
X-Google-Smtp-Source: ABdhPJw+WxoJbbUAHBqufARh//Kz8OqdRbGLbzDBMhfQ2moQ5kplpPMrOSZbTl1D40LAIpjj8OPcjw==
X-Received: by 2002:a17:903:2284:b0:154:3b97:8156 with SMTP id b4-20020a170903228400b001543b978156mr36177999plh.95.1648651531873;
        Wed, 30 Mar 2022 07:45:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d80-20020a621d53000000b004fae1119955sm23907186pfd.213.2022.03.30.07.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 07:45:31 -0700 (PDT)
Message-ID: <62446d0b.1c69fb81.e8451.d90c@mx.google.com>
Date:   Wed, 30 Mar 2022 07:45:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.18-28-gf13da7fbfb23e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.16 baseline: 92 runs,
 1 regressions (v5.16.18-28-gf13da7fbfb23e)
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

stable-rc/queue/5.16 baseline: 92 runs, 1 regressions (v5.16.18-28-gf13da7f=
bfb23e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.18-28-gf13da7fbfb23e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.18-28-gf13da7fbfb23e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f13da7fbfb23e8cb84f4cb174009de27b10beae4 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62443c4693f1832c6cae06a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
28-gf13da7fbfb23e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
28-gf13da7fbfb23e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62443c4693f1832c6cae0=
6a8
        new failure (last pass: v5.16.18-27-gc3aede4bd0e3) =

 =20
