Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1F0147A4C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgAXJSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:18:47 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36996 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbgAXJSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 04:18:46 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so981925wmf.2
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 01:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NRGyCC9aipX/f0oZJF5CHyrGw38QqUwE8Z5bOj1KkWM=;
        b=SIzO5aIEa18cjtzVwest6DTaaz3KZC/dZYLZH0ofcKLDnHSxE794CSYNPWcnzpJXT4
         +dOUXXBBd4LfgitmgmzyXShKKE4q/oItqG7Ep+G9APEZeeECQ1MSsaU+X2hwPZxZe1wG
         PAholgBwTAyARACgRfU58Wv/SDyZBuzXyTkLrSI6fCCU9cUDN/5XPrzG81eTYCfagL19
         bGTXRnBRPAMogNU3Rk6fR9P8tC2uZ51yCW/jgERvvMprHm2Z8WhVxJj/7bu0+i3+8CLO
         MGXN7mH6fdjD4Dy95VtmanV3KmrM+HoPfc2mSZ3zrvP81i6fs2JT101ruStCfS6cbZX3
         MmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NRGyCC9aipX/f0oZJF5CHyrGw38QqUwE8Z5bOj1KkWM=;
        b=Ps8/MGhLUQQsulhdzwu1uJSXjKYzWCaS10e4VL/ZydZ+wWmqtaHqrBYMIR4eTaXkee
         /+aekz4mbgmMypzaC2Rn5PGPxnS8vtqYiqV0ydWO2oyc5GWt25AVtpltA2OUP2HM79/Q
         6icq0oyO8EJzSQ37mW2RCDjeARcaqptiBTQiW1Se9OiFiVvDs1bFL2w0efc1o6M3x91v
         6iwV7AfDLKzfGUdEq9UPCeuJaZ1QHIpWWJSRpj9hMW0+/vOEJ+DWbnR+pf+VVyQfS/rZ
         Eua7JrmzHub50GAoGqZsbhRvekvatjAvh6r2ahXMZxLPYz/3AVPnh/uiIRnynT8B5irp
         o1EA==
X-Gm-Message-State: APjAAAVl38LCc1kxhiSTJ6JoV7cul7hCeWQvb8rUpUdOrkTriMFPOOhu
        R6E6sPcEWUZhJvIi/Hjs2N3YG3/0vXv/Dg==
X-Google-Smtp-Source: APXvYqyt+pRormFKnAtnOEytbugx/kj968oWYfMEbebDvvDJZ/HgpivkIDW0BX7MXT83v1+XrUs72A==
X-Received: by 2002:a1c:2504:: with SMTP id l4mr2365325wml.134.1579857524864;
        Fri, 24 Jan 2020 01:18:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s1sm6398214wmc.23.2020.01.24.01.18.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 01:18:44 -0800 (PST)
Message-ID: <5e2ab674.1c69fb81.eeec8.9774@mx.google.com>
Date:   Fri, 24 Jan 2020 01:18:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.167-344-g0069bfaf2102
Subject: stable-rc/linux-4.14.y boot: 125 boots: 1 failed,
 116 passed with 5 offline, 3 untried/unknown (v4.14.167-344-g0069bfaf2102)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 125 boots: 1 failed, 116 passed with 5 offline=
, 3 untried/unknown (v4.14.167-344-g0069bfaf2102)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.167-344-g0069bfaf2102/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.167-344-g0069bfaf2102/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.167-344-g0069bfaf2102
Git Commit: 0069bfaf2102782e106a221f50763f8057bd1d6d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 22 SoC families, 16 builds out of 195

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
