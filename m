Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84E64952C9
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 18:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiATRAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 12:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiATRAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 12:00:34 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C523C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 09:00:33 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so10429358pjj.4
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 09:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FlLXBd9aCqMv5Utb62OQ71yAk8NZGE/XgKxxn0jKY6U=;
        b=eeGJOsVO2zrV6Vid86wsinc9LChhGV1fTM+/6YFeOHVNtyr24Us5+FQn1VXDDbPHbt
         6isFGbNmgJ/qZWyZOqYaV76M5sLkeRe30Z3pnLzkzZF41WuWkh5wiVq040xlopBkg/MN
         eAEOLxw4ZXN0I/lT7F/cRHQfwKddUTOCNeCTlJYA2RKDc7FXmN/cEMOpk4l1H7pF83r8
         XYxmuU59YgMyvE45oBJ1gHxS+2TlGuKp4JoNvjiHlWqnF80QSjfLSwqtDSK7sMb+ypCo
         CE7+fOj15taDG27miln2Wgb4nX3AzAEaQL34MPxfF0OYOdQodWPiYLQTI4uHlZDeUaTz
         i1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FlLXBd9aCqMv5Utb62OQ71yAk8NZGE/XgKxxn0jKY6U=;
        b=zo2ZCu03EXFGpcZfTvaYailM8AOhdPjZ/RKm73nmBOk39oQUGGINNJccHBWskiZZY2
         ojUU8Nd2ZDek6CUmNpSoDKztiMhaRZ/YQ0xY8h8MOSmmZQcgloAMP6//ow2iQ54pbSbE
         bQFNZicH6kAxPZgCbVPSwtx9AMna1DNNVu+edPjlVNpBxYuguckHQSPUeDSqieRH85XQ
         BgSO+qXgeze++I2YcvFxLeursqAyA5aUz0LQ8i9nGQhnch2k9D/zJqJ6pENBwZPQ7i7O
         aW34SR4SYtvtpENzaZmZuCIsjLF6R63nZkQcFg7tBUMLhhquke7lqtFGYXKfIW5sKdBb
         qifg==
X-Gm-Message-State: AOAM5318iS8dCPGc4mKg+mBpO0UI0SUrVOkN+H2kdMPwdw8wBYZAcing
        GTUbR9EOTV0JnWAQ8SJPny1Wjh/8kfawCyUU
X-Google-Smtp-Source: ABdhPJwCEZBqvSt8n8chb+DQpJ/4f4u3qu7cjK0bgsHatI9YtNl5pi95+gHwa06+AotDF6Y+7kwVqg==
X-Received: by 2002:a17:902:ce86:b0:14a:b9c2:4e36 with SMTP id f6-20020a170902ce8600b0014ab9c24e36mr21670829plg.57.1642698032635;
        Thu, 20 Jan 2022 09:00:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d8sm3785315pfl.198.2022.01.20.09.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 09:00:32 -0800 (PST)
Message-ID: <61e99530.1c69fb81.21194.a599@mx.google.com>
Date:   Thu, 20 Jan 2022 09:00:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
Subject: stable-rc/linux-5.16.y baseline: 152 runs, 1 regressions (v5.16.2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.16.y baseline: 152 runs, 1 regressions (v5.16.2)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fd3e07fd10e79694bff69fff1d38e97b47e77f0 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61e95f3a46e68db4d4abbda1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a311d-khadas-vim3.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.2=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a311d-khadas-vim3.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e95f3a46e68db4d4abb=
da2
        failing since 3 days (last pass: v5.16, first fail: v5.16-38-g67761=
5cd2689) =

 =20
