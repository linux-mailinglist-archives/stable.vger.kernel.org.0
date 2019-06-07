Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831653959C
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 21:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfFGT3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 15:29:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51931 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730234AbfFGT3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 15:29:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id f10so3131086wmb.1
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 12:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Ap2p4K3FsBhUMMLvzSSv6qGy6XWuBL+FfMivSOfqOJ8=;
        b=s5AxgnMWDpn6CtYOzZSF9hjBWFmPBtZaEZn0wUfZIB7ELojrTR2LQUSgfegfbL9hWK
         Dyu9kPxMVZdWzl0DYg0V0CGOqtDpDT2twfBZY6ZzcMt3RxybrsXK7JkmS99AwXFyW3vh
         N1gycoyii5hZ5NUKE+8fJMrVPAQ3L/lyx+ycwDCrCL1SggRk2tI5Rd9ynSFe+KipGN2F
         S//K6f2VOJiBAT94rAHPOPDGyr3m3nJwnZUN5EU69AuDqoG8bZtqIiswvsOMEXQOOyA6
         0Pyax0QZsW777YthmhXgjXo0tsgQQQ9Gs8sbL09h2tWwi/9Lk9XVkVT6Pl4Xcl2LSRNj
         d14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Ap2p4K3FsBhUMMLvzSSv6qGy6XWuBL+FfMivSOfqOJ8=;
        b=WtlwqGLWIfuHANaG/ajQtR459DveY7nrdgEmu95qQRHXf7a7WskvMh3fZ/G26WjJMf
         qdRZVU/0flGSm3bAxiOJjpjgSw5MDxZUPaBHHDtDdnfiDo+KuFjQ316lq2NyepsqsewY
         Cz86PZ6Kq7BaSB1X3ki+F4Am7S5OtJE3fN5fjfHtG4K/kVwTYr+qUug8mM7TWMUFB79Z
         TfMkdTXawsvmBBfKn98paFdtqgY+68A52bkFDBoUGpaTucm2IJSf8Hby3zkCv05348cD
         2GYzoRPUUaa6BfP2XJ+dPwrdIPcqVfZHzlPN/bxWqXjBW0oo/wsr4VJOQz9RzLP0gZZz
         Bnlw==
X-Gm-Message-State: APjAAAX346Q/menncXPOZLCzx8rPSA6crcbkRQsZbS1vpdq6kRIl7aCp
        RRVVhMKusQUaYSTyRwmh+uYoSjY3DDz9Lw==
X-Google-Smtp-Source: APXvYqzg8rN4XO2cEWlxa8W8vpTbdCYD+U6tzRJD13uX0yolhaXKgzY6lmmpxqR+wy8yGJR9WOBlcA==
X-Received: by 2002:a1c:6a17:: with SMTP id f23mr4626066wmc.91.1559935791212;
        Fri, 07 Jun 2019 12:29:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 128sm2810695wme.12.2019.06.07.12.29.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 12:29:49 -0700 (PDT)
Message-ID: <5cfabb2d.1c69fb81.8cb0f.1984@mx.google.com>
Date:   Fri, 07 Jun 2019 12:29:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.48-73-gbcc090cdcd34
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/73] 4.19.49-stable review
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

stable-rc/linux-4.19.y boot: 123 boots: 0 failed, 112 passed with 10 offlin=
e, 1 conflict (v4.19.48-73-gbcc090cdcd34)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.48-73-gbcc090cdcd34/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.48-73-gbcc090cdcd34/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.48-73-gbcc090cdcd34
Git Commit: bcc090cdcd3453e60d078bbce0f28dc4ebb8d79d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre-seattle: new failure (last pass: v4.19.48)

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-gxl-s905x-khadas-vim:
            lab-baylibre-seattle: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
