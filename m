Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878804CE648
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 18:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiCERll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 12:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiCERll (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 12:41:41 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D95B1F1DDF
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 09:40:50 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id w37so10126184pga.7
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 09:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wEpqFyate25XK2MHckRxvjMJY5chSLeBbN2TubJACSc=;
        b=SmhF0SEJOMKWHj+2+zCvfaCXXJBcPB7VFRe95QkHSKrl7JA/9HOhRl7Ijfb5ULTlvn
         h1RmLpPk1NK24UdVOyrVNyEC7+tui4Cu28jkkXIw7x0bDAzYvNMjCE7CQjoOcQh7AwbV
         u3ork7PKWpKGr3/PKbzK4zGjZFhDUd5FTfR9s2Qm354xCeaWSFKikkgsW8So9FS6HwAG
         Om1tZ7Bx2UtWxhgSfL6x24iG10E3D83ApKGzwZbaMXvhCWbhM3vVd0L74FuQsJINypWC
         1t/EE15uWaUkgF6TSUZrLrW1YOQoUOTPif8NMsLgQI+pi8wn4i/nW4pz7G6nPLwgLK2E
         rbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wEpqFyate25XK2MHckRxvjMJY5chSLeBbN2TubJACSc=;
        b=YT5v01Q0+vedGSRtaFnkpVbPynqK87xcAeLP8l1pApM+t5G7wuyY5XeoWXazmwbxWB
         igN+P3st7z9I/iI+f0PStdd8y6Anva6JMdLrNB56c1+vbql76fFVK91Px+U5+nK4hQes
         b6CvFUKwTKHW9BAZhoiDjrXDiJt8J6CNLWd83cAiIhs7D8yuKJZmzv7g6pZFpEYN0XBp
         AsPmA/VjEpenfv27kKzj1UzXOtsF+lPS77euFpt0ZRCzSaTnSo9h+vqSudMNQB2aIZkw
         WtFbIHowYiJr1xipYraKu6mn0SgQ1xwYpQZ2f/I6+zdCcbAnwHUJ2v2hlpkxH8QxQby7
         IK4Q==
X-Gm-Message-State: AOAM533boxrL7VOhewO/TUxFONmXiYr+E0qa0KPmoGRI2Sx52YQHiIEf
        BjPiyUk+cmfd5r9bm0doTkwb/ixJDTU+foATXZI=
X-Google-Smtp-Source: ABdhPJwmfpTiFXdiQT4110YgJgiDW4SHjZHJUqKk95KR34GyjfJ+fSRZuzW3eomoBky8zcieaHyw2g==
X-Received: by 2002:a63:6843:0:b0:37c:43ce:32e8 with SMTP id d64-20020a636843000000b0037c43ce32e8mr3442473pgc.456.1646502049871;
        Sat, 05 Mar 2022 09:40:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s42-20020a056a0017aa00b004df8133df4asm10632235pfg.179.2022.03.05.09.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 09:40:49 -0800 (PST)
Message-ID: <6223a0a1.1c69fb81.c23e5.b3eb@mx.google.com>
Date:   Sat, 05 Mar 2022 09:40:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.269-25-gc9efcb7ab478
Subject: stable-rc/queue/4.14 baseline: 42 runs,
 1 regressions (v4.14.269-25-gc9efcb7ab478)
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

stable-rc/queue/4.14 baseline: 42 runs, 1 regressions (v4.14.269-25-gc9efcb=
7ab478)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.269-25-gc9efcb7ab478/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.269-25-gc9efcb7ab478
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9efcb7ab4789b94894310ac18bd82fea8590096 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62236903686de584dfc6296d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-25-gc9efcb7ab478/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.269=
-25-gc9efcb7ab478/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62236903686de584dfc62=
96e
        new failure (last pass: v4.14.269-12-g77c318e6819e) =

 =20
