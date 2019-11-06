Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C007F1E73
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 20:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbfKFTQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 14:16:39 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:45986 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbfKFTQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 14:16:39 -0500
Received: by mail-wr1-f47.google.com with SMTP id h3so44335wrx.12
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 11:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u+46vo0zwKAOKb1bq6zhqHQgFTKjbUPNCoamaN8YPAE=;
        b=KLC3A2BMYrQr+Rrf88FMR4t/oV+Ewd9+vglCmk+AOht8HqA+ikdlJIjktza6EUiDQj
         VOQY18ORRZaNSNC1CI3NPXOuprs43Y7We2nmDu/7GhHBdDGLZIF1nAQWVbLhj8WApbea
         odTKe8IFajFnNluJ6c0MdN35SldKd5XNCS/YJ4pX6smvytxBXWKryrfGcCe4Wz/PBk76
         qAZ16vnG8oUvsWonR1xaD8IZQoRo7ylNOFkz0j4POSrVCeiqJCzMme0+CrC3uctOyuAY
         fHdp6hDMitMY9evDgCashq8YqERXrLwAo6ZFwLmjEyYNl9pWmqnod/fiHKg3xl28Q0PV
         C0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u+46vo0zwKAOKb1bq6zhqHQgFTKjbUPNCoamaN8YPAE=;
        b=qw8zJmxgHzSHHt7fzSfdPPCAzQYKdSFdabAts3HY+B8ltxuRC+LncitxbVwAWHf8HD
         vDmiqAULoG0zUy0Oe/MJ06pdKHy6ZFqWxa079CLNBO/g/TNDWKFhZp/3mhxemElMu8a5
         w4MN2U29VQmT8EFN8KyMqN44Ke99MX8gnu4h0wUNS/CsfA3rLVHP8ETJIhg9X1XM/8Y3
         O2Nz+hAbMBKW2jcAECfiA6sMA2OtYhi67Sq4pZWDJEXFO1dn9Y31oVW3lOTn2vTNAMOq
         Xmncb9XbeqR5Rwv88vxbORIoi/Pio48IwzLybnU6EZu0/3IeM7rSdWBes/5g8qg5mFfX
         n35A==
X-Gm-Message-State: APjAAAVzn4Gp7m2vIy68XE5ZNPncIF+9+7zoY1pBF5hmWOjNwp+nvnc+
        qKEH1IwB8Lch02U7LdvXmrRhemKGtkY=
X-Google-Smtp-Source: APXvYqy8ZIz3lfvYNnDF7IiJWLQhpXFRwz013Rz/t7VkpqaZmjL+w4+VTwXvepUfjeAO6C2AmuvBbA==
X-Received: by 2002:adf:f5c2:: with SMTP id k2mr4064478wrp.275.1573067796671;
        Wed, 06 Nov 2019 11:16:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l4sm42118817wrf.46.2019.11.06.11.16.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 11:16:36 -0800 (PST)
Message-ID: <5dc31c14.1c69fb81.3052e.676c@mx.google.com>
Date:   Wed, 06 Nov 2019 11:16:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.82
Subject: stable/linux-4.19.y boot: 61 boots: 1 failed, 60 passed (v4.19.82)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 61 boots: 1 failed, 60 passed (v4.19.82)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.82/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.82/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.82
Git Commit: 5ee93551c703f8fa1a6c414a7d08f956de311df3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 39 unique boards, 16 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.81)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
