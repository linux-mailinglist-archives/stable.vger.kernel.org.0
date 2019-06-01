Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E9D31D51
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfFAN20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:28:26 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:39025 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFAN2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 09:28:25 -0400
Received: by mail-wr1-f41.google.com with SMTP id x4so8279190wrt.6
        for <stable@vger.kernel.org>; Sat, 01 Jun 2019 06:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Du28GE8GQNCy+jTNuyQqyMY1Ce1FGLRFD2GmevNOgx0=;
        b=cNrRAmcboTmeAR7QNHWaR7fZanhhIOC5aWZfBywaziX0vXvwiXIsG1SocU1H31Jot4
         ymanLUB6ESrB5q3xD6ycGv73B/D00M6YfSN1RrXEbEdFVlh9hKVMDBez3b5BFgcW3gxK
         RhGEOnunkEgJgb0jSxdPkoAXuSPiocDmU0s+6hsXu+rBsQzuVWobi2qbbX/WQn0/Ea7i
         NQsmEYZnSsjMl29ODLaV0cuFtfx8Fp61HxdMEK0joGfG1WmtqeW3q6JKO9iJZtbkzNY8
         MzJ2K8HvVxFrRQU/PkBOKVv7+5QGZh1Tu9HGdOmMVw6eF5k63Ip3JASCWZ7j7XtYbF0R
         9GTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Du28GE8GQNCy+jTNuyQqyMY1Ce1FGLRFD2GmevNOgx0=;
        b=S21IKl3WbQcRKIMG6qc8ncRZZq6Tt5bcW8nkDRSJIVafznptnzs1r2QgSq6gIJrYcz
         SN+4nwIDc5akMyyBIb5aJn+qKvO717FnN6tr2imvuiL/w+H2zSseqpFcO/+ZdJsf5Jqk
         lULkp+ltIIhETWB6qvkf7NTBxLl+xXjwp7VOlEslLVBsHZt9RtTMF2KS3TBJS4tdPdqM
         xJDb6UBNISlFq+v3mP9+Pu+dpxhXpuuHMch8LgHLAVXxwPYoHWvpkULozk0PhhPkJXZm
         8vTzjbDBxV4Zw4NKGkwGOYiVbL1ZWqU2/ErEKxlEO1eXtQNWUes5TSIP1LTf5vmpO10z
         KPwQ==
X-Gm-Message-State: APjAAAUhb2hoNstDSYyX8dk7Q/8HUYeuQg3EOlgTvcbiU/9jFbMSoDT9
        5K12zYn2NTsd02NE4nvXUro/ad7IkZaVew==
X-Google-Smtp-Source: APXvYqxQpErvZqctM3iUJXfxS/DYqa9OSUQFwvbXJC9CAvK4d+vZRnLc0x/o2OY6poi4AjcprIg1HQ==
X-Received: by 2002:adf:b683:: with SMTP id j3mr6204219wre.76.1559395704038;
        Sat, 01 Jun 2019 06:28:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b69sm5420192wme.44.2019.06.01.06.28.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 06:28:23 -0700 (PDT)
Message-ID: <5cf27d77.1c69fb81.eaf58.b692@mx.google.com>
Date:   Sat, 01 Jun 2019 06:28:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.6-38-g5a6f1b561052
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 126 boots: 1 failed,
 125 passed (v5.1.6-38-g5a6f1b561052)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 126 boots: 1 failed, 125 passed (v5.1.6-38-g5a6=
f1b561052)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.6-38-g5a6f1b561052/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.6-38-g5a6f1b561052/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.6-38-g5a6f1b561052
Git Commit: 5a6f1b561052770d4b877bb1f7ef5b876ef3e3a3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 23 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
