Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177A01B314B
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 22:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgDUUgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 16:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgDUUgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 16:36:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166D6C0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 13:36:11 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 7so1574357pjo.0
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 13:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P5rf7612qYo/S0z2eDoxvxm2THmEJbzgIqfLSyUVz+I=;
        b=oMp3PAKncWSs64BZyGGW67z9gQIoNVO2bfQaPcEvK+Y6N5h3AuCYWrIJL0lOqOSsRM
         Hky7NZlQfh51I554C7nTmCiQbQmOGHuCkhi4x//74/yo5EY/DTTPI5iP8XH+/LmgG7ib
         vBZ2MMG/bdwMSiLyIqHSf/BMv8xt0TMvKDiLnLW/h/zsHEXMs7Oym5S1holA2KeKpeIZ
         tq0YAjiUd2b+THBB5E0Bi2yjjtqjyfjED1kvIB+FBGeiZVMKUmtinUzuQfs67pMdn6kb
         iiVtPrPDfqNEpFU9uiibMAxWT4jmtsi7H2ZJm0xuZhj9MTDsOTuP3I+JWdaLklpyYDMI
         K/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P5rf7612qYo/S0z2eDoxvxm2THmEJbzgIqfLSyUVz+I=;
        b=alWXpDOeklw6zSnKRGbshQeatkFfzyVCrKMx72yle8tV7pRWfcT0InSwLMrfUdW9nU
         /NtGJP5QzfR/4EcrApwy8OeTIL5of21McA69UzbZacRCed8SvnJeY208u7Uc+xoA4rUV
         byOtQPoy3kf5xi99DmPARoatXGb9Jj3JYom4xE91wjpuvOHMmj4HGcsK7A2LJl3M4tVF
         lwCjvr1zvZPNlONRcyLtk2jgsxnin7NT6Wr2adTl1Lb2KY0hNuy1Vru/Zs6z68sl7Mwh
         NCd3JnwCQDfi55JEPoUbPIJqyangy0aFq6/OU7E9sUr3ZlJKGR1f/pM7DsES2Ru2M2tf
         JoBg==
X-Gm-Message-State: AGi0Pub4DRlquHCBpaxkUFh1BSmjDD4Ksh/W6pDPUJaU3OAyq1UytnSQ
        Sz/qfBzeg1pPF9giLvUyDxMAuIaPeKU=
X-Google-Smtp-Source: APiQypIFelTLI09+JkL1RBDNK+7Iek18MlDEJC5+i4UglB6rGoODu6m62+pklt0YdqfQVkto8HPHWg==
X-Received: by 2002:a17:90a:1464:: with SMTP id j91mr4969989pja.87.1587501370272;
        Tue, 21 Apr 2020 13:36:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 71sm3190474pfw.111.2020.04.21.13.36.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 13:36:09 -0700 (PDT)
Message-ID: <5e9f5939.1c69fb81.ab4f8.a2f9@mx.google.com>
Date:   Tue, 21 Apr 2020 13:36:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.34
Subject: stable/linux-5.4.y boot: 54 boots: 0 failed,
 51 passed with 3 untried/unknown (v5.4.34)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 54 boots: 0 failed, 51 passed with 3 untried/unkno=
wn (v5.4.34)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.34/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.34/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.34
Git Commit: 6ccc74c083c0d472ac64f3733f5b7bf3f99f261e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 41 unique boards, 13 SoC families, 14 builds out of 195

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.33)

---
For more info write to <info@kernelci.org>
