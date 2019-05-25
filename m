Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A012A743
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 00:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfEYWmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 18:42:07 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:44986 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfEYWmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 18:42:07 -0400
Received: by mail-wr1-f48.google.com with SMTP id w13so4902494wru.11
        for <stable@vger.kernel.org>; Sat, 25 May 2019 15:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TExgID4iEssrHvFExOtOBhfY9wq/7MEd+uaZmp2Hu3c=;
        b=fcQcLejUlBCSaAX+KEY2qB8l5osjgwDS5Ly1yf5csL9Gbz6dDYNEHSvxFWflbGVONR
         yssBfB7QbnK9/GLudNbcwN/NB3yP5AN6vYqUKvVxXwEuJg9cwVRjddWesUAGNGp0HcKT
         LYfgrEuARRyeaQMtfjL3CPeF246pAWucfV+qZqhqdTFzH4Hgd+2h/Ep/o+ITKIRLCuMS
         xl9bSQty76fSPBjOw8ub4ES5IBzaZGon755JQ4tqVUlty12EUpwqVw43MQUT+4uV7NCw
         ommnfor1gr2cjgCNv7ET8A1/WufzNKaeQHhorubMJE0QRiiSv2LeFbI+8aEWHrBqpiMc
         jgfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TExgID4iEssrHvFExOtOBhfY9wq/7MEd+uaZmp2Hu3c=;
        b=D8/f2ngQqlWxv6PknhQl0ijrGUNsrcAm3gDT41rdpBPUwpq0cC8smOVgwUEgB/0HEK
         NZ+LmtuDDMK05CVuuCJBJsx2Ox3gnnGjWSUR60FztTESz6iefgmFS/XR+SJx6LJJiioX
         HvXnHjK01nC0Se39TveVrm13XRqLQ+hlXWy/S+Pnr+0MzQuTPvf4sr8C2VVcqmy9lnBw
         K7GxDiF5/TjyZaHExQtJVnRZA29N5N2wwE0VWJIcc86HIze9TCKCZbj47RcGg+jWwbET
         idH4O/vGZLtOc++X9DIsJyF97M7/HKjsB14MIgKlafPDV1Q9ZkkLoLrLOJFo1wCMXxcf
         L0HA==
X-Gm-Message-State: APjAAAU1oNe4FyvHEgGVLeAWj7J/Jt6OH/yZ5OayAcf23QfpLUv5x2GR
        k+TnpNwsIE005nE+96N7oJ+K5I75euQ=
X-Google-Smtp-Source: APXvYqwmP1PKkhA4CSI4mFS0+k5lm6zCrL2kXDP5KR6aTkudQONotyjemolXgLx8VLkTI1Jqd23sKw==
X-Received: by 2002:a5d:6a8c:: with SMTP id s12mr3951246wru.326.1558824125990;
        Sat, 25 May 2019 15:42:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f7sm4698424wmc.26.2019.05.25.15.42.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 15:42:05 -0700 (PDT)
Message-ID: <5ce9c4bd.1c69fb81.25208.8b5c@mx.google.com>
Date:   Sat, 25 May 2019 15:42:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.5
Subject: stable/linux-5.1.y boot: 59 boots: 1 failed,
 57 passed with 1 untried/unknown (v5.1.5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 59 boots: 1 failed, 57 passed with 1 untried/unkno=
wn (v5.1.5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.5/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.5/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.5
Git Commit: 835365932f0dc25468840753e071c05ad6abc76f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 32 unique boards, 16 SoC families, 11 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-g12a-x96-max:
              lab-baylibre: new failure (last pass: v5.1.3)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12a-x96-max: 1 failed lab

---
For more info write to <info@kernelci.org>
