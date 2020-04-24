Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DA81B6D76
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 07:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgDXFtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 01:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725554AbgDXFtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 01:49:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B83DC09B045
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 22:49:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e6so3526043pjt.4
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 22:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=szvhOiym8IsDmZjze8+779TyGI+4dQzwI8hadlTmsyY=;
        b=EBh6CypNDjxl/fO1x/rv9imy2HmmktsgcldNXrZy9jYnjCu5lnLNygMyL0kpCEW9r5
         tFXDh2cHi8AjOGW3YPTPmKFzwQgA8b81kEdGqCID03naVPcoDInsuVIiqDPZE0I29HVU
         hgRhG1ypkRkzjGayf7MLzL8WZawkmnp0yXdhYWARB0pGPPpVNXbsCtGsL13e2J0INWoX
         ThE1uJBCMcFlAEP1Y68yDrTTrGujHAVpT4DdPQunkdLj2+vbC88mFATCeud+c9pkxcnN
         AO0yyA6JZRe0L+5fHnjdNKxNdmWHapXPDW4qBnuf78wWhhghY6Ya7jwC9ZwkDRsROlCb
         350w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=szvhOiym8IsDmZjze8+779TyGI+4dQzwI8hadlTmsyY=;
        b=qiRnI5Z1kke32vIVvkhYZ38ioxpmaDcmeDk1ArnN3FdDt1qCiUc3hXKfcqUvBRCvSd
         GvzxwvZgffsE4VwC3aZh0Z/s7dusB2NtqAAvbFOe0ukmTBttloanfITKZFw0fB2jV7TB
         626dQw7pXl5OJUzsS9D6l4XxnqLqGcuqORGUF0CB2CPJXs8dh1N9qUa0R9SSBBDbOcbJ
         GB2R2TgfYbqgwE6Quj9cfBms0qIyZs8wVsAMDzw7eIQNo2SJqCFIK3qoSwnkBOoVzKvN
         vT9ifxx5Y0viA8HhCwDvffH9zAstipJegZJwBZ65033mhawKJsaQ/dvgFut61c2nl1A8
         7esw==
X-Gm-Message-State: AGi0PubDQK+/wcY8DK9vFicX62ebw15YT+QI2BdKZxexh0K+iXafAL8w
        a4hhvPT1u6SeCENmQHIZQPurqKQk4qw=
X-Google-Smtp-Source: APiQypKAsO4yWtvDtgy+f8RQczBQuM0RjA9oZYfvpXuy+PvoypFjKVrzB/pxROs89077alEEMxKEVg==
X-Received: by 2002:a17:902:e905:: with SMTP id k5mr2118987pld.232.1587707363142;
        Thu, 23 Apr 2020 22:49:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13sm4481758pfo.67.2020.04.23.22.49.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 22:49:22 -0700 (PDT)
Message-ID: <5ea27de2.1c69fb81.854fd.142b@mx.google.com>
Date:   Thu, 23 Apr 2020 22:49:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.118
Subject: stable/linux-4.19.y boot: 22 boots: 0 failed, 22 passed (v4.19.118)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 22 boots: 0 failed, 22 passed (v4.19.118)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.118/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.118/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.118
Git Commit: 7edd66cf61670d2d0c31f89cb3a247016e489a8a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 15 unique boards, 5 SoC families, 7 builds out of 206

---
For more info write to <info@kernelci.org>
