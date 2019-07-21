Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8656F3F1
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 17:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfGUP1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 11:27:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46004 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGUP1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 11:27:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so36782973wre.12
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 08:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WbflbyEUHjpoLjBoqjEr/Pnb9q4QhMd+ykXTPLIEUOc=;
        b=yRKXJUQLenH5+bktW3P7NjsLpPlUvSeNbLEmljjzKau6lWeuA5x+ANQ5g3TFZSMIjU
         R/FHu/U8Z+yVlTZTWj7SsSIIAyLl1Mm2tN6vceEEo+pnipcUqfvYjgclNRi4dEH+k4AU
         45/AWHXJAsm3cCapqxPLBjYDXsqZ+b/Fldh+ZZEiKgPdCcNXplALwhfKK4GQssneMh8k
         JEaK3q8HpzcxmqpGZpyXpKVH1VfTUBJQ0DuhZ3oapgqU2gwOpeCbtg9LiEKrR3BK48BJ
         UoXbL+tyyoBRJDrKzQlHDgujfCr1R3x8PXUOYlTXHLP3n6ZV32G06fTuuqqjftAzliiC
         a4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WbflbyEUHjpoLjBoqjEr/Pnb9q4QhMd+ykXTPLIEUOc=;
        b=PYard/8U4+Ki4V+wgQzcpT04xLYo/BEO/mtt/ZupdZCZN3k17Mb399RBhUyl+iHupp
         nqTQs8mLioe+wHILTbnpl+fXYPsDxLe+2AIy5dSnf6jbfSPlPzCll6Wsm37gKLVQdcK+
         yROLkewO/vzBbb93P8/CmQBmyr8fb1EAv3qIGlTa8a37r+3iIftXRGb32ClNwySAw7fE
         8oncEVyCgYUXH2Uw26mZO/AX3vpBovXyWzhMij5zMYVYnctLuYi4HjJrz/juW97n14s6
         CtwnqSGb+AHVJa2E26qUvZpJwQPbXuLhGqOU2FibOqjBryluG70SuUhFUM+pVskjgggL
         AVHQ==
X-Gm-Message-State: APjAAAXLZT5zmCUBX4l8vasWlgHnovTQ+Q1JlZzFHu6HYdWbjj5jTsk4
        CLksHZvbgz2G38iORkrUutYyvs2B
X-Google-Smtp-Source: APXvYqzm6Ph5BPgWJjk+SVnuNyIoyp204OCT89roV8nZVcF13A1Bmn/br6ErsETsvTt6GPYmjAEXTQ==
X-Received: by 2002:adf:8364:: with SMTP id 91mr69245659wrd.13.1563722841334;
        Sun, 21 Jul 2019 08:27:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l25sm28614092wme.13.2019.07.21.08.27.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 08:27:20 -0700 (PDT)
Message-ID: <5d348458.1c69fb81.4b11d.c6f5@mx.google.com>
Date:   Sun, 21 Jul 2019 08:27:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.186
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 86 boots: 2 failed, 84 passed (v4.4.186)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 86 boots: 2 failed, 84 passed (v4.4.186)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186
Git Commit: a3e421fbb8579236dfb5fa82c395553828dec233
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 19 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
