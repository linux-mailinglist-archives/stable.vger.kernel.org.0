Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03CC1DB5CB
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 15:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgETN5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 09:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETN5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 09:57:36 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54732C061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 06:57:36 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f15so1370845plr.3
        for <stable@vger.kernel.org>; Wed, 20 May 2020 06:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j6CmTo6K11Ka3OyMlD8fSY8GTkMgmlQhc3AyvX9wYKE=;
        b=pWlzKy20x/U+twFgxpp6wDwG0m35kZ1KjKq96RT3zyvBlLkPQN5aK3SYddvxbINMjq
         ndfaQ94uBR2et+FEJqGMXMekmaTD+x6RXcmaZJ0asEABYoTrpWf+I2TfaMS9z/+Ki5Z9
         dAfW4zoj4Kd9rstJinuYQZF9gWRdXgMn+pmvGMrmPJoJwhQvPeU77PBtEYDHxUZa2yQp
         5jErDOPyKvUc8PM3yPsqcbE1CzldZHCWt6XZzNoCeej2fRIh/YqFOJdwd74KEAUFF+nZ
         Rvzjw01SdNfRiey9cPhdOWoPbrVF5Kbalq8X3fA0iWelog51o4qEd4FLv23zowd2eRgm
         Me+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j6CmTo6K11Ka3OyMlD8fSY8GTkMgmlQhc3AyvX9wYKE=;
        b=dfRegTb4JeZ1k/uIiUvtQqM9k/7Y85HQGrDGpXWU3unURiU1dOO6Dm43uCE83/YP1p
         K0TFo/gvzZ90pCy83LiU01UeeZQBI+yvnRGO3y2XToh8X2ngi+nAYnm/cSzf4FombwnO
         rNaRxDBGg9W4rW5Z5qmqeI0Q0mRaXryHm8amY9bamjBIDjlikzS50SHE+/ydVFrzpE4n
         6TnjtOtDyG1/rF/5riZje8X07me7hrnOOC7aFcV/b4MydIgArZk2q2PhwS71+nmCh4qT
         CNBPddaPffTHIaNiUlnYD8hv1wV+f25cbx9+B+RFGAs38OXDqDdD2W4fdBEnDejLlUa0
         mxBw==
X-Gm-Message-State: AOAM533YcBpss7tQg6i78Y83FJkeNIjYrnG1wC7x84YUCeaJJyyDnCCh
        AsL4wME/M7iaaWoXLQapV/PNbEaZDx0=
X-Google-Smtp-Source: ABdhPJwUet7FJMZiftnUlZWpdgYf2Quoz3HVAyLvLHxc3zj8tHVH/dqIvcQkXqiauLBlj0w5y7c3nw==
X-Received: by 2002:a17:90a:23ab:: with SMTP id g40mr5554924pje.224.1589983055457;
        Wed, 20 May 2020 06:57:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ay15sm2269691pjb.18.2020.05.20.06.57.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 06:57:34 -0700 (PDT)
Message-ID: <5ec5374e.1c69fb81.9a846.9079@mx.google.com>
Date:   Wed, 20 May 2020 06:57:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.124
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 89 boots: 3 failed,
 83 passed with 3 untried/unknown (v4.19.124)
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
https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel/v4.19.124/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.19.y boot: 89 boots: 3 failed, 83 passed with 3 untried/unkn=
own (v4.19.124)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.124/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.124/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.124
Git Commit: 1bab61d3e8cd96f2badf515dcb06e4e1029bc017
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 56 unique boards, 18 SoC families, 18 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.123)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.123)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.123)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab

---
For more info write to <info@kernelci.org>
