Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFF5199440
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 12:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbgCaKxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 06:53:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43529 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730933AbgCaKxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 06:53:37 -0400
Received: by mail-pf1-f193.google.com with SMTP id f206so10151310pfa.10
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 03:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i1cvsXpFpy+8LDKHm0SCwIMXPqxsloai2SswWcsFwv8=;
        b=nbbg+ky0GkGFOg70PDKmxRwBGLCxeHb43zaZ6HhhH33vGSfoVy0sSueO3XFf7eY/nk
         P9kUiJP/QDvOXiTUh97+SUsPhZKWnjvUIOWc0aWoxYC9dJj5vlcfbx+V4KTO4HHwBjCj
         yh/qg5yB32EbVscR40utIUI49xQ6QcYzOeLEJ4HdJH5eJYwVV/fwnnda3ggi7JCILfIp
         YAr6mrMMgTNxIUp+1LH2m/2XWNvKmNJPwrfrvqfcf9oOE3uLrVtYeeUMiSCSiPd7FrED
         6FcAhs1l+j/a/JjvV0Sg9C+Q5a37qoLYL3J+WiBTC8xOfk3Z1ydhSrpH4rGbe+U1Hi7e
         B7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i1cvsXpFpy+8LDKHm0SCwIMXPqxsloai2SswWcsFwv8=;
        b=WFJ/QuopEqimqJBw79Wv9tPbScv0cCEz8Dr9OazEd2MrZMVLjjABe5HDzELnGr9AE2
         msq5i+5CTrlFkqq1ZCF0rOvA7xT3N/0Rjujj46igBifj1G9i8kb+Y7pfSE1Lm9a8qk4E
         qiWnpueVXhYZuXH/bXqWcXI95UX8kSqqODcaqjywZ/wCrTEDiawdCyHjdjz5x9ULphOx
         7Wru9z9VF1tY3zULLwLnRh/OtDDUTY2+rOQNgCKhqQKmNIiaCkjH10Xve/dBjjIIH+u2
         9Yc2Dw381WtjZXJFGSlhtdBSDB0QyqOOzlfsrL339740yH59PxBTi7f7IHoNfVEq+6TG
         zL0Q==
X-Gm-Message-State: ANhLgQ01lv4W4HUaOTPscFIylNHfsADyXsc2/J/IZQGhqGPjgHRZ51rH
        FUuB/UAClKWmYcIRbDIyHd8lkUoU9DM=
X-Google-Smtp-Source: ADFU+vtA3DOb/FQBTUmgW1RTc0wxyjJVgxEutx+v6iT/6+eNaKfpcvWn8Icg5SwC89/xAJICz0WQ9g==
X-Received: by 2002:a63:8f07:: with SMTP id n7mr17418000pgd.362.1585652015828;
        Tue, 31 Mar 2020 03:53:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m3sm11797794pgt.27.2020.03.31.03.53.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 03:53:35 -0700 (PDT)
Message-ID: <5e83212f.1c69fb81.418ea.3cbb@mx.google.com>
Date:   Tue, 31 Mar 2020 03:53:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.217-82-gb193eaf1881d
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y build: 190 builds: 1 failed, 189 passed,
 2 errors, 13 warnings (v4.4.217-82-gb193eaf1881d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 190 builds: 1 failed, 189 passed, 2 errors, 13=
 warnings (v4.4.217-82-gb193eaf1881d)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.217-82-gb193eaf1881d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.217-82-gb193eaf1881d
Git Commit: b193eaf1881d9417b2663976c1bd7eb6e856251a
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
