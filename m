Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070AB12F289
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 02:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgACBFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 20:05:05 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51921 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgACBFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 20:05:05 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so7129021wmd.1
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 17:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HQA7OXUw1BHoLY2vz9YnNyPlJl50CwewTquyYR4IWXU=;
        b=Z07sDoBwtdofzpMZVTzNPE9ay6MMkoLu0ulXUmQ//6tDo6laQx58mJfOU2pvW6G0wk
         9MdwSuHSEBEj8lAxq3NNMDg3vVh3DnpjiCtkLc+jfju0rME2EGoAKGwS4DClNIQaLKO0
         vUVQHtNMqsNfIENoAG+Y6tCBux5UD2FvLu4vVT1Y7Vgm4sriwB8Pl7VRXQxsmCYl+e+F
         H+ARZVpVsQPjQOyOQ5Pf64MtpKqgijw3gG/w85PetYSGeRilBurwQ8mAbDxwSEbz6hSL
         Ln+eujfTR4/fDhLTzfjc2Nl04Z7lc6t1lratbKd2x9KTQMOTevL5GcLf67wM4Nw5klJR
         bmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HQA7OXUw1BHoLY2vz9YnNyPlJl50CwewTquyYR4IWXU=;
        b=uCCQNBOj/ujHSAK1ByFO6uj72GBSMp0lVCOcuhSEYr3A13mKW9e1JmSde0qZcbIWp8
         QM5h49/o6VEXFEQFAHQK5JfwVPV7nH9tIuRudnsQ6yg4nQsiU8jd6bi/vqTWyHSUy72F
         LoO0irda+iIzNPBL2bFS9SdDDvnt1U504x/b1a/XtfG6+zNQjzd2NNP1jOinPTVxkTUa
         ujxmdC85MjuZ5O328ZA9dW75aTmfvOoqer4YGtZB6q64hVVw4G1CYvd3GeQ/ns3+HW2P
         mA6Eh5sZZMJDyKSym4DyX7sceLgysLiDHXmRKpqmN180c60F9aanyWyw47AWk/fWeWqu
         uAtA==
X-Gm-Message-State: APjAAAXIE9LSfrXRZunozgRCMJE4OJkMGJsNl7hh9DcTa6+b5M4XhOjN
        bQY9Tk3WekXqAOH9lYeJHImF12Sgrwqe6g==
X-Google-Smtp-Source: APXvYqyLIOCQvfN1z+xWKQAdqj/+gt1N7lqfGw5IjcJ5AycmBEWomaxge3E+CbmR25ZwPbfbGTpyoQ==
X-Received: by 2002:a1c:5419:: with SMTP id i25mr16730988wmb.150.1578013503241;
        Thu, 02 Jan 2020 17:05:03 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c68sm10047759wme.13.2020.01.02.17.05.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 17:05:02 -0800 (PST)
Message-ID: <5e0e933e.1c69fb81.8f71a.ddd2@mx.google.com>
Date:   Thu, 02 Jan 2020 17:05:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-92-ge09672e5ab69
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 52 boots: 1 failed,
 50 passed with 1 untried/unknown (v4.14.161-92-ge09672e5ab69)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 52 boots: 1 failed, 50 passed with 1 untried/u=
nknown (v4.14.161-92-ge09672e5ab69)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161-92-ge09672e5ab69/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-92-ge09672e5ab69/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-92-ge09672e5ab69
Git Commit: e09672e5ab693decf3286999c35a7c7b5b7e4a2c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 13 SoC families, 12 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
