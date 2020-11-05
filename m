Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5352A892D
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 22:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732043AbgKEVkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 16:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730973AbgKEVki (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 16:40:38 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42B5C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 13:40:38 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id i26so2269450pgl.5
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 13:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Pdey/tcIMEyC7HIxcXPQ5UQY6Gn7sP5GonNJMGxm0Dk=;
        b=tShZzZlJup7uJkeTG+86x1sYOLhV6Gy8xQ7obr4cyEobzrKAaV0LX73awadlnDky95
         Ex9iggj8uBR5Xx3hQkIHbb77f4BqOJASGeLTYOm8i24HZ1rrQJB2w7WAfB3VYv+ExTXG
         BPH/AfT0ZI1bt81O5Q7GabXrQPCugXjCm5+4BldLxVaAcCAJNV2hErJjDD+pEqGYEetC
         lsOAgzt2o7jUtSjRxeqw6R9XF4Lk9qPFl80cEVtzN2Jgy9iicN3K8/x92skhqsDEPICP
         edOFfGbKskv+oLjUzGzLdOxfUv6LDWSC7gzpWQbwY5rDKZTHJvKAnGURK/U4Cn9Js9kl
         PxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Pdey/tcIMEyC7HIxcXPQ5UQY6Gn7sP5GonNJMGxm0Dk=;
        b=lZwVFARjKWVDbIa793rqps2QNpu9QblZvzthdyjYVjVb0iklQroAdLDBlGsFlCHILl
         LgkYKk/t17a8bLgQ+jBY/vxLXDcQYiH4iHsuL5Hi9FSurVeCpquIxKkFm9LeBAO1Knzy
         amHmjLSmJAloPKVA38nApVE+l2AbKxKZHb8fZOZjp+vfJnCT47tLl4BC+SnoRZdBlc8i
         CWhBaoiIVKeBQxLQx+JnpOqKiZYjbdu0VIbJpJs/aDFRYJJ9ppBsdriL3XBOa4UWj6+3
         FTslACRUSKMZD1akEiHPUkuwxuQD3SFQnGOV1iW/HJ41H1+D1I+AqzTUvoIM0RYoBzAA
         JSRw==
X-Gm-Message-State: AOAM5311caV/7o6TO0Ol73c7CvqcixRVr55OmWoASeSVunyxMGqL52E4
        u09UxV0EeCWu+lao+dmETX+yW9HDbnGgZg==
X-Google-Smtp-Source: ABdhPJy5M8aYwRcuq6qPkdDJP59Z+jprDmEvHrwAKs28v+v5/TX2MlKdtIcDKUZ/f0qfcIRoh3tH0A==
X-Received: by 2002:a63:c843:: with SMTP id l3mr4161349pgi.376.1604612437931;
        Thu, 05 Nov 2020 13:40:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6sm3876927pfh.9.2020.11.05.13.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 13:40:37 -0800 (PST)
Message-ID: <5fa47155.1c69fb81.ddb42.7cae@mx.google.com>
Date:   Thu, 05 Nov 2020 13:40:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.241-63-g1e4676585859
Subject: stable-rc/queue/4.4 baseline: 124 runs,
 1 regressions (v4.4.241-63-g1e4676585859)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 124 runs, 1 regressions (v4.4.241-63-g1e46765=
85859)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig        | regress=
ions
------------+--------+--------------+----------+------------------+--------=
----
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-63-g1e4676585859/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-63-g1e4676585859
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e4676585859b1b0266aac91179497dc08f1f2d9 =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig        | regress=
ions
------------+--------+--------------+----------+------------------+--------=
----
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fa43d243b4412ed6fdb8874

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
3-g1e4676585859/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
3-g1e4676585859/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa43d243b4412ed6fdb8=
875
        new failure (last pass: v4.4.241-63-gee073a715a86) =

 =20
