Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D67445F606
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 21:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241086AbhKZUqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 15:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbhKZUoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 15:44:01 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29496C06173E
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 12:37:19 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso8767887pjb.2
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 12:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x6Tb89L2Aq/Lwk4/tdwl9fQE42qNdIwe7VQnL4dWm0w=;
        b=pcoasTzALDXhYuygbVDWFnoPbuWPHmCg9SuGS1uH4cQdyhSMYCLOrs1Wb7LiBhwx6x
         reE5rzqP4N5UWbIVHGEuCnU04wuoP6M9nUe/J0+KnyeUSmvHb8xx+u7ccSu3rZ6SVxAs
         hwF2U0iPbFturVqeVezIo1YYTkZcgJA63VV0idrzGXkngy6478ldQXZDYmldu9ICE2Ud
         7sYDMMrCwqY2QJ/JGE7auRgp8H6dwZ0+NvmWb6wf6dkkw7OzqFjXs2STuzuVQbJI1OHW
         7FE2/Hxt+Tw9KtyOa5NmGbG33iGNCq8zFv/ee0F2wfqntiOzfA3onpOIElIUFYtFgJD4
         ZNlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x6Tb89L2Aq/Lwk4/tdwl9fQE42qNdIwe7VQnL4dWm0w=;
        b=gXhsgm/0bb/6HpqQ01UUHnfGz2FPaapL/ZO2nawGtt77K/Ri3teK+hpRRF9eRQFKkb
         45c5hWgd99+lG2pNFW9vQ4nWYDu8y74+jU9IghLNfjBOFSojoHZxC23TpzoxC3sh3w4L
         g+Rs6dMKNEDRENIQTToXag2X6qLt7wOJUkiOsvajGvMKTiSG3ddeVSnJ+6InGr0LEFBK
         56DcuNCMR69Bu+DZGVsi/exI58A6o1UBjP4TAHXhza+2BKyEib4ZOuPrMFA/eqHzj3YL
         xKreg7G8bQejMbMA/eGrc8Uhlm684U6/8zijtaUfzPETm9RpR6h1hd35gpI1vZw2XUDe
         XoJw==
X-Gm-Message-State: AOAM5326MNkL6OX6oxd5vlkPfhChXFNmdgZaHaKNO0TPzr7B+krhNUzr
        IQYvWArjrLVuLbAhD14r//esRDLC9sCgb09Q
X-Google-Smtp-Source: ABdhPJxnGPeZCJe9bkEMpBlEXxov8B8mYtZYDNb0Eu3D7ClmPgEw2QBaNg3sFMmV1LfkjOwXaftJHg==
X-Received: by 2002:a17:902:ea05:b0:141:c6c8:824c with SMTP id s5-20020a170902ea0500b00141c6c8824cmr40639219plg.86.1637959038616;
        Fri, 26 Nov 2021 12:37:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j127sm7917125pfg.14.2021.11.26.12.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 12:37:18 -0800 (PST)
Message-ID: <61a1457e.1c69fb81.6b313.6368@mx.google.com>
Date:   Fri, 26 Nov 2021 12:37:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218
Subject: stable/linux-4.19.y baseline: 151 runs, 1 regressions (v4.19.218)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 151 runs, 1 regressions (v4.19.218)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.218/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.218
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1f244a54b39dd02c69f79001b38e2650e96f1ea8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a110edbf9202d18718f6cf

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.218/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.218/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a110edbf9202d=
18718f6d5
        new failure (last pass: v4.19.217)
        2 lines

    2021-11-26T16:52:45.374600  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-11-26T16:52:45.384327  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
