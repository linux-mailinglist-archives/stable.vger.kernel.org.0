Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0708508C4E
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiDTPlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 11:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbiDTPlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 11:41:18 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848C5457A9
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 08:38:31 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s14so2099763plk.8
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 08:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2U9kYy+XPox8IiIIZ3bat2JxpbQh86VIcOXVNnv7Z94=;
        b=QBEHpiFtSYyHSvdQt51RRef2OJhbVjATnv0BrNWDvLXSmugRh7lSmFByPwLymThuRt
         8AMyEXE6IXrMGvUJjlsaMCaIxg0+NHmwFoX/eFtJHXYs8OENmG5+xC9ZF3nnq0DlVMbN
         5QFtVQ6ktuXepX9D5NxI50QinHug4czPoTCBTfxuV5lrL7r/Mi8CWRcJ2jieBE9YJy8X
         /VVW7H51XL+8WgQaUdXI4sFSWsGU2P6v16AnT+BIGIQJMr4r7EUIj/MvFILS1Frlty+r
         fuhcaxTHuWw+N2HAUrXxBLrel0784V7AMGwx8qhrNFFTpjbE5Gm5IMkyxZHr1fs7Hu0D
         XfjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2U9kYy+XPox8IiIIZ3bat2JxpbQh86VIcOXVNnv7Z94=;
        b=B4VZZzcvsU/e/alh8L2WTteIY2RiBaiFN3EGbbOoLnNiFMwxXiE+1P5ZnBYfhtApT6
         Yw2VK08dTjR3Gz1c/jY4OziXF2+EQvOAaeWKwlBfZNI3p3xd7FDFxV7nOZUbium9TYd/
         n3oBYFqrVzeMKb01B9vneaWReSig0IgOd2Oq2WgCMPFrCUf48Y+1E5nBnPIHYNJfcwcJ
         BMh8tDKoaizjq3hZM2DFONMFnRr4dqQyhtGRX8Ra3wD++9FO9gkSwcLbosmuPcQvcObo
         QIRxL6ndXyFHEyRRJ6wwyl3KvhkNn8dv/94WS0rd+Kti0oHS5f/Cq/6fcO7wRZ1P4X+M
         Yfyw==
X-Gm-Message-State: AOAM532cplp8EsQT77Q+Cfv8T5BhDUndbBLmE6p29fzezBSlYXc6NuGW
        i3qQRLWWD1b++ogxw1KTMvKg+dbHanVcMMJBcKQ=
X-Google-Smtp-Source: ABdhPJwyPZ08LdaiwQ+fkuOSa9AXO80xsZMXhDd5vgySHdD5rNq277IEIaFhR8iami2v/HRiZtmyqw==
X-Received: by 2002:a17:903:32ce:b0:158:f3cb:8900 with SMTP id i14-20020a17090332ce00b00158f3cb8900mr19082945plr.66.1650469110892;
        Wed, 20 Apr 2022 08:38:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20-20020a056a001a5400b0050abaf55b5fsm3742132pfv.191.2022.04.20.08.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 08:38:30 -0700 (PDT)
Message-ID: <626028f6.1c69fb81.f9e18.93b0@mx.google.com>
Date:   Wed, 20 Apr 2022 08:38:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.311
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 86 runs, 1 regressions (v4.9.311)
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

stable-rc/linux-4.9.y baseline: 86 runs, 1 regressions (v4.9.311)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.311/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.311
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7eb61afe0cb414664c5944ddc98087c6a37cbd34 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/625ff839aaa69f9d48ae067e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.311=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.311=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ff839aaa69f9d48ae0=
67f
        failing since 14 days (last pass: v4.9.307-12-g40127e05a1b8, first =
fail: v4.9.307-17-g9edf1c247ba2) =

 =20
