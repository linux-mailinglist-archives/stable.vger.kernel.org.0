Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CA123526B
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 14:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgHAMpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 08:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgHAMpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 08:45:54 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49E5C06174A
        for <stable@vger.kernel.org>; Sat,  1 Aug 2020 05:45:53 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j20so15787565pfe.5
        for <stable@vger.kernel.org>; Sat, 01 Aug 2020 05:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7r3YHTif7YAZOPsi2kOKyy4Om38fGmUdyqmUBk1dEXw=;
        b=W8L1AyXMcogp0A25LEZaJ5wL1h/RBUuFRSXEhDjg/gB0kGYAs4PzNOYeLsf8Ipxe8n
         168B6lImtzu6cCi9GexXXKXUNzdkIQwq4ATsb1N+BWlTCcbnIoM6cckBqAOBxNEhD0wV
         Z/GlCXecBzpQQdZvsZMyKnvtJuf/LIJKkQev6Cd6kITzprXt6eFjhUhyfYf4BFi8mTVr
         SBg0s0/rUUmAZ9Sn2sJivaEn/9orjsTqKUO070cjo5COzT3P9+l5FDcYq9Pk/Jtqliib
         LF7yt5c2Feco5JKviTTkIhBGLZByZAEeMb/YmhsYHYUlZ6ZUNFHn5NO2LgVdA5OaoZm5
         mieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7r3YHTif7YAZOPsi2kOKyy4Om38fGmUdyqmUBk1dEXw=;
        b=ipK6F/b9zeZjgt1pSyiDb/gIRiz+Kd4mTftnpKG3eBk3cFDQrwk1eZKGaEL+IGdAYO
         SAcenkncqmMg3xlvvDr+81b/6JYlsrYTgJWg9x9Kbw/xzyXhIcOT9fFytXflRbulI2ff
         isHmgDPBnRsVEo5zf4qfmHGkl4fpvscJgdaziXYeogWVoZQb5SDYIn0LbLGGgIoL5KJU
         Di8LMNSAMRe0pr6GXGe+rK0lFUAeaLg9sglbPDw8CZk4y1QuFmblBSkmIAov0SYQ+T/3
         A+2mFJM4ExUKq5qzmCseJVM2OgonwXwayPLY49LmSN9Dg5fyMj3RPYhxIK9DELFLpQoQ
         4s2A==
X-Gm-Message-State: AOAM532gCcYkL4daHD0l/3Su5/hLzjC+jOKN7pRl75fWp8wAE3TV3I/j
        u/oUZb0n3X8DonaNgBGbQ1ON/x4K26A=
X-Google-Smtp-Source: ABdhPJy8PgsNmct1eA8o7zkLbnfX7KGCJ/nTq9WKLoMMPJq625cHglRRTeBT/IADO5CfgH5EM9xeXg==
X-Received: by 2002:a62:7e88:: with SMTP id z130mr8203237pfc.14.1596285953060;
        Sat, 01 Aug 2020 05:45:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bv17sm11739342pjb.0.2020.08.01.05.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 05:45:52 -0700 (PDT)
Message-ID: <5f256400.1c69fb81.11d53.d00c@mx.google.com>
Date:   Sat, 01 Aug 2020 05:45:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.55
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 191 runs, 1 regressions (v5.4.55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 191 runs, 1 regressions (v5.4.55)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      169b93899c7dfb93a2b57da8e3505da9b2afcf5c =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f252aeb6ac38f88ae52c205

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.55/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.55/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f252aeb6ac38f88ae52c=
206
      failing since 111 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9) =20
