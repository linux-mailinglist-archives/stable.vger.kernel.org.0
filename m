Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBB56CD07
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 12:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfGRKxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 06:53:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45111 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfGRKxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 06:53:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so28133312wre.12
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 03:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=BZhk3I9YopZBEm/G2sJlkBFEM7T3QsUlbWV+Bwbj0NA=;
        b=BWijFD8GBhD5MqfyPTqAiklp09MzmdPIky5irjv7EobSKY6fj1PXOI/jYgFXaPCayz
         J1HeWnnZa2DsjuRgKTqjJT1zXn4oOdgHRTBpqoB2UpVdzu7MUjPLzaWiPsVYxb9obov4
         sAa8SpozBQ4YnR7LMtiv+eo7F+yvVhfp7lVKI8w6HtqlQoldwk7/cT7wyde4TCfMahse
         d4zdiazqrRvlWfp4ikj9VIYe+XA10dcDg/e7VB4oCfxUAdi5A+hpxWnDfaeQX6UVCTZF
         zDvRtkrgXtwm7rFgT1as5cOJjeQ4faBOUyJLc5wZLkHt8XRahu1fEC+8EIn1Qt3kz+sD
         Doeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=BZhk3I9YopZBEm/G2sJlkBFEM7T3QsUlbWV+Bwbj0NA=;
        b=uGXIWKJ0n46azq0L9lpgtTE36RZEHFlAoOdKBzIfHf5ChIBy7enHyJSWz3RLgme+8f
         MpxWWfYr4PXXN/fyV4MXVZv9daOzvk6xs3zv2reivKKpHFq/7MVLAdBwhVlLGIV4bgdH
         0EjKXxFDIpBN2q7LIAbee3ShTu4+6iGmqLKD6plIzoulveDhAGsdDdfduv85iBHqBQ07
         fpQntFxFL2xs7pjH0of4Cs5m+JHczfO2BGZ5VftHgXcYQ3WPAyHVNPHDCV7D85K9p5Uf
         UFpfzCuiE8gyCnN+s34wYnUy3/06TTqL57mMZatnrb11gE4tM5LZ3hara+5+K8f75rRN
         5U4w==
X-Gm-Message-State: APjAAAVx+ud7JHwkcAtqvvU62RwYOultEyHmEATX3D9uP7jM5081/ikG
        u5CNR5XRT1mcWzkLHXD+gQ4=
X-Google-Smtp-Source: APXvYqzyeYPna8D1rCeYUEkXtCOw/Opg2enZeAMkdWbeBInaRZ5Y0y5+oviVsEq8y6l/WXelx3R/IQ==
X-Received: by 2002:adf:dfc5:: with SMTP id q5mr51634938wrn.142.1563447221635;
        Thu, 18 Jul 2019 03:53:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w24sm22062305wmc.30.2019.07.18.03.53.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 03:53:35 -0700 (PDT)
Message-ID: <5d304faf.1c69fb81.46a14.a26a@mx.google.com>
Date:   Thu, 18 Jul 2019 03:53:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.133-81-g2c7e97d1f95d
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/80] 4.14.134-stable review
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

stable-rc/linux-4.14.y boot: 123 boots: 2 failed, 120 passed with 1 offline=
 (v4.14.133-81-g2c7e97d1f95d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.133-81-g2c7e97d1f95d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.133-81-g2c7e97d1f95d/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.133-81-g2c7e97d1f95d
Git Commit: 2c7e97d1f95df23feb292eb770c22e0b1472edd6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 26 SoC families, 16 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
