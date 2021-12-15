Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01307475451
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 09:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240828AbhLOIdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 03:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236165AbhLOIdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 03:33:45 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CCAC061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 00:33:45 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id n8so15822452plf.4
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 00:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wUgZRJri6rSBH8AzlUzB1cBTzCUXT/YInHx31uzKBQ0=;
        b=wQV3BvI/eyw+DrQ/RIzDZPTRKygBjoUV0as8meDM7Gq3YABsMi/TyloSck7ZDXMzHh
         N5kRWIMnat3y0BT/2Z4y8t9tszecX6p0XzTUGQamUrVjeLWXIkapebHvJjRQx8IrtHK7
         RFLvgb4xRdAUHQkCR0c0a/GR2zhMHfmmdZJJON6zKBLHmHkwHN+Blw3+Pu3XpP1Twcqy
         AGPmCMVw78j+Pz4vorpn2mP04LwcAEJxXgOQWWIsC75dubg7dHq41XrwqJ/G+xbaMDAk
         lUmS9lKfpWgJHFpXYxA7L8F32mrEyoK9k3AQW8/NDq8dHSNOAFfEXQr3HsamEnBhBy2Q
         jQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wUgZRJri6rSBH8AzlUzB1cBTzCUXT/YInHx31uzKBQ0=;
        b=fGCodk6pxjg8Xf7GhWttNORulD72WYHrI9bTNNRCXfSzumJW5StXY2gm9CKku3gJyZ
         fGDOZY8ylzzFekbpHk7uJIhrUBklb4SgXBJlTbALr1JeqKP7fYT5WBJXOsPxrNhPn1ax
         aUeLuPUWAxMcnAJOGx9GrP86g5KqPUB2OcqUDF75l+2tegdsUe1ife5MDRbbOLeXdgOt
         PFjV5Lkqp4813weId8eEMCoYEfOaZydS6aPYreqzxua4LknD/A78ZeXr33RL9c4DV8/u
         kyXL9nXRe/MqdiYWlGD8N4nVjLgyiKf6wa+3IAi93YtTFLhR/IiyR/+fvjN9z4vg+jw3
         njqg==
X-Gm-Message-State: AOAM5321yc7EiO6Z8oqezuqk6BX3xEWltxItxP/PAfFA9lzZnkCUmbxS
        IxjkwI/tlGnTSs4AfcILic+JwlybzsdWiN2X
X-Google-Smtp-Source: ABdhPJyvFgh6SuknMDnmHpErIpLPCTKnaQR6rVGDNmiZPVnreb7QUyE8t0qehvGC1/cV9JquV1tevQ==
X-Received: by 2002:a17:902:f783:b0:148:a2f7:9d6a with SMTP id q3-20020a170902f78300b00148a2f79d6amr3422665pln.137.1639557224865;
        Wed, 15 Dec 2021 00:33:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p49sm1560018pfw.43.2021.12.15.00.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 00:33:44 -0800 (PST)
Message-ID: <61b9a868.1c69fb81.63b4c.4606@mx.google.com>
Date:   Wed, 15 Dec 2021 00:33:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.165-9-g27d736c7bdee
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 168 runs,
 1 regressions (v5.4.165-9-g27d736c7bdee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 168 runs, 1 regressions (v5.4.165-9-g27d736c7=
bdee)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.165-9-g27d736c7bdee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.165-9-g27d736c7bdee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      27d736c7bdeeb639f3be76a7b73b887987e55db2 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b96ea46a4be8d40d397185

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-9=
-g27d736c7bdee/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-9=
-g27d736c7bdee/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b96ea46a4be8d40d397=
186
        failing since 0 day (last pass: v5.4.164-88-gb4f7c3a061a8, first fa=
il: v5.4.165-1-g0847763b98b8) =

 =20
