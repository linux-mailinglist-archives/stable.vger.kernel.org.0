Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AC16122CF
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 14:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJ2MPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 08:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJ2MPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 08:15:01 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B972D3FF20
        for <stable@vger.kernel.org>; Sat, 29 Oct 2022 05:14:59 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f140so6966361pfa.1
        for <stable@vger.kernel.org>; Sat, 29 Oct 2022 05:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IN4oOeoE519wKI8XKyEfxFl6oDP7HJ1jZmEgD6B+feA=;
        b=N0J1mmxOAtDvf29AvwiokIMQTkWtP1wh6NVYg/nsYS/T5pbZ6ZPbGGYrJcOXUUBqe2
         JFdMGSTLV1Z/ScXM/ipxJoQifjO0s02+UxJtM2v5JrFM1k8ylV5fB4L+/oHT0Kka3BNs
         tFzwdsxp8rZGABrmnuZ2soH994kB8gYQqPs/1lyfFyRyQeDcbvNABuXLGCKN/J9wytWS
         duMOQ4oSLan2h21iDZLz5iK2ybD1oppNUCrdUwIvZleuiS6yLx1JxYQawq6usOWwwiHQ
         58xxIHPd/kjsbCZca4sWgEywfjINnubS0gDRLbThZnKoXhJQmji0bRFQr1x38Rfz/69w
         QrsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IN4oOeoE519wKI8XKyEfxFl6oDP7HJ1jZmEgD6B+feA=;
        b=5MSPB+08rNhHuSEpdRf28WGJXEbaZiR+pJfupl5W8BpLFeBHtG/WAJ+HjTumARNAeM
         UMlSqcVOcTWmUR9mzYsDtf+8E17EMHQLY14aHBVFBWEwe7ux78+W77YccW1bzMye6E+N
         qFayZSHLF6csqdHX6DJuugFL8OwOXXcUMX3Z/nlASL2iCITngIaUvswv6raEhAsIMdjk
         jnzxD/SU8b3LhHYM1ZIrm8wpqmnjJmg4uWNLVwByqLOkXmYS+6ek6o2XgPAZpimDBxN/
         9d+tM4a3Xp3GmaEFju6ecivD0MXpCF1Eud56PT8MCb/WnOqlyAsakUx1BZtdnRyMmejn
         zH7w==
X-Gm-Message-State: ACrzQf1mvkcI7AcLc/zT8yucroGCusJaZo054ZBoXWSrGg9qS9JhayyV
        qf25ZleFkqCrUWFf9mPnd6Xvr5IXHUzEkJwA
X-Google-Smtp-Source: AMsMyM4d1urgw9c9cGpNOml/WTdeKpVBnWXbg+rjrPEc5ob46Kdgw4u8EHHgS0Hh6lL3r1qJnRULgQ==
X-Received: by 2002:a63:8143:0:b0:46f:5e58:7866 with SMTP id t64-20020a638143000000b0046f5e587866mr3756202pgd.447.1667045699109;
        Sat, 29 Oct 2022 05:14:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3-20020a170903200300b0017d7e5a9fa7sm1180485pla.92.2022.10.29.05.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 05:14:58 -0700 (PDT)
Message-ID: <635d1942.170a0220.da0e6.1c83@mx.google.com>
Date:   Sat, 29 Oct 2022 05:14:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.75-78-gce53c64371a2
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 143 runs,
 1 regressions (v5.15.75-78-gce53c64371a2)
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

stable-rc/queue/5.15 baseline: 143 runs, 1 regressions (v5.15.75-78-gce53c6=
4371a2)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.75-78-gce53c64371a2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.75-78-gce53c64371a2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce53c64371a23cca681c716d72bf038ef244374c =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/635ce043cc3f4b7d92e7dbc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.75-=
78-gce53c64371a2/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.75-=
78-gce53c64371a2/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635ce043cc3f4b7d92e7d=
bc8
        new failure (last pass: v5.15.75-78-gb1b5c108c9ff) =

 =20
