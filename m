Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2499C4DA3F7
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 21:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351687AbiCOU23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 16:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345892AbiCOU22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 16:28:28 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E04B50B37
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:27:16 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n15so110012plh.2
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e971YJ0373vCf0pSijQNtqGxfBI4VqEhoh4939qD8Tk=;
        b=g9znTadiCE9NBQK/LrkNHD8LhFpJbXMwZDMciIw33by55jo0ex2qRF2vHHKIxv9fd5
         YAvOn5wNF6JLhbkQbkisMUJaZhDOO16hiC2a03vnYQs2tF/WlnQfi9yQEypBIFSZieJs
         vUctCsgsuebTK/wteHVK6HAGFoQ+5H9agrrbUvvLVeUArORZyRsT5qAnuZx4XJ9+I7OG
         lzQYx5xFrMrYdDuulmRkzxWFXR/nwOl6t9x+uUdeuk/HXURZssupMhRuaAiKgCS5lRR/
         f8+2BKDl1W/tKOBpO2K8yAHydzmhMkH2+fN9f734u6LiXKUnRMys2Cs0YGg+mA1VB4LL
         zssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e971YJ0373vCf0pSijQNtqGxfBI4VqEhoh4939qD8Tk=;
        b=AsIkSVD/cP+IftmuSQTL4h0PYdSJ/Fe5bRgfHEedsGB2TGuKXLy8OtXiF2Kl2F/24F
         4nsNkTIQAq54yfoFnuqQwoYtyxhqz/KXgv0IpY78WK9TZlmf9dtrYxe7X8hTgKP3RRUf
         OVS+PO6+pcaxmzgLVjobCvvphEKEjfkmYoNjCjGehoQzIdvaVaLJUpez10BZomoPePk9
         lGCA8mz2UcniE1wlUCin9h4xQOAlK7vv8d7D0qV62GXrhA9jcIOgG4dbZ518rcmoydFi
         nARlJc6LNu3yT494HYlexGcOgcuUxHT6l2S35Qr+GYeWENuhhdV5koMhTGXV3rC6MtM/
         a0zg==
X-Gm-Message-State: AOAM532DUvrZsFOzPrO6Uq6QlcpB7SECLu6w2d2bWAGzBBls+v4eMhSR
        Bj7e5dVgn3w0BMuS0NCqlnsxz8MmoF9N3+mr/p8=
X-Google-Smtp-Source: ABdhPJw+4tJ5N4nq/oeUgBvkpc+xX5laWolciuRseW9WZeUTjc0N7xT4FF2QGF3MH5C74V25QKp4Vg==
X-Received: by 2002:a17:902:aa01:b0:153:3a40:1097 with SMTP id be1-20020a170902aa0100b001533a401097mr21073027plb.107.1647376035662;
        Tue, 15 Mar 2022 13:27:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c3-20020a056a00248300b004f6f729e485sm26507863pfv.127.2022.03.15.13.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 13:27:15 -0700 (PDT)
Message-ID: <6230f6a3.1c69fb81.f34e7.1f53@mx.google.com>
Date:   Tue, 15 Mar 2022 13:27:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.28-111-g20b27e498e39
Subject: stable-rc/queue/5.15 baseline: 77 runs,
 1 regressions (v5.15.28-111-g20b27e498e39)
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

stable-rc/queue/5.15 baseline: 77 runs, 1 regressions (v5.15.28-111-g20b27e=
498e39)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.28-111-g20b27e498e39/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.28-111-g20b27e498e39
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20b27e498e39be92a5dc03d0b7b80fc797110cf9 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6230c4958a67e3c0e3c62991

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.28-=
111-g20b27e498e39/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.28-=
111-g20b27e498e39/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6230c4958a67e3c0e3c629b7
        failing since 7 days (last pass: v5.15.26-42-gc89c0807b943, first f=
ail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-15T16:53:14.281959  /lava-5884213/1/../bin/lava-test-case   =

 =20
