Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0EB24056
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 20:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfETS2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 14:28:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50787 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfETS2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 14:28:18 -0400
Received: by mail-wm1-f66.google.com with SMTP id f204so354855wme.0
        for <stable@vger.kernel.org>; Mon, 20 May 2019 11:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=HmGLQrCdMJnuW0msOlZFsmWFSYM8a4SlYwckrQhrmPc=;
        b=pxIC6RjXIlSAHmHgcibUXYxYkRk/OfkzCKXfgjYuNxbmItg01fawJDeg47wU+LdeQ6
         tBOnKdqMKgVLefMnEd42QcutXOi1t5sAuc5EZLWgcmZ3YyxKEHjRE/5gZraqCqFwFYgC
         ZpwAqPK0xNyxnGoc0xS6C9sZEuA3ySqh1AKfj62ay3cB9nGzXJ1sTFX6k31lpyka8t0+
         BaWsyeMP4vWyB4eI60+5xSn54OZGPlxkv6p9VMTKz3ze9K6UNO83YKfCy5iVMjtEclXD
         R/+v2zZmOJBx2uLtVak0sChaQJaiB4QPEh8ppCE/aM2Ewc1xXZ6SZgyOLPqNBj/xA994
         NVbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=HmGLQrCdMJnuW0msOlZFsmWFSYM8a4SlYwckrQhrmPc=;
        b=LkHvUHUl6QC+AgakcijoFri99jfzJuv30VSUOvcGljZFMaGMyRZfbQuSaKzBxUXCIb
         aCeX6+2YJFIfcVLULSNmGNsWf7boZ4KCRHpzhXxuEalgRZdeTgy4eooU74M/EdJDCknh
         aTWHiZ8rbU1bXwQc6pTgrTyry8K6fw7QPiacIGlqUXsvorY0Y5n+ssFUU307xLSsIfbF
         8f+qxTeAiwM1g/MWT8i//Psad2uRnUAkZ7lLesH+1viCSHnSBbrmpnT72FoJ5fUiYwdu
         Vqp8bbu/Yvzw9YeijRSrnUWkqipevKbL1PkvDPCJlc2wml98L/hXUxZdKq84UN7knwgq
         Qpwg==
X-Gm-Message-State: APjAAAVk7oevDYQ8yyF9UVE+j/IIKb+OWkXqkTQT+sCJ+LcMgs3OvLIu
        Fu/7aZSkAyosDR09HJmVuXohFw==
X-Google-Smtp-Source: APXvYqyM/JxSNjJ+fSfxCOiK5054Q8CKIbdo6owX1RblhrlSQ9V78BYQOLZe90/nJXfg9D1K6mznyQ==
X-Received: by 2002:a1c:f507:: with SMTP id t7mr341285wmh.149.1558376895848;
        Mon, 20 May 2019 11:28:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s11sm34074338wrb.71.2019.05.20.11.28.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 11:28:15 -0700 (PDT)
Message-ID: <5ce2f1bf.1c69fb81.602b9.a71a@mx.google.com>
Date:   Mon, 20 May 2019 11:28:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.120-64-gffedd7fd95e8
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/63] 4.14.121-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 117 boots: 1 failed, 113 passed with 1 offline=
, 1 untried/unknown, 1 conflict (v4.14.120-64-gffedd7fd95e8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.120-64-gffedd7fd95e8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.120-64-gffedd7fd95e8/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.120-64-gffedd7fd95e8
Git Commit: ffedd7fd95e8d03834094434754a33dbc060770d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 24 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.120)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
