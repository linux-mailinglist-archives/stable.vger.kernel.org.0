Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585704F5DE
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 15:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfFVNUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 09:20:50 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:39070 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFVNUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 09:20:50 -0400
Received: by mail-wr1-f52.google.com with SMTP id x4so9150238wrt.6
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 06:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5XzoBpcP8LpBzcjV+ULK9WJnBquQiPNK00TL0sKxwNw=;
        b=fifj5KTOaUJdUX4TvUYt1+GdpQpQFl/xL/NQmr4SKBSq6mc0aaOX56jle2McrQpyGk
         Hr6FlcwCp/k7yeoL/gQd36BD6TZT7J04m8ocwVILGWExRCjN2l/TuOh2Y+mLFoOgMN5W
         CSWva5/2IgX1gul1CYgukcie1kopWsSGC58vilj7+YrBzIchQ7NgdD0DCwYPNTMrfNst
         TDIAZe89oKy/CGlmLFzILqZXsMtf9Nq0AFRJIOHe50OtUGAOUPRywl1oTVezBIlVgJu1
         b+HBWZVRHtK8JoR2GRqYOUWrv4T9jY7PDIKcTPTnvW/vlpvyHPTe6Y0hW35OVIqeCxtY
         5B3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5XzoBpcP8LpBzcjV+ULK9WJnBquQiPNK00TL0sKxwNw=;
        b=pleaV7aeIz1Ezg48Hp6Fwb+XsSW/m1bZI5VDpaF/u3m0uMqiJMwoGH1dhvMq9fLfCd
         aeTTBsMioWEr+4L0zYcKBUub1dC1ipI+YoXpm9BpLqlAiZVFItv7hc90vxrgEJeh2trW
         qPsPfej7E5JRrHx/VixPDUe/ylqHpPRVIKvsEbP8AakkUYxWBpPhUn5R7dSRMTNMliK2
         5Th5U8Zu6iIcAgzxTAB856o/4wnBfqOvdP9iu/G3Xttb1LaMItK4UMQv60XVLLiXLTxe
         v3YSfAyGyxYnCOZcX57XvrjiXHO9dHT4gbGrihmF7Sq/v3kNhQydVz/fjFkOtdh4UOxM
         0L4A==
X-Gm-Message-State: APjAAAVJ0u3B14HVndbQ7MHlCcvgauRoPHcRQ9ng6y10OZlu/bR0hO+D
        MZbUER2glFwAH0N8FN4DiSPZYXjG2en4Jg==
X-Google-Smtp-Source: APXvYqwY2l9N/0IFtyIojak2BOVae/cIWfLVKhKpOiA6//EpKPiAvJ4hoRpnSt76AyACTCpGsNw/tw==
X-Received: by 2002:adf:ce82:: with SMTP id r2mr38666386wrn.223.1561209648179;
        Sat, 22 Jun 2019 06:20:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e11sm11833496wrc.9.2019.06.22.06.20.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 06:20:47 -0700 (PDT)
Message-ID: <5d0e2b2f.1c69fb81.9efbc.234e@mx.google.com>
Date:   Sat, 22 Jun 2019 06:20:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.129
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 74 boots: 0 failed, 74 passed (v4.14.129)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 74 boots: 0 failed, 74 passed (v4.14.129)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.129/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.129/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.129
Git Commit: a5758c5311775625be7f6dd54757ed356dbf2977
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 16 SoC families, 11 builds out of 201

---
For more info write to <info@kernelci.org>
