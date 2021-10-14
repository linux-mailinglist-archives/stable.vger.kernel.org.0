Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6C242D0FA
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 05:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhJNDfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 23:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNDfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 23:35:09 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF48DC061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 20:33:05 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so3775731pjb.3
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 20:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ckfNIDUhzU8HjFV8oy1k4aKxx+wUoLi+3zMWmhRrews=;
        b=wiGi23P7BN6mgdy0HKtk/hRHp7O83zK1pak8TXO28BVlBNjbnwykfH2UIwDuEmbvcm
         jTo64i832jCTzU1Y0DJsw/zLtZymU+gwQQbiRCuVgdVW4qcjfqDF28HmzMq5v6xdZ4Jz
         qFFxHXIzO/MmVyPfIeUQxeHhtH16+bE+CLlNEyZpH0t0Pbzpcrp9kqTxrqdIoWqB34/E
         X/Nz+gk+HkbdbTaYX7qfhHSf480HeIjfSMPZxNvMQQLa4lhzEG+D4dHbH2SBWfh4XJZA
         D0Yq7aDPwjgXMktxuNDond8n4TVRcVZVgHGgvGO61S5Y5v3/kS+TNRIUb9nrGsQPuItp
         UFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ckfNIDUhzU8HjFV8oy1k4aKxx+wUoLi+3zMWmhRrews=;
        b=wZ+kLAVrwqPTpXLZo/s88wCH0N/R94a7uGpFBdtQ2DtGXuqZRQ45v03j4BrUZ3KH4N
         otXn9aLwyKbzwUonR56GyUOfun7qUrJ9WKvs/PvQojzyAgT7YWSGeAISe8TygBgMOVt4
         Ue8EznShivenJCxYmExWo+yf0RHkatOMBysrfkK4phanZ5VLrIy9CAtcSWpPIR/xNh0V
         V5n2N0ycuMjXiVXGiA1F6UAAIc7hSRE5Ho5kMfHIl0vI5YgH1jG4KBMQf4OjjzJlMJST
         YXTq68xn/e8sME92XN1jcKowEMM1mFPPPkNSuIf0Pzw8m6evcL7rmGtGt120qk5ezbBC
         LMjw==
X-Gm-Message-State: AOAM533OiuQ6I+kAT1Ei7p2M0wpseRoBVe1BVmBfarnMMQyn0pVIs5bn
        oKPylsEftAe+36IEBbUE6JtMQTufO1Y2P2bgSFw=
X-Google-Smtp-Source: ABdhPJwlSRjCXSdwtmjdhJUg1HCPd/lCEQQLsdKR30SzY+2wHQwsZcxw7bccOOKHEGfWXY9//WiC6Q==
X-Received: by 2002:a17:902:d488:b0:13f:165e:f491 with SMTP id c8-20020a170902d48800b0013f165ef491mr2937371plg.12.1634182385183;
        Wed, 13 Oct 2021 20:33:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b23sm852746pgn.83.2021.10.13.20.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 20:33:04 -0700 (PDT)
Message-ID: <6167a4f0.1c69fb81.ecbb5.3e83@mx.google.com>
Date:   Wed, 13 Oct 2021 20:33:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.12-30-g495ee56a80cd
Subject: stable-rc/queue/5.14 baseline: 81 runs,
 1 regressions (v5.14.12-30-g495ee56a80cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 81 runs, 1 regressions (v5.14.12-30-g495ee56=
a80cd)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.12-30-g495ee56a80cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.12-30-g495ee56a80cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      495ee56a80cd5cb854bba27579775bc3254a3cb1 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/61676790d3db171a9f08faad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.12-=
30-g495ee56a80cd/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.12-=
30-g495ee56a80cd/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61676790d3db171a9f08f=
aae
        new failure (last pass: v5.14.11-151-gbc5a3fbd8294) =

 =20
