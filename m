Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782B229EF6A
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 16:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgJ2PNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 11:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgJ2PNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 11:13:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563C8C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 08:13:34 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id o129so2589776pfb.1
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 08:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pdd6yyxqVfRQnzREvNQ0txHG81tAB2WNIth7jKVlUwY=;
        b=FuSUf6EzPfI95Wj2vuoKs7+9C/sPB8JkA8YT9UUja0JtS3VeI8WnoZlW4AgxcSpR5U
         KaFeTBQNOPYsQypXrbKyzNX68IbCz0OTvcJQ0diD3gOom9Y4LkMj8n6tFR1vMeg9H6WC
         33zZgQ1H5hKshv9dPbJZC8Uz5MW50GUleItrY+vvFDzEAmyPbtaM5AguLZ9lx8soKa20
         lVeidm3DkHd33p+ippXJ4vTozLCFxnNxX6YsYlQSwlyzpPxsGA/YVA9YbT7kuc/lafn/
         +uV9cMNwEoxXLj9JNywZCv6e9sRYGvBKqtSI1IcsHK2oRv1N2sy/nqnNhrpQm5sTs7zZ
         VkNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pdd6yyxqVfRQnzREvNQ0txHG81tAB2WNIth7jKVlUwY=;
        b=csfSFzK6jWkXwqbL54WZmxYUn88ynCOBfjX/tlGVimgOGwQoAp9ROZYCxsck9CTELu
         h2n16dq65pm24OMw6zGFqKeipRQOPWD3g9tmu8hSB5B1lEUCc0D9QPs15RjG54oSXuFL
         UtR+Qz/wJfj7kYIcTJdav9E7YrY2UOwCMCQZYqFKBokQQPr1df8Iv+tYy9EcCvjvNV7O
         icH3wp6cTQQpOb12ZTWrfjs2fltLS3X29lpw6p2y2FvWzqnG4DcSnDWe+r4WK4lm3tKr
         kkyusiJAMowAm5W5xGFmVOSYQS5EDEVjZTYgbT47Q9sl2YnZ5HVTrzIdl8XgFYlYzNxM
         Z+Mw==
X-Gm-Message-State: AOAM533mNEZylMFvM1EL6nzr7q1ygx4aCtA0vVQaF+S7Vuj5qFkJX+yx
        +7bRlXnhyg0wFCWyAZv2dhOwYWDUCca+Yg==
X-Google-Smtp-Source: ABdhPJwLOJOjqAcYTuGBod0XJwtbcabsWoFG+xslUNbovwPNNQfCkT/0sKlPyx+CTdWh9eKxU7r3SA==
X-Received: by 2002:aa7:96f6:0:b029:164:2def:5ef7 with SMTP id i22-20020aa796f60000b02901642def5ef7mr4651338pfq.44.1603984413538;
        Thu, 29 Oct 2020 08:13:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f17sm3258705pfq.141.2020.10.29.08.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 08:13:32 -0700 (PDT)
Message-ID: <5f9adc1c.1c69fb81.3c0b6.791f@mx.google.com>
Date:   Thu, 29 Oct 2020 08:13:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-632-gdc7f1e674b6d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 201 runs,
 2 regressions (v5.8.16-632-gdc7f1e674b6d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 201 runs, 2 regressions (v5.8.16-632-gdc7f1e6=
74b6d)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig          | =
regressions
-------------------+------+--------------+----------+--------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig  | =
1          =

stm32mp157c-dk2    | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-632-gdc7f1e674b6d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-632-gdc7f1e674b6d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc7f1e674b6d692c7531ec2add97afeab940ab3c =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig          | =
regressions
-------------------+------+--------------+----------+--------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9aa93b412309c51a38102d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
2-gdc7f1e674b6d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
2-gdc7f1e674b6d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9aa93b412309c51a381=
02e
        new failure (last pass: v5.8.16-632-g35e3ec0c7174) =

 =



platform           | arch | lab          | compiler | defconfig          | =
regressions
-------------------+------+--------------+----------+--------------------+-=
-----------
stm32mp157c-dk2    | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9aaa86870e20d5c138102b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
2-gdc7f1e674b6d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-63=
2-gdc7f1e674b6d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9aaa86870e20d5c1381=
02c
        failing since 3 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
