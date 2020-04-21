Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBB01B2E9A
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgDURwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgDURwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:52:08 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B36EC0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 10:52:08 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t11so7122411pgg.2
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 10:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B7XPjGbnDGXz1b6u+XdVM3+SOspJbi4dZMuoJhjDmaE=;
        b=RR72e43E589D6aNZRdKfmIXi7gdgRIVNS26G+SvA3Zkw+5j+EYMPUhbm/Ld4Uml5sA
         ZDWEn0tcQvNyrfAqlC37ciRQGMunx7Kdl9j0otqNsQcdaZVeOwZ/zG+gNYGgiYNK/Tyu
         HCAoaZH6ap8uZ32jcp0gDDZimxYPRPQ30iH19uVnoUd79Fi0FnV/gJeYxuDqxytS50go
         AEYIca5B5xVYMkKMPg3kxj+c5Wzz6YnGUZMvDVuEJCffvrtjPpKho6+NplelqM516Zcm
         A+w47Ip9bPl9wrPie+yxlm9uIjhlhACb1jGe7LFL5o12RJKJkC5drtmUlvyArHOMv8T/
         8yCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B7XPjGbnDGXz1b6u+XdVM3+SOspJbi4dZMuoJhjDmaE=;
        b=V/VcJsJm+5iWBr+cYiiLpwCvfP+yF5ujzcbsCcBLbNcTxeUtJ21+Z0doL2XYVR4Ipf
         LRHLAEpyJe3M3DHg+YAzmcrTWARSFbKgb6g06LSDhIr3u5syI2s2DljhCiTk0yZ1ha7F
         W6nvZKAhll+Rlsv9b6pV2Iq36Or3JMKudVpD2+YFt52raMxKFeYZDP7ivTMVbfUzlvtn
         UGP9IYSHI15HFla/iMBMw/K7R2R7WjMtvqm81t9kJNvb5UyunGylZelf1pCd3g6QjAk2
         tiTPDHSe5yIneJSIJN+ksvxZbCpawPvcMu/D1pVC/Dz3aGYyP9kI5VvCe+e1t3oe5NR3
         CWCQ==
X-Gm-Message-State: AGi0PubiBymklvtpow6XIsw3U/l0I/24F6t+xUkhxUfhgakpQRox/Ven
        PMWsKel7OhhS61hq/x5B7vyP+CzJmzs=
X-Google-Smtp-Source: APiQypIXvpAxL8XIh5sG5CUDcr7BvEsQ3GjrtzYvheuOOlLy90MyqIgOqHnIuCkGit9FC9n58NNW0g==
X-Received: by 2002:aa7:952f:: with SMTP id c15mr3351448pfp.54.1587491527465;
        Tue, 21 Apr 2020 10:52:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r9sm3000412pfg.2.2020.04.21.10.52.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 10:52:06 -0700 (PDT)
Message-ID: <5e9f32c6.1c69fb81.b9808.9780@mx.google.com>
Date:   Tue, 21 Apr 2020 10:52:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.6.6
Subject: stable/linux-5.6.y boot: 56 boots: 4 failed,
 49 passed with 3 untried/unknown (v5.6.6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.6.y boot: 56 boots: 4 failed, 49 passed with 3 untried/unkno=
wn (v5.6.6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
6.y/kernel/v5.6.6/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.6.y/ke=
rnel/v5.6.6/

Tree: stable
Branch: linux-5.6.y
Git Describe: v5.6.6
Git Commit: 7c57270321607353f2bc2f1a866b96fcb3454386
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 42 unique boards, 12 SoC families, 15 builds out of 200

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.5)

arm64:

    defconfig:
        gcc-8:
          apq8096-db820c:
              lab-bjorn: new failure (last pass: v5.6.5)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v5.6.5)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
