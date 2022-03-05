Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B5F4CE59C
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 16:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiCEPq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 10:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiCEPq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 10:46:28 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1972C40E45
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 07:45:38 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so10489680pjl.4
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 07:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tYmCk+D5N2p+7xHzvi+XFWylI+PtQUg/hXheIXoEOd8=;
        b=5juI/vaRiNXhiIcXACwyD0G+/qtaOt43wf3Lh1+fQjhKwrvZbaI8fux7kc+9KOo17K
         SjCWQNnMkhoLzjAb71z8hJos47lXk4RBVcygnrY3DMjqyZU+29xK7gl78a6PmJdWG5H/
         LbmTlCevEWUJa8GNAuFhEMiFjNf+9fDukbtXHnekziSqfIL0rhSbQamztySWHHBB11Hp
         fVLBfefb+bO++qNbzPyCJaL6IZE5Hun50uIsftIB06AAw6RhzMwpx5qyHKaKFTT3E+Ws
         dW1cHOSs8EhJMc1LJiBcDNQsU+fQz2wRsmEk4XmvUvH5RekQbDm521i9471XX0ePDURq
         /l3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tYmCk+D5N2p+7xHzvi+XFWylI+PtQUg/hXheIXoEOd8=;
        b=QTI3sgzpoq987DgQUw6TGKqoeWVp7YRnyjgiQqN4n/RNXd7gPZrjQCDeXP7t4QKvlM
         rzU0x7z7pUTuQFs5JvvpYfeSjDxvwUmAYeQG5T+JVRNDY3MbnVy90g5uNEZif4m6dq5q
         tDi5YW/lqlK7riAC9louGSVQ7Oke0pcvh+LIkyo5azShgH7OCRNm1ruISEogHqPIAT8/
         ogaB9yEyvbM6ld6bIgwo1a24x4hh7bQAmsOclH6iAJWvspbW+0JEelVe20ajC9MeWcMq
         hgiN5cbkGljguDvEWs35lBzYDaGAwxu44nLKqpctRBlyioQgsqDW5Q06OSW39z7CYDpD
         koIA==
X-Gm-Message-State: AOAM5315ZHUP/flC6SzUvjtg8cj+o9YvJS4pPDOC/7/cqNrnovK4DgIq
        Pn1KeDBFYE/BFgcgNy4tT0s23PqzlmnQVoiCNq8=
X-Google-Smtp-Source: ABdhPJwISS0H8SV8etrPIe3rdsETrQeLBs9mZ+VurX8NYJ9otzyffPPMP1S0uJAABjfVmu53uscRKw==
X-Received: by 2002:a17:90a:a795:b0:1b9:2f9a:c049 with SMTP id f21-20020a17090aa79500b001b92f9ac049mr4310549pjq.240.1646495137486;
        Sat, 05 Mar 2022 07:45:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h17-20020a056a001a5100b004f0edf683dfsm9764289pfv.168.2022.03.05.07.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 07:45:37 -0800 (PST)
Message-ID: <622385a1.1c69fb81.82027.92c6@mx.google.com>
Date:   Sat, 05 Mar 2022 07:45:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.232-14-g2255e8399f91
Subject: stable-rc/queue/4.19 baseline: 96 runs,
 1 regressions (v4.19.232-14-g2255e8399f91)
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

stable-rc/queue/4.19 baseline: 96 runs, 1 regressions (v4.19.232-14-g2255e8=
399f91)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.232-14-g2255e8399f91/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.232-14-g2255e8399f91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2255e8399f9128be46e4a8a5715ae8ac4cd62f64 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/622351b3f20d639490c629f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.232=
-14-g2255e8399f91/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-n=
anopi-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.232=
-14-g2255e8399f91/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-n=
anopi-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622351b3f20d639490c62=
9f7
        new failure (last pass: v4.19.229-49-gd4f13be3dc58) =

 =20
