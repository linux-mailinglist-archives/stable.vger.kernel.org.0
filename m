Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0264A38DED6
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 03:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhEXBSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 May 2021 21:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhEXBSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 May 2021 21:18:43 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C022AC061574
        for <stable@vger.kernel.org>; Sun, 23 May 2021 18:17:16 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id kr9so5819719pjb.5
        for <stable@vger.kernel.org>; Sun, 23 May 2021 18:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KDl3PPLXlZ6gu9E1DpRQUToB1pXS9nYAOQYYQpMXqP4=;
        b=NffFBW+v9Ryqpsvv0ofs8P6W2NjEDxAIUY/8oy+H4in6N442sSjuui127fjdkH30oi
         DkF3+Lmky3k2VEHzQK6APCFoAY8zcMSE7b0Ey1qak0RLdaaqMSWwdWStrpPeUAqaB6pg
         sfPKVKVdLt/3NI9bJwCgCuCloOoTwgU0oKrQo9cAy73zPUgPSny1aFG1y7oM98/knN2m
         LJQM/ZWSHyeazO8BQ5YgadO+41eSi7SHHutd9NLd9QkfqgiRsvNhxIRMdWpC4/b9J0e2
         /kBQUJU+tuar8iPE1y9tFe4D8q6CvgtkmARoAbWg7Vl+itEBhO4FOPwCmqMVOczWTbeR
         T/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KDl3PPLXlZ6gu9E1DpRQUToB1pXS9nYAOQYYQpMXqP4=;
        b=VnVKjAzBEfPdMwmY0lEtXVCh1WhM6CztXGpX4+7pi+LUdQqJ2gZTQNKH9xMV4+euvk
         T9uv7TZMcDuQCKXoA/64oIxVBFg5fY/UdFYXtkptE1lwrrOyAdGlnARH2o75W56YqIxl
         3Ew3wDWu+MLHl1LIFLypD7T3rEZSbwtJ5V2xJcVseVB9LOf8MetIi2GkP28MHCl48kjQ
         /YGgDE84MVo7cWjNs3Fv6E6RigaXyTuCtA+pfEXANXxh52Km6aMMeLIbJUtORxn9PnRR
         /r2vryFehlhFElDH0zu95XYctLQee8plc2bisuBl5bsaLISQPsEokOrxDgTlOZHL7vqq
         drog==
X-Gm-Message-State: AOAM5300t09kb3Ea8LgNapvg2kt5evTe4oCq/3p2/b2l8M6D7Nojqr6N
        mFaAR7yvL2zmnvx/OzJ2VEJq0RkbjX2PHcBL
X-Google-Smtp-Source: ABdhPJxuU9PwzZ0JkSSgnlRSD4wNTsBNYXI3ocY5UfoJy7qijV0Ywazk+SXZx+3iacGb3eWxXMHHFQ==
X-Received: by 2002:a17:90b:4ac5:: with SMTP id mh5mr22141981pjb.226.1621819036106;
        Sun, 23 May 2021 18:17:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7sm7624490pjc.16.2021.05.23.18.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 18:17:15 -0700 (PDT)
Message-ID: <60aafe9b.1c69fb81.74d9a.8260@mx.google.com>
Date:   Sun, 23 May 2021 18:17:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.120-51-g3a263674fe69
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 114 runs,
 1 regressions (v5.4.120-51-g3a263674fe69)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 114 runs, 1 regressions (v5.4.120-51-g3a26367=
4fe69)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.120-51-g3a263674fe69/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.120-51-g3a263674fe69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a263674fe6916e37a3fe1c361610b237299f1b9 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60aac7115efee2fcd4b3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.120-5=
1-g3a263674fe69/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.120-5=
1-g3a263674fe69/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aac7115efee2fcd4b3a=
fa9
        new failure (last pass: v5.4.120-36-g7a5a11d8ab45) =

 =20
