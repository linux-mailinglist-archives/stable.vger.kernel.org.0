Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789B062759
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 19:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbfGHRi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 13:38:28 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:46024 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbfGHRi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 13:38:27 -0400
Received: by mail-wr1-f48.google.com with SMTP id f9so18058041wre.12
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 10:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dMil1FF/9REos4dHEvshh6LKzpYeBc8wUcAzB7CI8Tc=;
        b=V9aXFNMrnnU4MF89JULP7LndF2HjAMUFa/oOVEfYISmLvAbcp4P6MXx0gKhY8+26pp
         v7D+Udb0twXnNpy+L2yr9qzbQ2uG211LC0dRG5VRYLgfef9mklrw6zEZgdnkppkgw3Xk
         Cx9IqPuybMGu/wO0K+TlEXXxyfSRQ31QIiMbSGriEgg7+PQiayQoNUZjFjfvnrEuPOMS
         ZIHXaQdxJbmE3GyTEX6JyTLqU54fCpZuUSVykeQ5GTFKcLfr2YybioLqZW9FNgXMpa4Q
         wtUpOPMh0JwbhvGTujzszCnxG47dOrxVNWf5se1trz62bmZ2j+Qu39XjWTvnjUnbKEKU
         9zCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dMil1FF/9REos4dHEvshh6LKzpYeBc8wUcAzB7CI8Tc=;
        b=VTOx4y288C9d3GsMjZwVAnC1j3nEAFx0oaVx6ViPIPXNRwvr9UPSopIfhJZcJWK5te
         1OToU/86nGTSnZopHWlQlNYmrTmjMecVDQOFc887s3F7PGes4o1uU/djysPheqb+Ngtp
         f3M4JxTiIc6KEmkHlMYOJrJJefhJ43E6FzN5DxnP3GxUEzVdDpkPRHBady7Ugaf5d52R
         ZMdiz6r/7wG5/A1uXi/WY+Uqe/dg7Nzs+yvWWDqtzYx2jMpG2OBmAlFB6vbEYw8IZLjL
         oYhEEc8wJ/2nmqUGG9zeVbCeneF3H1S8Q7LljXcO4MSW4nlZDBPK3+clcZ2DmT2jfV8x
         rTzA==
X-Gm-Message-State: APjAAAWKcBZ6pFVxv9+C95uwYXK7Up4BwvvMBfeKq1r2i/j5ItQd2xQw
        XxhjkgBuxuvqFgo00SEvN6Yoqz3nnvAOOg==
X-Google-Smtp-Source: APXvYqzoUzUnyD0h4EmyVe/PeItGu7x4bQZQV58hJO0eidyCF4ks7vPFzZ7eWNIUxJzmgzcBqpdFKw==
X-Received: by 2002:a5d:4e02:: with SMTP id p2mr13007467wrt.182.1562607505478;
        Mon, 08 Jul 2019 10:38:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm14784054wrt.49.2019.07.08.10.38.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 10:38:25 -0700 (PDT)
Message-ID: <5d237f91.1c69fb81.8d14e.2165@mx.google.com>
Date:   Mon, 08 Jul 2019 10:38:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.57-91-g7b63e70b83fc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 100 boots: 2 failed,
 98 passed (v4.19.57-91-g7b63e70b83fc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 100 boots: 2 failed, 98 passed (v4.19.57-91-g7=
b63e70b83fc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.57-91-g7b63e70b83fc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.57-91-g7b63e70b83fc/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.57-91-g7b63e70b83fc
Git Commit: 7b63e70b83fca977d86fe50ca2a48f40addac0a4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 24 SoC families, 15 builds out of 206

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
