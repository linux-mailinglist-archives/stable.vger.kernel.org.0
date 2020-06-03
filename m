Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74CC1ED495
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 18:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgFCQ42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 12:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgFCQ41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 12:56:27 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFADC08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 09:56:26 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m1so2182004pgk.1
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 09:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3O6oxgJMf53ISEdxG71eKI/4pjPZb/xWm1uhXDZUBEM=;
        b=IkztL83Z/EBXFLzzjpDby4sahiTvYK7ALV+lzw63+/M+HoXLnLRrG8xk184SXoE1rn
         x12H5rBSsBJReQYiMdvD0oI9GN5gYSy1dfZIMmoacGyJ6NehgplZJURkiAaIfRK6NnC1
         7mcFrx1YEp6B559breafqPDqcbf0LmD7sHgU+BYiw1GbKXRuqRn9Lj9PWGTZhCgT/hmA
         5cnmVhju79v7/3wuTyRJX3c5k/DNycCf1x4N58KnBtFdHt9OLWc0+RMpHjsaQquzm/oL
         i+kTcN6amOuoDt8rr89XDbLkXNfxnAMgiDpviRIfoio5DRbz8Nh4SChZ+KQdAh1chqs8
         PMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3O6oxgJMf53ISEdxG71eKI/4pjPZb/xWm1uhXDZUBEM=;
        b=ogtTDuhL/maBuImtVDEmSCwdveQAWweq+IxVnywWPhW7dZsWqE8aBirFrjliZ4Y5+r
         LNnw3bOWxwWHSfhfV/T6MoUvs1b2RGYIwa74nYARdav4UYbKANi1mlm3gMOSXNK3slka
         W3+j31LbvazGXXI9Ldva9PZndYK1pgONHL84k7OS3r00mAz08f8JttOK3kl866GUwSj1
         63UuGrhosXtrpDrr7H1QAafcYOYAxNriafEO1U1kKEzvqtvW+8VPyaZvYboS9cSErl9Z
         j8rDQCYm76CAZUy14GeD4OgnNEdoSl6K5qhEbZIxvY71JhbCq9gkMAGd36MEpcv5PhBz
         05ZQ==
X-Gm-Message-State: AOAM533GDqWS+WF54cTtAC0vbWmJTx9Fh1IHL6ghbT6HCDJUoNu5NX45
        qK+Ev2L0ROKwjyYi0WYCkUew/nZbLSY=
X-Google-Smtp-Source: ABdhPJwlRgqkKjO4M857TRN/mTu4n8D1yzKCKUI26BCar+OWe1UFKDAIL1Gr5hO0s5bYd5DFPT2O+Q==
X-Received: by 2002:a63:5d6:: with SMTP id 205mr290828pgf.237.1591203385174;
        Wed, 03 Jun 2020 09:56:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v8sm2240363pfn.217.2020.06.03.09.56.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 09:56:24 -0700 (PDT)
Message-ID: <5ed7d638.1c69fb81.48aff.60cb@mx.google.com>
Date:   Wed, 03 Jun 2020 09:56:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.226
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y boot: 47 boots: 1 failed,
 44 passed with 2 untried/unknown (v4.9.226)
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
https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/v4.9.226/pla=
n/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.9.y boot: 47 boots: 1 failed, 44 passed with 2 untried/unkno=
wn (v4.9.226)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.226/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.226/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.226
Git Commit: af5595c4ae50545abbcc14515e5b15f823fb9b01
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 10 SoC families, 12 builds out of 152

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
