Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FE4298A33
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 11:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768371AbgJZKPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 06:15:21 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:46961 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1768358AbgJZJrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 05:47:20 -0400
Received: by mail-pg1-f173.google.com with SMTP id n16so5763246pgv.13
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 02:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9jmGm5RM1Ux9hCK86nZGT/XSuQJzap25ywWgzR6gooU=;
        b=SxL7t5yfYiM5o+g8OYa2pH3NsrjwRNssxhis7ixCTwN+uVCGVG1936s6Rr65gXHks4
         we1uqNovXMkLhyH7wrZ0QJEZL20ebJfxedcGmvhjvKqS9cCdA9no4Kt4vFOqFgATLPuf
         05f8HpOry9AUoIHvOaY3r70l+54gjMNigs87ChTCuHOTuvF2dSQEclRcJm9DmA+6FTTh
         gS6mND/wLw2s2oEhzK6DDDmMmaFamM+qAjmOIOOYESPW3zLfifZkZrdnr4bdyyhECQ1i
         vCCpLqkOD6D2X0pwsEKErIyFMklFjQq846Ml3yMueGZQ7zNdqk2RnsgZbTcQSb6bZxZd
         TRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9jmGm5RM1Ux9hCK86nZGT/XSuQJzap25ywWgzR6gooU=;
        b=ZcjdOeemP2lU+ZqiRjlceDmk2b6tiyPZJzYHCTLJANYMaB+amvD0mISVu7eA8QC8+/
         XOQMr04cbe3Db3Q1kDu4VheDQ4Y0dpt9ctQadUe5/5GDl+xfVSaGOWxaDqY2CAnZx+st
         5mUh1YQuNgJTbyqy6NbyIvcF6mVLzyR91rU3tPKkI1ad83S2TXvkBhsp6INBW6UxfyqT
         wR2Qlh68j9UMAd+jeXyUEDOgLNlOoIjcwQdEd/nIPEWmf/GVrNsHXIGnhLcVJoTOMES6
         Jd85iSBcU1iAzIYKO5ES4ky0emvNLSXtqlGW+6JzfIMaj+wN3IWBBz3TyGA/Z/gwlEQT
         yItQ==
X-Gm-Message-State: AOAM533d/JpfrHCHSyvirTeNS1cccSyYTjppC1javQAcc8uznTvanEmI
        U0pqJLvZGoR3mkioBFXInF5emxWghOrmmw==
X-Google-Smtp-Source: ABdhPJwtuzqcSpi8aJuFwhivwowoNGOnoLgKl07ftbbZN3A69lvW4b9aC4bYUNb8kWA/zBtntwGogg==
X-Received: by 2002:a63:fc09:: with SMTP id j9mr12358784pgi.388.1603705639996;
        Mon, 26 Oct 2020 02:47:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z26sm12480842pfq.131.2020.10.26.02.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 02:47:19 -0700 (PDT)
Message-ID: <5f969b27.1c69fb81.1c961.a72e@mx.google.com>
Date:   Mon, 26 Oct 2020 02:47:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-626-g41d0d5713799
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 199 runs,
 1 regressions (v5.8.16-626-g41d0d5713799)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 199 runs, 1 regressions (v5.8.16-626-g41d0d57=
13799)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-626-g41d0d5713799/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-626-g41d0d5713799
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41d0d57137992a8475ca0298ee7a4609de75855f =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5f966a2dbdfff71b5938101a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
6-g41d0d5713799/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-62=
6-g41d0d5713799/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f966a2dbdfff71b59381=
01b
        new failure (last pass: v5.8.16-78-g480e444094c4) =

 =20
