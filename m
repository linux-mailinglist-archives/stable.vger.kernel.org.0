Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B136F48453F
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 16:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbiADPwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 10:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiADPwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 10:52:19 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAA3C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 07:52:19 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 205so32608554pfu.0
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 07:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tfDtrsK4UZO/IAJTNQNW60ImpkJ0IUcM1yTPRW0Qiks=;
        b=YYK0qZggHtVcUSQKPXmiVN6Cm6Ubhc7Lt8+Rq6wUURIKz1oAr2bGZrRN1Ts3vYQ76r
         wjleC3F4S45mZ6Gfqo8ckeu/JLJyqWt/j65ufCTt0cqVXxLutDC6CLq75eGXtsszMGBL
         mzJxylOwJ29hXbDlAZQ4VY3sUpW9Kq9B5Gm0YZ2DFoLP4kC4IBqaWlPMGm7Se9KeQXx7
         tUF1x+t2BU/X1sbgl40fr4dXJUyRsgnGJDjAkQNaBE822XDnINxdSYTUgYcIRFZ8wlrx
         1nPndSYzje97nw5o7wFMXLoHwYnvYk1I3nIibCG7oGaPyn7g4FE8Q0FPLqApxc+AeUiS
         COEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tfDtrsK4UZO/IAJTNQNW60ImpkJ0IUcM1yTPRW0Qiks=;
        b=J1gZmC7WGDwc7oGD8mkCp7u2aAL7GypxZo3prRR917Fekfl3YqzrTV5KfpVZP5TwCc
         euXLrsASMpsr5AJ0qv4S0cksFxv2TltoN5CupMiqVbtOEoQgIPsXLA4tLL6dqKCSSiwl
         KNuDsvgiaosFgnIMk162byQdiwnxwGIlw8HrCbDzBDNPTVkaJEDib7CA3lUffulvvqT9
         AzgWoy/819XQ4mJn2pvs2MkZ5kxM87wnbAoWSN+FeqS1DT37iDdCrlkgNz5w609rd0Gy
         wWEz9P51hKBZe8I2EAFOOjtg+2Up3nuuw1fIwKIJYuqt/OKV6l6lipdE7BCWeJ1XTuvN
         Q6bA==
X-Gm-Message-State: AOAM531oMBQAuew/OKc9STh2O/g4yg88esSw1kcD/ux/t7LdEesRwYG9
        6/QwzSlHyIQjw4hvgRIdj3vOSjJVLISqLFCZ
X-Google-Smtp-Source: ABdhPJylj6TXfIvg59tLtKVFfgQRE6JUhV1ECYNniYLzv07CL5UPJU4CJl1L/ExJfaL/dceRkYmSRw==
X-Received: by 2002:a63:78cd:: with SMTP id t196mr35956270pgc.503.1641311539012;
        Tue, 04 Jan 2022 07:52:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w5sm40434270pfu.214.2022.01.04.07.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 07:52:18 -0800 (PST)
Message-ID: <61d46d32.1c69fb81.502a6.8dd1@mx.google.com>
Date:   Tue, 04 Jan 2022 07:52:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.297-12-g9ec8a3265c26
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 118 runs,
 1 regressions (v4.4.297-12-g9ec8a3265c26)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 118 runs, 1 regressions (v4.4.297-12-g9ec8a=
3265c26)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.297-12-g9ec8a3265c26/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.297-12-g9ec8a3265c26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ec8a3265c266ca3c1ebe103134875177cd3d856 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d43ba4b088c3f2afef6766

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.297=
-12-g9ec8a3265c26/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.297=
-12-g9ec8a3265c26/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d43ba4b088c3f=
2afef6769
        failing since 5 days (last pass: v4.4.296-18-gea28db322a98, first f=
ail: v4.4.297)
        2 lines

    2022-01-04T12:20:30.198849  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2022-01-04T12:20:30.208344  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
