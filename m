Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F441EAF16
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgFAS72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729635AbgFAS70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 14:59:26 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69176C061A0E
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 11:59:24 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s10so3925337pgm.0
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 11:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8DnSpfIDjm74iY5FjZzEDjuwknnYpLT/IpVzej8TgU0=;
        b=mC2UnohBY6HHCcdb8OAUV8rxMFfkyTQRRhCI9YGItLiFHKK52NebCbVtQanC/XxeFi
         RWUxWdAGrmj5BGWZWBDPskGpe8jmpYMu5t2Lw8NAml5XtfW3EhXpzTsnEPQOUMgfQxry
         vhkDIeZtaDFYl+Y0WYNj8rhP/yYZDnV5qnRrrumK1qtVxxrWlVqFjkvncEuuvGIDKK6+
         DH5fMlTx6GU4m65EVvTIw34Qz8P2IYNEwIHJC4NoLC4PD0X2MowxoZqR6WGuqEG0lnUk
         X8LZPco1VUdmDT/3i/BrIJ8Hof1fH3X+dJvWzpPJjiqS7Awf+qJ2VnXKqe+wj8ArIuJc
         m5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8DnSpfIDjm74iY5FjZzEDjuwknnYpLT/IpVzej8TgU0=;
        b=AuLrY/ddVMoS+tDrhwQrGWqxIo1L7dR8nQ3MisYR9JPlN2ywFpkVyQxptCA133azg7
         /yujUq+/XyebUp5cbDMVMV5aiR8jaGt794zRq4YbWktWo1Z6UZZFT+0jD4SYZIH6N2XJ
         X3xNHQS/AzCq1/eCQtjiGp9ItoVJPWExJ+Uq6Z91bg2FMMOPKOwBPeJ6LLEbNIZBUfO8
         G+6yeBG8OLYMc7PJaPHfZ6ZSiGSvq50Sf72y+lgt0k2QOqyBwe2bApmNoYyfYTfzFMzR
         TaXaEPETTar8TYfG0E3dxqq6exxzZSWg3tXXgoXNKRppDOkdmpdHGuCTK5EZ+2gWIzme
         eYVg==
X-Gm-Message-State: AOAM5326SrbmrxIyynDWmcxH/FvlhjqG2SKuYi5Bsv7pxxfL+AtHARLH
        SUMmOkGtak9mlj1b6ITE95lIR2ZO9xo=
X-Google-Smtp-Source: ABdhPJyLXeIz+t04VRnMlGJcRj2IySmALooK4OAHUbZhLubhmrzQAQgFd1Ag/70hAJuBW0Y2v/ZnfA==
X-Received: by 2002:a62:1c93:: with SMTP id c141mr22226557pfc.289.1591037963646;
        Mon, 01 Jun 2020 11:59:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j130sm150956pfd.94.2020.06.01.11.59.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 11:59:23 -0700 (PDT)
Message-ID: <5ed5500b.1c69fb81.bc179.08a4@mx.google.com>
Date:   Mon, 01 Jun 2020 11:59:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.225-57-g990ea89b3621
Subject: stable-rc/linux-4.9.y boot: 9 boots: 0 failed,
 9 passed (v4.9.225-57-g990ea89b3621)
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
57-g990ea89b3621/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.9.y boot: 9 boots: 0 failed, 9 passed (v4.9.225-57-g990ea=
89b3621)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.225-57-g990ea89b3621/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.225-57-g990ea89b3621/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.225-57-g990ea89b3621
Git Commit: 990ea89b3621b316bb37afa2f9e65565cb4cbc26
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 6 unique boards, 4 SoC families, 2 builds out of 166

---
For more info write to <info@kernelci.org>
