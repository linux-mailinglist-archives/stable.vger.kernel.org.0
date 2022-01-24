Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705D349A9F6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323873AbiAYD3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2361483AbiAYAXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 19:23:14 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF656C0C286B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:06:49 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so532724pjb.3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cSN2W4ZIuRrhF+4bDDGfjlC7BiuX0fu/9BkBt/1CRuE=;
        b=gGrvkNMCGUw7PrYusOe2lCtBXrTjsYdswVM0f5m7h3It95vbxeaD3eOGvgMn0+h4QR
         72Ce4RpH9SSfNXvf3e8ux0yQqZwM00GHWvr4IQFLJ72YTLDOY7fHCuQ/bkR+ToydcBax
         sBm41i1U06SjqT4Hid9Lv/lK1qQl1n7gRxb5ZTzO7qhD4SQ/1ActprqDA2Hj6PJ3yJoR
         /fHFAas/ZUT/nIY4TiPPN4quWVZh2q6ADXu5xIXdGGkRnK47ivYPObn/Yel3UC+/V3/S
         DmT/VoCF1+4M1AOmDsfTTAuUYeMVVWZ/UqadHconq4+r4hP4kdVjiPObdT8QgjtzGztD
         pK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cSN2W4ZIuRrhF+4bDDGfjlC7BiuX0fu/9BkBt/1CRuE=;
        b=KgPvhzMjlGaTq0ywZMGWT/O0ND2K25JDZynMppNwz/fWvetD2ulhtEnz7UwpJs7dIu
         HcFwNWDp05++wEhoRqFTqP1g9JcInIxeBcyk4P2MGLku3+o/c4fHddufBVzjEgAMLfQJ
         ZGor4EqWy9Jl45EC61uY8djSJx3W+QefWBRFZHLyl+PlZpGoKHVOY8YgMwTM44ra+F98
         ah92ir7PxeIfXlXsPO8lbP2Jk8S1TIXurFyyOYOyxkOR+858oLJdnaC1A0pGld8NfdRr
         AZT5zG/kZkCcpHlYKY8DUsPAamuzyVyh/fEC/rCqSeDFCOTzZE6Wddf/vKpcDQTedTJ1
         ikgA==
X-Gm-Message-State: AOAM5327iqfbNDfpoVaE1YwZUEpXpVr7hyt8QWDMOrMSn7iZZpPpzxvO
        wLetYEL/dXw5DzTkSDbnC6a8yYuH2zDMeMZ1
X-Google-Smtp-Source: ABdhPJwaUfgnhktUMCIcYuQGA+sOIEvCy+55dA5Ee7HS4lrKHU2NgSH33YEjkhyJGQzPcg+S0z8A6g==
X-Received: by 2002:a17:902:e8d1:b0:14b:7484:9df7 with SMTP id v17-20020a170902e8d100b0014b74849df7mr413846plg.133.1643062009293;
        Mon, 24 Jan 2022 14:06:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2sm17787937pfc.183.2022.01.24.14.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 14:06:48 -0800 (PST)
Message-ID: <61ef22f8.1c69fb81.e0296.0330@mx.google.com>
Date:   Mon, 24 Jan 2022 14:06:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-1041-gbb0f7c24685b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
Subject: stable-rc/linux-5.16.y baseline: 155 runs,
 1 regressions (v5.16.2-1041-gbb0f7c24685b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.16.y baseline: 155 runs, 1 regressions (v5.16.2-1041-gbb0=
f7c24685b)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.2-1041-gbb0f7c24685b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.2-1041-gbb0f7c24685b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb0f7c24685b0704cba2d1a6c554a0effae79397 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61eee9eef9668dd243abbd51

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
-1041-gbb0f7c24685b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
-1041-gbb0f7c24685b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eee9eef9668dd243abb=
d52
        new failure (last pass: v5.16.2) =

 =20
