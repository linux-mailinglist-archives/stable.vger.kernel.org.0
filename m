Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E886F4395A
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732320AbfFMPNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:13:12 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:55727 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732269AbfFMNfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 09:35:04 -0400
Received: by mail-wm1-f53.google.com with SMTP id a15so10224861wmj.5
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 06:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QjokuOejEYrH4zgQBiDBajZ8DurYYyh+ldcBT5bvFUQ=;
        b=gGDRljp3dVwNPIz7BEXi2uyNcoFaR4KHhTB4d5Aj3g/1wnuiMdjIefolAcuJH3Q53R
         JSY/p34cjBedbyeTZBdwCfU8aXKutF1qlc4K7K3o28Foe01C5of2fcNpg8iKaV8L0/aG
         DL9FPOsBN1DlF9KPxp/2MfkZjdu3Zr3go6OdqgOZrBQ8ij9TAdIJZp1uqEKHujSKFYc4
         ucvTTKwUCwes1X99tYVGbeISDz58kzGHQBNbP37FY6KXfnWyGL12uFucGYLwq8XZdiSk
         onURnZ5jWkktlqZXs5qPZsRGmMyKjO6X5FkG/d8Tz1xcFKqG1Q+oerdOfpgWJo0mbpcq
         0wgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QjokuOejEYrH4zgQBiDBajZ8DurYYyh+ldcBT5bvFUQ=;
        b=X7QTWK8kqJORtRAuB5urwFCRRGgEaUUE8JKwJm0e7ImKzt54Whn3hG/GG+2/d5oCJQ
         clWgDR5V8yn03mCpLes1kSC3xLBhODmmyR3oYlYYdlF/lbVeZDzwb8blFVSoQKo13DI4
         fenJ19fvkuFeg3MWDPIFc5ILaP3AlPhrUzAAlGPpYsWT6DZRXRG9x619qToj6O/yupOm
         yc6tzc7QKj69SMwY17YNShtFlkBhHIEKHW2gOZZi/2vBDfaDxCutBFxQbjuW1O/24B82
         hhBNrDKFP789sWz6iFTsQThdywo5+7d10WsBULn8HOIp81Xm9cdX2J1nUZPyDXvSs20u
         wkOw==
X-Gm-Message-State: APjAAAVMS3T3xaYluj43cDZ1EZDGU3cKVHFZEN1Z7aRcgnsSOGtkZDtG
        +uCIzVv/Ecpy2OiEhxUAV16QQOo4upQVFw==
X-Google-Smtp-Source: APXvYqzCF0eDmVbRfrOlfManwPl6veAJzTk6hpUCxiiLRZRnUrSQQjUhzDG3z0SKiixFbWMFll5Cjg==
X-Received: by 2002:a1c:968c:: with SMTP id y134mr3640323wmd.122.1560432902123;
        Thu, 13 Jun 2019 06:35:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j189sm4355730wmb.48.2019.06.13.06.35.00
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 06:35:01 -0700 (PDT)
Message-ID: <5d025105.1c69fb81.749d7.835b@mx.google.com>
Date:   Thu, 13 Jun 2019 06:35:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.181-58-g5e1c6cbccfd6
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 101 boots: 1 failed,
 99 passed with 1 untried/unknown (v4.9.181-58-g5e1c6cbccfd6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 101 boots: 1 failed, 99 passed with 1 untried/u=
nknown (v4.9.181-58-g5e1c6cbccfd6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.181-58-g5e1c6cbccfd6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.181-58-g5e1c6cbccfd6/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.181-58-g5e1c6cbccfd6
Git Commit: 5e1c6cbccfd620e6ba7f563b1156baaffcf86656
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 23 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.9.181)

Boot Failure Detected:

arm:
    qcom_defconfig:
        gcc-8:
            qcom-apq8064-cm-qs600: 1 failed lab

---
For more info write to <info@kernelci.org>
