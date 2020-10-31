Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C3E2A18BF
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 17:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgJaQjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 12:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgJaQjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 12:39:13 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F924C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 09:39:13 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 10so7638529pfp.5
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 09:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m7WtS5acHiuvLtAz/POw02Vt3nMnmT2VeRYqrUtKUV8=;
        b=Ay+sKg+gnxi2/p5MWaghifRneyRSuNllxXNdVir+3HMyHPtmTH9VXGxSsvBkM/Q66O
         NM/838JoSl34hgYylcgkJNyirKIaKN/n2GUteuOE2Pz0zT8lRXRcGHggCXI0BRDHMUOP
         eqp6RYr/wkwxBVna1u1ePSM2c4ul3ZQKe8tKuwotaAuc0fQT5uF2BYhgWM3Sp2gl3uOn
         P69EBwA1cEolgzqUb3gN/ca0618yKibgEe1G9wcw7sM2wSFGbgjXNuVM06ejGSFpYyEZ
         jFf2tk69y4kllozv1mINco1iBKZ6DylRAQJctulqHojldWL/hd7CAj/FB/XrnNn+IxVx
         6B+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m7WtS5acHiuvLtAz/POw02Vt3nMnmT2VeRYqrUtKUV8=;
        b=AmIJZlIyTLrEXiFsPV50gqHMTgkdUJBQM3ZsHKDRJiBr4lY8YAn16mhleyvOmqpSfe
         Os8sJJHD3LL4mNzNLbj1iyZhYPORq8//bz0RGNOdQL+/iP/meNP/7Gzm/9hhAOK118NQ
         d9xlKulFIr90CkQD/XnNP7IERyhW74XeBve8eXMmSPdaNxMchDpYItL6DUh0QfdG/8Uo
         YTyz4Ub1dQVwhFyIOgBLF28X5ZP1aD+tug55RyaKY89ZvLGEqODcIcKRb7CjIzUnIiNM
         aMuGlYwZEiaKHSLvqrWqgerGAY1gl/p9yPBIIDi176xK6BjVCAb3GnPHvNvLg1J6XtCY
         iWMg==
X-Gm-Message-State: AOAM533o0/VIF0XTrizvt48Nc4pateiv5a2ReXzm8RVgqM0CsD9YE6i1
        dV0L9EytWSoQOan23xAgoVNYzyTOywP0Pg==
X-Google-Smtp-Source: ABdhPJywvSLsTYVCLRNXz5w17rVD+po6qf5VfESqi8XZ10oEEcN5Fv2/mRZCs62a2a6u2AkC4U3xpA==
X-Received: by 2002:a63:1307:: with SMTP id i7mr2658098pgl.317.1604162351920;
        Sat, 31 Oct 2020 09:39:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a11sm9191664pfn.125.2020.10.31.09.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 09:39:11 -0700 (PDT)
Message-ID: <5f9d932f.1c69fb81.9e316.6b43@mx.google.com>
Date:   Sat, 31 Oct 2020 09:39:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.73-48-g1a794ced991d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 173 runs,
 1 regressions (v5.4.73-48-g1a794ced991d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 173 runs, 1 regressions (v5.4.73-48-g1a794ced=
991d)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.73-48-g1a794ced991d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.73-48-g1a794ced991d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a794ced991d5d81c2d16769e7e72fb1380d76a4 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5f9d62902ee1ba3ec93fe7e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-48=
-g1a794ced991d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-48=
-g1a794ced991d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d62902ee1ba3ec93fe=
7ea
        failing since 5 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
