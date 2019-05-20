Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5ED23F3C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 19:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404018AbfETRkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 13:40:12 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:36566 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404016AbfETRkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 13:40:11 -0400
Received: by mail-wm1-f46.google.com with SMTP id j187so208407wmj.1
        for <stable@vger.kernel.org>; Mon, 20 May 2019 10:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ASi4P+vK/BY4xARlAX5okcCkAi7jUwOKEr1mT66lsfQ=;
        b=iknlluJ2eSE88axZW+jDhkvTpImkt/2NF+DX/ID12BqPg7vh8Z7dFvuG2Nl0onWS2I
         3hRYD/FMoLy24/d3DEouWBfDDT+bI+E7CQP7Q06aKu30I4pAwYuECrHg26y5qkKl1iqM
         62Tksjt5BVE+mdeC90jaIYhint7RH7K5rqAVnKQK3KXX8fHAo756eQ4sBMOE/d4lW9Hk
         u2/9ZLeBEd0gSHwQ03cxb/lqbciC/qq3N3VyVumrNopl5II21r/7oxKYAC+94nlMTnb7
         fMfBLU0uV1YqH+Cs/8HbbacMWnQbyKkPiMGhgWpRouqRoVRN9fDD24ZzYGE883OBz9eb
         oBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ASi4P+vK/BY4xARlAX5okcCkAi7jUwOKEr1mT66lsfQ=;
        b=mvIdnyJqPD7jDTTKGQRZQv/jj0DTdldpOIiTqBNmqfURTrHNBHRuN8dzseHwa3WrSm
         XfyqYeOucWQtPPhgx4dvAmPe29OuahTBV2RQM3pzPfoCEoPWh5zsAT3pRKIxsu7BUuTO
         jX/fCCLAT1FbSHmWA/6zL+4EDZtOYmEN4zLmN9QGzPJa73QOlpVXninpaKZboyz5RJuK
         IaCAAphpcPRavGoxMrVjkPBbjax/JJXUEkLcvJWGPxLMXOwzWyJYEFMxWdlBQvSAGK/6
         HHFc0u85hyiRpD7jpM5qvCNzlWsflQStAryBKed/Ik8nKMJhr45P6gawkmsZ+tGdHIph
         evMQ==
X-Gm-Message-State: APjAAAXML8YYydD5dY9Nt+J+mAfNW5IHZyheBO4tKQ/wK+nnzuWE30Y1
        Xe8B/ADYU0S0TANgeP1TVQoQ6H6LRUvDjA==
X-Google-Smtp-Source: APXvYqyhJ8RmxL5+YPnrkGnhX3m97TKw5BwQxduD4wWQOajSz7OhMDMSi8fs8rFsKmmYbUwGgb5Mog==
X-Received: by 2002:a1c:c8:: with SMTP id 191mr231184wma.6.1558374009609;
        Mon, 20 May 2019 10:40:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v184sm335994wma.6.2019.05.20.10.40.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 10:40:09 -0700 (PDT)
Message-ID: <5ce2e679.1c69fb81.842a8.1aa4@mx.google.com>
Date:   Mon, 20 May 2019 10:40:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.44-106-g6b27ffd29c43
Subject: stable-rc/linux-4.19.y boot: 120 boots: 0 failed,
 118 passed with 1 offline, 1 conflict (v4.19.44-106-g6b27ffd29c43)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 120 boots: 0 failed, 118 passed with 1 offline=
, 1 conflict (v4.19.44-106-g6b27ffd29c43)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.44-106-g6b27ffd29c43/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.44-106-g6b27ffd29c43/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.44-106-g6b27ffd29c43
Git Commit: 6b27ffd29c43f07e11cc906154745c4e9b3d71c3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 3 days (last pass: v4.19.43-114-g=
b5001f5eab58 - first fail: v4.19.44)

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
