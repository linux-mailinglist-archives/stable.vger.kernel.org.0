Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2831C1E6F4C
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 00:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437242AbgE1Wly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 18:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437136AbgE1Wlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 18:41:53 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E87C08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 15:41:53 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cx22so242119pjb.1
        for <stable@vger.kernel.org>; Thu, 28 May 2020 15:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1hjhKX5nVbTjpttLypBsVpHTZqIznWutNeM9Tut1HX8=;
        b=t+xf98lN/ASxiRrWviIbbYPetNhfn4bD0+vVJfixj/2GhZlb+xEbtKliD9lO4Bh2oL
         aD4a9IarQjUoBSaFrgdI0gal93+CNI+1OnGYReOQptSIR5k3azD+Ut/Q/Q3/3P+nn9Wa
         Fwhw8W5OJ5z26f7FzE/44UebznpQDiyekzlufob7uLkCL1SeCB5Sj59lmJxlOOGlX0/b
         LXlICWW0+hGDRkoqUo0j57bzbL6tX9FUv4/c/YuhFx1PTxpdt4w0n0xojjuy2prc2nj0
         MoUBadRSHrxkbulVitU4CENzWsNre+lY+wZx6N74uCMPxLrBF2FKwaycZLMxATf+YW3D
         QeSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1hjhKX5nVbTjpttLypBsVpHTZqIznWutNeM9Tut1HX8=;
        b=JtJ3MtQGjiUuEj6P1t0tzKj3Ava7XatDVJjD3syYfSKM1Ame3SBmrd1v/28yvbs7XY
         XchCjxg3eYocNPLI4Uvu+aEuaS8TmdjWnXObgDR9WrV/m6RHA1NNPewroQiMaUlUrnD0
         EBelxn1+3oa6HWtkNqF1zL65Fzz8fsUlT/N8LMbLm5EzKJpE6N3yrsanCyQd3qSxBcGP
         6Dno+9/W4OC80aqtwaQO/2PqadFhXoDCq9wM7iN8ubxoBhICjW/uctJ/YJHtXnO0pni7
         7ZxDekzPQcy+W6U+gaVt1YUOQoN9BIX0kygXgg0YaimRw7RSmI4bQaM6U6T7Fl+hhn1g
         cGSg==
X-Gm-Message-State: AOAM530xVgDxCcC3VP+k9+xAuWxWs//mlNtd4uKL9+cJiBefQ2g0F8LK
        zNqJzlCmd37vA4WE+UIEDd3khGrp1UQ=
X-Google-Smtp-Source: ABdhPJwzL5daxxui3ZcZ14XcdL9DKusY2NFJAokaLWsMJYlERfZllgL35qoEKubUbdaX7MZKpoaQmA==
X-Received: by 2002:a17:90a:5889:: with SMTP id j9mr6242612pji.40.1590705712618;
        Thu, 28 May 2020 15:41:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm5717114pfq.136.2020.05.28.15.41.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 15:41:51 -0700 (PDT)
Message-ID: <5ed03e2f.1c69fb81.682aa.15e4@mx.google.com>
Date:   Thu, 28 May 2020 15:41:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.225
Subject: stable/linux-4.4.y boot: 44 boots: 0 failed,
 40 passed with 4 untried/unknown (v4.4.225)
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
https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/v4.4.225/pla=
n/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.4.y boot: 44 boots: 0 failed, 40 passed with 4 untried/unkno=
wn (v4.4.225)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.225/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.225/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.225
Git Commit: 646cdb183bb780e11e0ad4534d9054f77c31c8dc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 25 unique boards, 10 SoC families, 8 builds out of 154

---
For more info write to <info@kernelci.org>
