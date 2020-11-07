Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1E12AA7DE
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 21:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgKGUST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 15:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGUST (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 15:18:19 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3AAC0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 12:18:19 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id r10so3682417pgb.10
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 12:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TeGDzYiTxu+Bm7ib7Wv0UlkFp1K8JYQYg7oEF/M9qzw=;
        b=l5slAQH9KVUB2suJdowa1gZXSUL2mx7ETdnK6Rt1pzc2awZ696Amm0rpabyQLE6Pnq
         sjjpMBpJgV6xYzwfm+y/Z5c0d2OvUMIyGdB3Oi7FWQL26luKOfoHbENVKOlFo57/xBRJ
         BsBVckMriJz+YtKL7J97i1iJEnpWbKnE9gb16VJUJw8Jhhl5sWZwTYJixeMwtH6VIvZE
         f2yV0AGwN5y4s++hlZqgd5sEi+WWHWXK0qNj9RCmoSBYzbD7KAg2AvxUXP6DuPNuvgRa
         ni0Oj/Ikhl1tl0PDoZ5x9nf66WV8hyJdVsmqKtFm1ve2xq9eo6VWN6Rm/Byo2R1xlgbG
         e62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TeGDzYiTxu+Bm7ib7Wv0UlkFp1K8JYQYg7oEF/M9qzw=;
        b=EfmWyimf1dYuIoowghLdkC2UfUBxoYLXC6vogzF9A7++PBjKqByQJ8S7+3JxJuPCbH
         ufk1doV4RFjMZYW01vwwJJ4gYIK76kepg6CRTjzq3Tal5dtBI+Gg82e0Ok+NraSBScOv
         1jp0GND99GimhcTGaP0jA6YSgPc0dAP1gjWKSem7US6JbqazcWcMhcYItScI7b2lj5nW
         NmLdsw+Vg4nXpOIbNJ917ITqr5gqRWtt5YvBPEFWBHbpj4JYljIKgrFZHwkpKPIGYtej
         owmILKXt3e8POjV0fnB985uNNBdh1x9bcXRDqlhKjpmoWi3iy2vx+tsJiTu/7SP3UIxH
         56bg==
X-Gm-Message-State: AOAM532BhPWgQVA7yQAJwXVgChezUAzW0XpH1pDHBNF8vG/k1T6B2KP5
        SJm4Z6sj0LFPiP4CA/C04scZkb+OolFSLQ==
X-Google-Smtp-Source: ABdhPJxVfHc0ImZ7rrYTDQGoSTVGz1kD0Z9wLeRhnj7a2sfq3lHMGFOoRhjQaUaTHpRVeWsJFWJqeg==
X-Received: by 2002:a62:55c6:0:b029:160:1c33:a0f7 with SMTP id j189-20020a6255c60000b02901601c33a0f7mr7408188pfb.35.1604780298347;
        Sat, 07 Nov 2020 12:18:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b4sm6297951pfi.208.2020.11.07.12.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 12:18:17 -0800 (PST)
Message-ID: <5fa70109.1c69fb81.7a936.c3cb@mx.google.com>
Date:   Sat, 07 Nov 2020 12:18:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-98-gbb5ddb48abfd8
Subject: stable-rc/queue/4.9 baseline: 147 runs,
 1 regressions (v4.9.241-98-gbb5ddb48abfd8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 147 runs, 1 regressions (v4.9.241-98-gbb5ddb4=
8abfd8)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-98-gbb5ddb48abfd8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-98-gbb5ddb48abfd8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb5ddb48abfd8fd2f1765b7a1af35503d963b6d2 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa6cc33b8c1c1b9aedb8868

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
8-gbb5ddb48abfd8/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
8-gbb5ddb48abfd8/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa6cc33b8c1c1b9aedb8=
869
        failing since 9 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =20
