Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED89AD9972
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 20:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390780AbfJPSqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 14:46:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41523 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728538AbfJPSqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 14:46:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id p4so13377246wrm.8
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 11:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5QKdIs3H3a+fad3Tte37ikKIx4qHKGto0v+G9Dt0D9M=;
        b=xVug2dj7C9lj1iBT8LIFEuGzp7hYptcPLwDGOIUK5z+I4l7GLt9zv6dhzptr5dxI9N
         XwqlWUK3zvvE8RYDs8ozM9CakR3wLW+dWkL8MPVsXFZJtJQBOX+Wd9kGfdvJkXOsZG30
         ZGFoeaycsRGn3djDGb5pqmQxlTxAHHC4bfgdUAMeYlEWbzfKzfsSCfviqZlYPYBXucOs
         qyQuSePH36cO65GtL5mHDsxyjvvfbgXZasMWJTq9MKJCDC1mZwly/J8mx58oYjTqRYbH
         FMAy4TUeRZa8b9SjrX2TkO33AaN1dUxCha3vlLdHF1nC3ud+Z71MWT0l9SP+UXLr2vo7
         Ibpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5QKdIs3H3a+fad3Tte37ikKIx4qHKGto0v+G9Dt0D9M=;
        b=KW23HtjEpnYTQL+OGSV/NWYbOX+ISygbkfpBYTmNNauYfzKcH/OjSHcgsY47CT3CwV
         UPwxbWYDuKVh8TeHM3RKqMX3LgOzBpnyd9UmcV39+L5nkOWJaOxMoMKg4GiMkvHonB5u
         aAeymKeRbMjjbzGQfD7bIaVyh6bh9l9GYgBvv5HWA0jME5ujKO6fOtxcP2eluMs7hRiv
         NRV1lw7IkAtJV4URW+qb5l9ZPv9ZddXqizzS2WLeTx5apxgUYK62tQ84rwMaZdLt93MA
         6D/eiIr2VxnLWq0qH/ZZ1q1clWuJI2ycxF/3oBTCXclkt7O2t4qgheDS+C/DpsokLqwo
         A/8g==
X-Gm-Message-State: APjAAAWVtxDAEnkiYnJv6SBYx/v7+8roahdF6a+zRXevE4kYoOwPeUjW
        DuDj18xM9oZKFM4PYRqnnGiWrf8DN5c=
X-Google-Smtp-Source: APXvYqy/QDWmco5WomMO4Pz19SWHRykDKkuB4PSdwpGJJRhZJy5bTVSyfCTmzCTq8NtBE7zTedU1oQ==
X-Received: by 2002:adf:a157:: with SMTP id r23mr1453961wrr.51.1571251605255;
        Wed, 16 Oct 2019 11:46:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n15sm24089714wrw.47.2019.10.16.11.46.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 11:46:44 -0700 (PDT)
Message-ID: <5da76594.1c69fb81.54617.2ee3@mx.google.com>
Date:   Wed, 16 Oct 2019 11:46:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.196-93-g8811b6f62880
Subject: stable-rc/linux-4.9.y boot: 41 boots: 0 failed,
 38 passed with 3 offline (v4.9.196-93-g8811b6f62880)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 41 boots: 0 failed, 38 passed with 3 offline (v=
4.9.196-93-g8811b6f62880)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.196-93-g8811b6f62880/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.196-93-g8811b6f62880/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.196-93-g8811b6f62880
Git Commit: 8811b6f62880b7a4b6d43be23d9837491ce18ea0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 12 SoC families, 13 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
