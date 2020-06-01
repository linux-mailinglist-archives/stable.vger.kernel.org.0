Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6591EAC8F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgFASiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbgFAShm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 14:37:42 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF3BC008635
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 11:28:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w68so3066918pfb.3
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 11:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SsIbPeRwNNFxzrcZEGA7j7NybiB6YmXYMo1rE5PiPN4=;
        b=E3u4vRTwTVja+/3WsDu0gv9M/ZZlIJqW0hywvY1tynompY66azYjbRVAjgE9lKUxz0
         L6/uUePDNBoN2eYtCFb4hDCOK1W5tvvP0G2YMcTOX1DcISymiaAlFQN85RUK+JdBa8uc
         WkFuEXLkeGWTj9wtOI3bOBZcgk/Jesacc0+ix+Dn32vawKsJEA9NxQq/i9TRcV3YChli
         HL0v1XxlGAqiiirlWcknm+VnUr0tOvDhUNuF+yr3PnXs8dRlf03bq20BDEd0QMCM6MXh
         aeSb2Jw2Y47BMfKdAGYcMevp90Kzkmg/oicvWQ6aJsVqwqzjydIiwKGDguUkNeWPtZMn
         kMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SsIbPeRwNNFxzrcZEGA7j7NybiB6YmXYMo1rE5PiPN4=;
        b=lFAg6ZUNAwQIhZXJjn+8ePKvhfbDei/8Yp1xbg1Fj28gU2v9SG44Z0NP3v3q8bBDfE
         v5Y52xGU12Y2yfElIYc4wH/ipAILN0js2zD1s2j2YPRutJUNHPXdDn/ayIul0O3neiXW
         ktjRe2DN3eAJvaKK/0dE9Bqz92JRSXcXNEcheWxumusKOzueiMqIDGPGLHkZXVjKiu1Z
         1Rq70wrwqke0NerJLzYookUJ688H5tJhQ+07jL0wb0z07rKuJopKku/AgC+5rDOGJwj7
         OdfxUbxg3BEMp5IdiMVOW3drqleU4xubVrgeOvnk1nYrDFWaClwASDMC9CuOOVdr43Jp
         SesQ==
X-Gm-Message-State: AOAM530IV+RfLn0TzcJSQDIA2m2oWypN/tbLwcQiE6xF9fwul2yN6yYJ
        2LOIAjgzkMEjU/+W1QT6q8CCHksbN+8=
X-Google-Smtp-Source: ABdhPJyGR1DZFOraiPJdHezl6PjE481+1U6zR33ytMGuSSUUBFSVJIRjxFrMomMY4niHQoNcwG1TQA==
X-Received: by 2002:a62:75cc:: with SMTP id q195mr15844969pfc.256.1591036107844;
        Mon, 01 Jun 2020 11:28:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d12sm109223pfo.153.2020.06.01.11.28.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 11:28:26 -0700 (PDT)
Message-ID: <5ed548ca.1c69fb81.eb542.054c@mx.google.com>
Date:   Mon, 01 Jun 2020 11:28:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.6.15-178-g1c16267b1e40
Subject: stable-rc/linux-5.6.y boot: 129 boots: 1 failed,
 120 passed with 5 offline, 3 untried/unknown (v5.6.15-178-g1c16267b1e40)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kernel/v5.6.15-1=
78-g1c16267b1e40/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.6.y boot: 129 boots: 1 failed, 120 passed with 5 offline,=
 3 untried/unknown (v5.6.15-178-g1c16267b1e40)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.15-178-g1c16267b1e40/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.15-178-g1c16267b1e40/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.15-178-g1c16267b1e40
Git Commit: 1c16267b1e408b27d3dfa4eaf628863e1729daf3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 91 unique boards, 24 SoC families, 20 builds out of 161

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: failing since 7 days (last pass: v5.6.13-193-g6=
7346f550ad8 - first fail: v5.6.14)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
