Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CFC13B806
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 04:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgAODDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 22:03:55 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:50843 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbgAODDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 22:03:55 -0500
Received: by mail-wm1-f43.google.com with SMTP id a5so16215188wmb.0
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 19:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XICYmEBDZTAHZSV3Ed1cU7oVv8IKBBHD1LsHV8ibNCc=;
        b=o3schYvf2VQxFz4mlroUV6XC4UCfullofh/y3u2WN2N4pHY6Z8C6ON2xegnsHn8zPO
         8XDjiAQs32e+IX/mVAUKhdnDsDgKD0bdIdJT9e5HiPseDGEPd797YrS/gl9REO9LMNTs
         40MFfnr7jJ2CYPBuOYHmmkzDgClVKqTWqNkQlEdvUmJINJ0TLYsesvQ/p+CawOp3yH4K
         tc1E3yTeS9afsRxLLXTgRsfoaRpkJNkCWkZYC7zCEKZeR6nsQobMuNY7OCxoaLVAl9JL
         zDQlNF4qV2+tsbT1BnJhztS44/D4Ta+mA5ZaN+Wv/jfZYVM8xC8WLmk3+6JMFP0bocaA
         jkcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XICYmEBDZTAHZSV3Ed1cU7oVv8IKBBHD1LsHV8ibNCc=;
        b=kzqXz5C8/4WpLRO+YBq+P52+ylDoD4fOnSGTEjp1D5sfuML+83XHWX7JbTPNDIWgw6
         vXieHeWGRQhTwaY13bB114SIOMKSSZjDhGkcH4aaJ7LhGAD/CVIYwUJtz6OG7Hey6T6h
         AQR6HLTKK4WXrOfwxeJx552Zd3uMuTIF07iuh278hxzst4leJqf9ZJ0Xk1KQ6MCMC0zP
         ltPAsLX5uxbPaAGRJkzHDFaAFY9+wvDyLF+++a/VkwBSNeYADh5gtt2/UnpbbCJ8yxvN
         ACVCp80PSFJ7s3FQmlxC/ZSbK9z8YGFOZiP7hN6uwKhKfCYjXqNnQKn9v9P9Tv+IADvo
         T11g==
X-Gm-Message-State: APjAAAV4zAoX469SbtX2jSCZTip8Y32uLGpCoge3AMI0/y5RdTkA1vgI
        ZRe6cKoc21hyEHuJYLAyFxAF5QCfXyA6jw==
X-Google-Smtp-Source: APXvYqzH98tJExkWnqVajinUrEtraudYQ+TiFa+68FCtunOGiLLMlIUO/StWHGU7pN+w12qLKLPHhA==
X-Received: by 2002:a7b:c775:: with SMTP id x21mr31050123wmk.59.1579057431974;
        Tue, 14 Jan 2020 19:03:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n3sm21536793wmc.27.2020.01.14.19.03.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 19:03:51 -0800 (PST)
Message-ID: <5e1e8117.1c69fb81.495df.b5d3@mx.google.com>
Date:   Tue, 14 Jan 2020 19:03:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.209-30-g87431e1e7f61
Subject: stable-rc/linux-4.4.y boot: 24 boots: 0 failed,
 24 passed (v4.4.209-30-g87431e1e7f61)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 24 boots: 0 failed, 24 passed (v4.4.209-30-g874=
31e1e7f61)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.209-30-g87431e1e7f61/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.209-30-g87431e1e7f61/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.209-30-g87431e1e7f61
Git Commit: 87431e1e7f613aa7991364a565f2a029380ac7e7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 16 unique boards, 5 SoC families, 7 builds out of 186

---
For more info write to <info@kernelci.org>
