Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B316153D7A
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 04:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbgBFDRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 22:17:12 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:39959 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbgBFDRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 22:17:12 -0500
Received: by mail-wm1-f49.google.com with SMTP id t14so5216630wmi.5
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 19:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nJdnmQ1RyiCDvsuxA3I+2mvVfwbxWtyLMRUd/ChVSF4=;
        b=XoROUd9ZYD2oeVyMR7KQQbQP10HHxtPy2imt22ZABXdIyvnP44LunRMYf7h2gHLnsE
         5ZEf+PlZ0IooEIuk+Xjf1qZ1nmKZ99vNHiBW7l+GTZ5bnu5XWNu0vHO9rnF0bdhuanCN
         fWFs2tUdJ9DXOz+WpdacyZ5onLAfNtqgdZZOPgCrek/bbRukUl7UiiI7FkHANvql7YcW
         n7RDhWQZ2DvAI0ioA/16N4Ud/iSpmjXbHXf+ym/ILPBUUDZCHAl1sRuFyuHoP0PmV6BB
         MOx8uoP5XTVhq0jfjAXVIYTUd0ErPCOe2y6B4m39Xz8Ud9+OH41QJL67ik9dZo679Pm4
         s6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nJdnmQ1RyiCDvsuxA3I+2mvVfwbxWtyLMRUd/ChVSF4=;
        b=ihxjQ7z2cVr7y7+dVlKnOeU6ywb0TTbXZoN6UDm8bE0DbvgCwbt+LXzkJ8B2hPzzo5
         0IECo+qsI4QT6zvN70CNoNQN/yDRO6tdwzDoSoPCZGJU7cWF+mS+u9ikvjsfUgdpr2A2
         wYAqA7DGWQYMIpqu4bIDk4igRpZ8GSpdccnIPCF1tncdgtfSWOroK8TkLz2VdXZZ+Xu4
         TY9H+svXlEn6Z8Jo3xUh8bL6dxqBSRrfkSGwTJT4y13DwsJSp6eCX5LGPUn/hciOz+3k
         wmuYg5OF0dlSlFTewVi9erCS1P/LbsNlm7kv9wFojeK27TEnqFXxann3sb/kmjes+f/o
         cqyw==
X-Gm-Message-State: APjAAAV/ksoyHbyT1FSrPvEBTNM0DQPS7QAyGqc0OrrT6sdEEScBtA81
        6P/M6vuE5NYyX+I6CCFvTyW7b39WZd9gwg==
X-Google-Smtp-Source: APXvYqxTmKt1W4BYClyQzbGHTkGjFTM9oa8IFpOZdmjGG6n1J4QjAx/rSgRfZWqHvxuYQf7V0bUcEg==
X-Received: by 2002:a1c:e246:: with SMTP id z67mr1356358wmg.52.1580959029117;
        Wed, 05 Feb 2020 19:17:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q124sm12245062wme.2.2020.02.05.19.17.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 19:17:08 -0800 (PST)
Message-ID: <5e3b8534.1c69fb81.fb22b.7060@mx.google.com>
Date:   Wed, 05 Feb 2020 19:17:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.102
X-Kernelci-Report-Type: build
Subject: stable/linux-4.19.y build: 15 builds: 0 failed, 15 passed (v4.19.102)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y build: 15 builds: 0 failed, 15 passed (v4.19.102)

Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.102/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.102
Git Commit: b499cf4b3a901e87e1f933df04abf69b54de4457
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Built: 3 unique architectures

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---
For more info write to <info@kernelci.org>
