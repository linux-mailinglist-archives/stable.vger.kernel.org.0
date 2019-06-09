Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441093AC50
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 00:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbfFIWPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 18:15:02 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:44238 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbfFIWPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 18:15:02 -0400
Received: by mail-wr1-f41.google.com with SMTP id b17so7198921wrq.11
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 15:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fZUMUrVSrWqn06R4SEg3jpCziIJecrOIDyIpOoux5K4=;
        b=QlLB8vXxYZVz/SCSQRyms67eU9A/lsk1RSx6qKWfsrcm/+WbBvsBP2/1IBXBotBLN5
         MR6DqJVuVFAzweaue5Iz3P3PUoZrhY0MdEmFzQs9ywEFnNfxwoR+QMeRuUuDkMOhamDB
         1TP7Mly6BbwZckGSdaYBzsq+csp8XIFeSBcAdK3Rf1GvYpJenhxJ6A5/nwon08IV8jvS
         QeB3nbUWTfDhLyFVbVDR7mVCyzpT3C7Y4adouM3ikWB1f3319dGMJl7XwF5sR4od4D/G
         NmHHbUEdMftxWPPUiI5BHri059i7nYG0o7EzCTQlc02duZXSv4kMSlEmR5Ov37mBeZJq
         hnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fZUMUrVSrWqn06R4SEg3jpCziIJecrOIDyIpOoux5K4=;
        b=YTgTeYsr98il/YH/hUSjdBFFSD7W0hhsH/kJQVzOaYxKGyQxitvy+hcz4YGbAe6TbV
         ocZH6frUotCI8YlT8I5Yom2ZBDlBcFqJ+UTRjYm/g+axN+0rVaWT9sO52ZUGL0lMb228
         ynrjJRlFX/IioWKvyeTZrIDi5Mc988qSybIZ4hmKBLmtjH6x+GzDsG7KjCd0tE0CiIvA
         2MJD0gRBgjtg6AE7YDUXMjEK8gIFB2QRVM7kMNgLkKoxU+/gn0PDqXiJkW/09I/lTaLZ
         GbE/w2ujgW25GwEn/fNYncgtGNjrPx4gYZIs/yT9MIWd98kaL3oqFvM1e0/KxmY+jm5Y
         tfCA==
X-Gm-Message-State: APjAAAXprE+JgCAG/+pCECJzKFdWWxgwUWUZNip1UbaTvSEUMNBCeP5P
        gTjM2V9pbX0hdwVizOqwhhRsXHPj/yo=
X-Google-Smtp-Source: APXvYqxY72h1aSjEBL0FYDkIJCnKXTJofFlG4mqG8mylAb7+x6C+sK5NewhVLH6eHWmFPbscXD1orw==
X-Received: by 2002:adf:dd52:: with SMTP id u18mr4200636wrm.193.1560118500406;
        Sun, 09 Jun 2019 15:15:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l4sm6766526wmh.18.2019.06.09.15.14.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 15:14:59 -0700 (PDT)
Message-ID: <5cfd84e3.1c69fb81.25423.6c9a@mx.google.com>
Date:   Sun, 09 Jun 2019 15:14:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.123-106-g396ea3538ca4
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 124 boots: 0 failed,
 124 passed (v4.14.123-106-g396ea3538ca4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 124 boots: 0 failed, 124 passed (v4.14.123-106=
-g396ea3538ca4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.123-106-g396ea3538ca4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.123-106-g396ea3538ca4/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.123-106-g396ea3538ca4
Git Commit: 396ea3538ca4ce6f760fff7a837e10f2450c5526
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 15 builds out of 201

---
For more info write to <info@kernelci.org>
