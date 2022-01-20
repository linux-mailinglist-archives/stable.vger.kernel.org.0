Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB774954C2
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 20:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377639AbiATTPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 14:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377536AbiATTNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 14:13:48 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951A1C061749
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 11:13:43 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l16so6847470pjl.4
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 11:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+w3u8tDmb57jScwglvrZWBWVpF/UhW5/Teyjafw3UGA=;
        b=uQNFPVP1d+XnNQjE6XMkNAaBeEV1+QbVdoFmeR7KaEG1HCe/7i1+3+vQyIccW8XqRI
         nFQUVH+VgWyoBCgFkrwBLb9EWMTLYWa14JD2RZw4qFVv17MpwwBfwU3Fmxc0/L+eCxXk
         4o1nGLl07TZdO1H4hWTGhudYsuc+Ng/FY2Ol8PzpSGbGdRNp/pYYXADdhtMwJgOUj563
         l49Xlsiz1OiKWKIXYgy9tQRgRZKc1TcTU+foMsaAIvBi3ZZI9uEFBQJ/kagxnLZxL6IO
         o30NBkQJwriaJ9gmW5AYBwOZ18P0szIw8PCsMZ/yLNhl9ukc4F8GdSjX7hiJi7pqYE69
         iaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+w3u8tDmb57jScwglvrZWBWVpF/UhW5/Teyjafw3UGA=;
        b=Hwl1K1ZN7YMDg/6JghLuPhQk0sqbFu4RxW0iYJMs2y0FmvyBq9cJ5HUOeT+u719j8z
         w3pGFgk8PJmH4j/QPDGrW9r19XhO+DZMbhS99ppYWQeNuXkxjWMygnToykl/0acidtZR
         ZV7rOE/GuNK4Wp/ytHoXWqRjq3w1pbNDaOSj3doWM4Mrx+0pQMu544wxDHfi5+QvebHD
         nBQqsGOkuS/smdvqRoRGgeVf//KCYIXvLkokMwBGWX1Prh6bEapNy4mCEhZkr7rBjD+B
         +AxFoCX8B6RTLx+A1oDKeadyJ8/uGFisIsXhMCsQ4cU1ls1hntvEIzRNt/AQrX4guO74
         +xZg==
X-Gm-Message-State: AOAM532uOctOb9oSzxWGRR57OxJBbFLApc++WGYitZfjTMIVj0b2lz9x
        RkFzbuq/TPd4lykJW24fXYDRi/j1iooDIwL0
X-Google-Smtp-Source: ABdhPJw5Xv0hVnJaVmocdCiXJSuWtvCvFPMNUp/Vp7w6w2UFeqqFeu6f2WfWgmafjflC3y4fZ1C0Xw==
X-Received: by 2002:a17:90b:3884:: with SMTP id mu4mr12361793pjb.133.1642706022948;
        Thu, 20 Jan 2022 11:13:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f11sm3179525pgr.48.2022.01.20.11.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 11:13:42 -0800 (PST)
Message-ID: <61e9b466.1c69fb81.c2b8c.92e0@mx.google.com>
Date:   Thu, 20 Jan 2022 11:13:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-12-g4a79c59748ce
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 122 runs,
 1 regressions (v4.9.297-12-g4a79c59748ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 122 runs, 1 regressions (v4.9.297-12-g4a79c59=
748ce)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-12-g4a79c59748ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-12-g4a79c59748ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a79c59748cee64639595c973a7484268f482b93 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e97f13b82874de77abbd11

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
2-g4a79c59748ce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
2-g4a79c59748ce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e97f13b82874d=
e77abbd17
        new failure (last pass: v4.9.297-12-g2155294a7be2)
        2 lines

    2022-01-20T15:25:52.812550  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/128
    2022-01-20T15:25:52.822365  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-20T15:25:52.837864  [   20.180114] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
