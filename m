Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E864422B3
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhKAVfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhKAVfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 17:35:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC96C061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 14:32:26 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y1so12726238plk.10
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 14:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d/k/1F8cRJBCr6ytQKuCRFM1IkkFPvCAZbfYmGTQGQ0=;
        b=H6XfGHx1cNYiPBcagyiDL2lcxIZ746YIU/jxh9oy1crm6Xdc6TeO4hf7nHHQNs9Ym9
         aK2xRia+fOmn64fkHTcuxDAqgr2U5YRTSmyuWnEmKEr9QaWMMGvTt6c10XTaJxqFWmBv
         xoVhQ3QG1w8q9+AvA3aqazNltSmcvrMSAvNdJ3la7U9c/I00EHYN9r0Sgs1jGLZ/S3ZD
         j71o0Zbh/AqmrZSEzfqbv358IP8wfE4G9SHMdDEskx3pzMDA/7kN9jPFP8oibjN5VBIF
         RhdfbRz+/BSDIjSsARlZWiv2NxVv5Rp9rFGituljaRU2pQfXwJDwFV7KlqsEp3cKjW6r
         CQ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d/k/1F8cRJBCr6ytQKuCRFM1IkkFPvCAZbfYmGTQGQ0=;
        b=PQkEjTG/b7EfllSRMSN3r0H4NicBMC/vgIAT0NiCWNK0ILDj8YBNDfN1UWRiSSwXkh
         IYuK12FfCW/o4U2glu1GtBOusWY/7pS0cD2n0P9Xdb1DIdETPiFlASXgZ0EYnGmNY2+b
         doQOzsmA+0Uirxga/g062DoiVIL9QFAGBkbZjDgIybj33ZyURQ3XAh+pE7/2t3NY1OxG
         RejXkEYFpuIQYDUD+UIVIQECWfLSZRMovIN1bU2b0WnuHIN1l9qRgA4AOp4GotY2rz5F
         Hfogfa/JMXJXhiUfWvpEXONd0vsihkyQyTY6wZ7RPE1efiMkG9N/fvYMjZjD5vgqKedG
         bUQA==
X-Gm-Message-State: AOAM532LYsJVpECfUtv/aX1D4OUwJ95jepg4EkhIvYp023LKoaXH9DWU
        TqTdJud6Q5fe+dFc9JWvuIMy0/IjTnbWS4jd
X-Google-Smtp-Source: ABdhPJyBbwNXFxAOj8llcve9lj55KZlfHf9duOzUDxjlQ4cD8URkv8HqIEz3ByI6hlXWDbrGn42/LA==
X-Received: by 2002:a17:902:ab53:b0:141:7167:1c4f with SMTP id ij19-20020a170902ab5300b0014171671c4fmr27386730plb.30.1635802346436;
        Mon, 01 Nov 2021 14:32:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s30sm18524666pfg.17.2021.11.01.14.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 14:32:26 -0700 (PDT)
Message-ID: <61805cea.1c69fb81.151e1.35bb@mx.google.com>
Date:   Mon, 01 Nov 2021 14:32:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.15-126-gc99063ce032c
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.14.y baseline: 142 runs,
 1 regressions (v5.14.15-126-gc99063ce032c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 142 runs, 1 regressions (v5.14.15-126-gc99=
063ce032c)

Regressions Summary
-------------------

platform               | arch   | lab         | compiler | defconfig       =
             | regressions
-----------------------+--------+-------------+----------+-----------------=
-------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.15-126-gc99063ce032c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.15-126-gc99063ce032c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c99063ce032cc300f6046ce43af6a0f5155171d3 =



Test Regressions
---------------- =



platform               | arch   | lab         | compiler | defconfig       =
             | regressions
-----------------------+--------+-------------+----------+-----------------=
-------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6180259b569a9f4c833358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
5-126-gc99063ce032c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broon=
ie/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
5-126-gc99063ce032c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broon=
ie/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6180259b569a9f4c83335=
8dd
        new failure (last pass: v5.14.15) =

 =20
