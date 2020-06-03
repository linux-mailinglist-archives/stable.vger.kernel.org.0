Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFEB1ED4D9
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 19:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgFCRSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 13:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgFCRSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 13:18:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEC2C08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 10:18:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t7so2209342pgt.3
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 10:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jpwzVqjHe3DhOF4588LQgNPFCbynzMFJsN7af4LMEe4=;
        b=Aa7D8RDv0vDjZ6+xnoXuJq+gKU6opdsf2O2/U452z29GwBUakyUYURoL2JO5evaPvs
         ke27wYuub/FoZz6RxBstdqVKgtOwYoeymekBG7OLtmPHNaJwCyjKcgpGiKotwyKKEIsb
         1W+bOmm8THp0QEVZdqdyLys9bM8YILRNreE8hnannom1O/8IVtuP9znx8Ul850In61gk
         rgqp9Y1X5nnBJIYDdYiAe6DeKaQC6E2s/qDeTGlxZYJphPHy/A+sSeFPUcC2oY7g/Tbq
         B4zbPYDtXulKZI5YIIvO93kD7MwAqlGE0/0O8/jBmtp0caLl9g6gft4kbq8FGpps2JJ3
         HuAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jpwzVqjHe3DhOF4588LQgNPFCbynzMFJsN7af4LMEe4=;
        b=Zwg6LWW59+6CE1WohSIfDsTR8T8Rdq/5JpJWSgY7jFJ7AbYrSICbhZbYRxHDzyyka6
         3/Y2KYYehMWS6xiwbSKcVy7Vg3M80g0gTxYd7pQdeaEgktRg78sPBGDrvy+jYyESwYTm
         kovasPJRIjPVwUYOnOFCWh0okxZMl1FaE2PS0KtnQWpIKkfgs9guFwThH753W7R5M8i/
         VkZMzEbClIzs3ivg94Qaw/aZQosydGaLiZxJcwkgkg8JtrF27+/Y3YmCCuE/z0h3OmJY
         c2GHfUjV9UukfeegKNoAamhwH7KKeCaA8fUn0Ot97E7hg9auy/0uec5J0tAP0rFKeBaj
         McBw==
X-Gm-Message-State: AOAM531ZankUkmsHSDJxwzbZJkKVaXjED1Cu6MBdJEkQSS82Jx/S6hFX
        U7LE+8eVikcyH7lFXYBceNFSLOGklbo=
X-Google-Smtp-Source: ABdhPJzZIJnC4iC5rorkEI6tsbpBtjF0nBPVVevKWfslq5pj/nNAC62s8WG8f0trMuw8Z7DaPX0a5Q==
X-Received: by 2002:a62:e913:: with SMTP id j19mr195642pfh.78.1591204708666;
        Wed, 03 Jun 2020 10:18:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c9sm2361150pfp.100.2020.06.03.10.18.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 10:18:26 -0700 (PDT)
Message-ID: <5ed7db62.1c69fb81.f5eed.62fa@mx.google.com>
Date:   Wed, 03 Jun 2020 10:18:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.226
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y boot: 57 boots: 4 failed,
 49 passed with 4 untried/unknown (v4.4.226)
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
https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/v4.4.226/pla=
n/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.4.y boot: 57 boots: 4 failed, 49 passed with 4 untried/unkno=
wn (v4.4.226)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.226/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.226/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.226
Git Commit: 95a3867e897abd7811196123f81a119a75aba863
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 11 SoC families, 13 builds out of 154

Boot Failures Detected:

arm:
    mxs_defconfig:
        gcc-8:
            imx28-duckbill: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
