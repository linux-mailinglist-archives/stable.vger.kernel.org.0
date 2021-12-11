Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA376470F4D
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241352AbhLKAUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240722AbhLKAUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:20:05 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A5BC061714
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 16:16:29 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z6so7325893plk.6
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 16:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nnqWAcqJw+2seM8tMYO35lb2E/JOmmJs4v3UIROApJc=;
        b=MgDGJ2IBNf1AXBhBEU4IhsM8QZOdBl5FlJ1LDKawiK8KfffJYi2IbIimuEZOPm8tzS
         Pgwlo+ag+K3m9Vk+PlQComtc5VXO9BU/b5IJ3cpsjXmnvHg3S59okkLLFo8Pw3N/urjm
         X+0UPXRfHPnLfHoky/qNp1nS+i6oS5JAOjOqEIMTkMRE/Y7F2rJHRNCn1mv2lPIeBl8Q
         GiuCG6aia2vByARdWDAZA0VsOCiWexZJ2d50ctqWVy9NRGtdNDzrl1pO3w9HF0rbb7IS
         p4StL0KofqU/WzJTnLuxlyNyH4Nick1q9sYgj13gMUzzqkLN3IYNVtzpqk97PE0gv17F
         btPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nnqWAcqJw+2seM8tMYO35lb2E/JOmmJs4v3UIROApJc=;
        b=T/AzvwdHAEs7au4OYG1aeAbGDVNnqbFFR4nPSkw+FcCdOYstubP/UveVTRxjIfdUO9
         6AjmAOwy9vg+rNI4DhSf8Ow/OiB71B9/xgc69sXZ1BmcTG5XXIHEIWsFod9/x+BUkIpj
         oHmjpcpFjWAabihqSFYUlqL5Y9NSBBxql+hbjuX9YKZJvp8QGWGFsZjg2T08tmQ9NzYj
         pN+euxCByTmZnwDSBztOh66vHkkncD0eBeXixCV9JYx4r49IacT7z16LWzrMlMhQJMEU
         9wWu7t/6NIlibJtOPq6sCRi10eMSWX6IszZLlRQqbLoMOi5pdVEhAoE3OJcyUPnGmWel
         SBUw==
X-Gm-Message-State: AOAM530TG3pU/CKleSCkss1aDuk4vYjxIz1E6fQIzNVVfjzu7Ctyt/hn
        qALyNzMCM58fcOXDVYUuh4G0Nd7toXLGDM/N
X-Google-Smtp-Source: ABdhPJyfApaEr8Elho0JyQUbXZ1nyydMdIw1t9WwAlnPi3cZra8I/qm1EqjThlqdP6gjFmfOSkTF8Q==
X-Received: by 2002:a17:90a:7086:: with SMTP id g6mr27630048pjk.34.1639181788750;
        Fri, 10 Dec 2021 16:16:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n6sm3740598pgk.43.2021.12.10.16.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 16:16:28 -0800 (PST)
Message-ID: <61b3eddc.1c69fb81.eb818.b440@mx.google.com>
Date:   Fri, 10 Dec 2021 16:16:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.164-26-g9502d781e24f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 147 runs,
 1 regressions (v5.4.164-26-g9502d781e24f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 147 runs, 1 regressions (v5.4.164-26-g9502d78=
1e24f)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.164-26-g9502d781e24f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.164-26-g9502d781e24f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9502d781e24fc4cf4d7eaf02de444ac37cc3d881 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3b70517d67fd397397167

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.164-2=
6-g9502d781e24f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.164-2=
6-g9502d781e24f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b3b70517d67fd397397=
168
        failing since 1 day (last pass: v5.4.163-72-gfda44f5f463a, first fa=
il: v5.4.163-73-gf01a13d9c502) =

 =20
