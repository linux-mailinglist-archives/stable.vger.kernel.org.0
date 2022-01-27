Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FF049D6BC
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 01:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbiA0Aay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 19:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiA0Aax (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 19:30:53 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F577C06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 16:30:53 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d187so1147195pfa.10
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 16:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7YgkXxCV/9QuxfEpwVZdEfjFBtw0qLshXTwK3g+vTUg=;
        b=cowGblj3T/kjJ58cltY0irBegHnVl7eHcyk+MzzhPMDUctEdlaVU1hM3aUxOYx8DTF
         0quz4fOcKxiUIAdjUIli2M0m4uVifZwrPIyhczR9kq1jDSOykZtyy4RF17Vn2LdzlK+p
         SQnPT27psJOmrg8jeaWB4NSjpO/ErlwVv3s7gmMtl6wpm5s2CKV67pV7piyj3I1ScDBV
         zwGZVH57l7EC0RB+nZ1pmu9cRjAx7dkOT073LqZ2kRRfyaD//iXFmaFWdzG6YF9Hd5sX
         cz6pRPzuA4En5/jTtt63jLri9tivfYjdLXlVlwOo0rnVCVK0h/c9iWwNWPXMmNvCm5mB
         zC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7YgkXxCV/9QuxfEpwVZdEfjFBtw0qLshXTwK3g+vTUg=;
        b=M7M3+Fa7CTTmbvKvLdHbt7w2ysnDLbK2w2ilFhTpCilZHFur5+JbfyfOSyqHAjmHc+
         aUxH80QA20YizNdnJAd2SM28gz1ZC7kvtWR7/KW/THktddvCDrqd872KU8RbS3ByLMwL
         B5cVe+Wv84j6vtcJ7VMWaGBC5AvGw7BClukAzXXvanWMarGa7UpXI7KjjlMunOTSMfob
         XnUIi8V9icpowLkpwukvg6Ls+xzoRdgDPc1Ga9JbFNl3E9g9s3jzgUrfpfvegV7UVVGx
         o6h4VQuw2o2q5l5WNv7x7EIQMVLpirsZrgcFvBQCv+tOHdHcvm7dB71WxTgyFSqyimO6
         9z8g==
X-Gm-Message-State: AOAM530cQQggsCnEIgcYmbdaG8Kk61wbhxLbynOPgzPmWedBn6/Xt8Tv
        YmT/u6/LYK8IvjHmVOo47NlW5sAJ+tJOILs18u8=
X-Google-Smtp-Source: ABdhPJyRYXqyWu5HUu6kmgrj4tLNfMfOqJAH4iod1WVYDueMzOuEhW9yksCiTleRC5dEnFnzMIjPhg==
X-Received: by 2002:a05:6a00:1c4b:: with SMTP id s11mr1220214pfw.51.1643243452472;
        Wed, 26 Jan 2022 16:30:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b20sm3332122pfv.134.2022.01.26.16.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:30:52 -0800 (PST)
Message-ID: <61f1e7bc.1c69fb81.f300.9c98@mx.google.com>
Date:   Wed, 26 Jan 2022 16:30:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-114-g37c6a274092f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 149 runs,
 1 regressions (v4.4.299-114-g37c6a274092f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 149 runs, 1 regressions (v4.4.299-114-g37c6=
a274092f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.299-114-g37c6a274092f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.299-114-g37c6a274092f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      37c6a274092f263c8efb44a1eb49fd3ce6cf44c1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f1aee755bb405720abbd1b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-114-g37c6a274092f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-114-g37c6a274092f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f1aee755bb405=
720abbd21
        new failure (last pass: v4.4.299-115-g214b7b038f18)
        2 lines

    2022-01-26T20:28:05.841444  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2022-01-26T20:28:05.850925  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
