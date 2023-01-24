Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E95679DA7
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 16:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbjAXPhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 10:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbjAXPhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 10:37:24 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ADD4A228
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 07:37:19 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso14380718pjf.1
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 07:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4hF9ljEH7sGrPfWxV7U4hga+MWaDaeQJZ57kmGcOAKM=;
        b=UgUNWPrjq06qAUw3ntxFBVQQ1OVquUZtrmhDzOHC514TmhgVIwXzz7pqBFnoYkGe5B
         J4JxgaG6lRxhUZtLsT35uEt0l4Hz/1c9aNNN50ZE1FWVbNk/YElX2XkZ/bw4XGqifQ0t
         oVjiR6Y1xE5vwGce68FVMFW8m3KW+EnCN/jW9DeKh6w5hW3C3d6taT6sY7d3+Qx0vEMP
         doFwPcp+Pe11YWmPGo6SXBvTspy+Wk4eX/cO+ZxbG9PblNro8Nn3VVF+eIa7KSOIPIPO
         74SWEajvHp393YWQebrb8JX79+zy9qyQ0/zGjI2HWXkHlNAv47O7EM/ZGIHXjVLA7lfd
         kyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4hF9ljEH7sGrPfWxV7U4hga+MWaDaeQJZ57kmGcOAKM=;
        b=vg/xb4E6Q3eYmLmIs135RGGbmbGnC6TRmms4LVcQTPUg2hBEdGEfHQbAlIzW1ELlRD
         y8PnFzI7L/36zoQPbbWF4BlmKiStnUtKxEgW6zm0qW/KWINf8hBRqvpZCx0PuLeDHFRX
         ZrBmARHoi/RVf5iBO4wxKrtq7x8NdKLgk6SwAazio5w2v/d3Q5bHb5g7rCRKojtnDfqV
         CjI9yiTi1Qr/YSHqiYpqfy/SkGBh8K+JZCQpIQMolFR8+VSxU5BwnyD9k8xILLYat50G
         z9HrNthdbhjPWA+Ox42P1LvDTyQvM5ihoKPLT56j0dyEuNhGHBLYM/fvlZM6hO4Cdo0A
         DLMg==
X-Gm-Message-State: AO0yUKW/kbllcsaOLrbK31apGbQBeG75bYOilsjGdOjYObLfS27VPr/3
        FLXyhD8r7giINJf1oYJr/XZdDO7j0b4VvjT2AOA=
X-Google-Smtp-Source: AK7set9Et/EY7+37571sFTw4n9DSoaUODhY4grDywAUjBJ8ChUydTKdvNJ4IHX5u+1ay1Rrj6zrESw==
X-Received: by 2002:a17:903:2344:b0:196:11a8:ebb5 with SMTP id c4-20020a170903234400b0019611a8ebb5mr4294834plh.2.1674574638465;
        Tue, 24 Jan 2023 07:37:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7-20020a1709029b8700b001929dff50a9sm1837976plp.87.2023.01.24.07.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 07:37:18 -0800 (PST)
Message-ID: <63cffb2e.170a0220.2116.32a9@mx.google.com>
Date:   Tue, 24 Jan 2023 07:37:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-218-g1f8f93d72631
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 173 runs,
 1 regressions (v5.15.87-218-g1f8f93d72631)
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

stable-rc/queue/5.15 baseline: 173 runs, 1 regressions (v5.15.87-218-g1f8f9=
3d72631)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-218-g1f8f93d72631/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-218-g1f8f93d72631
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1f8f93d7263101450232ca305bc17d561ec8c2a0 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63cfc4ae2b49eedd6f915ecb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
218-g1f8f93d72631/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
218-g1f8f93d72631/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfc4ae2b49eedd6f915ed0
        failing since 7 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-24T11:44:28.745326  + set +x<8>[    9.935064] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3198528_1.5.2.4.1>
    2023-01-24T11:44:28.745536  =

    2023-01-24T11:44:28.851818  / # #
    2023-01-24T11:44:28.953248  export SHELL=3D/bin/sh
    2023-01-24T11:44:28.953615  #
    2023-01-24T11:44:29.054689  / # export SHELL=3D/bin/sh. /lava-3198528/e=
nvironment
    2023-01-24T11:44:29.055062  =

    2023-01-24T11:44:29.156257  / # . /lava-3198528/environment/lava-319852=
8/bin/lava-test-runner /lava-3198528/1
    2023-01-24T11:44:29.156805  =

    2023-01-24T11:44:29.156942  / # <3>[   10.273846] Bluetooth: hci0: comm=
and 0xfc18 tx timeout =

    ... (13 line(s) more)  =

 =20
