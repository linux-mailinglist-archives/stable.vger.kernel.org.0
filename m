Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EDECCB54
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 18:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbfJEQk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 12:40:28 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39405 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbfJEQk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 12:40:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so10582550wrj.6
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 09:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NTgzXznp1Agz3Wo14GnDlElsRKcXop9M5VMVvEJr4PU=;
        b=Y5YKBzw+9+Q7L4zwDO2snrNRkvB3fDrPwMvo5wb4wslSUlMXbi37+NvorvieSw7kqN
         XVbxNlNRON4oT9uMGMDE8Fh8x94v8OFHtFIvHCn8K3BMYYEM323ewk1TymMEjPXgf2ij
         d49/IQuxEAmnrKIoMxMoyKiuuWsXdoJr5XCq8A1gLdPkpkfu4h+TMC8jiGA3a/durEbT
         J6ybD60B7VeQPbNPPWn2Ff9Qfp2SXson8/SaNeHTR8fJoT8+E7MpDmZmnEjkL8cXdMhf
         uvcm2NxvIcBOD87sieHhEvonackB2qWBXnFpbl5hws4TjtTrQI1TpTQkmaNW/lpN8gaM
         AG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NTgzXznp1Agz3Wo14GnDlElsRKcXop9M5VMVvEJr4PU=;
        b=qFj1zg6JmzIx6QoKuMnEHA4T+n0KFycuZUn1/UotPVzWL5Y/tFZ5FBMI6eS2Gcc6Ec
         yYkN56E0/s8bxiXqRCzO8I9hv/ZpJMzLV6u/jlVQcATF2Tl4lZoAIhLppTVNmG22pcF0
         89vPdP/soXCcHfN2u2QFieXhOYe1C2rLHinhkxHu8sILA80GXD0JdOlV0TNstM+EozO6
         ZFK2uLJyQ7p/GGf4uUM3AjG8uG/90j0BnY985G6LOc5RC0vAs3piZ/4En5ebdvkdihKp
         dpYenDaQTBXUrBwPlr2L+Ledm3nFhvFtEDJEzOrDZ1Rcz+/+ct5PBujYTltE1NY6XEN8
         YgfA==
X-Gm-Message-State: APjAAAWI4ie765nc2BitpdX+EiHy9ukxM+Z4KKRUHGEJiZuf0tHIO9G4
        IIGaOzNQUOOSIOA1SNXyAVVFbT5eLJA=
X-Google-Smtp-Source: APXvYqzx0AsmpmNVqFS2LW5Dv1bAl/vvrhc4G91Ts0e8tps/wTRvjwHF48el/wl05DSkseV5hbdpEw==
X-Received: by 2002:adf:e612:: with SMTP id p18mr7767380wrm.181.1570293626743;
        Sat, 05 Oct 2019 09:40:26 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h63sm19619702wmf.15.2019.10.05.09.40.26
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 09:40:26 -0700 (PDT)
Message-ID: <5d98c77a.1c69fb81.87fd8.8a36@mx.google.com>
Date:   Sat, 05 Oct 2019 09:40:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.77
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 60 boots: 0 failed, 60 passed (v4.19.77)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 60 boots: 0 failed, 60 passed (v4.19.77)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.77/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.77/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.77
Git Commit: 6cad9d0cf87b95b10f3f4d7826c2c15e45e2a277
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 42 unique boards, 17 SoC families, 13 builds out of 206

---
For more info write to <info@kernelci.org>
