Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEDC712899C
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 15:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLUOqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 09:46:12 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39914 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbfLUOqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 09:46:12 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so12163786wrt.6
        for <stable@vger.kernel.org>; Sat, 21 Dec 2019 06:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5QImJyfzNRHiTk2BcrI1UmHexXt7UL3XiM2H7W4siLE=;
        b=xpZ+D5+tLLyqfm1Vd5JlMrna2ZXax/BlCF/NnJoWVQs1xNQWiGVndSSW6/Rn+FSd7X
         AoNKjhPa4xbIQ3BPgCwp9E2RVJp2XaPvPhgjjBO5DIvqGhXy1L7AaNXLOvihcyT43sgn
         /F/zQmDa6Lz+7CP0KYdUFHQIax6HjJZak3hjcsn33wnggU37rz2MmBZN8nOgwJtQ6c6h
         wf62XrDf1tg6brGBK4r84Ea1lIpqCnhuSueQL8LThJizNOQUwBbstGWmIWFZWQ7xg8Ee
         j03WhmXxPlGwCHybqKC4ir6SDabZrBCOJQbLsF++aGFhYAI6PLH+yNBLz6L2X+LGBvt4
         5eFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5QImJyfzNRHiTk2BcrI1UmHexXt7UL3XiM2H7W4siLE=;
        b=qh+9EAjcFsrfsCFu5u7PJQUxNU/FTjFHExRCazLglRZbK/QKbRNXzWpUBmbh0g9hsd
         A7iLBj9ORGShdhqN1bSImCGGRguSJiWfXL8oPf3NXz9+5Ufnt8EMZDG4F+gWKlZ+eFyl
         eFI5Ost1eb4iTLEQxOwoaykFP030qgW3PPGppPSSaOzngQigmvyBPOVdA5+Er2C8nk8F
         JKkyawnekVj5GHmbiSm/A4KCZfMfsRKSWOjxPXyrIMAyO3lB2mvsqewa1jH71BEPstBf
         fM9VfOPBly+LwtIl0nqn/7BYh4xHOOVI3DTpGKg/k/ACV2Qr7gtyVfFNlwQAbRTTDad8
         hwTA==
X-Gm-Message-State: APjAAAWUqUhwSjAReOP4uwk5rNnyIKnustBgLNoW2SQzjiILvMYZhlsx
        du2lEveY5UL0NzLu/Jt01TR+WXH/aY2OvQ==
X-Google-Smtp-Source: APXvYqzqmLSwtrEJOo/Qn+tMJ9s9tw6uCbXHkgfkOcVrBipy44AIAY/whpjnGtDUFdlChh+pqKT+Iw==
X-Received: by 2002:adf:ebc6:: with SMTP id v6mr21030856wrn.75.1576939570286;
        Sat, 21 Dec 2019 06:46:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d10sm13832894wrw.64.2019.12.21.06.46.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 06:46:09 -0800 (PST)
Message-ID: <5dfe3031.1c69fb81.b551f.4c17@mx.google.com>
Date:   Sat, 21 Dec 2019 06:46:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 56 boots: 1 failed,
 54 passed with 1 untried/unknown (v4.9.207)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 56 boots: 1 failed, 54 passed with 1 untried/unkno=
wn (v4.9.207)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.207/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.207/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.207
Git Commit: 5b7a2c7d46bf29fa59e746a520369c0fc30fc655
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 14 SoC families, 13 builds out of 197

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.206)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
