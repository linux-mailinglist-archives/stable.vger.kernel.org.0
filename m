Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 665896F3A3
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 16:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfGUOZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 10:25:23 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:35541 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGUOZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 10:25:23 -0400
Received: by mail-wr1-f52.google.com with SMTP id y4so36749362wrm.2
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 07:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NAiTyvCra3YB1eZIf92bNxrx4uDYhll0zvmomIg82GI=;
        b=GouBG9lJwh49JCeXrAv7LONCGv6jB6mzOiohT4vbid9+ZB1YcLOULaUftzwKBoCX0U
         ASQnBfM99Le4+8uAE1CXiqknYpOHaxbJMLXBL6BPYo+a0QNACxsX/YMi1uDrBjLVH2zT
         +x0OyFE0WPEMHh9L0XAEoGxjrVaNaEXpkaCe7i0KOFTmH4DoAbpMh5i74NJtWGvpZSB/
         NvniyKFFzE/d9zD5Os767mykmBqFx2TLTxlBQ9HRKkHMllD9Rk1n7IOPnj3DrHINLLrJ
         U8UPFoj4xr6BxCZZpEuwRWI0mtrfxOWreh+/9niKsEcuhcHbmWkZNeKPWIulbSmvitrZ
         Xadw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NAiTyvCra3YB1eZIf92bNxrx4uDYhll0zvmomIg82GI=;
        b=L43jptov32x+UOfw4zQ1FrN2roi9f74MWR78/rERivG8Dbbe+65ti1vTO9Nl6YqoLq
         lRwJ2MMpED0XjJwjf8UwBzULmQ2BL2SLFqEUjExSlPFU41Vzx0niRxtXGa2JpdVo0SdI
         FqeSdj/rlGg+8N65JY+DTcLmsPhW3CMGZkmg6zSqfvvxvTs5WUxvK7ycEAvlSypxWX6P
         nj0j9BE1FnwLwp6rq9IHpbDUJPFdbs0VpbcFIjBcIprxEWwbp7kiVWbMdP/5X68+IJIp
         oJVIpdUf3OeM+VFND3FFcLfwrSrHRS4QVo+scBzS6NXkKfojZZ80F6IagvoGiZBw5WuA
         yD8A==
X-Gm-Message-State: APjAAAUyaD+oUtocrx1fU4BhcGa45t4LWtKElbvwv0txZuqpdchMTrmo
        Oz5y87/rllYYrgYN15WB6+pfH2nz
X-Google-Smtp-Source: APXvYqyo4fsPBABzncu7tJlH2frdL7Coe1ES6AJaPX4yUqwqjsj0Luz0Jt/6dUxgonBn21X4qyer6Q==
X-Received: by 2002:adf:d4cc:: with SMTP id w12mr71041684wrk.121.1563719120983;
        Sun, 21 Jul 2019 07:25:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n9sm71304495wrp.54.2019.07.21.07.25.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 07:25:20 -0700 (PDT)
Message-ID: <5d3475d0.1c69fb81.948b2.1c70@mx.google.com>
Date:   Sun, 21 Jul 2019 07:25:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.60
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 98 boots: 0 failed,
 97 passed with 1 offline (v4.19.60)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 98 boots: 0 failed, 97 passed with 1 offline (=
v4.19.60)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.60/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.60/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.60
Git Commit: be9b6782a9eb128a45b4d4fce556f7053234773d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 24 SoC families, 15 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
