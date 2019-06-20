Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4FA54DD6D
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 00:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfFTW15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 18:27:57 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:38398 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfFTW15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 18:27:57 -0400
Received: by mail-wr1-f48.google.com with SMTP id d18so4596864wrs.5
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 15:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ag++18MM2w6/vpUxW7CWe051RRwuKEh5Ljl74q3jfpQ=;
        b=S+elTw4ICfIfs/wGtChoVz/773aZkEXWLPX3dLAuuqKUXL5WcnsnbEp1SM9dtnSSez
         Accr2nOiy5moolSr/B+8CySWC+ukScXsXQoO2z64BHn1bMxNySCMPmio7bWXOxRIdCcm
         r4aJJZek66VfCN8KHSQIolN+QqQzdSL2K7ylgqz726reH9luI70fe3APaBH/LXmul9xx
         x6yF9p9VrWjpQUOawakdjuEZYq8Nm0kElByn5eX0/rOAPS9Vl/laPuIatm8p9FLhMD7x
         uyHvCEzrLQCmfnUU2Dpuz2Cu3/ciLfINfZxxizAg6pJGVBVGsFhnmFPRGLJG/1ZiWQtQ
         r6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ag++18MM2w6/vpUxW7CWe051RRwuKEh5Ljl74q3jfpQ=;
        b=fpVsI5SvcNTgwPUNCoNbrk45NGIqT98d1vNU4GSUj3TY/lZg/59l4bJD66z6GITNEV
         uf9KcxVy5gjJsrN40UbfqOhiCZveJUXnmf2eCg/wsH8YUtVDrt8+2Ly83fijGlETJICs
         39kCgj/yLZ+zX6idaC0md8k6d1JXHyAt7xbHB0YcBMTyuF21lYj3e2iqiSFsqMDswkz2
         qdAmTbEfwiioCd68ZGgbp7HlOSOx7ugZZ5EMLcHnSy74Rya9UK6eCA3Lrp5PSJSovxlB
         3fTnkM3G6EX6DhZ9uqKYXXZa4IYC4rDMOwrLIpAGeKWfgb2A4at3CUfTkTpZ2hct0I5U
         XoSA==
X-Gm-Message-State: APjAAAX9Y+RIZKb1q6sv0+Bp6HqNBUAHwbkolLnrOkow7CIGuEomydmi
        oNJjulPPlJwfgtDpyM0D1I8lmc4yRflNCw==
X-Google-Smtp-Source: APXvYqz8oFfE9diNaPHjsyXQBykBeWDzP7CcHAf/QT1V24bZHAswQJoLHLN+2G+MNvknXWlB4Sji8A==
X-Received: by 2002:a5d:6389:: with SMTP id p9mr372613wru.297.1561069675494;
        Thu, 20 Jun 2019 15:27:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o6sm530702wmc.46.2019.06.20.15.27.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 15:27:54 -0700 (PDT)
Message-ID: <5d0c086a.1c69fb81.15d4.32bf@mx.google.com>
Date:   Thu, 20 Jun 2019 15:27:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.182-118-gb2977e94f62a
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 102 boots: 1 failed,
 99 passed with 2 offline (v4.9.182-118-gb2977e94f62a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 102 boots: 1 failed, 99 passed with 2 offline (=
v4.9.182-118-gb2977e94f62a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.182-118-gb2977e94f62a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.182-118-gb2977e94f62a/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.182-118-gb2977e94f62a
Git Commit: b2977e94f62a4008b6cc418f3af3c1a04ddb8ce3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 23 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.182)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
