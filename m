Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B4A4D0A90
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 23:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239976AbiCGWLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 17:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242331AbiCGWLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 17:11:03 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23544BFC6
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 14:10:07 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id z3so6805477plg.8
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 14:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fg8KoUwRmnBj+kFGAqw/qbO4HmynWUvqfcj6G/OXMHU=;
        b=duZwCk+3aSEe0PiX+IAQlPiD36YM6/Y1CnGMqb3n60VC803mJv1BfmhUPutM8J44IR
         3viyneNA7n97eWSQ6RRMKaJ8kCmZICAp6jIKRFE1bN0/tsWywPgUHLNdrIN4hop5sP2X
         NLsed1OZ7K3JvQ61nbFezIeurIAhMQ2SMZrbE6refhitCNEibcxN51jGkOkVtN1Yetid
         1BkGXxB26ZRy85EdYT3M0boNJhw8MKNqMg6jdhgR8OLKar6w2bcZS1WM9b+0OFUHKPY5
         6W26KI3EAZpCYwjo7E73CV4LmNaQAgfvdB1Ober8h5gO+XzcCGUG3YISXem6+B4VJsy5
         KaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fg8KoUwRmnBj+kFGAqw/qbO4HmynWUvqfcj6G/OXMHU=;
        b=yglWTfel63Y0XurgnF1VuC8vE/5b7yGgF/8K18LTn2ReUnOzhQaNGEJOSIVe3guV1X
         FUl7ht/7o0uMrWbO5B+kQLCg3HiekI2T2rAxomdOElCFN3nVpKWFvI96gkbXx05n7y7t
         jAmMmO5vD8ADQ0As1UuZbNUlRzbi7srUK0axU0fQrmcB8crzOMIj7drVydlRDP88qJqk
         SttWFUX1kM4IH3y26JZ0jK4Q6auMYwNHxllEPi0cFqYLwQ8xIHYHFc62Z7zIqM3eGRbG
         kmWKnR1pE7cSlvuAwphum1KUnwtWaObHtyDGbxu6LfGM+oXq0fS1NceIwz0LHEV0YwFu
         G3eA==
X-Gm-Message-State: AOAM5324noAxSlYHGPQ3uvE684l5USckSpRRm1YKlQvdNzg1+wOMUwee
        6SGqEJK3pxJBIh8QohZhTCMhJA9BKRVlEclR2Mo=
X-Google-Smtp-Source: ABdhPJyQxW3Fxn1BQ91RTIlVc8r3oWgWcl4v/E6MPFLpQcl1eD+VlglrpbZ1mhUhQmyvmU/lNf1ZpA==
X-Received: by 2002:a17:902:a50c:b0:14d:4e8b:d6f with SMTP id s12-20020a170902a50c00b0014d4e8b0d6fmr14285254plq.42.1646691007266;
        Mon, 07 Mar 2022 14:10:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x3-20020a623103000000b004f69e65c1b9sm14155317pfx.123.2022.03.07.14.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:10:06 -0800 (PST)
Message-ID: <622682be.1c69fb81.5b58d.507f@mx.google.com>
Date:   Mon, 07 Mar 2022 14:10:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.269-44-g5ffa96cabf3e
Subject: stable-rc/linux-4.14.y baseline: 56 runs,
 1 regressions (v4.14.269-44-g5ffa96cabf3e)
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

stable-rc/linux-4.14.y baseline: 56 runs, 1 regressions (v4.14.269-44-g5ffa=
96cabf3e)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.269-44-g5ffa96cabf3e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.269-44-g5ffa96cabf3e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ffa96cabf3ed80e6ade1e0670b39b5803501cf3 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62264b3ce5bb6bb25cc62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
69-44-g5ffa96cabf3e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
69-44-g5ffa96cabf3e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62264b3ce5bb6bb25cc62=
969
        failing since 21 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
