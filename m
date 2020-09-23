Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C142760D0
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 21:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgIWTPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 15:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWTPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 15:15:36 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2332AC0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 12:15:36 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m15so214613pls.8
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 12:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IGI4azsLUq0wPVnKbVUAsmeJi5vqTgxmDog2vcX/oZ4=;
        b=zO3+HzvKrFxczgT6wzLUL4D+VB+HiLYN8XUDROdzry4gCAhGLSFWeSNAmr1WzmldsX
         5rqcAEjP39NaAP0NTWGVONpjV6wRVFvB1Womr5hic4nLEfdV97s3E3qorMwS3hoePdxE
         0Qg3sv4aXb+WmLSLbGcbjSubbSHyDQcEUd0RaPXq+Q0ohvXcyC0TCZIKgXCfmYoHy0mX
         ussNw92OjXOLJylyBsqnRB6q5QoHbbMy7nFmWgyp8Ni7tRezkfn04jCpX5phtyciMnPR
         KytiZ3mb7Flfw2t9Y8X1dujoLPsucOVrfZbs5/4gx+qh9bsa0vbeoJxw3iwd8HDVCxH2
         9vEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IGI4azsLUq0wPVnKbVUAsmeJi5vqTgxmDog2vcX/oZ4=;
        b=beLJiPxVnNCHGtWXZz35HQiqEuk229rldXmEM6o3zn5C8twDcQ3kahqCx93k7zM9+m
         eBQtwIxSbjAmXL+w//PQLQxnlNteV+VmUoNj/Uy0NJ3yJTiutqwq8zKIQ8ftc5ZWA47n
         lHmDj9y7A50Y/aNdm/IK1FTVVX3JnD6PAQoHxO4bqhUF7+UZ5FVNw6aLDNJMfBw9WJiv
         UJ+rPfhNkMnUJKnqvfQ2SopESaHnlVUvppK+Mr4xCtCMpjZbZViWH5ic7E2sH6cZAW8g
         tNexjkMSPLHa1ADFtjghphLJJ/D0CJexJbC4rDhiBDbOhopbR/HmX9HUCfdBBrVQkIMq
         1NNg==
X-Gm-Message-State: AOAM532dZ9e1SO6azg8vm4EvtZc3EVuTVXwU79Inxol2EtSKTLH79NPO
        jrsGouTc3yKjlfVzrT3VMYbonR6pjpWv4Q==
X-Google-Smtp-Source: ABdhPJw9PRM+aHXbkubu27LLs7O4NJ/k4SOijyIBKK72FAsxhygcMp8BvHRkQnewDa/DX7tnw3QUng==
X-Received: by 2002:a17:902:b48f:b029:d1:e5f9:9f6 with SMTP id y15-20020a170902b48fb02900d1e5f909f6mr1250743plr.66.1600888534946;
        Wed, 23 Sep 2020 12:15:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f12sm318352pjm.5.2020.09.23.12.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 12:15:34 -0700 (PDT)
Message-ID: <5f6b9ed6.1c69fb81.741a9.0f18@mx.google.com>
Date:   Wed, 23 Sep 2020 12:15:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.67
Subject: stable/linux-5.4.y baseline: 170 runs, 1 regressions (v5.4.67)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 170 runs, 1 regressions (v5.4.67)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.67/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.67
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a4bea6a4f1e0e5132fdedb5c0a74cbba696342fd =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f6b6445349511d5d3bf9e3e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.67/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.67/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f6b6445349511d5d3bf9=
e3f
      failing since 97 days (last pass: v5.4.46, first fail: v5.4.47)  =20
