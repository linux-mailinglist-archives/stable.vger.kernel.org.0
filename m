Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD9B506167
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 03:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbiDSAzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244192AbiDSAze (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:55:34 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0967A1B787
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 17:52:52 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q12so21908625pgj.13
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 17:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oLWc0xYOF7TFu+QvgM+czIvfp7ETkLjReLynaYhJvdo=;
        b=Hh9WTwYioTr3pjh8wAJFqIuETFEKhwjSesS/ZqlLRuqdK1wdZY72beTZkiweTjgSmZ
         iDt7p5AnwTX66Isp2U8L96mkSxd6HH1npn1F2vjxvPd9GDEBmWsw4cMAA8AjbEKZ+RJu
         q7eg+QMapUgCoGURbmTDu8/JWPw5WDBYIfUenHM8hpZcBylyRjvGSDhxWw4h4GTFIFCv
         32wFjamcVpifZzhGTG3kDMAcrvGlHUjLdwimpjGBeq8XoN5rVELHUOdSAPrkcLhPVQDh
         Fkn3N37gZv26G2LTT3r+bx4JY2DO1bD5Ip79mLVzXnGwYf5Sd3haNvqQEDvDQv31Tjtp
         /u5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oLWc0xYOF7TFu+QvgM+czIvfp7ETkLjReLynaYhJvdo=;
        b=UITkc0w13LJfZqnllyQle/xYMJOqU4C0LPMkHpUiYNdbY0htvvAtUCGVmHaWB4AEWG
         7IxGFWqdAIL6VT13eKuGPbLslLKPle7zHCjgKM0kaHN4zjTF6rpFGP3rdnGQtaOjZ1v3
         Vvqh1AWDxtTWzYK2Y3hNrPze/wnCgGYk1ulU1C+LUF0+xGfjKTUdN3gZqfaEOtI4y4dV
         N5SWGip5NyqOArfmsuuZum2EMdgmGEZfiTLOW0YELYSpPEGwxf3Obj48HsP8TX/LDcml
         ogyu5ZRYbvYW8i2GJ9QEooEC0scBTytmuODPTXBan2JdUYgX9uMJGYzHjjHrC3oNWpNm
         PKbQ==
X-Gm-Message-State: AOAM532As58ASN2zeFDjaQ0gn6EG9NIfscpta3e+9qVlqshRzWQZN+Ve
        EVxNHx3K3Y9x2uIP0ZlLS0S0Exrkoau3/GHV
X-Google-Smtp-Source: ABdhPJyQPZCGPOgF3+JzW1IWBKKZZBBz//rfjPtqH/2E3huFJZmLJa3TivnjHny5kGxIu/ZgFrSXSQ==
X-Received: by 2002:a63:2d47:0:b0:399:53e3:5b4c with SMTP id t68-20020a632d47000000b0039953e35b4cmr12477986pgt.165.1650329572209;
        Mon, 18 Apr 2022 17:52:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z188-20020a6265c5000000b0050602bec574sm13765613pfb.209.2022.04.18.17.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:52:51 -0700 (PDT)
Message-ID: <625e07e3.1c69fb81.81c15.0d06@mx.google.com>
Date:   Mon, 18 Apr 2022 17:52:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.310-218-g660879b75af91
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 81 runs,
 1 regressions (v4.9.310-218-g660879b75af91)
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

stable-rc/queue/4.9 baseline: 81 runs, 1 regressions (v4.9.310-218-g660879b=
75af91)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.310-218-g660879b75af91/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.310-218-g660879b75af91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      660879b75af91ff176113000248ea7ffa9d5dbbf =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/625dd4bf3ec86fedcdae0781

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
18-g660879b75af91/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
18-g660879b75af91/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625dd4bf3ec86fedcdae0=
782
        failing since 13 days (last pass: v4.9.306-19-g53cdf8047e71, first =
fail: v4.9.307-10-g6fa56dc70baa) =

 =20
