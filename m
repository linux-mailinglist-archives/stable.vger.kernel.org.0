Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E38417880E
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 03:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgCDCHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 21:07:06 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35699 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgCDCHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 21:07:05 -0500
Received: by mail-pj1-f67.google.com with SMTP id s8so201166pjq.0
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 18:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5hdNoVMeDMUSDh4C7T7CaQtILzGzxWHOZsxijb+AT9k=;
        b=A4Sue3m1SrT7TQyTvGK6BOd6+JC/THHT9ej+HwlT3gJne7hr/6/SGrgApd83QXHjzz
         CSFQmpbovXU2v87L0UedNwIIoiX3JyQrwi+xWG4KqEXYUwd5DQuixJN/d6uFKqqgRwd1
         TBJ9T6hokH9i/MsIx2Bn1+4GrhjZC24x5kWZPXG8X9eVQfA56GtQ4XyFJJcFcHINxLJU
         cFsqmYvYv0Tx7eeOuowQvKwyx2EqTtANmaXgtBT87+8+cJK3Im2g0a1Kg9hJipJN7web
         xMTIV+Z1hGigqSA7vru0O9s+eIi9cDhkaSDMfnHMHfDkYh8HGpPjtXu/3bdCpJAF+0zC
         7j3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5hdNoVMeDMUSDh4C7T7CaQtILzGzxWHOZsxijb+AT9k=;
        b=CUh20tH3aNYg2ob+dZuSDsff4dEdnJMUzdc011e9bCEdyIxSoDgK+lY7EDK5JuCFpp
         3+bIu9cfl4wP+AHFkPIFCHDTwZvWwLXT7h1GHk/gzwM6/fJuojjpB2XYW+m8abGlxL3V
         IVLA4dO0+R/S7nspYSOFW2DMAixjeWkE1zm5Yq4cSSGHvAPWytVxWnrcb5N/uxE7SRr7
         lLb8ijAanNp5UnwIYq5tKefJ2N8/N26SwUqSMu4Wj/CcDmvaS6SV32MTeQv3sfOawbg/
         BIGxVLss+Ame14nGCEVUoRnW9xIlw46StBXFP/pf3XKqXOmifg0rWXrCG16gayiKUGrn
         jlbQ==
X-Gm-Message-State: ANhLgQ0T6O10LdrJryCNzf+VneoW+cfsA8gemMtPBdS3cdSlFEkQlSt7
        Oknj+NMyQv96UipKYxNV20I0pLena3k=
X-Google-Smtp-Source: ADFU+vshoWghpi4ubwU0Wr3psqA5tvVRsTzu2caQnVcHYYvlN5dnk6mVEnIHd0ZTd5LgVVbroGKHJg==
X-Received: by 2002:a17:90a:c78b:: with SMTP id gn11mr498078pjb.97.1583287624443;
        Tue, 03 Mar 2020 18:07:04 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z63sm25700693pgd.12.2020.03.03.18.07.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 18:07:03 -0800 (PST)
Message-ID: <5e5f0d47.1c69fb81.374bb.3f28@mx.google.com>
Date:   Tue, 03 Mar 2020 18:07:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.23-153-g1254e88b4fc1
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y boot: 73 boots: 1 failed,
 71 passed with 1 untried/unknown (v5.4.23-153-g1254e88b4fc1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 73 boots: 1 failed, 71 passed with 1 untried/un=
known (v5.4.23-153-g1254e88b4fc1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.23-153-g1254e88b4fc1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.23-153-g1254e88b4fc1/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.23-153-g1254e88b4fc1
Git Commit: 1254e88b4fc1470d152f494c3590bb6a33ab33eb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 16 SoC families, 13 builds out of 199

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
