Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E40CCC37
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 20:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388005AbfJESiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 14:38:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40136 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388759AbfJESiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 14:38:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id b24so8704279wmj.5
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 11:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=42RPjqalGxbiUJPgCuF5yKDkfGIuCkVYnZF9euBPpXU=;
        b=alCAWR506PkuMVUuHS7TKIZXDhDUA5yV497NCafJVU4GrfK3t18PDrDmGLo5Y2b1JV
         QVcXyTBLvp2fMnLlYMiKmhBPh8mwNdaPULdO/CCLluHt3rbrepINCnn2yAD+VTSQIXkl
         JhtKi29hl5A/cFoMu02bQTVYaLRHFxwU8AzNNx9k4NF+lA3EgMO4y/2lVeQMajhyDU/v
         SI0wneTWIp7RjMtO0T/PrSPIKNGj5ILTxulGBRkvPKf6miv14X3ZMIhxFN6d2wS7nsZP
         fywb4TvNAsGO30PIvyAbCM+tbdE9GGvfRYlJwJaU+R+YPxIaC9ELRLIwDq3NfapWg4Xg
         f4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=42RPjqalGxbiUJPgCuF5yKDkfGIuCkVYnZF9euBPpXU=;
        b=B2M/1pFLyGl4I95Jd65ggZvxAGRBAIa+Rd+WT+ClZPbroGHQrBT7kxG7IntL8jzIRE
         H3kF1jSQkBWbgWgpTAmLcB4A5UGOLqVqkLpG2uSlL55ZpQP1wzagKJPsYcwkskwL4UAq
         fVzHfJH+cneJarM3+HjkGYspWIU4zaT3ICHpoU8lIMZvm1uc9CJs/3B08xDd1MQDzDGE
         aEFtqmYJUwQCklZzqGcHN6Xedfn1a+RIJ9zAXJYyb43jhI0b2EPtJgTOaPs4DjlQsfxS
         5GM7ILjKJUwlPZc8LdxzQRDRbEsZO5ZYcHDZ2c5qkNc9IXkTDdslDHynP0NUceLKvaJi
         cq3A==
X-Gm-Message-State: APjAAAXmbqKSWiloexmZS4mrkIyvNdqOMxzmhf9EWtA6AInQYoQPU7M0
        GoVmp+l2Yek1pGucH/PFjucNMeEovc4=
X-Google-Smtp-Source: APXvYqxDjcJRQZfEGEg8yVnJ0HIFttyhazeZKRzSHyETMFKcyn//gmtC6oc5v2fuYg0R+IoeT6a8Iw==
X-Received: by 2002:a1c:c91a:: with SMTP id f26mr9532564wmb.85.1570300692715;
        Sat, 05 Oct 2019 11:38:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t8sm8832179wrx.76.2019.10.05.11.38.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 11:38:12 -0700 (PDT)
Message-ID: <5d98e314.1c69fb81.c6ec.6c04@mx.google.com>
Date:   Sat, 05 Oct 2019 11:38:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.3
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.3.y
Subject: stable/linux-5.3.y boot: 70 boots: 2 failed, 68 passed (v5.3.3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 70 boots: 2 failed, 68 passed (v5.3.3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.3/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.3/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.3
Git Commit: 5a4dd7cf7b980093d507d55571e342ba702cb336
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 51 unique boards, 18 SoC families, 13 builds out of 208

Boot Regressions Detected:

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v5.3.2-1-g9c30694424ee)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
