Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C825722773E
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 05:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgGUDvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 23:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgGUDvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 23:51:19 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A567C061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 20:51:19 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q17so9646144pls.9
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 20:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5JsplX05b8pqVt0DUjmoPhqiB8vJYS0XKuQNTFqPmdk=;
        b=t3exQ7mRR1R5VwULbeNtYLwGlVuIB2RNrWKAhD1QN68haXP/4oaswEuEvuGwBeuMKB
         GKCAVv71ch5XYk1XcCbO7zDYDExnFteCLWQ6U1rli0VYSjm5y9lHQWGVXBDISZdokwrG
         FxvPn6cBkDxGyB0Qh0nZ6EjRtLiv53kGf/H6B1/KFit9ozLITtH9C6kJyQvZtPeFXcXO
         EzuGMaODldYMWbCXqbqjcE/6yTcedXKINfkGV/6PCWGKBkpvVrSCxYzTSCz9kZGoPnjZ
         qeqcWdne7ScKczT38w2cBfcqbPZvuelht8H0FHYMQAUSlRrLAbeQvftOxQ1x80lwW18G
         ZywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5JsplX05b8pqVt0DUjmoPhqiB8vJYS0XKuQNTFqPmdk=;
        b=VUkTHw2cz510Cubh7Cw63O5Ymvp6z9F4zc6kLKuejqHtWy+p3O+xgrZo35Gdqmgdcs
         heRfP4sFPiBh3z7aRwDmSQtg5smeZ2huiynY5des1jEGQrefeUlvG25o6GFYhTP8OtXQ
         72Bno4dCdXQ6/gabq/fQHTmMzC4hzzpEWVmt6xmGz81GDufeqIbIM9abN8cPW+yWBycG
         9vv8ZeZKlqPUC4s3hIin3G9UsDBq2LgVjmlUQcqzBfp9ToyquVV32KMM2hKBiCMZccaH
         5tcn3mUsBifRU+94HWmhhWFr6eXHkNgRehhdHyrBu8RCNikt/iwEctfEWkdXXaf0jemD
         VIsg==
X-Gm-Message-State: AOAM533l8hplgS0jfyEPM+Wkr+4QinFpCUTTQAu0g7g2WqBu37wvwOUE
        H7kNAkmhUK/zGh3pmxeknvRWWjy0aI4=
X-Google-Smtp-Source: ABdhPJyTe+DvT6mnROb64nw/GtccX6XI+qc951VzJl63mIJrHiYhSyCcHopOFia6bR9E5gJ8NdqyRw==
X-Received: by 2002:a17:902:988d:: with SMTP id s13mr19489741plp.228.1595303478172;
        Mon, 20 Jul 2020 20:51:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q13sm19567163pfk.8.2020.07.20.20.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 20:51:17 -0700 (PDT)
Message-ID: <5f166635.1c69fb81.6c38a.f94a@mx.google.com>
Date:   Mon, 20 Jul 2020 20:51:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.7.9-244-g7d2e5723ce4a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 139 runs,
 3 regressions (v5.7.9-244-g7d2e5723ce4a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 139 runs, 3 regressions (v5.7.9-244-g7d2e57=
23ce4a)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
 | results
------------------------+-------+--------------+----------+----------------=
-+--------
at91-sama5d4_xplained   | arm   | lab-baylibre | gcc-8    | sama5_defconfig=
 | 0/1    =

bcm2837-rpi-3-b         | arm64 | lab-baylibre | gcc-8    | defconfig      =
 | 4/5    =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.9-244-g7d2e5723ce4a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.9-244-g7d2e5723ce4a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d2e5723ce4ac92e4ad9337075863b004ceb7083 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
 | results
------------------------+-------+--------------+----------+----------------=
-+--------
at91-sama5d4_xplained   | arm   | lab-baylibre | gcc-8    | sama5_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f162d4afce8d5138185bb2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-2=
44-g7d2e5723ce4a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-2=
44-g7d2e5723ce4a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f162d4afce8d5138185b=
b2e
      failing since 4 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fail=
: v5.7.9) =



platform                | arch  | lab          | compiler | defconfig      =
 | results
------------------------+-------+--------------+----------+----------------=
-+--------
bcm2837-rpi-3-b         | arm64 | lab-baylibre | gcc-8    | defconfig      =
 | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f162fccc9a5e46b1f85bb18

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-2=
44-g7d2e5723ce4a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-2=
44-g7d2e5723ce4a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f162fccc9a5e46b=
1f85bb1b
      new failure (last pass: v5.7.9-32-g83669367670a)
      1 lines =



platform                | arch  | lab          | compiler | defconfig      =
 | results
------------------------+-------+--------------+----------+----------------=
-+--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f16307f45538c2b9785bb1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-2=
44-g7d2e5723ce4a/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-2=
44-g7d2e5723ce4a/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f16307f45538c2b9785b=
b20
      failing since 3 days (last pass: v5.7.9, first fail: v5.7.9-32-g83669=
367670a) =20
