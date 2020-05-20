Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9577F1DB515
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 15:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgETNdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 09:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgETNdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 09:33:00 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332C0C061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 06:33:00 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d3so1346628pln.1
        for <stable@vger.kernel.org>; Wed, 20 May 2020 06:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zvWKvDTndPDMsV1ssJ+jOf+KnUMdp21Dz9txBG7N58E=;
        b=VkgyJsimgbh42cxva9j605qSqJ/f/xm0jonXRELGffegiVwz9emU7/TkrB3/xU6HxE
         nDWvJSZ4/XhCUOSadeoxIPON/65wf0qMH9PTIRmi5TfP2F8bpLLVC6KUefueGmbTpBRW
         tNBJirC8WlrgDHotWxPzdUc6HUPV3bueh5derzucBq0Nlx7GEUzIFAMI2PaUW3m7dRVd
         Mehr/vF4kuw2fR+/IsA+SOt5aXbbtNfeWYMWLwP76CJ4FnVIPNnPgvjKxANIOUZrQxDO
         5tHKOzI+8RwO6xw7dSexrJZafEu4XoNC3ICXa75l4ec8VhTxTjCOiV/Mo49qq1az1Va0
         S+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zvWKvDTndPDMsV1ssJ+jOf+KnUMdp21Dz9txBG7N58E=;
        b=VRODtDW1mLxCduCj5aJ5yggj2W7hRs2oXoITK+7mfVZTtmNrVonTt0eUUnPtoFKMLt
         +XkJkh1/VcCgoDd9C45ej5ArOMQCw5oeDFQ41psrdUyV9x8aK3gXubOv6KC0ByvJLAUZ
         8S89I/pFQwIuhmZtI2efR/QdjUffAuT9rETplvlq9ZGaZKoKYgniMZX+/uuTWDxpsW9x
         xWDN3tcfHw8IHfw00x4hGrOz5wDGaSjX98iK7AlejyAHYT5XWZck3ct/Ge2nlehahDs/
         YnXJ30lYro3h0Mi8adUFrkoVe2YGoNsXdSQ+EsAT61aAJxmPd+mbRi9yMo2pHnnLILO/
         3QWw==
X-Gm-Message-State: AOAM531jWd2FBBIEkXRniWgkcYkCnHVjpE46A1lFLte5eILORV8lFlqj
        h2e5ZzQpeWZF663hdM9gqkrNcAbZ+tw=
X-Google-Smtp-Source: ABdhPJzHK8Xg0NoDN+5fKv0gyuK6L1p8RlOx8b90KHa1q3F3LvPFkYq8iUPquo/WECpMriGiOfiTag==
X-Received: by 2002:a17:90a:dd42:: with SMTP id u2mr5460051pjv.65.1589981579401;
        Wed, 20 May 2020 06:32:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i17sm2272178pfq.197.2020.05.20.06.32.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 06:32:58 -0700 (PDT)
Message-ID: <5ec5318a.1c69fb81.b1ae.8eb5@mx.google.com>
Date:   Wed, 20 May 2020 06:32:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.6.14
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
Subject: stable/linux-5.6.y boot: 82 boots: 1 failed,
 78 passed with 3 untried/unknown (v5.6.14)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable/branch/linux-5.6.y/kernel/v5.6.14/plan=
/baseline/

---------------------------------------------------------------------------=
----

stable/linux-5.6.y boot: 82 boots: 1 failed, 78 passed with 3 untried/unkno=
wn (v5.6.14)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
6.y/kernel/v5.6.14/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.6.y/ke=
rnel/v5.6.14/

Tree: stable
Branch: linux-5.6.y
Git Describe: v5.6.14
Git Commit: e3ac9117b18596b7363d5b7904ab03a7d782b40c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 56 unique boards, 16 SoC families, 13 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.6.13)

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v5.6.13)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.6.12)
          sun50i-h6-orangepi-3:
              lab-clabbe: new failure (last pass: v5.6.12)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
