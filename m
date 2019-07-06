Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F11B261072
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 13:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfGFLZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jul 2019 07:25:14 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:35477 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfGFLZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jul 2019 07:25:14 -0400
Received: by mail-wm1-f41.google.com with SMTP id l2so4738373wmg.0
        for <stable@vger.kernel.org>; Sat, 06 Jul 2019 04:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=36KlCNolIjV276dwesHT4WTqnoup0b4pZSYfyjH7Sic=;
        b=xmIRLjbzhyZqN8uNwtK/6XX4u7E8FJsGmlyJ5xcTgipisrLfkJ8KBUq3WD2rtIMd6M
         toqHBkEmKQTK2DRorz/h2Tes7sbg/PhrfH7k4O9L0qXkBI/IPezFr8mZqJkirTfNDH6c
         Ei0u08Pv58nyTEfsbawZtDmCTgrhxQ7vi3b+ZacApjQVKxpd6luWwruwbBxQRCBjNpL1
         b4hDpogP469ui8gHMARMF4hYQKZa9ucg2hZOGguPLdw975rluyCehiP6COmNd2kCDe6r
         vlyH2S91bpsNIvEYIK2maUD+YI6u/l3vTG9pywegdmTmE8B8Gx7MuUqFq2+fxot0Pb0u
         OpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=36KlCNolIjV276dwesHT4WTqnoup0b4pZSYfyjH7Sic=;
        b=TijwenrACu55r9UOewkV8TugdY2IXKQRjhi5Anf9GaWvG/Nt0bKfqLQrKLKn+5udfi
         JdznqafnTyhVMfvvyk06xloHv5PGjsxleSBwyOLzieGs9zu0L27bGxm5/gIQOJgiX0TN
         pb7Ff9QkPv44p8PC2K5nRjLzgdxeyx0xHDXyn180PnA1AeJiNJziNnqNprETW6vzCMbY
         P1OqKBGU3w3UrzO2x3sDepDFLv+Jpj2/K2JnQaDXIfAIYl4NC3AXC6WlO2wN1NZ3Er8J
         Q33+2jAkO2iA1qLAuLv1BkcbQkpnP5N7EFwvmJuGfVFWuRxEWsqiLzWj0hKo8qObA0jY
         mUqA==
X-Gm-Message-State: APjAAAW7BBtzqVWpcYO/KdTAlATaWzwNo7r0Rv4Z1wUHulaGLILjd/E9
        Kb2QqZHDmkNccqmD+c+UHLoNGGXPdMJJKg==
X-Google-Smtp-Source: APXvYqwUb2r97NGqRZRSVVitY6ANGREz7Mwsb6HzUrGmsu9LXnRsifQ+YQ9tPF9aIjXScp1Fc4slwg==
X-Received: by 2002:a1c:f018:: with SMTP id a24mr228758wmb.66.1562412311893;
        Sat, 06 Jul 2019 04:25:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 2sm11525199wrn.29.2019.07.06.04.25.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 04:25:09 -0700 (PDT)
Message-ID: <5d208515.1c69fb81.75e33.3348@mx.google.com>
Date:   Sat, 06 Jul 2019 04:25:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.16-89-g2b5fd394355a
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 139 boots: 3 failed,
 136 passed (v5.1.16-89-g2b5fd394355a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 139 boots: 3 failed, 136 passed (v5.1.16-89-g2b=
5fd394355a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.16-89-g2b5fd394355a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.16-89-g2b5fd394355a/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.16-89-g2b5fd394355a
Git Commit: 2b5fd394355ac0b2cc9572232727cb2bce7c15a7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 27 SoC families, 17 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
