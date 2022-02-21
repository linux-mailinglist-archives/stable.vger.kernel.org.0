Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B3C4BEAC6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 20:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiBUSOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 13:14:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbiBUSMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 13:12:34 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BAC625F
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 10:03:07 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id l19so9564618pfu.2
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 10:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=De5dOyD6lkBkAbVgk7RvMpL0WarOuZqFAOxsNLM0u5s=;
        b=l+9asHh2N1DHXrm3NjxFWmJ7oWYGGdSxxIWtXtn2r8HbPI+Zv7lOPVZ8GsEduJxhlw
         UOg3tHGT+jVda3p4mEZFhBL7BE4DAS/8mZf346wmWr+6Ei02HkbGRzEXO8HKNCUH7cpf
         2YvJ/h5vD6phy9WYflCgqZZQ99SBMdugOtUgH/5ZZX1oD57TyItZPJWtsUn9p3ojX8is
         LitvJrK2fMqlsiN0on/GTA9TvBqRPmeBqe9j7KOY1j+qbWrOnRLU01EZC1UHZI0Fo8Sr
         vtFBnK6eInEbOASZMQe+E7ta+mkTrdreaYBGv6ccWw9pJrbaqSmb9JJ9Je771m36Pyv5
         lz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=De5dOyD6lkBkAbVgk7RvMpL0WarOuZqFAOxsNLM0u5s=;
        b=a2b2UqwkJXyjisF39eQseMxxULOhNK5+XgvqOYoMBn4YIBX8EJfXinjHNBw+tri/W+
         cj/X3v0uzA7gEBO8huCcEwcY6CdJQrCfpikW1lxK1sYqRlkwzgLc0zkdVrNhn3fjmgxB
         fEVYrNW4ISQuKBzilSCDlFcVF+0P2abwwN6LpQ/6/+c66kZfLhsMErp4lvXq5HIidr8D
         Z3HB++5Ei2fuh4dgGuu8gKygCTBtROlsKZBs21E20xi3z9AFKkYPxbpeQ9fnfEtGGkBz
         cB3/Am8AT0GaUKSQWfGKu8PkCIuVN2xJVypOd0TUlp7nv0tO5qWYtZKpbk8qaeYalX4P
         dNww==
X-Gm-Message-State: AOAM533UYE9Q0NkAju3w2iVZ/+E8uwfqowfXbhik+r/zcYEsNNOo8IuN
        6pUgWT5qt82XVtaR4VrG/slhRPgYMW4vmKKM
X-Google-Smtp-Source: ABdhPJwTo+iC68dp4+pjyU1Vzc4hQnhVILNzBQAJfcadulNmy99H54CpYm3i2W4axS/loDtan/bYGA==
X-Received: by 2002:a05:6a00:130b:b0:4e1:7b1e:6c6 with SMTP id j11-20020a056a00130b00b004e17b1e06c6mr21389445pfu.22.1645466586263;
        Mon, 21 Feb 2022 10:03:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t2sm14032838pfg.207.2022.02.21.10.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 10:03:06 -0800 (PST)
Message-ID: <6213d3da.1c69fb81.97fc3.647f@mx.google.com>
Date:   Mon, 21 Feb 2022 10:03:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.302-34-g6686f147d38f
Subject: stable-rc/linux-4.9.y baseline: 58 runs,
 1 regressions (v4.9.302-34-g6686f147d38f)
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

stable-rc/linux-4.9.y baseline: 58 runs, 1 regressions (v4.9.302-34-g6686f1=
47d38f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.302-34-g6686f147d38f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.302-34-g6686f147d38f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6686f147d38ff2b3ffc43718976bb9ff43c5fcc5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62139fcc3bd9b5067cc629bb

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.302=
-34-g6686f147d38f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.302=
-34-g6686f147d38f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62139fcc3bd9b50=
67cc629be
        failing since 4 days (last pass: v4.9.301-35-g133617288e03, first f=
ail: v4.9.302)
        2 lines

    2022-02-21T14:20:45.729619  [   20.692626] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-21T14:20:45.774681  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2022-02-21T14:20:45.783967  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
