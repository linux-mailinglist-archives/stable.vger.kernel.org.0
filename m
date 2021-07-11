Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9DB3C3F87
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 23:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhGKVjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 17:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKVjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 17:39:01 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD05C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 14:36:14 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id n11so8939232pjo.1
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 14:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+Z6PkSaIKLGvsGAkU/UigCkjN1FDgdZOs2WBskkArU4=;
        b=EamDABwmDeJcXQWdYJV1bgebMvN/jFwYqboA2UrH8w7QJEnFCZHY3ZAHVdiudPeSHC
         JoPX55wqO88lwNyTBz8CMC08ar1deyT6nyhz0POvRhH5srPThnXVND6iLo0M/gV5XKqV
         BwcnYQTS5TX2muUWeSdJeT3uhbPE1mL+NzuuurWAly5du+UVr5HsxXflLKXMsu0XxRIc
         6f7Tk5acUrn0Spee20WTaUsvLfclg3wYmBkKZTkWYWq4EJ3VP8FMs7hJo6Qo/UyWxw4A
         gL5/XltQNXhDlijTpt1+Kh/J/F6i0KZ4RelpV+Z3bi2uI4AcfjDZOO5ANGwIOUjZw27Q
         lGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+Z6PkSaIKLGvsGAkU/UigCkjN1FDgdZOs2WBskkArU4=;
        b=ohfXA7y05X6on4D6318JPeMfwwbM+WJgzKvu3qqG5RU0BKIcpiugQmMmThUS4iX+UW
         17AQDc7LdwWmzOYOrEtZT/if7zkTXGC1RV5l3qDzwtPAtawN38ErQ5g0GFMdyDHNw8Gh
         XwE2fkCl5dEnM9v+KUbrD+Fq4aW0QZfO4QGUWjnHf6DwKKCZy6Rxv14Zjujqq3PK4FNB
         h1Oxlp8NyfGgEdZ/GEr6uEPpe/GwR7GvQh0JCtdfMLmDQMgq2tvEjoR4MzRpNw//aeJV
         6loangG4fhSJey2OOcHKOZ0FN5fzMP9712so1J6CDOYne6Vs0oFrKHkdKGiRNNIck3Iw
         tQBw==
X-Gm-Message-State: AOAM53295YJzWB4dGUTWD6d4GnZTWY8pouAEJsGTfUXxTUH0sBU597Cc
        dzhXXKzIBRiGLTPbKXJQWGxT4JU29+rCc08r
X-Google-Smtp-Source: ABdhPJxWAFgl+FBKkzQj8XSiHgXi+Vq0ERnHSUSfyaTNtIln4K9n0CF6My1i7rIk9cxEGHxfvzXrPw==
X-Received: by 2002:a17:90b:68f:: with SMTP id m15mr10839486pjz.91.1626039373957;
        Sun, 11 Jul 2021 14:36:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id js5sm11625651pjb.40.2021.07.11.14.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 14:36:13 -0700 (PDT)
Message-ID: <60eb644d.1c69fb81.9cf0e.1ff0@mx.google.com>
Date:   Sun, 11 Jul 2021 14:36:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.1-783-g664307fdb480
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 190 runs,
 2 regressions (v5.13.1-783-g664307fdb480)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 190 runs, 2 regressions (v5.13.1-783-g6643=
07fdb480)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =

d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.1-783-g664307fdb480/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.1-783-g664307fdb480
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      664307fdb480732e13cc2e975e28c3f4e8fc4c0f =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/60eb39913957fe50fc117983

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-783-g664307fdb480/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-783-g664307fdb480/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb39913957fe50fc117=
984
        new failure (last pass: v5.13.1) =

 =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/60eb3ae64b2b0bdac911799e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-783-g664307fdb480/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
-783-g664307fdb480/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb3ae64b2b0bdac9117=
99f
        new failure (last pass: v5.13.1) =

 =20
