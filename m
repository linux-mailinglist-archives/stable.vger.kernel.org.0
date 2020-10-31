Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0822A1907
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 18:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgJaRm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 13:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgJaRm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 13:42:29 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A979C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 10:42:29 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h6so7527930pgk.4
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 10:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y5CPqTJYK74aAh9QYONWj8V8gLk+fWTm+cWlTpfDPaw=;
        b=uWGiQgmZTTVxP87+fGs3JTHQ9qP+cj7upWipsZ3tPKveuyMMXUFXb7YPp7vlNxyfwY
         ZpvUji+pyIoAL0ImjEiOA9mnr8zMtm7f4vWzdkPciRGaL5P1DV7rdEHnE85KrRA5uKe2
         Nk1sJ6Rojfyc+Bl1wnD8tA3X5Add890tQeUsKESPRuBfCsxS4eeEeME1pj6Ydgo/VMxb
         PTLk2UXS1y3MWbMHTskAcYp9E33GKR3/VLLrLv3kRG3APTZjgh4n9bm0LY+yEPHHBgd5
         Wo3053c4Z9WuDeplmS3Ppj/rYqZW1ae1FIjwMw4uyRD8fDSb2jR/mi9z3S4HpEN5xteX
         /Tlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y5CPqTJYK74aAh9QYONWj8V8gLk+fWTm+cWlTpfDPaw=;
        b=ufBIZBFa5/Uw6xGFXhiMYTZcNjRnSxsKXeOtdXmPquqynDWc+TOP1CTyFWs26Fy3aE
         Bw+j345D4ItoMr7jiZRqOlPMkuXvTtz6YWgktxUZmxslZ13kTqDiKbOzpD5hcuA8yLNc
         LLujvaODOqEJI6myB9KHJhGaVKNLpBCwHSY0l/HF5kXzUKCm/vEfOgBw0t/YM1XZ1Ubb
         2poyDDIi8h0MsUnljg7PJ6GtUwMxwP85aCsZ3ykBV6uIhAxa7CaHE1qTRH8guK5HdOoT
         /GnJC2ECVc7EwiL3qN5Cxlo93Golzt8V8cJ2XxPhct5rNgdVaYs7P/mHVUVZhJwfk97f
         aD8A==
X-Gm-Message-State: AOAM533GmRbinabSIl3tX5sGo2vSW7suC2ZLinAvJOw9yDR9nPxlGCVx
        VAVkTu+PHxvw8SIKVB8vxBLAB547qAxDWw==
X-Google-Smtp-Source: ABdhPJyyAuDH+noQtLpaR9Vbe8sDTi8xUha+JJlvlPRp0/uaizi/8tjM0O/oT0WcV5vy8aEoJzEiPQ==
X-Received: by 2002:a63:5245:: with SMTP id s5mr7037449pgl.205.1604166148807;
        Sat, 31 Oct 2020 10:42:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 17sm9261887pfj.49.2020.10.31.10.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 10:42:28 -0700 (PDT)
Message-ID: <5f9da204.1c69fb81.6d6d.71fb@mx.google.com>
Date:   Sat, 31 Oct 2020 10:42:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.73-49-gbf5ca41e70cb
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 177 runs,
 1 regressions (v5.4.73-49-gbf5ca41e70cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 177 runs, 1 regressions (v5.4.73-49-gbf5ca4=
1e70cb)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.73-49-gbf5ca41e70cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.73-49-gbf5ca41e70cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf5ca41e70cb8c44990cf2b4c49b3b22e88537c6 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5f9d6ac5828d1594de3fe7e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.73-=
49-gbf5ca41e70cb/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp=
157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.73-=
49-gbf5ca41e70cb/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp=
157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d6ac5828d1594de3fe=
7e4
        failing since 3 days (last pass: v5.4.72-55-g7fa6d77807db, first fa=
il: v5.4.72-409-gab6643bad070) =

 =20
