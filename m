Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC8676C2C
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 11:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjAVKyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 05:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjAVKyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 05:54:49 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7251C16AC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 02:54:47 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso12956422pjg.2
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 02:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1sa0uidK0TUNnth6t6B0zLrX9LrvGTH3ERKSPwhaTPw=;
        b=EmpWT6kgNXHirQVzrbebJ9NFwJjeQy4RBIJnt4IN66bDZKXhItNG0X3Tw8pwRMG7dQ
         +O324NYyMCNx9Uc91Gds/Ua4kmSvdix5OCQgg3UTNaee7x4STHhMXk+Sy+QCw1kVzoLS
         SQUkMI/LKW2YXVS1E1juUdzUwSPOlJAm3r0ZIj8hyVqrJE+bVi162zeYCJwOe7DxcjcF
         tFdcU9phJuUast0oRseES86LLum8TEwzFCLI+/T0bjbqvzeqj6pbFlcDqvqgY+1qwE81
         IXsusIEI3ROo7HNdsxfxh0WxTCpo1zYT1i8DZZTkiPkw3lwZ7EC2ZGbtmOwgMAhDjP5+
         IXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1sa0uidK0TUNnth6t6B0zLrX9LrvGTH3ERKSPwhaTPw=;
        b=aGQneyKNfjEEOCfYapP2GqeN2f+M9SLEefdhwOlkBUjlRmV1eKvbJQm5gXzCefSReR
         bXzeswlQCQ8UYyn3+YUcq/16HYuWYE5GqM5GdBwUfx/Lg/imsMJ/Y+1NOlA0GHxOCifA
         TxgwIaMJxj3xCaG3dPANyqgR8K8Y0mEbnxSyFEj9cTDN6OXEENADwzPf8kR7nrBYXGYL
         31rGgPU5U9dgd4uKLtJBClSZ+D2DBXovX5lVCCq3QXlGJLca1Q1FX2qbocMGdNxEkH68
         imHT+ISpG1NlvnPvgpSG9S3vUdzmal9TwWcrHibjGU5cDLbIfR7JC721V+5LVy2KyKIa
         iO6Q==
X-Gm-Message-State: AFqh2kpcqCkE1F7jL1+VFMrjqkD9fhvjpp2JebAOtESed8wEaKrKONYr
        hIjCXMqvozOIMW4spBSz1wZuc8XU30Hn1ig1ozo=
X-Google-Smtp-Source: AMrXdXuSeuBsWXQsY695ubnqPoNs+goui4LE69gEQ+NoKntInoS5EZpGpOCZ3M3zj3y7WOR64msR/A==
X-Received: by 2002:a05:6a20:c18f:b0:a3:ca9a:ff82 with SMTP id bg15-20020a056a20c18f00b000a3ca9aff82mr25051032pzb.61.1674384886756;
        Sun, 22 Jan 2023 02:54:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v18-20020a634812000000b00478162d9923sm13136604pga.13.2023.01.22.02.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 02:54:46 -0800 (PST)
Message-ID: <63cd15f6.630a0220.1d119.3b53@mx.google.com>
Date:   Sun, 22 Jan 2023 02:54:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-142-g39a39be2e804
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 153 runs,
 1 regressions (v5.15.87-142-g39a39be2e804)
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

stable-rc/queue/5.15 baseline: 153 runs, 1 regressions (v5.15.87-142-g39a39=
be2e804)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig             =
     | regressions
----------------+-------+---------------+----------+-----------------------=
-----+------------
mt8173-elm-hana | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrome=
book | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-142-g39a39be2e804/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-142-g39a39be2e804
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39a39be2e804deb6f673fdc889b0255676ec4b7d =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig             =
     | regressions
----------------+-------+---------------+----------+-----------------------=
-----+------------
mt8173-elm-hana | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrome=
book | 1          =


  Details:     https://kernelci.org/test/plan/id/63cce183743a3a5b29915f6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
142-g39a39be2e804/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
142-g39a39be2e804/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cce183743a3a5b29915=
f6c
        new failure (last pass: v5.15.87-121-gd2741f8eca76) =

 =20
