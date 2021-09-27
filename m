Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8D9419447
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 14:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhI0Mce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 08:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbhI0Mcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 08:32:33 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CEFC061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 05:30:55 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id r7so11784375pjo.3
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 05:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o3jIQcD1+L3A6BT9yoni62/v5FDkFlE8fd16/SeI6SQ=;
        b=KVw8s1JQLlj7AM4pdhSSCp5G95bU6ym041LR1uvzBJT/ikj4uBX3qVmUhrzbJCQVOX
         3egiXh+E1yfYe/9cmQGU3OuNQ2P/iq/Cta5QX/imIOh1/s/Bcsj2ZGflCiTuZwfEICXu
         cec+wtv26Fb/viln7U63evEC4aLACmk5wbb9lF/DU3DU/65lGwnzsRgHQ8K4+SATxpP4
         kxeMqhUCaLreFHzEDotfRKTApPdUivG9MYlNl3GivZgJMd2CCaILRReK2UqbDZqjSngZ
         EqU6WUWeW3ercS7t6IjpH7KkhI08+jH6/IG3g8JY4BNo9KI8csZ5FKJi9ESMckv1S7nI
         HKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o3jIQcD1+L3A6BT9yoni62/v5FDkFlE8fd16/SeI6SQ=;
        b=0L46/VoYFjtjmb7J5vLxU+BH5bnxEEW9dslNKiC6TiQkncvya2QZyGxjXosZmAKnUa
         32cRRH+mKZxtqDGaLXolxMfjGGv3NQwcTKIoDfS11i2Xgz/f1gBUO9zlLgeAGuTlk9xh
         tZNX5uNMu0DWflfF2yIQvLHHOqRoCzlwJxw8l4Z5J1+O9pNYxJDg3Kf4ONQKM6GXHUL2
         aPcmoJE9VcXdQD+ahJ8dLJ3JZZTWcKOOiooMHhH9vfw1zotBvvel/XJ3Fmaw/xsB3xHg
         dNtI9/tnz8DEXRiDLP8ksqJGSu92YwgsCbJyjp1MNlZswz+/eRifDpAKCtAj76p0tSCI
         DLgQ==
X-Gm-Message-State: AOAM531KvL9axlXeaY1jr+J8DjZhGZltottVxRL8OsjDey7cqGcM2Mh1
        c47MariYMA3rwfWpy+Q/tzwgqlnNkwg/Ik26
X-Google-Smtp-Source: ABdhPJxDcBnBS7QTMKIeDwZXGz+xhZgYrgRh23rPtgkmtmG0fIgvpThVp4MVv8kb0Q2kZBgtTVlvAg==
X-Received: by 2002:a17:90b:4d07:: with SMTP id mw7mr18847944pjb.66.1632745855230;
        Mon, 27 Sep 2021 05:30:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f27sm18083945pfq.78.2021.09.27.05.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 05:30:54 -0700 (PDT)
Message-ID: <6151b97e.1c69fb81.e8521.9f45@mx.google.com>
Date:   Mon, 27 Sep 2021 05:30:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.7-248-gf2e859a1e522
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 158 runs,
 2 regressions (v5.14.7-248-gf2e859a1e522)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 158 runs, 2 regressions (v5.14.7-248-gf2e859=
a1e522)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.7-248-gf2e859a1e522/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.7-248-gf2e859a1e522
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f2e859a1e5222332702207c6145ea1df25164c65 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61518622a4f6f9f0eb99a304

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-2=
48-gf2e859a1e522/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-2=
48-gf2e859a1e522/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61518622a4f6f9f0eb99a=
305
        new failure (last pass: v5.14.7-145-g9bda1b95c376) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6151863b82bf1c90a299a394

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-2=
48-gf2e859a1e522/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-2=
48-gf2e859a1e522/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6151863b82bf1c90a299a=
395
        failing since 2 days (last pass: v5.14.7-3-g11f9723f1192, first fai=
l: v5.14.7-100-g3633965a8dc7) =

 =20
