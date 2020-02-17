Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB013161B4A
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgBQTLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:11:04 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:34267 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbgBQTLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:11:03 -0500
Received: by mail-wr1-f43.google.com with SMTP id n10so19127569wrm.1
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 11:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A1ZP/HkTY6xvlC8iwr8tan+LewNB9FQtHyxVpBIvHZE=;
        b=ILipkNi2QuQp22XTewoG5rq9AoxHNEnkddN88lyJ7w4YBxAuHjuceM4tiiTQiX4Rhl
         xNsitrA6whem6QHjuH4hzUdALXk9+wFEW1qPsaOR88xRbv26XvgxGWrEccmoNSS4izph
         VRApmwfb7jKZYtnHyo/WMqmgh+e3udBRGVlAS4HwL9TWiINpxp7OqAArYBK+FeDSYweU
         PnjD5lQwAnfxFD45Z9kqYIGElFmdfbcuq1Pm8fFjmZ3adYFZAIGuLWs5VReb+IqzbG7o
         MUsNWTtONDptkC/q+RBAbZwyAOXUQ2EQ9/blUZ9j5R71sj4QaftgdY5j9U/f+0Hgx9EG
         0ObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A1ZP/HkTY6xvlC8iwr8tan+LewNB9FQtHyxVpBIvHZE=;
        b=snbkBfpWLJ3xv10/Wl3S8XQe5wIp61nU6UwKna/F6eRwschEKtJfRUu8q7kQAakdLZ
         ZlF5Px7BB2O3ACbE3IHtOv4d7choLq4d8dbYmlvafJ7pZTp0ZbvxdwDgSTq0Cz5YufFK
         /jko3x9YfhM9QLXsOPoXhJHDaOczaULp9xurmJQi4EoQuczEoMhjgENij+1c2i6Tve/u
         ZtuYGHKj86wPFKL+wviZiAvRpZDnEq1sA6ThISqio5ch8vKR+9HJBSkADpZDs9diBf+6
         uCToLWoma7Mt4l13hesgzRs/4daBQ7/kKw/z+CgxT8ClvtMx6odw3xCQzeGoHul7WspG
         8xWg==
X-Gm-Message-State: APjAAAWiARdgoQ7via8oemLv/IcCXkZmEiIQrA1Z2Y265DzAnhu6vcsi
        I4v/37s1TPBc5Cuin4cF7YiOtAdb4tMp6g==
X-Google-Smtp-Source: APXvYqzv538JoY1jwjWiiw+GgnhSSrhf9pUnffh4d5JAp5DYo2lbZobrmA/LGo/ZrVGT18vF0cEjGg==
X-Received: by 2002:adf:e692:: with SMTP id r18mr23791047wrm.413.1581966662332;
        Mon, 17 Feb 2020 11:11:02 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f127sm456179wma.4.2020.02.17.11.11.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 11:11:01 -0800 (PST)
Message-ID: <5e4ae545.1c69fb81.fb9ad.25d6@mx.google.com>
Date:   Mon, 17 Feb 2020 11:11:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.214
Subject: stable-rc/linux-4.9.y build: 12 builds: 0 failed, 12 passed (v4.9.214)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 12 builds: 0 failed, 12 passed (v4.9.214)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.214/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.214
Git Commit: 7ce439266f602f60f05dccf964a8685e53684a9a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 4 unique architectures

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
zebu_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---
For more info write to <info@kernelci.org>
