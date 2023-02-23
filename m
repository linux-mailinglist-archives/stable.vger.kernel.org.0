Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D856A03CD
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 09:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbjBWIaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 03:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjBWIaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 03:30:05 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9697D36FF0
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 00:30:04 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id nw10-20020a17090b254a00b00233d7314c1cso11957305pjb.5
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 00:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JX7IPVeY2qAvtj+PmUDhBTpXKWEG3lnZBNcRwcZcpIk=;
        b=DBlf4cvk5xsZaytgHMXgzOGs1jiOvtn7cmzYcB/arIIdOCxRqV0dABpaB6VxvB/t/y
         oU9ATdon6Dg5iebLOChyXfWOtlHZbYHz/DdM2HOJUhEgqFQHiokccnfVWKUTILGnd3n3
         VLPaCox4cHW3br//Y4TFRlAGP6hDovv4uDzit6eURQlH401VA1brCtbTCzDVsooj2ntk
         0pokiANFfN4iuXUx7XU8pWuFzpIqopLauP7uVnImKo8MOmklxVkzegBnEOj1iRRnVqfz
         djJrNAqAPNpIoqPO4HBW1W1ul05KJrTSl8VpdeY1VPTXF1M+4wE0p+95NuvBf1NzMO64
         ydAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JX7IPVeY2qAvtj+PmUDhBTpXKWEG3lnZBNcRwcZcpIk=;
        b=nq0tD9aS5RrDnMnG3iFs3dmrCIhnyAnnrLiRKXnVYRfUY8eLMAxP4VeAuFBoYYQ431
         MzC8tPC8R93ZQ0ayBy+tJ/CJgmPWBWiXLhNPyAUC6DHlxAZJHqgSYQ8o+9oyHPg+xs6o
         U48F/ZR2s6xKqWpzw9wvfLjyPDfOCFOBFzj6uNNJYuUQEjRfxzeJ8IPIKyzxzYOECuUC
         KIlEcbXk+8b3qOE2Gkjt92tMZMfUqbNGc30Bnib+JQ2/ZrXRvN4lcWk81ZEuz+jXDEo4
         m4AZJzkA9tPnWCQ5/Joi/FMDwLdzRwdaELvvMduyhZAzwedo1AF3VIzGH32fEXpfLJOg
         j0HQ==
X-Gm-Message-State: AO0yUKVaEtOIA4H2C4i3FMKUXqKXHTzXl2UK/GRXh7nuSyGHK2o+m5oM
        Z/noVrzkRO9HKs9A/xPEWkGznzbrASNSb2GoaM3Lkw==
X-Google-Smtp-Source: AK7set8GQOu9+z7qK1R6EhdLTMagGExVfqFvjoKT4f3LTa5D7aQimKvC+f1cx85ZIDHj5EQjjEYweQ==
X-Received: by 2002:a05:6a20:a005:b0:c7:1d82:838c with SMTP id p5-20020a056a20a00500b000c71d82838cmr10234707pzj.41.1677141003866;
        Thu, 23 Feb 2023 00:30:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z17-20020a63b911000000b00502ecc282e2sm2064907pge.5.2023.02.23.00.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 00:30:03 -0800 (PST)
Message-ID: <63f7240b.630a0220.a2c22.3cc5@mx.google.com>
Date:   Thu, 23 Feb 2023 00:30:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.13-30-g96454cb3d315
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 118 runs,
 1 regressions (v6.1.13-30-g96454cb3d315)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 118 runs, 1 regressions (v6.1.13-30-g96454cb3=
d315)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.13-30-g96454cb3d315/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.13-30-g96454cb3d315
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96454cb3d3153a3adb555a8de0b7d5fea0f16084 =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63f6ed3cf9c55d32f58c8667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.13-30=
-g96454cb3d315/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips=
-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.13-30=
-g96454cb3d315/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips=
-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6ed3cf9c55d32f58c8=
668
        new failure (last pass: v6.1.12-117-g997a1434b1df) =

 =20
