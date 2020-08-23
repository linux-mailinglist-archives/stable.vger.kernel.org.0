Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3952624EFA5
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 22:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHWUBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 16:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgHWUBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 16:01:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8854C061573
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 13:01:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mw10so3080373pjb.2
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 13:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aafFgFZmpxvIhVh+t/njgPveXaSijTPkCVpeEkWajeY=;
        b=eCaUHuTptfE6098OsnaCgcrPq0HVNU7y0RXcFXuDFstFtULNOysk66MSpaUWTfrzJu
         kHW+BpvW33fgwNAhAgdI70Gp7Xsl96zdW/AKaU7V27r+Rf590eoiMcUvlXKvThSZpxNZ
         JT/jwWmAxDuoNxGNNDGprFxmKC4I7TYGmwjvjYIO7bflqI0C8jb/c0hK3XiGI7ZhVzQX
         6yTWdwwcScr1nEjxU9ZofPnrQLuliDVPyMz5quoHNSEqmQFWHIpw69CyMzArswWzhQEk
         kVBz9JTAgho6rhVCnjuXtv+wXcxNBTbTv7wP+i5BQPpuTlhxqvzgzvRBRG6ItSCVQkS9
         IdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aafFgFZmpxvIhVh+t/njgPveXaSijTPkCVpeEkWajeY=;
        b=YrKaZzfwd9gxjffp/0Gp7OzA4EW7uCa02jUe+1aSJCYui7TX4otO6+Bj8ZsUkj9gGa
         ejEH528nZgLZjwAjVZfOMNRk9SzL1Xt/h7RXFwnzfFl9FAFKOREmcrEou4qSEN4EDNpY
         YcM00T9F5lBqT1nAlbJcWpPCztwY9J5/22Oe4Oe2RtvvChmqdYnPOcLVYwqhcoHY+mJd
         Z/b83A3KajL9yyhTA2upah6Yw9rKt4pCjMYR2M23/c0w4s1FipJkakSz0lnhc6gJZ4yj
         bSaXdPnPUESk2c7l8Qd4uY1N4GA1jErV8KzNxDyOWFzyonEfVHN7OrELKbKDUHFvvOjU
         auJA==
X-Gm-Message-State: AOAM530jyNOHS+0jOyvCJFXvg+D5UiZzL3adUWqkFPpIAGBg1F6FDkKb
        0TxXEeREA7Pob+D3oBMoPGvxORTz5SIILg==
X-Google-Smtp-Source: ABdhPJzkbNSHVjUgF2SVlP/AIMOktlgsibTITbqT/EESsnrQF5yOY9AyDoZcr37r6Qx64p9gl3fhrA==
X-Received: by 2002:a17:90a:a101:: with SMTP id s1mr1799017pjp.205.1598212866499;
        Sun, 23 Aug 2020 13:01:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nu14sm7042570pjb.19.2020.08.23.13.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 13:01:05 -0700 (PDT)
Message-ID: <5f42cb01.1c69fb81.74182.3d6a@mx.google.com>
Date:   Sun, 23 Aug 2020 13:01:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.141-19-ga76a89456133
Subject: stable-rc/linux-4.19.y baseline: 152 runs,
 1 regressions (v4.19.141-19-ga76a89456133)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 152 runs, 1 regressions (v4.19.141-19-ga76=
a89456133)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.141-19-ga76a89456133/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.141-19-ga76a89456133
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a76a89456133f91791ee74d2ea5c8d761a56a413 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f429023f6807a49a29fb438

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41-19-ga76a89456133/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41-19-ga76a89456133/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f429023f6807a49a29fb=
439
      failing since 68 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88)  =20
