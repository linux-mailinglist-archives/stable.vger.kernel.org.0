Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297381746F3
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 13:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgB2M75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 07:59:57 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50562 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgB2M75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 07:59:57 -0500
Received: by mail-pj1-f65.google.com with SMTP id r67so2451280pjb.0
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 04:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cZkc2h8e28riQPC7hkq0LJyeMGEuke2sduRm+lzR1Ao=;
        b=KDqEcy27vpogOQHTRmhVG+bJ7COlEm0rGLZbHAzmjBMqbmtB1frc3Fg03WroAZ6Hw3
         u8GFnZ7Xx+7V40iUGQxcbV5Nqlmrh8K37YHNG00oPDO+mQQg3iV+6+WxzczDABG81qSB
         8ouGTN+387IDAvLiJmckN3/gZm+qVOcFhG2+07njDur+1agwoqJsBfFQ6lMIAUfv9aLb
         Erg3DPEPSCXu5pHgC1J1l98kKe+/dJi7gGMC504u7WwZpP48U+XR6HrKCN4m0FDFatuJ
         9w0kH4Ms9IWJ4Dp6+vVWZC5x2+IrQfHkYlwLCUwndc6HQY3PqM5Q9TS3vKxs7Ykjt/P4
         JDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cZkc2h8e28riQPC7hkq0LJyeMGEuke2sduRm+lzR1Ao=;
        b=YKVWnRSXK5Tmb+4WR7abw6Vqo+iMG+BbKaYYhV2Sxfu5DkWEH9e4+Gyl4JzZRFTKrt
         bhcY162LDABz9R/gHyjuvBLpG/9SslNxbRLqPwpJAbwi+8m56kYQqtT4mfISmH2pYow/
         4RcSBkrtHwamBRrc1+H29rFTXwyCE67hRDv3pTNvkaaPxAdZjVF5cA6GC+JQP18itpzt
         iF3npmlLMySdyy7CV7BbLneby5TDAzW0Gmtz1O8n9hz9pNR7Uc9wdaHY6825pXZDiNVp
         rnPf+JtgnGDPP/r0n20BwcK1uF172kOA17ksuhlsMPuga4tSZlSwVTLPM5AhFHX0VWv5
         tSyQ==
X-Gm-Message-State: ANhLgQ0RnV1x4GnH4SCjtWACNWeUjDSoUwHKlyEQeL6HX8yy1GQjggth
        spSx1N/IH+DHnE0YP/m05X2taFg+h/8=
X-Google-Smtp-Source: ADFU+vvT2cFTAYY0wfKkdA/Ta63HpscHRiFXWUZrBtgSaMAgG0TwAyg/gSz+sUs2VcKNin2VbkwoFg==
X-Received: by 2002:a17:902:7c04:: with SMTP id x4mr1335837pll.4.1582981196170;
        Sat, 29 Feb 2020 04:59:56 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r66sm15685767pfc.74.2020.02.29.04.59.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 04:59:55 -0800 (PST)
Message-ID: <5e5a604b.1c69fb81.71fd0.7d88@mx.google.com>
Date:   Sat, 29 Feb 2020 04:59:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.215
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y boot: 15 boots: 1 failed, 14 passed (v4.4.215)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 15 boots: 1 failed, 14 passed (v4.4.215)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.215/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.215/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.215
Git Commit: 1721173ef18200e8e8265568f13942d6e19c2c83
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 15 unique boards, 5 SoC families, 8 builds out of 190

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
