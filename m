Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868AC49CB60
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbiAZNw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240280AbiAZNw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:52:57 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55D0C06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 05:52:56 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 128so22680091pfe.12
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 05:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gAbPcMwde3z1xFEUjG5Zxv5uodFDz7dH2cklVJV2t/U=;
        b=Ky1gCOBC7a8ivJrBXTmDLt8ZgW1eV3882QwAUviww4M7Em3H2Vt1O7jBGyHlunmZps
         ugrHuokGEGvWOm9KnrnFWAhCWMr5CSmUSQlFO6FCBH5nvJnrlelyyaWV+PKJspM+D/Qg
         TSmqvzdbsMBFREHAKCbMr1ujd7PIi9Kof/EO3Xy8CVtjyv1RPizmvNhposZPw4JBCDrj
         0yvqqpiUmjKhHVddSlSsIhWUTIhAxpYjANZPFx7NqbYFvVOM5NdsZDLgqRg3tbL0gJ6Y
         fLNGdjRPjgLRw4HmAN+xqL1j7iUo8GM/L3rcTbO8a3RuleAMaXMxxEbR8iS73xC+n2f9
         VgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gAbPcMwde3z1xFEUjG5Zxv5uodFDz7dH2cklVJV2t/U=;
        b=xAPSFf0pQIzgXlAKkH/Ax2+1GtP5kzP7VeETAxHgX+9I2XKpw22x08FLKK/CMQxugZ
         ryixLF7lNSw0tTLhq/xn4ysLcic/HeC50fn8wCiD1zPkAkOqpTG/9qzRvAc6z+hyvgKO
         +G+2/WQB/rbW4evykLmJsIlrdS3j8G7R1RoTUQnmsZyv6uHOBEDVqphw+YsqVzQ2LpKT
         eSIP4FLBYcqcdFQheaPtzra5cfRzeA2RQZZ9om4qobQ+aPgBzpb0gMup3DyKT1ivXAMb
         4MlMg4lvEHLPshg9S27/sfzzfzXVhHZZV4VC9EqRc1BAB0QQ7BqHnjzLlEBAIJEQqRiw
         QK0w==
X-Gm-Message-State: AOAM533OOu274i+u6EjY70z1qADcCTzADkA2rIjAO+TUuMgKSGlKEWsJ
        civj+N4ZRupiZ3P4Wf8Dux759+VTBC/L+289
X-Google-Smtp-Source: ABdhPJwHLDT+07/zfkrRLHi3fGD54CTCl3mM1OJw/mMD/MKvMP1WrAzoJAeYC3KvqJbuIbEXA6Ijyw==
X-Received: by 2002:a63:b00a:: with SMTP id h10mr19035830pgf.400.1643205176334;
        Wed, 26 Jan 2022 05:52:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w72sm1930751pfc.211.2022.01.26.05.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 05:52:56 -0800 (PST)
Message-ID: <61f15238.1c69fb81.a48da.4f6c@mx.google.com>
Date:   Wed, 26 Jan 2022 05:52:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-154-g670e79b3de6b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 122 runs,
 1 regressions (v4.9.297-154-g670e79b3de6b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 122 runs, 1 regressions (v4.9.297-154-g670e79=
b3de6b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-154-g670e79b3de6b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-154-g670e79b3de6b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      670e79b3de6b4cc5ce424d1a997940a80be34f54 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f11c0b89c19e83aaabbd43

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
54-g670e79b3de6b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
54-g670e79b3de6b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f11c0b89c19e8=
3aaabbd49
        failing since 1 day (last pass: v4.9.297-124-g1de5c6722df5, first f=
ail: v4.9.297-150-g86d4516a7d68)
        2 lines

    2022-01-26T10:01:29.697374  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2022-01-26T10:01:29.706134  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-26T10:01:29.720486  [   20.233123] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
