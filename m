Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE9E5ADD28
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 04:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiIFCKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 22:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiIFCKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 22:10:10 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031761276D
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 19:10:10 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t3so4842832ply.2
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 19:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=2Bj6yfYRnve6dmc/Z/xbE7pMMPOELs1NMGsXGyQ0wL0=;
        b=Vq+auMfZpfiQa5zrbWA1wC+PHb/tFG5OoqKTYUJnyqsOWdMTAqkTKob5rNLtsFkeDD
         EJwCY5Xkeg6fO0d0LJLvHnTwXkaoncgtVBM9lGqIZ5p0FFHINlqy7t2vp5Hhz/UeVpA3
         /RDe38NHSAXCRZuMoa/DgkeIGi9lakzehdp66e/Xze72WM1GuqeWBFEfhsvz+yY2S8hu
         t+U9YW+6WlVlhN94akP3Z+eF/oKpTLV9mqywVU6GCve91yLYuPpWSu32SKVhjZa31Lth
         wwAqS2hLLwUm+oZKi5J+RSqplirTk3LWLRhsjzaEpED77AxpMxpH1v5dZaBCDqhnBh9o
         5zVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=2Bj6yfYRnve6dmc/Z/xbE7pMMPOELs1NMGsXGyQ0wL0=;
        b=LPitPnx4DKePwRw5kATGrtR+geBkdtrdPVPmrUmkv1+GgxX4FyxR4EH3uhttKm3+F7
         k82ry6ZwisBoeOkETRyQeOYiRlLPJmmOfbbUcqa1CcBpzvpLIQGmF5QdT3s0DteKxbME
         mqfSi1DIbez+xD7WRS3SdgyND26takAjJvnv7cUZi3UNKVWvTLPARkSN1/6QNaUlj6Z0
         dlFkvm1qYJbeo7BLbITPl4FXNUy5h3vOH6LyMRqAYRO4JE+i5Zmpy+Oi7IE78Y5sf54O
         xNmvwPDbG5Fcw5Mec4LhO41bguMQ7sWFeDeuRwzkOQCQzK7Ivqf3on0AaoHOxC8vli/Y
         ScNw==
X-Gm-Message-State: ACgBeo3CupOGz7cmw6nS6p1Lj6IAxerTpeaioMCBlliEd6iib6NupSfS
        AAWbVvO/3SHTYPnTRcvvF1E21vZzW4mO2dtPF5Y=
X-Google-Smtp-Source: AA6agR6H7gFDd754ZLV7RHEz2v47PIJvWQ8d/TpTQmeII4zOyrRiCZ8W/7g+yWbnU+3e1WSbM/0jVA==
X-Received: by 2002:a17:902:f542:b0:175:32e0:1e30 with SMTP id h2-20020a170902f54200b0017532e01e30mr32157046plf.77.1662430209305;
        Mon, 05 Sep 2022 19:10:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 202-20020a6216d3000000b0053e2ffa9652sm48465pfw.88.2022.09.05.19.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 19:10:08 -0700 (PDT)
Message-ID: <6316ac00.620a0220.1447a.0197@mx.google.com>
Date:   Mon, 05 Sep 2022 19:10:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.63-261-ga360ab80349b5
Subject: stable-rc/queue/5.15 baseline: 130 runs,
 1 regressions (v5.15.63-261-ga360ab80349b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 130 runs, 1 regressions (v5.15.63-261-ga360a=
b80349b5)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.63-261-ga360ab80349b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.63-261-ga360ab80349b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a360ab80349b50652938d834aa848d22de12b4fc =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63167cd43f570b358c355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
261-ga360ab80349b5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
261-ga360ab80349b5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63167cd43f570b358c355=
654
        failing since 159 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
