Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45812A2115
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 20:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgKATWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 14:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgKATWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 14:22:44 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C4CC0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 11:22:44 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id i7so6969190pgh.6
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 11:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GmwQg8CFjzPaGUp0coA/VnMRom6ZvaLYyvVvYRWhLAQ=;
        b=BJ3la0vKTB2P2Mw4Yp/vHZhCdUySDw0rIY8XA1ZZId/VV6+ynVlqtfQqCfrCQ3rfns
         BNuYDCX2+Kk4dsdYjta60Q5lxrKQgysy5YDv6X2CI5KODyXrCPgSKOg5kqQzmljWYLFv
         ekkYPo6rw6fAlcuchAPHK6mTH52hH5adQ68lUCi15E+pNQ064DTD2D96FfVoio0hRqFr
         VRO695qS0dTaTaQOAZkI8zqYKtFUaYbzrBZr8oObSYOPuXqB2DmVDiFFLN4Y8tFEyhLg
         epbnQ8v2xeAeSa72AG0aqOxDHavHFV0BDZThCZWFMmZb87sdReu+U2xtWdcwc7bI/R23
         +daQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GmwQg8CFjzPaGUp0coA/VnMRom6ZvaLYyvVvYRWhLAQ=;
        b=U8garyzfpaKPNSHWPTZXm5a7BRAdVIIlGlWUiNLGPBvkrhMnIEZHyBT4RLYbTkwk2/
         ZGq6BL6N/jvHCdWimNxTyyoT9HyATbAOgqEepcHxJ495PqfLbY3ilcf6ti17tvoBt2Yt
         PfLlhZQ5JKO8rzSEzxjqKVDV0s3kdfbJJ52ofIItWDP7ED9OxQbfwFVbslni1m+u8Kj/
         bZ6J9KlJQE6cZf1rUYa/PdXpxLT1B2DQgOiLkwr6Q4cVNgdBpIzzWlCPtWplTHmSwIFc
         RpaXY1H8zKv2bb2/yxlilpTK7yfCVA5vM4PNitXln56113nFzRy70VslUR32vz5wZbYA
         Ielw==
X-Gm-Message-State: AOAM530ox7ldMD9GpbDmk5uLwgyO7kEN+UwDd4rzc6PGUi0i/ceMGptg
        eCU7lD1/p/ba7pmAf0aSahig89+1vPH+WQ==
X-Google-Smtp-Source: ABdhPJxCiPH6EbVphYEYC7vqtxMO9AQRDJ/3OHiRyD71mJj99uqpmhY0jpq7L3TVMVtaWQrgzliC4Q==
X-Received: by 2002:aa7:8805:0:b029:160:b5d:b279 with SMTP id c5-20020aa788050000b02901600b5db279mr18542132pfo.63.1604258564186;
        Sun, 01 Nov 2020 11:22:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 136sm11805343pfa.132.2020.11.01.11.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 11:22:43 -0800 (PST)
Message-ID: <5f9f0b03.1c69fb81.cebc0.fa4b@mx.google.com>
Date:   Sun, 01 Nov 2020 11:22:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 195 runs, 2 regressions (v4.19.154)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 195 runs, 2 regressions (v4.19.154)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.154/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.154
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f5d8eef067acee3fda37137f4a08c0d3f6427a8e =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9c0f47a208d1a96638101c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9c0f47a208d1a966381=
01d
        failing since 136 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9c11f2eac96582b4381030

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9c11f2eac9658=
2b4381037
        new failure (last pass: v4.19.153)
        2 lines =

 =20
