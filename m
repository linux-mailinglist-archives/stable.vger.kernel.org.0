Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EC8480510
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 23:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhL0WTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 17:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhL0WTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 17:19:53 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986A3C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 14:19:53 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so14379103pjf.3
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 14:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=51oI+vEVNxeQrpViBZ9shG09JkrkNn/V7t2/e165xpQ=;
        b=xmrXSMfLJaVOKBnQanH1gxn6EO1Pz48iBvwIeDv8+qMPmI5GqM2cJZK+msmfSHeRdp
         NhrpbNVrVKLVqK18YiI8HhoF7h6DL5/pi3uYSgRoSk8xX9NFm5JEK3IJfaFN02w1qzJE
         B+9p2n0CxG/IOexf+JW38g0LuCR39Dr5VAvtutrsJ/EOZzUCJ2wzMxGfJh/NXq3Qwz8v
         iuHGe42BofPrroeL/TYXw8VywVBOgNL2mWx0v6N9qStQk/BkMjXCjndtejeso9g7FNGb
         tIXDTitZfBnUuI5BUMIhOwsGwsKt8oF3JYlK5YxzM/q641bRq+VFypKDlMetOpaiTTmr
         Taww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=51oI+vEVNxeQrpViBZ9shG09JkrkNn/V7t2/e165xpQ=;
        b=ntX4VVMyX/tGsfXDudUvVQ/Gpy0B/Ls+lSqobSBfsDQ3qGgF6C2YOylknYM3ADkPQ8
         v6WGB3f3FRpOrURKXtfFDOKKfCj6faRhtuVsscedHbtSpLoXZMy6ykU/h/YP2PDKYGR9
         QSqHwAz2wA9IeLPMKfpcrAQItBlpQNBjz1veHJUweyOPh0KY91Sk7Qec1pgLxkxXWxbx
         gwPESmqPhvtXLfMdr2hnT/bpyQIyCWQ3n9A6gcZu1mJ/KAwlbZXkMNTWsRgb+MCHzJDS
         XyihqYezTMcsWP4lrPKSwaYT8YQiZ3Whr7MM36i5r1hBD8r178yNmk/DXOSV2Gf8rTeZ
         DdLg==
X-Gm-Message-State: AOAM530NWiZivK3f6GPZkQoDdlTy+NMGBAqUxEfRuIpzEr3g1pYka0+q
        +LKy6eWLU7flc1bipXSfR5RlgxuYuaxf3mSU
X-Google-Smtp-Source: ABdhPJy1W1oxh3MZBOoLb+Sp6qjKNLY2R/h08hU4KvUS8BlMvofUB+HDl9v0F7AewYhFNRUu/H88Pw==
X-Received: by 2002:a17:90a:8049:: with SMTP id e9mr23249974pjw.23.1640643593054;
        Mon, 27 Dec 2021 14:19:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q2sm18608401pfu.66.2021.12.27.14.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 14:19:52 -0800 (PST)
Message-ID: <61ca3c08.1c69fb81.44bf0.4c08@mx.google.com>
Date:   Mon, 27 Dec 2021 14:19:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.296-16-g071f35456b1b
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 101 runs,
 1 regressions (v4.4.296-16-g071f35456b1b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 101 runs, 1 regressions (v4.4.296-16-g071f354=
56b1b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.296-16-g071f35456b1b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.296-16-g071f35456b1b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      071f35456b1b222bfe7edad6ee874520bac6951e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ca02ce42a8ad5154397151

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.296-1=
6-g071f35456b1b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.296-1=
6-g071f35456b1b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ca02ce42a8ad5=
154397154
        failing since 6 days (last pass: v4.4.295-12-gd8298cd08f0d, first f=
ail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2021-12-27T18:15:24.104224  [   19.109405] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-27T18:15:24.154436  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-12-27T18:15:24.163964  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
