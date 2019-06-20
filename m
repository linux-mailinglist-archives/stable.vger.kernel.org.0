Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3174DC51
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 23:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbfFTVOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 17:14:05 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:51536 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfFTVOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 17:14:05 -0400
Received: by mail-wm1-f46.google.com with SMTP id 207so4414177wma.1
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 14:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HdKRiSB85LvUCFRxbPH+qwH2+8l2OVBBu3iiAsp64IY=;
        b=AF645dhMgoSfhYEfLmjEL3aDAP2bMMP1fubjmMPUMWpz1YzpLHPaZjUTGWGTuLUOKW
         hP4x4P13EHZuGMPfX05TCDK2GPY7XkX7pSApplUhJS9hRS0pJtXSo/LCxiNQnWKiDxoM
         1Wo7VUxkVi6Dr7nTLehyTW4j8N4p05lhYoB9U/uQGHkEJfAf8mO12093jNVqt0VnNZVg
         9q9YlzH1bSIO/JMMS58wLVve3kEs1A1GX2CEbPjvyGuOccn3nN6HiV2FxE9okGXUXO8l
         Jy1fIa5klaiXzShTTEIby+w8oAnLEXDoFOH2ES7oAHcNmvgCML7+x+lCdBaetqqoPlY4
         N4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HdKRiSB85LvUCFRxbPH+qwH2+8l2OVBBu3iiAsp64IY=;
        b=Dn08DHlJ8U6LlS08/Ma0F6VrbWxR+G4wGn18DpN3FjIQz6dVB7JcP/aa8GSpHQa9Gb
         QrBe7CHl0zM/E2sWZ+aovmbHZx/Rct82cxOOFKCSCcIjDRpN+/ZzuF/n00DMzBT2uiL4
         IFg8BnA6/jK1WF7ZgqiYwi7I+c1KHqH3d9KUUnBYROwcViOpN3Ov5o34ll9loy4EqWnN
         E4+gNqVzBlfW73n8QWcTvZd47AaS+k7nW+Aj3UJOHtssokbpQKZmRtFouCspBZNdepMQ
         XfW7Y1I2fn7n5ZArb3MVd1fqYYhy0eRsTZFTf9uNZsfJkjog9DH/gCEsP/oqZtEYakPy
         OdRQ==
X-Gm-Message-State: APjAAAUjvrSZypduYyR2hOolfRJaLl4sFeZ1N1g6Z1FH3qtBcPqMz0AL
        9Fmv2nbGjqLITc05ME3ORfdO9TDIjpkTSg==
X-Google-Smtp-Source: APXvYqwZfWhWPtznKpLqyeysgz9IUTr5bPtoEInI7nxwzngo9lFzu4VPpae24tR1fA6QskKUkBwvTg==
X-Received: by 2002:a1c:cb4d:: with SMTP id b74mr998936wmg.43.1561065242945;
        Thu, 20 Jun 2019 14:14:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d18sm1490953wrb.90.2019.06.20.14.14.02
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 14:14:02 -0700 (PDT)
Message-ID: <5d0bf71a.1c69fb81.8001d.940a@mx.google.com>
Date:   Thu, 20 Jun 2019 14:14:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.53-62-gf22a520163d3
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 65 boots: 0 failed,
 65 passed (v4.19.53-62-gf22a520163d3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 65 boots: 0 failed, 65 passed (v4.19.53-62-gf2=
2a520163d3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.53-62-gf22a520163d3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.53-62-gf22a520163d3/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.53-62-gf22a520163d3
Git Commit: f22a520163d30baac515fcced7eb7ae13dc78c89
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 17 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
