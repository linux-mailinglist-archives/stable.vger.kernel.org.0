Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B1F1A69FD
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 18:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731613AbgDMQbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 12:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731558AbgDMQbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 12:31:35 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30CDC0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 09:31:34 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t11so2710187pgg.2
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 09:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FuvJdPwa3ME0Kt2NPp4dY5N7Fph4FrdNwfxIr1vK8Rs=;
        b=tHlg/oVCkr1ZD/JjBff/CtamkVeqaw/nVJGhb1U8VFoJul9ijvODO20FUI4EoZBHWi
         3MHGI6XhiqFbjjlTO7ba2cmc7wcyLBVsWw7xvY2mTUDJfGmiBFUEsZMH6y9ouQ8W1vEO
         PX9pdj18ae5DMKkS7CNfH+Pem2OqAcjb12AQQoGnCnSc9pbr0rS1To6tWt0JYF8aVJU4
         U2s7BDP5KKPpKdRBALGhidubUcqfD65IhgdVI3f4312dAzSUOq1OZbydQhUqRhGHnUFY
         i9QgKI/W2waLZlrdfnuLyVpVvU2Vs/Ryx8uAibfPas5sh+kiMSrwp4acDz0V7eNHJKaf
         YQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FuvJdPwa3ME0Kt2NPp4dY5N7Fph4FrdNwfxIr1vK8Rs=;
        b=CXyeT1y72pvpUFvG0CjCR0IVNhlW9RypsBapo8NUogcNIXdIRCCjyCp9XCaNp+N4Vx
         ke0H6Rc/74Z2Po6+quEChsGRItR/FVV5QadhKPSRqirx5SiIC6Rms9U01IZazhVufu8p
         UK7O/Knz1Tv2ulJ855GPqM+UjTjqKL3aesCrAMb1fMJ+1gh8pkjlnF7nDvuQ+dDm4cf0
         ngOc3Q0Y47pKqlPNGt7rFYKQtvuGW73FzDz2jxZea5nKECMkFH2avFN93ZMBMyFKXBEf
         E0x0UeBjqR4DgWDLL0gJc4AR2UEzob4z1kLDLPOn8YS45CC3gFj3GZtzYCZ7A5qtGA/5
         briQ==
X-Gm-Message-State: AGi0PubdJE1RjRWFeJDRgIh+IsJ/+O0OmhyrjASl0ubjbX/jh2/SZqR2
        ZCijeiU+HF9JVbTyLmmuD3w8nsQkwmc=
X-Google-Smtp-Source: APiQypI6wGofB0XzQhqtKpeVT+TUthv4vB+UmU9NXXCpCLAyPMwoSdps54EMvtqIS2KV2DlyaNJxKw==
X-Received: by 2002:a62:5e86:: with SMTP id s128mr19475201pfb.157.1586795493981;
        Mon, 13 Apr 2020 09:31:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x16sm6480077pfm.146.2020.04.13.09.31.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 09:31:32 -0700 (PDT)
Message-ID: <5e9493e4.1c69fb81.2ed7a.4777@mx.google.com>
Date:   Mon, 13 Apr 2020 09:31:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.32
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y boot: 103 boots: 1 failed,
 96 passed with 6 untried/unknown (v5.4.32)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 103 boots: 1 failed, 96 passed with 6 untried/unkn=
own (v5.4.32)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.32/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.32/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.32
Git Commit: bc844d58f697dff3ded4b410094ee89f5cedc04c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 64 unique boards, 17 SoC families, 17 builds out of 200

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.31)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
