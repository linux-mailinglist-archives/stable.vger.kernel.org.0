Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423AF3959A
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 21:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbfFGT3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 15:29:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34235 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 15:29:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id e16so3255703wrn.1
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 12:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=sJ5T+Z5HRLuJZN0gt3pR40uH2qtZesjRQTuawwndF/M=;
        b=zCTM3bLb49tLuFDID+q7Aq5ml379wign8HtBm5CULMa/8I9B3ZuhuiW1vkDXn1CMqW
         db7H7jeN5QgYcg2ga6MJVcJPZQkhtYErSPWTTJX1GLCGH4xqEnjb+6ZBSwcyYtmqc6k0
         wpOtEegNWB+uQP1Kz4OqIyMcPdkC4y2LMefVyGwcBSGkrRSJASAlzLirxFUJ4wP3Uehc
         PFYzG1H6WqjXQnHLVPeMjkCFz41+zUNiP/pzL0xI5oQHfmchHTVmFcpf5sAnbmELB3Bl
         nQmz02pUl/jemtBFE+TjrHKuUwx0uMlggWUOV9v8WFhDs7PdQk3EUTafF9UyNMOUQKCx
         Wi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=sJ5T+Z5HRLuJZN0gt3pR40uH2qtZesjRQTuawwndF/M=;
        b=JeBMDNfzoLXALJuh43GvOnsZUJIhz4iGkvrctaK9uH3G2vdbi+j1JXmnQ7ztSPfZHi
         gjFBhcXvoq+bD5xQeXBLq0q+moCLYlEwn7uTWm6ltUlNQVw7P03kLy05b2O1lJ+xurKn
         W028WYvIuu0/goiPy9Zjqa9m28hXXuar0a6M845tusgLEJpTfuoU8R2r2F/tXl5QRwiH
         3IH3BMnSgQt+wewMHKPWIPzKVAqH2eiuIITtL0vP/CjGLHHF1jUJx4KFkF05kWtJCEIF
         T++TD85Q7y1A8NcgM1T/jlpHAaDGJb8Dc3jDpFCI+1YaSvQXjj5FpMF8WYi1L56H3Tv9
         SE+A==
X-Gm-Message-State: APjAAAVqPpVB8oUoXynMwS5fU75+i4Y5hZ7LwD7Zw2BoLR0AWuNLW24Q
        wcOwsOS1dLcMTtdQZSk8RINHtg==
X-Google-Smtp-Source: APXvYqwRUoQ7RSKk3VIfPGOjS4thqVpAybZDzwWNvjshWmv3BhZTyi0fdUvKd1A6UNTzP9WQsoZg8Q==
X-Received: by 2002:a5d:4bc7:: with SMTP id l7mr6678142wrt.96.1559935789901;
        Fri, 07 Jun 2019 12:29:49 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o14sm3100647wrp.77.2019.06.07.12.29.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 12:29:49 -0700 (PDT)
Message-ID: <5cfabb2d.1c69fb81.105bd.34f4@mx.google.com>
Date:   Fri, 07 Jun 2019 12:29:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.123-69-gcc46c1204f89
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 118 boots: 0 failed, 108 passed with 10 offlin=
e (v4.14.123-69-gcc46c1204f89)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.123-69-gcc46c1204f89/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.123-69-gcc46c1204f89/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.123-69-gcc46c1204f89
Git Commit: cc46c1204f89505a33f1fb42e719ae0c8586cb68
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 23 SoC families, 14 builds out of 201

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
