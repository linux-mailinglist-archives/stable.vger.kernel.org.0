Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E123A675
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 16:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfFIOru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 10:47:50 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:45142 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfFIOru (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 10:47:50 -0400
Received: by mail-wr1-f50.google.com with SMTP id f9so6594893wre.12
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 07:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LE8be2WW3tBmaR7rIY6+8rvZuZeNTbZ8pKJZjnhwx30=;
        b=HJz2Re+AuoiWukEcldwUweIJFpJAhWPErdmKgNaRDiRMrg1EAhr+iPBrpfpIwPVTtJ
         TBStZxdkvXKt/cYoaxymoJ18IOsF8stEn/S37stTIP1/EzrVvD38GBLErDiZ8emX0dri
         SN0mou8bmNJMPxRu2HDyKpDR5bkegLysZdr3/h+D2Xu6krYcoiGba/z0G/I/eckJ6yIZ
         z9ERyeHDwLthSW28cmytBU0ziopD25PsGDJOhPKtmpKPLtCRJ7iTvxHeL/HCnMI8/gK3
         w5ACvwFeUwCv0i1GSg5myG535NQu8wLhPIWTRqMwB3qpvaWSjwR78BT4KuMOgQ26Qgqm
         DS/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LE8be2WW3tBmaR7rIY6+8rvZuZeNTbZ8pKJZjnhwx30=;
        b=IGy18GPaMHBfy8nKGpiLZn31AT2vGTHNK0CoCwpwsWs5bEgZmnlKQ7cO5fmRigiAHQ
         Zv4HzfZ1VkRhkUkSzXuQRrSzOUDoP78kbSRjTDuXBetlcfUppFZfcf6/xH4Y61kOognQ
         1D/7OzLAk3CoLiUtyxZJ5RPCbyI82AaqWdwkiov9qpnV15hK3k91cT0ZZvpReoi018QH
         x7Bt/FQmY8MGjdZHr2EhhJOrIz7mUA8mHB6VOwxjOVlhQtiZ8PDtF+uB4b7h8Lhag9Ga
         /8f92M3Kwile8HEYl4vSsITLWRQObKLFjrVZMrL9vA2hnC9dCtgKTiyU0ZMNRCc8eJBZ
         r36g==
X-Gm-Message-State: APjAAAUFspDhveBxWhkRCK91n2pEzseuGw/mQXmayrBeU5IE8Kmqe3/6
        2yrODjQKC0Mui5m5ImUFEeJHMjI3wpg=
X-Google-Smtp-Source: APXvYqzFdfAfZuqq+AhFo2h9xChV+9wC5O2GESDt35jsRvJP4oTGz6GR46GL7ksLABahWcBjkq8XHg==
X-Received: by 2002:adf:da48:: with SMTP id r8mr22148677wrl.18.1560091668386;
        Sun, 09 Jun 2019 07:47:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w14sm7906406wrt.59.2019.06.09.07.47.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 07:47:47 -0700 (PDT)
Message-ID: <5cfd1c13.1c69fb81.c6976.e4ad@mx.google.com>
Date:   Sun, 09 Jun 2019 07:47:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.49
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 65 boots: 0 failed, 65 passed (v4.19.49)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 65 boots: 0 failed, 65 passed (v4.19.49)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.49/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.49/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.49
Git Commit: bb7b450e61a1dbe2bfbe998a1afeda654c6a67e9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 15 SoC families, 11 builds out of 206

---
For more info write to <info@kernelci.org>
