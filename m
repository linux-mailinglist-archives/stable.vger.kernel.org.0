Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD30B48B8BE
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 21:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243911AbiAKUjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 15:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiAKUjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 15:39:07 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F059EC06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 12:39:06 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso7616018pje.0
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 12:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+BGEQCGGBqDJoqH5E9z0U+KwXzRpiBb0xlkHwxPowek=;
        b=TMivbaC8yR6q0vxibaX8PW6sSMB5vu+Icpqo2sVxmNG3pQlMdu46A41/JjIwVPHVYy
         bQ0UXDtIWiWdV2rv7OI7rOaX+3iRZFeuzIVpCrfSGKqT3UMvXOLwNElBT3c1z7R95/2f
         +jnV5ycDY7+/c2StqI5B+ULX0jyUI6JMLXW0nd68Wy6v+97cp9yZPzWiR/LUAL6Esp0n
         QRKZ0Vce2k+eL6K21cCM+MitLc7ayNUQSjKeKF6XFM7xY35mwDZtodavGR9fbgSkmuyR
         FhKJZnr+GaO4plB6rZJWcqqOXt3YIUf3RW7rIzh3JPz7MtI4PQx07ib6Omg9BtW2W7zh
         XIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+BGEQCGGBqDJoqH5E9z0U+KwXzRpiBb0xlkHwxPowek=;
        b=GdOIWFVCq0QB6h0oAIJZo1xr1IbZAw47kBszTJuETBIG0Dgl8nSbWrnb4IqYw8yBJZ
         RtwymH/HNAvOStVkCUzC5MBPpzj3TbYQTpyZTGOI0bGwVPQbF2zPlpz9M1x3/kPYgVR0
         JGlXRbJQKeXo1QXdqxdqOHcUZH8Khub2iAvvl10Z6lyTsaMi3J0AmZ35FCy4WmLT2kPY
         OG0MmhLxssWYErdh2LVmO997zVvMZRkNB4WtdK9KXQn1bpm7x7Pd2TePg2UnwnKaGyhV
         5txCVJ7yn14flot0GlmlpJVJ+Q5IiuOJhM5ixwlvOzsGxPV0oX0ovRVG0doN5lJNHJmy
         yxDg==
X-Gm-Message-State: AOAM5307eg31nCf0IVBq4rGy8uFOF/cHq7s4pZ2SSQ26kBR/RGmv3CHr
        deuSmCc0otxj7CpYdPctg3FAj4mjuqAC3iA9
X-Google-Smtp-Source: ABdhPJz/7BnCae47lz8ueofM+GW38sf1owXZF5T3b14s9bVzf8NwIXK9sYMXeVYqtZAn1O561aeDcQ==
X-Received: by 2002:a63:91c3:: with SMTP id l186mr5450594pge.455.1641933546426;
        Tue, 11 Jan 2022 12:39:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f16sm11689499pfj.6.2022.01.11.12.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 12:39:06 -0800 (PST)
Message-ID: <61ddeaea.1c69fb81.a029b.cd30@mx.google.com>
Date:   Tue, 11 Jan 2022 12:39:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.296-21-gd19aa36b7387
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 117 runs,
 1 regressions (v4.9.296-21-gd19aa36b7387)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 117 runs, 1 regressions (v4.9.296-21-gd19aa36=
b7387)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.296-21-gd19aa36b7387/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.296-21-gd19aa36b7387
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d19aa36b73877dd3b08c422e5a09e86d5e5f5f18 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ddb4fe2c912a031aef6748

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-2=
1-gd19aa36b7387/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-2=
1-gd19aa36b7387/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ddb4fe2c912a0=
31aef674b
        new failure (last pass: v4.9.296-21-ga5ed12cbefc0)
        2 lines

    2022-01-11T16:48:43.768862  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2022-01-11T16:48:43.777627  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
