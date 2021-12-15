Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011EA475505
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 10:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbhLOJTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 04:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236374AbhLOJTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 04:19:16 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C008C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 01:19:16 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id a23so15080561pgm.4
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 01:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6Nno8lBUFpdcr3uLrKI6WcquLULjaaoQfvrwEUeSLxk=;
        b=FSS6kT4SGHWkTEXShA1Gm4NN/Cmls85XAk4Yrithdm7asJmgGoqbPghuZIn+aJVFW4
         SU/kv/hr4uoB0Hve6OdEzAH3qVlGZf2uWUvg31drmu3fWDlWYtdgLE5z5HB2T0cNmLM0
         Y6LrA8n0biwuqtJrxtjlrHUhjUV0rGFeFVhznrqw0ICHKf5GnXmD/6MtxbV/5Zjv7Rdp
         EwUkxkfxc9oBqFUdBoneP4NBjSfbX1zd/MBybryV2O4OeZXwWd1sgOW+ZF4OiBrlCIFa
         L0FpKiigX3pBJ9V6nUDFXtMGz+DyNU8QVG8DpW3X3uTUoRylxtpYHLIV65WYUExlGq/m
         ZtVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6Nno8lBUFpdcr3uLrKI6WcquLULjaaoQfvrwEUeSLxk=;
        b=R6SnVJujoF0WX7lU2yKfg38UxXploJ8hMjDPnW+lOIUm1oKF6pZobyatc8BbVHJ1mC
         sr+JybrTH0uKODR7SN9Uij5OyeaOzqP5+zGqlzD8Y7SPcC37W3u/wwDJjFt9sK6O1X5g
         B7/3oYJgTJEGiQL7T+ZJKgWdmYgSd0YxmNxJtI8lyrUH+Zja0EMOYZOFSZzElrUy4gi+
         LQo25+GKwOFWBf9R7hW96YKDmLEUw9LYqPeAzi7Bm4VC+ngdr/h6eHANMkUJZ31B1O3H
         kzWxiiCxh3P09a6sx/oeayJR87phjESvW7Ghbd5GO4m5fu4dvgO33FhQ9f8x8NxfPt8D
         uZTQ==
X-Gm-Message-State: AOAM531sBc/UWffXyDQOvQt9kFWuiCvU+NRWhtzV0T7QIQAGQvo1hYAF
        5XPZiZAWa+BOmcCzbigLOW9dofFc5NGu73Wq
X-Google-Smtp-Source: ABdhPJzIywCvHJFWY35pAO8wo+ujAFwW0jYhierre2K3FmU2mnwWFXjGAIEE87V/cUS/jsIn1poTtQ==
X-Received: by 2002:a05:6a00:1343:b0:4ad:99ae:d4b3 with SMTP id k3-20020a056a00134300b004ad99aed4b3mr8114128pfu.64.1639559955848;
        Wed, 15 Dec 2021 01:19:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ev3sm818919pjb.48.2021.12.15.01.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 01:19:15 -0800 (PST)
Message-ID: <61b9b313.1c69fb81.55af2.1622@mx.google.com>
Date:   Wed, 15 Dec 2021 01:19:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.85-14-ga0e5648b46a9
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 141 runs,
 2 regressions (v5.10.85-14-ga0e5648b46a9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 141 runs, 2 regressions (v5.10.85-14-ga0e564=
8b46a9)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

sun50i-a64-bananapi-m64  | arm64  | lab-clabbe    | gcc-10   | defconfig   =
                 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.85-14-ga0e5648b46a9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.85-14-ga0e5648b46a9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0e5648b46a984339e8c472bfe5da299dd65fc3b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b9795c6bf4889885397129

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
14-ga0e5648b46a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
14-ga0e5648b46a9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b9795c6bf4889885397=
12a
        failing since 0 day (last pass: v5.10.84-132-g4821c82036b6, first f=
ail: v5.10.84-132-g7154d0f70682) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
sun50i-a64-bananapi-m64  | arm64  | lab-clabbe    | gcc-10   | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/61b97e7c926c7c573739718f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
14-ga0e5648b46a9/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
14-ga0e5648b46a9/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b97e7c926c7c5737397=
190
        new failure (last pass: v5.10.85-1-g8f1fe98f60cd) =

 =20
