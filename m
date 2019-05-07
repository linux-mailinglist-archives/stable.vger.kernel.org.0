Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F4916D89
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 00:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfEGWfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 18:35:08 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:36043 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfEGWfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 18:35:08 -0400
Received: by mail-wr1-f48.google.com with SMTP id o4so24455228wra.3
        for <stable@vger.kernel.org>; Tue, 07 May 2019 15:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9KmZcvbM51Ahdr1a8pXzpoTQRpVZOoeydHZiJZ+kMlg=;
        b=x61ECrB02RDYkZbhOsKqYpOsbADIYJH/UkdDNUu6oXk5Z2cgaWYNepPBj46TsUrY8Q
         EtVsLqQMu+h1Bjs9JuDPZqmYuXW9JEggnivFBNUc0H5KjfTWrmDcvSXenDE8hFzlP4/p
         CDSBFGBOyKun90U3T386TumRGwoBXkgKjRFH7c4bOtka2HFiDMGy77jnkUdZXkRhUnJR
         FlZUOJCG74Lw2yupPtfKpXHYjK5nlelJQ6dVABI8e+X/Gx/APfapGuUdn2DbYphIxY/Z
         N2VQG59hKem3mthKzpvrqGd9etPE5jPltunSf0btS2WozZMIIcGkds3mCc/x+WRNCAR9
         IawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9KmZcvbM51Ahdr1a8pXzpoTQRpVZOoeydHZiJZ+kMlg=;
        b=ZI4RwE2ZHxTQxvsc3708OvL2Wj69qyC2veR80ygwAErMdTtluyYfARxyj2rJYt37yw
         r7zzThwXPVKiGMWk+acfk6IOxaNQxPuP6r32iuvvP1oEeZsBuMbBO6Vv0Ad9TYOJNe/U
         OwL7YsJXYC12HJifAUBn5jwWPaLj6SJyhCE0Cy72n6PEbPqQSI1zCAIt9lswFhYXoZrj
         iSWPsdyrozHXVFPUp77upY72L1dtXT7ydIBFUVESkC3smoTVgmU4Z9EUrj5cRA4o+mbX
         dy3+aRgQ6DBLiqQziMT4hIZZonsYiT5A9Dv0M4Z/cbmKk6dLcDt2UytfqsJDkhC71QPp
         aIkA==
X-Gm-Message-State: APjAAAVSbRljoT7GAfP8eR3sjdTEXH1SmRixWdDsW+62TGjHucT/kE9Y
        ORulK6d40+fHsfnac/BB3k0mYpXtccWE/w==
X-Google-Smtp-Source: APXvYqwGhf8YxM/VgjXGhaWDDIhCZcqDRhcuoZLCkOBKp95YnPlJxw/BN/f2QVtVr/gMmarPWT4tZA==
X-Received: by 2002:adf:f6ca:: with SMTP id y10mr4217845wrp.241.1557268506464;
        Tue, 07 May 2019 15:35:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t18sm28475746wrg.19.2019.05.07.15.35.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 15:35:05 -0700 (PDT)
Message-ID: <5cd20819.1c69fb81.a79d7.6a21@mx.google.com>
Date:   Tue, 07 May 2019 15:35:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.116-76-g2e004f6acb80
Subject: stable-rc/linux-4.14.y boot: 64 boots: 0 failed,
 64 passed (v4.14.116-76-g2e004f6acb80)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 64 boots: 0 failed, 64 passed (v4.14.116-76-g2=
e004f6acb80)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.116-76-g2e004f6acb80/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.116-76-g2e004f6acb80/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.116-76-g2e004f6acb80
Git Commit: 2e004f6acb8062e310cf8e50c91d562d91dcdb73
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
