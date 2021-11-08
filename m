Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71470449CD5
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 21:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhKHUEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 15:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236843AbhKHUEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 15:04:46 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8BAC061714
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 12:02:01 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id g18so12310120pfk.5
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 12:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jEqcCqEE0Mw12XXorVx8m0RHDaKbcVk6YIy0pO7N6jU=;
        b=4NBfxCu4N+cgUqJ8F1wtK9YPehfMZe9w9SfVJls7dwHDhM29mr98u9o7FN6FEpYrH8
         eTbY/yX+HRI+fqxEY3f2X137tJgvHB5eCmanBer/UwFMo5NmB1jXHCJolckH/VpOTj1G
         eaTKS2wzy5JIJAKF/2ccVsAhj6/L7VA7724L1RsHCcxBst9Z0Gja6yKV46Os9RGBLdvl
         GkYV4cyc+jNnfS1Ar9xwortGVoJpjzfRdWBxj8lr5VuLhvr6hFhNTomqU7S+cevOkEdp
         T5LSrkUBNWFQHrdOj6+bG8flPuNU69h4ZRwpvkjoj6sY/QFbEqPUY2uCKR8p35eSenrf
         wKZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jEqcCqEE0Mw12XXorVx8m0RHDaKbcVk6YIy0pO7N6jU=;
        b=Eoa2/Qptzzu8xsWlRx9wH2V3LqJHcXaLKnbzj9W3QDvHuY/E6OJ4h+HbFDXAr4bkDH
         H0r3tjh8Uj/IUpHwPVKMJMmp4GAeuQHXgD+bZEwtnQwN32xOUIwLbRXVS120x5VLTcfE
         x0pNjVdv68jWI5UG0D3lsmdEZ04/O0fxXpdHX029ADUNcd1da3gLppNxtJ6UzJerndUX
         HDMAwdWLzYPnWXna5mhPiVZeJTh1zYxxYYvuOU3kdcdDHDvKEZ+YT79DEU9iaTiRi2p5
         fq01o9TJto5+LQ+9jwyFPz3MewM9BRoRsgtJsKIhJzO+LJ0ELjZCmh/kpoyzwV27w0zF
         e5mQ==
X-Gm-Message-State: AOAM5324yrFNRWx2WXgJ6fo+T+uh56sgqe5TuIj1l58jLUpaElntINU4
        8Ev1q4kn0vF/uyHm+lW16pNmEy4VZsv3hGC4
X-Google-Smtp-Source: ABdhPJzrRkQotW52uQs+E6zVHeDujjyPEAHkIZ5RNy27yGkpb1omar0x7OkhU9diJAy97oTOmTMJBQ==
X-Received: by 2002:a05:6a00:1510:b0:49f:9abf:7694 with SMTP id q16-20020a056a00151000b0049f9abf7694mr1966508pfu.58.1636401720666;
        Mon, 08 Nov 2021 12:02:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bf13sm162162pjb.47.2021.11.08.12.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 12:02:00 -0800 (PST)
Message-ID: <61898238.1c69fb81.dafbe.0c07@mx.google.com>
Date:   Mon, 08 Nov 2021 12:02:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-11-g6cf156718dbb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 148 runs,
 1 regressions (v4.9.289-11-g6cf156718dbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 148 runs, 1 regressions (v4.9.289-11-g6cf1567=
18dbb)

Regressions Summary
-------------------

platform    | arch   | lab     | compiler | defconfig                    | =
regressions
------------+--------+---------+----------+------------------------------+-=
-----------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defcon...6-chromebook | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-11-g6cf156718dbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-11-g6cf156718dbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6cf156718dbbde0d436ffe8b9f6eb05196263ba9 =



Test Regressions
---------------- =



platform    | arch   | lab     | compiler | defconfig                    | =
regressions
------------+--------+---------+----------+------------------------------+-=
-----------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/61893fe1c78e825428335912

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
1-g6cf156718dbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/basel=
ine-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
1-g6cf156718dbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/basel=
ine-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61893fe1c78e825428335=
913
        new failure (last pass: v4.9.289-6-g1ae2a4b84341) =

 =20
