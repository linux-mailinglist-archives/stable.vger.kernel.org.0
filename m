Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957121EB4A7
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 06:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgFBElQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 00:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBElQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 00:41:16 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE87C061A0E
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 21:41:14 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ga6so791142pjb.1
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 21:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P7L06egcKUjx/Dr6gIZtYnRvf+NvrKsKZn4ntVhbOxM=;
        b=dkOy/HArFmJoSTV7oOSdz6XFJmBhZSYr4NKEucs9Y/533PO65IhDsBqbnAn8xo25bh
         lO3H0m1x6ew0lmh89jDZgASGxBk78s/XRrIjTgFoOK752RcX3yN36B/TxzCqWJ4/6LmR
         2QrFeXzn2TXkKNYOef51en354KlHDStrJEYcGf7fexV3/ocRy7yhNz8P77skaUVpHiPC
         tb+2vabDHopP+tvbM9OFETKOaGEL9Vflg6RpaIodRjQIzJywQH3bwoSAVP+k+zqWM5is
         jzji7XB+jm+rAmkqZAeOgD6I7JFNWFP3TKWL78z3vn4MqWPuWiZXZNTyCBi2nXIcBmkV
         1cMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P7L06egcKUjx/Dr6gIZtYnRvf+NvrKsKZn4ntVhbOxM=;
        b=AKXZUu1iNkFXLs14EWVKG4L+HdaUkNV+bOhPhSh69H7oYf2OU/Hjmb+0vUZeEAptEG
         USZ0S1F8V4D5g7raqGsW2iWd+2bphHR3FQLKzUCB6ZtybDYXSRbUfPArsAclkG8WYnnC
         esIhaPidXFQ8EC4w0RptdcCOW5wcnlk/p0nIo6lwaHGlajjVoXeNDHBDYWif/s6pzU8h
         siANn2XIMynRS3mDkvx/1jQcTe4VvZgw54staId1dO1wCVLodSDuYXo33xv4Gv3jX/c7
         HTDZAkQapyM+qovrMeRE/Y2rbtQoJMucwkzuoLNettJaMuWsmOSj73IcXZwsBTnIYrPN
         Ec/Q==
X-Gm-Message-State: AOAM530QYjU+t+IW3lJyFv/tS6R3PssaRRPX89dSl+4kRn0rqTr/D8X5
        uAUAXa04jUNvSTRawPY8cKPW5X4JxSM=
X-Google-Smtp-Source: ABdhPJyg4VqYrNgnH49kVUuKXbyNV/6h5kzhXe7KVAyHBaX8+0stRP56QMFfLcedGV9TYpbfQq3qQg==
X-Received: by 2002:a17:902:26f:: with SMTP id 102mr21339507plc.209.1591072873792;
        Mon, 01 Jun 2020 21:41:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q18sm879319pgt.74.2020.06.01.21.41.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 21:41:12 -0700 (PDT)
Message-ID: <5ed5d868.1c69fb81.53f33.3f93@mx.google.com>
Date:   Mon, 01 Jun 2020 21:41:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.225-62-gf7c3cc559c2e
Subject: stable-rc/linux-4.9.y boot: 5 boots: 0 failed,
 5 passed (v4.9.225-62-gf7c3cc559c2e)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kernel/v4.9.225-=
62-gf7c3cc559c2e/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.9.y boot: 5 boots: 0 failed, 5 passed (v4.9.225-62-gf7c3c=
c559c2e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.225-62-gf7c3cc559c2e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.225-62-gf7c3cc559c2e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.225-62-gf7c3cc559c2e
Git Commit: f7c3cc559c2e60aedae9799208fc8dd85211b971
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 5 unique boards, 3 SoC families, 2 builds out of 163

---
For more info write to <info@kernelci.org>
