Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDBA1E7223
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 03:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390597AbgE2Blo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 21:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728692AbgE2Bln (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 21:41:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8526C08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 18:41:42 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f3so379619pfd.11
        for <stable@vger.kernel.org>; Thu, 28 May 2020 18:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bp2LLunXpX0FiSfPeSrCqxKSJUP49tYgJ/0onhWf0Uk=;
        b=FVPajAb/4vHAzBjKiHnypCX6L6TxVgQriXDEX7zNDzGTbruJe8IA3Emei/XjJH4PWI
         rbtJOv2rYCvaeUMXR9sSfWxZ+FwWcAl0wIVt6QhuHJxmGgr6uxn8nYnam+aUn5WSMEZs
         36rD/43KL+4Uw6fKG1tEj868OhmKgvmqQEfKtexHHXyviNb+rRHRevulTXOThWjPw3bd
         D5tRg34IgvI80rNcIdCppbjX06UGQFv//wAxUASbviTjafG9glddUfqrOYs9OF2VOXrP
         jWdJDqihDxMEVu8WDwBoX5S4PraRdAcxRQqStsrZ5/zvhGEh8Coa/GEM+ju90QiLdybY
         aEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bp2LLunXpX0FiSfPeSrCqxKSJUP49tYgJ/0onhWf0Uk=;
        b=gzd4jvL+k4akDQ+cR3XRScFiM0B9Zd1pk9cveYOXC02abkRKJh0y+H5LGpiuA8geN8
         Lhbqxaz4XIsVaCCa4bcVlTG1dxQoHBPpympBsa7plrBZwKve+3jnL7am1vD/hogSj9od
         E0cAA3146CwUBJ7cuNJYDVzEKrgDsawRASKnFE5Jp7Do88m+h2phhvfYh+onrC827uAh
         hq99HIs2inKmq5VhOKoKsrm7f0ghWOIiu0MNgYkNet8tgxYui2KfiqVZGbF2hJkXO6jx
         a6gojyROh/l37d2qiz4GZgJOfLroLynWu7lY8ELbCNi1fqbJF9oLDZL6T4/ImC4Le6Pe
         44Kw==
X-Gm-Message-State: AOAM5339XhVv95jB3I2PF8f8XmpWi0J+XfN63Pb9viF7V7ENMpnsC2hk
        lHoQ+3P1DtqQi36q8zwnuHp1Lo2uwis=
X-Google-Smtp-Source: ABdhPJzYNaQ5P/6tz3xIfrNtoO02sAyzcYH1VT0SHjuxJHGhUVLtmLipAW/bilCXEf479pB0bkW5rw==
X-Received: by 2002:a62:1844:: with SMTP id 65mr6344656pfy.112.1590716501554;
        Thu, 28 May 2020 18:41:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v197sm6078967pfc.4.2020.05.28.18.41.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 18:41:40 -0700 (PDT)
Message-ID: <5ed06854.1c69fb81.8b6cb.4bc9@mx.google.com>
Date:   Thu, 28 May 2020 18:41:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.4.43
Subject: stable/linux-5.4.y boot: 73 boots: 1 failed,
 71 passed with 1 untried/unknown (v5.4.43)
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
https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/v5.4.43/plan=
/baseline/

---------------------------------------------------------------------------=
----

stable/linux-5.4.y boot: 73 boots: 1 failed, 71 passed with 1 untried/unkno=
wn (v5.4.43)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.43/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.43/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.43
Git Commit: e0d81ce760044efd3f26004aa32821c34968512a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 60 unique boards, 16 SoC families, 14 builds out of 160

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
