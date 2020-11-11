Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400A52AEB35
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 09:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgKKIZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 03:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgKKIYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 03:24:53 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F57C0613D4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 00:24:53 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x15so608214pll.2
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 00:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y/UPgyDb0loPz0jHDTsN0DVYBM7k5B7e/8cEJLykU+0=;
        b=j0pW/DkUVQiW60Mdu2H8MtxTDP5+bKpKyw2dadtOpXUSI4uDZOeK/L3PpiNEaPX91D
         ukm1Yt1/A2HKbp/dFfZWZfgh7b6UOkpTl/zbCK631eVTMW7PJEavt2N9n1lTcihqYR1c
         OiytDwA+D2tQNv1C3sOPzSs3fqhrCc4S7h9gz43ULApMKnOiw9r3+2RjzvNxaMZ1+lvS
         6R80UIOQQUPpribyMAJrXlRfOvbQX7qU3wWiWtl6U1KABxzUm3TwjNRbv8JaLtF0jyM2
         9wZO5yp8YEUztHcAnhdgwL7l8IcI4O7bxNyOm4WVn6xh28AClwtQszFLf0atD5/X6jNp
         Yl9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y/UPgyDb0loPz0jHDTsN0DVYBM7k5B7e/8cEJLykU+0=;
        b=UawLU7rXmWTV4pcjDmm/ZLSZPvAxsQ4EUinbNg3TfNjEdz8FM3S8ucut+LnX+VhtWk
         zT2mNF80ER7HDTWoi4rLNwScHMQd1EbmkVUkDTiqKc1ynAkjZzowg3HEt19pFSYEsXjr
         mN6eF1al4A/C+XR6C60bl+syZ0eZtT0g/pcVQn6cVbHSXAt+/y/FvZgvfwD3+bT3QkDA
         5XLUOSoRsBUfe5qkZ1zJrbsqET9Bhd+u9n6JgxKtg799ZTLMTUfauSVRVg/ihQE4HtC7
         6R3cBbArzuhtB6G+AK1Dw52rfhA9XPwjRWCWQlYf1VhjZId59tpM2tcjIBKG7eTqBRZ6
         2Qpw==
X-Gm-Message-State: AOAM531i15p2RJeyQmxR8x158bPcsMziE8eg3yU5rF/nt90QyAdGh9VW
        gYYj8SFHVKGI13IK++DKm4mqtjiKtwaGwQ==
X-Google-Smtp-Source: ABdhPJwEFomLHkPgVKhCQvvYUK/sPwzA1BXOuo4r5NRbQAp/B6FfJNjUaF4KzM9gJYi+mlVd+gACIA==
X-Received: by 2002:a17:90b:297:: with SMTP id az23mr2855878pjb.71.1605083092770;
        Wed, 11 Nov 2020 00:24:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m3sm1695811pfd.217.2020.11.11.00.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 00:24:52 -0800 (PST)
Message-ID: <5fab9fd4.1c69fb81.5d90d.419a@mx.google.com>
Date:   Wed, 11 Nov 2020 00:24:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.157
Subject: stable/linux-4.19.y baseline: 98 runs, 1 regressions (v4.19.157)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 98 runs, 1 regressions (v4.19.157)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.157/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.157
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      31acccdc877486a649a86d37725a15175fcd5ed6 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fab6b15ecc2c57ab2db8854

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.157/=
arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.157/=
arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fab6b15ecc2c57ab2db8=
855
        new failure (last pass: v4.19.156) =

 =20
