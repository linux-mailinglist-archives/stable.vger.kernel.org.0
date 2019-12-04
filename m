Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263B41122AF
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 06:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfLDF6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 00:58:48 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40669 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfLDF6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 00:58:48 -0500
Received: by mail-wm1-f67.google.com with SMTP id t14so6418269wmi.5
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 21:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cSw3dPHGA3PNR/ZTr5dwaXft0iBOZCtoxcCy6+bu3X8=;
        b=D/xM+6Uky1OhwIulM06x2ujZMdmHotep0ms+wtkZo1AcZsu05y/zy1mikCBe0wcIe9
         NjADbEbQTP7tMJiVpDpD4JAS4xBFngFMj3r44GmD7FdfHwNz0xCcU/avvnjQn9oBkAn5
         u7HnSw2fjMqwRW0M2qszYiRzzpGQmnYR/5JuT2FMa+3PQYOXJ73XR+RTVPCXMmcooucz
         Um7fgsPah9kwvxRToykArtqOuJNIMkKr5kiHHSoyLR0uvcquhn3eHgmrytxoWvsk+CPe
         j7PS/Ir3LErd2bQXxgEkxzFUROnK54vxP8pFje+ozHlhCPlX2x9NeYIH6KEwuYeqdyzS
         k8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cSw3dPHGA3PNR/ZTr5dwaXft0iBOZCtoxcCy6+bu3X8=;
        b=kzmqsQ++MhBEgOa4m0L1JECd+gXSfcO/XsH+k6SJjdnCrCJi0pKEXuHTuUsw/s6cdI
         rD6sKPGu4899Gf9SUun4nFYBKGr5owbGL9JG9ch63xiKQSa1yvNj/Ov4gukb+yPnP7T7
         i+fpSw3ibyBi2LltEzwDT25D/6eoHoYD6EjkiVBE0AR/mHJ3T8zSCLDr0X43dcv1EuOD
         a5kkjRP6BANeWprMmPrODcVgpxR3X8JGsrCsIFe1BVxkAB0OYdwAjq1OmrjdAdQ5+JdK
         OAmsGl7emgeFmlkyapjN8FjWn/TmNRcylpaehRMpAw3MDzcIh3iuzbpw88cY7j8CDMYJ
         IdzQ==
X-Gm-Message-State: APjAAAWHP1x49qYi5LRcGDWUQqzW+9llWhbiyHlUA7CVhah3PD/eNW+l
        Y+y0MG4qWzGZFRwEgzXcrfLrXUWNJVOK6w==
X-Google-Smtp-Source: APXvYqzTEzfWjhbH2zxgT610kKz0D2hF8WGSb5eDyEAH/hLXK0qspUUKw0P/TgjWcetvKo3C4tKehw==
X-Received: by 2002:a05:600c:24b:: with SMTP id 11mr722841wmj.19.1575439125779;
        Tue, 03 Dec 2019 21:58:45 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m7sm2100113wrr.40.2019.12.03.21.58.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 21:58:45 -0800 (PST)
Message-ID: <5de74b15.1c69fb81.2532f.884e@mx.google.com>
Date:   Tue, 03 Dec 2019 21:58:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.87-322-gc72a1141eb18
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 68 boots: 0 failed,
 66 passed with 2 untried/unknown (v4.19.87-322-gc72a1141eb18)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 68 boots: 0 failed, 66 passed with 2 untried/u=
nknown (v4.19.87-322-gc72a1141eb18)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.87-322-gc72a1141eb18/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.87-322-gc72a1141eb18/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.87-322-gc72a1141eb18
Git Commit: c72a1141eb187e8abd900aa76dbbb50006353596
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 35 unique boards, 13 SoC families, 13 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.19.87-304-g18087c2f2=
df3)

---
For more info write to <info@kernelci.org>
