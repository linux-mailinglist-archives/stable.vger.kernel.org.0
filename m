Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38C8437BE
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732966AbfFMPAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:00:55 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:35135 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732569AbfFMOk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 10:40:56 -0400
Received: by mail-wm1-f50.google.com with SMTP id c6so10429837wml.0
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 07:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+RVryizvvLr6nOq3Y01zEZUNig98tyiJRX4i4NCALjE=;
        b=uLP7LpcHTgl2vve6esSWmSSXSFJUDU3S0Greh+BqxYZVFupJ0ICqSMbFA6RmxC1D/r
         yWJ2O1hneM8ohWwWt2WV/MtqswP08Zf51LMfiV75+7CUlcjO89BK4Q48sDPxgoFiJIim
         p+n2tBnK08sQYCbSPkZ1xOYbedMuPUUZzFNZ7pc8Dp4fyAZaF7KU0XBYqlKouppn5bOl
         V3nqEPEHr0N+tdUnaPYdKU7is1RQwBce2SK7hE0a/wsiVYzMagzDD4DBE7MjPeKCBiA/
         giy4a7rDQlZ1twSJjcYP14oAVUghmRw6Smvq4dnwAC9/rtSgSMciomMjl4n8dFx0Dt5P
         /P6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+RVryizvvLr6nOq3Y01zEZUNig98tyiJRX4i4NCALjE=;
        b=KsXpTfxcZAMB9jzNDx+wZ5NfUO+uCA5Op3ZvEhAGKcirH4njXbLDK8iWzSdXmiLgwZ
         YZM/2Qi1cdFDVpKHw2wlKKwiO1ZwaZS/mdPEmKaAQ1+bYBfG2SwgcRZcgEO7FJqwSZAB
         7Y4aSNX+p525cPqD4KKA0OQTBvzqKZt44mQCJ4X5g3D0MARba1J9Vk3VsCDOIwE7PPoC
         qQMV9uDBfQx63sEkEsl15X5iPT1mnRqjLYg+znsazZ0tHGZlshqMglWd+g+tWNuV2U4v
         hvz6MrEEsNsvzXi3rDrXLbN5HWlLZgcFTAS8yKCt3yWLJRP5iM2gUXUhtLTec4ejyVb+
         g1uA==
X-Gm-Message-State: APjAAAW0tukhZjZ1a6zUyT7lO1HF5uV5lW8BK28uubVtK4WMPyaf0YFH
        N0/GsS3qhQwzyzsnd9T2d4FX+ylIyUE4CQ==
X-Google-Smtp-Source: APXvYqz+k+DKCyLx6u8yFD/lhXNvSz7r8R5B7AYpL6tr89jvUAXXdl2KJWRHq26Q9wSIHCur9sFfoA==
X-Received: by 2002:a1c:3886:: with SMTP id f128mr4040369wma.151.1560436854396;
        Thu, 13 Jun 2019 07:40:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d3sm4561090wrf.87.2019.06.13.07.40.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 07:40:53 -0700 (PDT)
Message-ID: <5d026075.1c69fb81.edda8.8af7@mx.google.com>
Date:   Thu, 13 Jun 2019 07:40:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.9-156-g10f90b20eaf9
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 59 boots: 0 failed,
 59 passed (v5.1.9-156-g10f90b20eaf9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 59 boots: 0 failed, 59 passed (v5.1.9-156-g10f9=
0b20eaf9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.9-156-g10f90b20eaf9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.9-156-g10f90b20eaf9/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.9-156-g10f90b20eaf9
Git Commit: 10f90b20eaf9cf31c4ea0cbaf10dfdd807834a6c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 29 unique boards, 14 SoC families, 11 builds out of 209

---
For more info write to <info@kernelci.org>
