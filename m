Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D7AB392E
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 13:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfIPLOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 07:14:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38077 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfIPLOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 07:14:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id l11so38382069wrx.5
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 04:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mZKi60I4PeU3CnxWjU2uZVuyVnYJX5nxXuqjGAItFPo=;
        b=qc7Te1W9KK2r9dPGTEWQVmplXlnSasPz9wm7hoyN+5QPaupko5XpkW/R74JVdGhrAd
         kaiw6+fPosLyPR6KKhJ5cL+4S1rUb55JiTeO2xOYy3Ej/757TivNFAmDvfqi985j6Q6c
         J8fD/ASVkIbE7SsrLp2OOT5d7BxDkNhzQuC3S6fTq5B1IkuLcJOBPCXrM/z0f1JQZdcE
         8n3ToJHSXHzUvEvWVIeDa11hrFSAUSpB/wW2KLDe9WiPr42MfUieDrG8ib2mdIUkPNfu
         kpX8WLGJDPjRO4+QqUcfMzk4O7PFryxGrdY3OPwKKlEfZp7iuUaJmCzqT9Q/5475spJE
         V61g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mZKi60I4PeU3CnxWjU2uZVuyVnYJX5nxXuqjGAItFPo=;
        b=LdwMgH3dIrxYZ1OwzN6IpSbEjo8mVGiP8gKut9FqS/UzQsBtVpzlbQjW6u4OcO68P8
         I8AV03wPTgY/CKRplp9vcdqb9VVqsYC/9MYgZn5Bxt62PI9MG5Kv0HMqdugEW6GQxQYK
         YWyQr+tFJV11RkKSJBhPJ1/kjtj5w+zzHTOC9s9DbM0WU9G5W0xOXs52JGvxDtyKxTQU
         VAl01MX6h4+BTOFDnK/VCvHQDoCGVwhfYI/gCiLuc0n+o3U99nCyi6jv6Qrj6AoibH7W
         9v24ZTBbaJI+Ccle1T06tSGRc6J8GfaLpMQIvW0+gom78Z4j6Gz19XL3lyPUDz1LHPm2
         +WqQ==
X-Gm-Message-State: APjAAAUzzvaSHEFCl9xikrvxBb/Nc/N5TDy+bX36STfqwWqGKgx9Zu3Y
        k2RZacu7NaI5vdIXarUbGyCSYh92yNI=
X-Google-Smtp-Source: APXvYqym7/ChaiIif2S7vLA5X6ApIYeQZE7Bi1muoUgi6uK1nbIRzqjOZFogEY67zSkSZeKYNlaWzg==
X-Received: by 2002:a5d:5450:: with SMTP id w16mr28518471wrv.55.1568632478587;
        Mon, 16 Sep 2019 04:14:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 33sm47185112wra.41.2019.09.16.04.14.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 04:14:37 -0700 (PDT)
Message-ID: <5d7f6e9d.1c69fb81.91aff.937c@mx.google.com>
Date:   Mon, 16 Sep 2019 04:14:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.193
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 71 boots: 0 failed, 71 passed (v4.9.193)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 71 boots: 0 failed, 71 passed (v4.9.193)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.193/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.193/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.193
Git Commit: 779cde69dcc0c1d3c992c902a9d07bf7ec7b729b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 15 SoC families, 11 builds out of 197

---
For more info write to <info@kernelci.org>
