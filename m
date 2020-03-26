Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5A319373F
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 05:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgCZEMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 00:12:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42155 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgCZEMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 00:12:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id h8so2230091pgs.9
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 21:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5cuULBhruLNAJdEgZRCJvzEphCgAFIC+1h3tAvXk6k0=;
        b=DZ5/o70AnhTWBPAG9u5/7NimrI423SzzlZqYmaOXlWo9JqPfr+0mRP7dp8tt36kz9D
         /7OClVie9Bhmpun5RDd44g9/rz6EOhH9sWvyRmFoCBNQTxCOSPmMDxeLqbu4ua5Qy3G3
         DOocj74sOgK+OM5PXYI7zxTw7iIxcuDPd5/dcvZfv1hE95fN9B+fe+vsTTaLh5xpFXm3
         jJKHnakbHGdUGFl01JWWlVG+4VmuVmcAz7su8/ExWSQT9ltvBktZKWwlRBn5Z5oSd/l0
         DopEBsa/VLmLpsQzmC9XEQYmp65+5j3I8wXhFBJZmkVUKlU80d/xmioIjK9vcn3C4oS9
         if6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5cuULBhruLNAJdEgZRCJvzEphCgAFIC+1h3tAvXk6k0=;
        b=JdtN2+EsmS2oDmt7x/cRf4XIqOGSP1kO3hEo8B5vhZw1+pcoWgPGHIQRRKe2dpGYnC
         L+3xNH3qEQBLxMUoAafZUpMOoj7eEQgZqBBwuPxMT/H6tgAweX8uXV7OZu9+0kXZXiZX
         UEkBmpx2PaLcxsOjUqvN+uk9o5IXfRUcu8jcn4bHxnfY9K6v6Ln4yAoXi/J3tbxUVYzP
         YgeOnu5FI81wzVI1jZT+1U9dQuVjI9xmt6MQeWUfHnDhPAiah7i3GSssJVFGqMWDsSvI
         We/8H5x9bJLP2vZPMH9p/TeWUAUlyBaiZuTLse7Bqa8NoaePlRIgQV0rOwORjcdYE3Cm
         vhdA==
X-Gm-Message-State: ANhLgQ3dK98lAt7AQUjCU4BOqHLdVlodzpr0Srw8XABy/yfQMuGHdHHB
        ykrGbtieUCZKERznDdFnkkBt2jFkBaI=
X-Google-Smtp-Source: ADFU+vvgK6crIMvFWMv44FjAY8roW2CA237diOVgpWrtPcTQGRpugekkDxbfkPQqqf4fNxguExVb6g==
X-Received: by 2002:a62:1dd3:: with SMTP id d202mr6992460pfd.47.1585195940817;
        Wed, 25 Mar 2020 21:12:20 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b11sm597616pjc.27.2020.03.25.21.12.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 21:12:19 -0700 (PDT)
Message-ID: <5e7c2ba3.1c69fb81.8a4e0.3136@mx.google.com>
Date:   Wed, 25 Mar 2020 21:12:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.217
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y build: 190 builds: 1 failed, 189 passed,
 2 errors, 13 warnings (v4.4.217)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 190 builds: 1 failed, 189 passed, 2 errors, 13=
 warnings (v4.4.217)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.217/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.217
Git Commit: 3b41c631678a15390920ffc1e72470e83db73ac8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failure Detected:

mips:
    sead3micro_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 3 warnings
    tinyconfig (gcc-8): 4 warnings

arm64:

arm:
    clps711x_defconfig (gcc-8): 1 warning
    davinci_all_defconfig (gcc-8): 1 warning
    lpc32xx_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 1 warning

i386:

mips:
    ip22_defconfig (gcc-8): 1 warning
    ip28_defconfig (gcc-8): 1 warning
    sead3micro_defconfig (gcc-8): 2 errors

x86_64:

Errors summary:

    1    arch/mips/kernel/genex.S:271: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another=
 ISA mode

Warnings summary:

    7    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct d=
ependencies (FUTEX)
    2    drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: passing argum=
ent 5 of =E2=80=98dma_free_attrs=E2=80=99 makes pointer from integer withou=
t a cast [-Wint-conversion]
    1    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate =E2=80=98c=
onst=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate =E2=80=
=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate =E2=80=
=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate=
 =E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]

---
For more info write to <info@kernelci.org>
