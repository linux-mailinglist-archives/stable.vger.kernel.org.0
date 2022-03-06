Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D704CED0D
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 19:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiCFSIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 13:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiCFSIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 13:08:54 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EE910FC6
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 10:08:01 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so12076799pjb.3
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 10:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iQkUXQjWc2rDoxnOu2zJFHF2g4SpNwzG0D4e0HxKTIg=;
        b=hn2RuSMMb0/UMXIa2J1w176GeWD8QerbVjbiyKMzS5KWpApPssJnanBlyoFvHmYKOM
         LiVg7impMrSr255M06HYN+fAAwYYXU5hr/8xnW7/LyFgMIaklUHVgLAmEL0+X778LHM4
         qFcpblsRYslxOogO0e+GQtdEcezTR7XJteIW4y1fWReWfOAP/KgH8/JWwT9F/uSmpBbO
         eNB67QhdWJdgwS9XYouI+XsHRdojxoRRs9d7nNoYZQN8bxcUQmbppGywNZ+5+7A8qGw4
         h9FABkdk6M11XTbU8ApB70368I6Ec25SyfVNabNY377FnDWK7b8IOM4Z64bG75hf87/z
         e/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iQkUXQjWc2rDoxnOu2zJFHF2g4SpNwzG0D4e0HxKTIg=;
        b=w+D7xa3IPolGv5djuaROu/IueTziQZu13Z92ITloiWrO4HpWWmufzzfGk+FnmZjOBx
         R5RwxgT/ihWs8QsTlzIL8dpoFCldB7OuyXfBkfzz5lKcVhtVeINssnJrQ3LaUdu3m3SF
         oMUBRxTYR9Yf/DcrmRGgwWNaB5cBW3r3NIQQou1pDqN3/23PncA+gATaN6E3w6O6QQMH
         crOVl1GjQt4gp3N3dJYIOmFMTrFqFzK0QCULGDSP9nxP/N4pqrOPVHjRmGmr7XZzTYt5
         m7iVVF6f1PcleiAdsV6z52AjRWkbh/fFaNpig9houN6Ao1Q55Ynxe4fBF/6ztLlELYrf
         g2Ow==
X-Gm-Message-State: AOAM5339Jezxpf4dqOaPQHM+8utcBvQuci1Tw0+8a7isIBEHEooGXse8
        IEKOzdaBklDE9DREY9Gh5ts7WLhG/cafXsxu7fE=
X-Google-Smtp-Source: ABdhPJwpt6+FRy1GO6lrDOHrp+vV+UWSYZLEZuuxUJ60jO9AokUFLx7+5GyafXyk02uwHDnYnWUaCw==
X-Received: by 2002:a17:903:2290:b0:151:e50c:bb50 with SMTP id b16-20020a170903229000b00151e50cbb50mr2447726plh.95.1646590081095;
        Sun, 06 Mar 2022 10:08:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4-20020a056a00248400b004f6b88bb75csm9527931pfv.79.2022.03.06.10.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 10:08:00 -0800 (PST)
Message-ID: <6224f880.1c69fb81.fd22d.6cd7@mx.google.com>
Date:   Sun, 06 Mar 2022 10:08:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.103-99-g803f589c9a5f
Subject: stable-rc/queue/5.10 baseline: 107 runs,
 1 regressions (v5.10.103-99-g803f589c9a5f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 107 runs, 1 regressions (v5.10.103-99-g803f5=
89c9a5f)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.103-99-g803f589c9a5f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.103-99-g803f589c9a5f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      803f589c9a5f1f44fb9b4cf20ee6acf3475b7039 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6224c466e8ac3bf107c62970

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-99-g803f589c9a5f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-99-g803f589c9a5f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6224c466e8ac3bf107c62=
971
        failing since 0 day (last pass: v5.10.103-45-ga9cd4525baaa, first f=
ail: v5.10.103-56-ge5a40f18f4ce) =

 =20
