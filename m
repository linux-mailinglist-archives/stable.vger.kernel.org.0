Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABBD47481C
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 17:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhLNQbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 11:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbhLNQbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 11:31:49 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253F6C06173F
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 08:31:49 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id q17so13900038plr.11
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 08:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6sUe2gGKHbBesotFC/8whh7dlnoXGNt/SIiIBOCYeSQ=;
        b=F7Cxuu1NZe+r5DJocqCLRcFgbJABGCkNTU/+9SJa7sPBl/xDp4gVa97GW+7QUeqxiW
         o6/72+IJ9NPYcQT66egvs9+eTd0LCgD0wvGBHWYuZU0A2PyOdU4KDQwlWEb1GL8Y5xqF
         CFpdkXnaln7zWOE48/+TrDgkxZXAUPJF2nGeguIzB7o09QBrtkbkIywg1whskkCf1sfZ
         rLT8emgc8WqvO138903fs4QJ/I7d036OQEg9ORtvlN3WZ4D5XK9AAxiyAkcWrecZL4tO
         lwU53JCTvzSI9AAySeuSn/mpRjREJRokW/jlqxnX+rrZBAoY2qflpZ7o7wmZxJihhXmV
         OFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6sUe2gGKHbBesotFC/8whh7dlnoXGNt/SIiIBOCYeSQ=;
        b=WqqCYjHWP4Fw0svfRd05IQtCLlWngcffCc0evhUdBxT13hYBCS1ZHeL0X1+ZN7GVzp
         ULstR0tsxALWatQkElBy+5JVqyL9NNQ4goYG5zyAAOer+CBv47Y1yu0ObcG2zAxIC/tf
         iEAtCM8KYXbjOBpM0XKry0bDcF8aALMg9BA8VtIJp3V2vRw1j5k/0tSHZDLQgounVK+b
         6kojKuqR7e305DK9Pwa7HJX8lmr3hjIPtSNhBH3NyJ3hDBOOYDTa5ak4UkYVRM2eS0/e
         rtxiDnj2ogq6/PzQvUQy8rXtj40lwtIhTvcBnKWR15unG8q4NmSYlAnsIFpt5xVnBYI7
         v1oQ==
X-Gm-Message-State: AOAM531JZHYWdd/7+DeiSZrTykAqbSNz/aw5AMYBZmuXGS0y+msWVjX3
        k+bkr7Q/njSFKqg4nOZ9z/Ekf3mL/9u3pIpx
X-Google-Smtp-Source: ABdhPJxF/lYnfO4OVhZ3fYvKTS/7fVNMzVe54toaL5GUJWev5rIuUTklRnhOY16366vhusiIQhBxbw==
X-Received: by 2002:a17:902:db01:b0:141:ea12:2176 with SMTP id m1-20020a170902db0100b00141ea122176mr7370193plx.44.1639499508471;
        Tue, 14 Dec 2021 08:31:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b19sm343326pfv.63.2021.12.14.08.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 08:31:48 -0800 (PST)
Message-ID: <61b8c6f4.1c69fb81.2d63f.0fc8@mx.google.com>
Date:   Tue, 14 Dec 2021 08:31:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.84-132-g7154d0f70682
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 175 runs,
 2 regressions (v5.10.84-132-g7154d0f70682)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 175 runs, 2 regressions (v5.10.84-132-g7154d=
0f70682)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

r8a77950-salvator-x      | arm64  | lab-baylibre  | gcc-10   | defconfig   =
                 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.84-132-g7154d0f70682/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.84-132-g7154d0f70682
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7154d0f7068228b7cd42d7d46de568958d1e06b9 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b88cc725d7464cf8397131

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
132-g7154d0f70682/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
132-g7154d0f70682/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b88cc725d7464cf8397=
132
        new failure (last pass: v5.10.84-132-g4821c82036b6) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
r8a77950-salvator-x      | arm64  | lab-baylibre  | gcc-10   | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/61b88f6c97774920a739714b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
132-g7154d0f70682/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
132-g7154d0f70682/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b88f6c97774920a7397=
14c
        new failure (last pass: v5.10.84-132-g4821c82036b6) =

 =20
