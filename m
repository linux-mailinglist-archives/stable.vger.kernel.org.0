Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DC912F1D5
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgABXhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 18:37:07 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:39623 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgABXhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 18:37:07 -0500
Received: by mail-wr1-f48.google.com with SMTP id y11so40879284wrt.6
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 15:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A06FzB86xOotzH7N7f2KBHwmsRM1sdClC3xO/pz8hX0=;
        b=Wo6MYvmZpzZcrpWPyMa2xJA3vNST34PDkQVU1i2yr+yOqyib1WVlb1hWGm5BKXwzJR
         61ZgNQr6AHsYHUUTItf0GX/FIeRGCGeArAzff9VB1Qv1fekTPMRwSihvs+GFwCQAAnNC
         mjX1g4Ej+AGZKDTubx5d6kJWEFY4+cVsQ7gU4P6yhSHD7bzdqZrRzV+THbI5YgI5heSe
         ObaFoqhjTiFVRknkf5V5jtmXbmzsKoorwaSluxooQWf75npyY4VlzFDPOFav6zqbPIbf
         iKvzrt7pq1jeFRgihU8oPqn6zQvEPzfLY+uBMwDzZA0/gxwAh6oyVgOV2OnPz6YDb+am
         PD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A06FzB86xOotzH7N7f2KBHwmsRM1sdClC3xO/pz8hX0=;
        b=Op6gCd1cW3bcSjVm/9sPb0mCY8D0QqByP13oQ6B91kOn0WaDxXihXwRmryY2Rw3LLy
         te2nOXSe3GLcByF8SJ1pQCHd7rssGlX/pc0BE4QZu5VJPV62DzyJwffzSHB/t/RP7ZnN
         TKNwYuqrnztk8bA5buB63MpumUb5Tm3lHI8x4ra0qacCdxh1bHilwBfusZAEMb0oAshL
         Kd7T4boNJJo25abw6RBufwOrpI+a+DycFDx6vxHlBAlhogaqK1MMZD0/EwcrMHiCOwkV
         RZ79u3uT2tvdWmxAl60CG8navZOEIQumXdE6gAXxS1tAYVhq36hjNv5Bu4pKifZCSMC5
         GH7w==
X-Gm-Message-State: APjAAAXkZG69UsIe+zwNPZP71803TLI7n/BZZwZGqmbzyImXDZFckncL
        JzkmQ8zhCTOftQCizg+RhboY0Cx4c2Kl+w==
X-Google-Smtp-Source: APXvYqzYqSR0b/KuwdWm0tzKL6fIDJUbg0Qg0MGQI1J1ptiW1taNwY4uhW7ahmVt+bSjCHQG6kpvJA==
X-Received: by 2002:adf:ee45:: with SMTP id w5mr81568008wro.352.1578008225495;
        Thu, 02 Jan 2020 15:37:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d10sm59318301wrw.64.2020.01.02.15.37.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 15:37:05 -0800 (PST)
Message-ID: <5e0e7ea1.1c69fb81.b551f.10d6@mx.google.com>
Date:   Thu, 02 Jan 2020 15:37:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-138-gf4a245176f1b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 32 boots: 0 failed,
 32 passed (v4.4.207-138-gf4a245176f1b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 32 boots: 0 failed, 32 passed (v4.4.207-138-gf4=
a245176f1b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-138-gf4a245176f1b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-138-gf4a245176f1b/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-138-gf4a245176f1b
Git Commit: f4a245176f1b1cb298be54c50e2c562926ef7adc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 18 unique boards, 9 SoC families, 9 builds out of 190

---
For more info write to <info@kernelci.org>
