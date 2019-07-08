Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5BD6290F
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732692AbfGHTMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 15:12:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38942 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbfGHTMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 15:12:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so18340570wrt.6
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 12:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=LTYHuAcEiTADjXh81m7VrSjapv6hfDEK7BlZxV/EhG8=;
        b=lNEjFWw7RiFQpiRP7RdvDXvrjELwN/SwchYIfCIkS7cyx8/Dv8JDFvmALF3LO7d3ev
         uJwk8YpOqeE2KFfmN5Yn4lK5jp0ZHJ+s3gKo+IHzwVfTDkYt+8qXRF7eTdilViEQgx+r
         YhjGJYDV2G9W1GsI7ZfzIp8tu1NiZlu1Sl1E+Hh3ccqYf3QnjC2leGv8LD0CilHu/ltz
         63Uq5gztHnaWnaFX7kf29qppf1kDSvYuF4zTS/HcpWg/oMyeEUWJR6lGkhXv8NT3SR75
         hWd9diTYETZbs30J7jSGVulKg6NRp+jJvZesJjMK4GYtc+pc//QRriNviGDLbJGWismV
         YVpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=LTYHuAcEiTADjXh81m7VrSjapv6hfDEK7BlZxV/EhG8=;
        b=loUhHXfg5E7I1ppOoHuTqq+zdvoNrXdJJvOQJORJm3s2bVN9Cv6Ne3COaZjZsHf4Dk
         Iy7HQvAfWbKlfNYJR66mr3cxj56eyAFKlOS63210br8Z3PgonLZx/mjPWI7/Nj/W/ueO
         39wPU9GFpc6A0UjmGEJEIFYbi3jcMr6oXofFrmhPJFUhwFUwUpmtRmF8CxWqToCLOtiT
         TNSiaqI6NVyBJShZrLSFBjOximvPE1pqqF4BOpooZY9k8sC1/eUtCsavHVhEdRzyTcPL
         6+9+VDLKRjsaiUeT/jALMy4utmF6oAoabvDXSXlsXKh605GK7sDKY33qJ6+eU+wi/Yet
         fC0g==
X-Gm-Message-State: APjAAAUrkNj6mBYVsGBtvtNymNKUe15GwM2nfLvmi+V6CQfdH6VvmBR/
        MC43HFgeYExnsdtv/H7d8rXUST92fA0i3A==
X-Google-Smtp-Source: APXvYqwIErtox+EtBzu006KFQvcDop8wFxR1TDa7u/EFlLQncFEzRdfNQcWwtYnX/eUfTSoEklA08g==
X-Received: by 2002:adf:efd2:: with SMTP id i18mr17700304wrp.145.1562613161554;
        Mon, 08 Jul 2019 12:12:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a8sm341004wma.31.2019.07.08.12.12.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:12:41 -0700 (PDT)
Message-ID: <5d2395a9.1c69fb81.2106a.2001@mx.google.com>
Date:   Mon, 08 Jul 2019 12:12:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-73-g71b130d46805
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
Subject: Re: [PATCH 4.4 00/73] 4.4.185-stable review
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

stable-rc/linux-4.4.y boot: 100 boots: 4 failed, 95 passed with 1 conflict =
(v4.4.184-73-g71b130d46805)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-73-g71b130d46805/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-73-g71b130d46805/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-73-g71b130d46805
Git Commit: 71b130d468055291345db697052e5256d6e46397
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
