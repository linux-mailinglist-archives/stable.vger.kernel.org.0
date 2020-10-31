Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB0E2A19AD
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 19:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgJaSiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 14:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727967AbgJaSiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 14:38:13 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4931CC0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 11:38:13 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 13so7758308pfy.4
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 11:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=48m3bGvrkMyRWeDlen/zzxlxXOY42cALOE1KWUFs4vw=;
        b=a2KcfKLMeo7J4rKAEWRF+C3kJyVJHycykRuQgJh1vMZuzgiUKW+0NGK+Q9iASWAuNE
         T2TJ48SkXhR1GXmguP6os0wHczn7/znq4t0YXQcdgc+nnG0DuUb0C4M1OKw1LBlKobu4
         arc1L/Dab6sCJkyWPee8BYso7TjoMWy+RP9V1ixGgOb5bNJg5XIdAbge4GD9VWxnawm4
         sRRpej30a5Vj/3DqYUDts9ANR1jhWT1Gme89XPpcNR9e+ANdNwk2baIRhhZktZIaqc5w
         KSm7b+V/FE22uGbuG6SRn2/9vlcR9KlOehI/4eJJL5cjeJ7ecOSah0+vDUHgJPKnhNxo
         m3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=48m3bGvrkMyRWeDlen/zzxlxXOY42cALOE1KWUFs4vw=;
        b=XqRj08Re/9vuYLRQSuTTm/A6mqSB830o8lawanjHB5T0d9qEcoaAZnbiZDpdLS8fVr
         kkZBG/8yB2sttw0M4V2IGV44GdjRcJ/LTfZqYo2jEtMWwxrvbENGYm4iqRs0MBNu4P6Q
         X93MYD9QI4HShq32y9Oz2gsRZNlm+obgBxdxP0aNqqy0UKIQzSVdWt7FoCwOEccoU/c7
         byJK6VZESjcLv6+Qvobliz4zXBj/yEB7R6KWAGlLfN3h4uWebuZOzPttEa92JfiYQFBo
         TC0PODFimVfwK2zZk3N59UIEEAhltdSIbFkngNz159nE4Y40DgFTgvwuiHcK+JJ2TiOv
         nW1A==
X-Gm-Message-State: AOAM531IARYOeh2Yt5/9osH/QCzMzFg+ZYWngAdUYJmtobl6oN1g2B9v
        QqBhL0e5bR1C1xJmB1XKRxpq8f4qfk3swg==
X-Google-Smtp-Source: ABdhPJyD5LMxduuBnq3aZstpuer8VYQj6YQWktfs/9ZntpmcrhObaTxxh44olJ/1lfb0+CiZ/3/yAQ==
X-Received: by 2002:a65:56cd:: with SMTP id w13mr7177270pgs.132.1604169491654;
        Sat, 31 Oct 2020 11:38:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13sm9327777pfr.209.2020.10.31.11.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:38:11 -0700 (PDT)
Message-ID: <5f9daf13.1c69fb81.617ce.6ebf@mx.google.com>
Date:   Sat, 31 Oct 2020 11:38:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-11-g04b990a9881a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 135 runs,
 1 regressions (v4.9.241-11-g04b990a9881a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 135 runs, 1 regressions (v4.9.241-11-g04b990a=
9881a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-11-g04b990a9881a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-11-g04b990a9881a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      04b990a9881ae9d88501e81eb6999063636e9f18 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9d7d3fbfee3f911c3fe7f1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
1-g04b990a9881a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
1-g04b990a9881a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d7d40bfee3f9=
11c3fe7f8
        failing since 0 day (last pass: v4.9.241-4-g8d9cc85ab09b, first fai=
l: v4.9.241-4-g40bcb1fe569e)
        2 lines

    2020-10-31 15:05:32.176000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/128
    2020-10-31 15:05:32.185000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff234 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
