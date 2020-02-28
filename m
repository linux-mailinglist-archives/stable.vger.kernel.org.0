Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1191172EAA
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 03:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbgB1COZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 21:14:25 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41739 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730343AbgB1COZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 21:14:25 -0500
Received: by mail-pl1-f193.google.com with SMTP id t14so588142plr.8
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 18:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1LmVDYZFGICArPV4TaCyIB0ajouwOmzx6XFxsLUR4KU=;
        b=TECmSBJ5GYKW/TQ2QAoAhxb9loTv6vzpf/anfYj6EV6uecXaq0we5RJSP7yMD2GkKs
         /8WKOKglgExrA+HFx2rX7QeZZuwCXzN5wO/w1dYX6tU6cSf4YZktzTezzc9U8NYGfEYt
         EiFajkwGNY/6l5zQtY82QlErUGSZbO+kFbT98RQPPKkBKXlZRF0K/eZ8yVKiyzaEzb00
         TZkOcmxAKfOSOz5oXZPY9Tka4tMXR5zqD/87sYw+zFBFUQbqETYmP2wT/sB3yJvClljg
         iPZcUcb6hSoOh3AZU0AiTMYo9dw7OcYX47zRfiGAOnPJx1KXWfnAKzmMx8GErSaPHnV/
         0wMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1LmVDYZFGICArPV4TaCyIB0ajouwOmzx6XFxsLUR4KU=;
        b=MBeZ4sIOViHguAFdNcaIFhfTWutSTJBnYHbp46zrc/jErrXil0rrzDGhzMFL0b9Ml2
         A9lUXcBGUNZTqittivuW1P0akNMdLUqPdqCr7INX8/kDi4gtnHqeOu3tbKlEiB5RyeMC
         KBPv/oNo0vh8vcUkX23ibiWYu33ZG34a7gzm5no5S+VuE+jiiZyu8CxhooPr15LcaIcL
         sd7aSVdW6eX1j9DEcQZVh5G+bJkdO/O2wX2/AHOxlK/h7f3HOeeAESwKsYHk9OHjLk5C
         GCG8/hFGklgqSXpwHa3Gt8BmtOqSLj3p32QqtkwotoMNzkVf2ct+vTrWUx/zB68c6fVA
         jqxw==
X-Gm-Message-State: APjAAAU28ncLEIMSBi2USK4KvolGpzxjLCSyvbuqXwd6SQJ+nIgI6TG6
        Z9UZLA0L78u0GLzRUcfwU2MsOG6eso4=
X-Google-Smtp-Source: APXvYqyUo25hYQfdj+IujcpTsn4Xc6AE7PvGwLKQcsEK/exuEiBAkCYgqMwSv1OLOLDyKmcwxzePgA==
X-Received: by 2002:a17:902:8d8a:: with SMTP id v10mr1741427plo.90.1582856064188;
        Thu, 27 Feb 2020 18:14:24 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fh24sm2403pjb.24.2020.02.27.18.14.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 18:14:22 -0800 (PST)
Message-ID: <5e58777e.1c69fb81.e6072.002f@mx.google.com>
Date:   Thu, 27 Feb 2020 18:14:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.106-98-g6ed3dd5c1f76
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 94 boots: 1 failed,
 92 passed with 1 untried/unknown (v4.19.106-98-g6ed3dd5c1f76)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 94 boots: 1 failed, 92 passed with 1 untried/u=
nknown (v4.19.106-98-g6ed3dd5c1f76)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.106-98-g6ed3dd5c1f76/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.106-98-g6ed3dd5c1f76/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.106-98-g6ed3dd5c1f76
Git Commit: 6ed3dd5c1f76bc99760b8d2dee47709961c3596e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 16 SoC families, 14 builds out of 205

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.106)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
