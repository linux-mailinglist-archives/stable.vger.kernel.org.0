Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08ECA14DEDA
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 17:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgA3QRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 11:17:54 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54010 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgA3QRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 11:17:54 -0500
Received: by mail-wm1-f66.google.com with SMTP id s10so4406153wmh.3
        for <stable@vger.kernel.org>; Thu, 30 Jan 2020 08:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4+jdbqLJ84+5Jh2WZdIcDyGApYPJiRSJpexDPvm80qo=;
        b=uT1nivofpIoNuYqFGE6+wsmXI0DtzcDwfBJT4LLcrMYEaZRnK135LTnzobQuz5Owag
         TN/Is0wF7mEJD55hXQloLcSykT3qYjGWs3Sfa4FUoZEutn4aRIeeJ2SuRkaRzo75mpQO
         bG7QzP73dcy6Ms3UFSlV7vkWzefm1waC5gIG6IjgkMrxPGiVrI+qyQP4QDS/KgajRmtf
         aMqdKSuMysxYkO317jgmlgoqT9jGM00kAjXNnOIy9QKqrB4xNZbIKybPp5wRd6VS3s9b
         ZH9a7t6lqLrU/ye3AF3ixoEQ6IwoDTXp1dwUYfAaRWifWRLqXBKY025qILMGsw+aXFFc
         ej+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4+jdbqLJ84+5Jh2WZdIcDyGApYPJiRSJpexDPvm80qo=;
        b=ZZQqfSs80StcktuaJDeIt4Q+FfT0WgcYmKgh7SNj3oqwMud11DDKP0yoXWYbg2TiYh
         EWfubhmI4Tb7dhyS1+qp/xvHj71hTSdhZZBdNq77xCGvqAx4jM92eZBtg4Cs+bD4JVPp
         3t2jXQeUcHxzXxfYyuHWq5uVoYYAXndRB9UTeUlagKqLR7E2XnT2uD2x+XV9k2M12Uwc
         cgN28EpQtrN1JinrC+TsUtWSrbuyry8sQltnrq8uDYCJLw/MFpw/bVfxLCQFsjMcuSZJ
         kzS2XbESMMRkKDkxMQ0Ojod/ashR3LpOsuo0esD0P0SAbkIBwM0bK+z8FumZNNELOMsO
         m9gg==
X-Gm-Message-State: APjAAAUAerRGaRWbSJacgdEqYXGQX837kU3wRBuyY4I6vTK2iOkxu6N9
        iO/ukm3bBNV88rCNHzHiEZ3sNAkTUJL0ow==
X-Google-Smtp-Source: APXvYqy/DKgWrRNpCDYwbhNLSuYEAMxszQ+CcfWCXx6XMyjp+hCaP42Fu2GzYduxpL0eHOousNDghw==
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr6474861wmi.104.1580401071761;
        Thu, 30 Jan 2020 08:17:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w17sm7567338wrt.89.2020.01.30.08.17.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 08:17:51 -0800 (PST)
Message-ID: <5e3301af.1c69fb81.39e5f.2012@mx.google.com>
Date:   Thu, 30 Jan 2020 08:17:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.16
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 65 boots: 0 failed,
 64 passed with 1 untried/unknown (v5.4.16)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 65 boots: 0 failed, 64 passed with 1 untried/un=
known (v5.4.16)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.16/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.16/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.16
Git Commit: 60b6aa2b71efa7e0bd5393ce292ace4a0cf2e71b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 11 SoC families, 8 builds out of 186

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.4.15-105-g4acf9f18a8=
fe)

arm64:

    defconfig:
        gcc-8:
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v5.4.15-105-g4acf9f18a8fe)

---
For more info write to <info@kernelci.org>
