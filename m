Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ED9489A6D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 14:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiAJNpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 08:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbiAJNpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 08:45:12 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81929C061201
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 05:45:12 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p14so11962048plf.3
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 05:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ijto1vsuCXUDLsGppWbmnOgjV5NNveplYw352tYVwt4=;
        b=U49vWKRQFURTs5JCFWuaghVi9OVaPxI6+Em4aNX84tZjH72PYhJQG8zkaIGxlebToO
         LrWU37f3yemrELioHXDWb6y512ksYrWnr+xhklt2hh+80CIaRQNdPEbA0buSfj8PfCNU
         liTVyO9Y2LnrIxDe7XRaganVH9Z0AqLNtAJj7aYz8Fq0zRm4Kf//Za160Py6hoD6qB7K
         fB14UwCTFFjbL7bOphrgM9GNElQmMQc0BSNpDp5A/dPX2ZgVbFbzE6Ennh5+/jSVt/Lf
         OFFkh7YWhKmxeWbbWPcrbdwYQMGuvfNvtedaOvNoo+8rDP231MySQ99arnTttNha+Epf
         Z8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ijto1vsuCXUDLsGppWbmnOgjV5NNveplYw352tYVwt4=;
        b=sG13ljHmOXPm4GViOEBXmvltj//1D7gmqGS2y8QECXVwVf1CtyRP47EODctUIRzPjt
         XAAb0tUUARxwWz0gV5VINLpXyMqsEaK7NOS6KE4iiudwZtHHrqYIZ6Exlrg8miTDu82R
         RESTyc9OTZzRPZ/CPLrLrctg4t1+kIUun5YDaxT+DOxZukM98/XgsnTuk+6oa6l8lYC8
         g+YOn4Dmks6DYVwbE8oD9ZOSzSc8BkW8CefX1G8MNcrhTIJxAleDDZIbauethmH7kv7C
         ewRRlvKExl93jaic6On7Q6oXfUo+tyR/naFnsAnj95vT3fyGxVfgJ0ux45FN8Jxne78j
         fqIA==
X-Gm-Message-State: AOAM53096DIbYTUfjNnRBrpSHkTwdw9VhcBef3eRVO8nfrS5Ucl5IQ6y
        IhEc3XUpIs0F0fxyCbnHWJMTjEoPx77sH7xG
X-Google-Smtp-Source: ABdhPJwggp+wp6kZevSYfNFUW848rj+GxnrhnfT3bQoGj+JKe7H0BWKM0ALBa7PtI/84mhM2Wuswcg==
X-Received: by 2002:a05:6a00:240b:b0:4bc:ff85:4e0b with SMTP id z11-20020a056a00240b00b004bcff854e0bmr15417431pfh.85.1641822311867;
        Mon, 10 Jan 2022 05:45:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m19sm7334457pfk.218.2022.01.10.05.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 05:45:11 -0800 (PST)
Message-ID: <61dc3867.1c69fb81.2714d.0dae@mx.google.com>
Date:   Mon, 10 Jan 2022 05:45:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.224-22-ge159be04c4d3
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 127 runs,
 2 regressions (v4.19.224-22-ge159be04c4d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 127 runs, 2 regressions (v4.19.224-22-ge15=
9be04c4d3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.224-22-ge159be04c4d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.224-22-ge159be04c4d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e159be04c4d3e44598f90d60ccdab58c1fc0f82d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/61dc03fc8a02f4497aef674d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
24-22-ge159be04c4d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
24-22-ge159be04c4d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dc03fc8a02f44=
97aef6750
        failing since 6 days (last pass: v4.19.223, first fail: v4.19.223-2=
8-g8a19682a2687)
        2 lines

    2022-01-10T10:01:20.736307  <8>[   21.998046] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>
    2022-01-10T10:01:20.783308  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-01-10T10:01:20.792547  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61dc03fc8a02f44=
97aef6751
        new failure (last pass: v4.19.223-28-g1a042e04b035)
        3 lines

    2022-01-10T10:01:20.709168  kern  :alert : Unhandled fault: imprecise e=
xternal abort (0x1406) at 0x0007553c
    2022-01-10T10:01:20.711988  kern  :alert : pgd =3D (ptrval)
    2022-01-10T10:01:20.715649  kern  :alert : [0007553c] *pgd=3Dbc094831   =

 =20
