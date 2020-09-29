Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F28227BA8F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgI2B5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgI2B5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 21:57:36 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9983EC061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 18:57:34 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id n14so2985506pff.6
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 18:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gRVn6sIrImWqjtQTWNvekCU1oHLOnLrvteYuEqA/YgE=;
        b=vWY7hPlMQlDjTHAy/lZu9dZFIYtFnW53WUV7cpB+wWczD01NMMHH6iokvhdNHmP1Mx
         t0ePrQLyEZoh2v6UaSMAC9jfkQkghxxcFwSEgbGWL+194PbiRC7fv6UeRfM0sFJfoe9j
         Dr0OSBkkjFND3YkJI6xHcqYKwqwc+gFZ0HCb5GhFSHZNzjaul0BkbgiHwGOuIPoHj+f9
         pytK0u2PN0IAW7zRKkJzwhzCzmYQPacIiMlmMyJ6pZLuDm+87YLf9TD0q71OgRiAkXSA
         mj9d6HG22fNbq3tXZRXwXJIj/Ko4UjsIuJdHoNVb6KE+B0i5/5crgXI5iJ4nnOdGifHi
         /xYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gRVn6sIrImWqjtQTWNvekCU1oHLOnLrvteYuEqA/YgE=;
        b=uY5qQuSIo9ocnYSfqHEVBZouIibm0mAsRKE7YQaqYCjA4wgcF3qqn6KHfzkfUDlZRh
         lZSzBmlcHQ3xCjy2tb7f+OAz4mYQMx5NfL95zwyi6NXpHK9SQ5FjCpw7XVkz0MR3/XGV
         Ji7NhSkzaJxo+XYgKjOuFtAPCxufy0hVAFzm8RJJ4IXNsNvAT9ZKR7UaHpWJ1jFONHwv
         cJc1DjNIL6Vvc6L8wuGS9Fd30H4yMmyaw9UKarezs5lfTozapbvH0NTYVG+6zWFvBq1f
         D7kSoMcbfHUwdxyB7ncYTyEmaFHsSRQor5LsbemDSZwgDWSwJykf6YbKZnI5d6eHPc3u
         fhyQ==
X-Gm-Message-State: AOAM531qm4qTg7yh34SY3f6wasVdkH/1QJIoQrflQhLtXg8xHXJ3N+84
        O5ivqVvI33Wr6fep8t22F7W4nPl6FOiulw==
X-Google-Smtp-Source: ABdhPJwQhJC8RwL/Nwc5BsfoiILEACQ0gcOCj6eG1Ptu0ujguOwJrVI3JT9nK1jikg2jgzIhAwGIrQ==
X-Received: by 2002:aa7:9e43:0:b029:142:2501:34e3 with SMTP id z3-20020aa79e430000b0290142250134e3mr1883465pfq.60.1601344653846;
        Mon, 28 Sep 2020 18:57:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l79sm2984907pfd.210.2020.09.28.18.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 18:57:33 -0700 (PDT)
Message-ID: <5f72948d.1c69fb81.ab9b7.6a0f@mx.google.com>
Date:   Mon, 28 Sep 2020 18:57:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.68-388-g8a579883a490
Subject: stable-rc/linux-5.4.y baseline: 151 runs,
 1 regressions (v5.4.68-388-g8a579883a490)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 151 runs, 1 regressions (v5.4.68-388-g8a579=
883a490)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.68-388-g8a579883a490/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.68-388-g8a579883a490
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a579883a490eaff03bcfe7b51ec92e3c5638144 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f725af75cffdc82f7bf9eaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.68-=
388-g8a579883a490/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.68-=
388-g8a579883a490/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f725af75cffdc82f7bf9=
eab
      failing since 170 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =20
