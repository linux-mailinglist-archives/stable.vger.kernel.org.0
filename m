Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D931E64CB
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 16:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391230AbgE1Oyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 10:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391384AbgE1Oyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 10:54:31 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EDAC08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 07:54:31 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id nu7so3290644pjb.0
        for <stable@vger.kernel.org>; Thu, 28 May 2020 07:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cpgj4GM/JojnHJxRdlDDuaUAzMlsG2X/erTwW9OzT7A=;
        b=LllbDg7PLKaU1VVWbp1y5zfv/lQzTq7x8tH2MEpzRwwKD+EKAh86pcNM0RLGxi+9Zy
         6Y7LSK5Incl/yQvVIYs7Vc33KL5V3EPFI2qf7yG8VMU4t113mkcaWFF6Yu4nlBOpUAH8
         aU+fgkOBd0G/2ZpYW+h8svFKK/ixS0xpohxWoz0JA8fYW3BKG3bAaKNkytRjL0oKqVP8
         ik0fXayNAMggJOHCSpu/5sDzgWiP401H2cOFpRM70I8toM5TCLnfRKx5bSVP6rtszGaR
         oT40ZeAQylqyuPVB9erbPQcKkSIUjD6koFyMo0XOZwvOk0CDS2R/8rTYOHxJyo1AYhe3
         /DdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cpgj4GM/JojnHJxRdlDDuaUAzMlsG2X/erTwW9OzT7A=;
        b=hHlaR5ZFCxEzvz9k0npLVVky+SbtwLvCUmlSbWt89qAKU2pVcjFP9RxM9jLIoS0RBA
         CxaidxlrpyljAACkwjlq0vI++dnV/AFaLP6KMx8m3t/ieukE9LVlmiDJAk3H96OeiDjg
         hUXxUTMYmK5jcWgIBDXxcZ2JsuVQPX7fZOwTl8ZLeBIRwFq3lr5vLWZ65oZWcFk1RjU5
         pdB+FaQPIgsC2CvULlpoOvpJDjocbUqQ/94gQYok/jFkiM6oKHdBHd1W14QuEhMq8+JY
         NyJdsMM7z06I9Kx7FIZfGjyrNjnAeMI4cyyL+ShxNc4LA69Q3JEBwcSZu5AU+4uGBokh
         onRg==
X-Gm-Message-State: AOAM532VPUc4pou+BnfTP+N/zzpInGbAmYC0cl1SCySoWg/Pj7cY1QDB
        086mB6vsMfjF4NuzmrFhJY5HE+mZhnU=
X-Google-Smtp-Source: ABdhPJwfuFvasuMscw9RWFXB8mvY+lW5PAJCc4Za+IKZ3nvPjBfXvJZ551bek4pt5gWlxRWlTapisQ==
X-Received: by 2002:a17:90a:c098:: with SMTP id o24mr2349862pjs.117.1590677670014;
        Thu, 28 May 2020 07:54:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m5sm4584423pga.3.2020.05.28.07.54.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 07:54:29 -0700 (PDT)
Message-ID: <5ecfd0a5.1c69fb81.ec46e.75e6@mx.google.com>
Date:   Thu, 28 May 2020 07:54:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.225
Subject: stable/linux-4.9.y boot: 60 boots: 1 failed,
 55 passed with 4 untried/unknown (v4.9.225)
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
https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/v4.9.225/pla=
n/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.9.y boot: 60 boots: 1 failed, 55 passed with 4 untried/unkno=
wn (v4.9.225)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.225/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.225/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.225
Git Commit: 82dddebfe7da9d2670977ab723da2fdac3eff5b0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 32 unique boards, 12 SoC families, 10 builds out of 156

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
