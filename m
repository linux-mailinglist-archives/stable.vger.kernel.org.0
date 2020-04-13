Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFAB1A68FC
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 17:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgDMPgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 11:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbgDMPgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 11:36:50 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E1DC0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 08:36:50 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id h11so3496757plr.11
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 08:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZBhk97qXToz7HzuxXJSLiWKaUDDuza4k83UaqzPqJC0=;
        b=baLCvdO9QRzp3s+vpGqO4UBD19RS1wCfDi19eoGjWn5of5nP3l/ZAVR3cFkriwQDfI
         hoKnsk6yw+/do5dRMR6SDa/5NCRDeI6F964Q6i3BPXwtwfNKV1iMe1FUttu+RArG39Xg
         ca775K28qLte1+zwM+e6GCyneSn6ayOFHYtFOccs07k3tCclYKqFnuq+QdHfA2G45mX5
         rvEZLWmNVbCslwSt0A3PGNNRURhxjpf+YBOvOBdFnRkd0RA4BBht3dpAdJJ+3z31Dc+u
         gMr4DenQw0Ixq+L84RNyBnJg35pGCVqOWpD1ub+Jf+ntc+1oi/8nYJN/NODylxa8VEK5
         gZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZBhk97qXToz7HzuxXJSLiWKaUDDuza4k83UaqzPqJC0=;
        b=CC2Eg1bsfVDt6SKW9Yl9RMb0N1jSTecy1o08FGSIYI7czi7ODfFr6P7Hiy158VUdAM
         yA4r3cdMDzUJy2Ebd6SPPyLuSq1PIX0MMgU2O6d5nM2jpslE+khKJx3ZE7tJ1qfnO9Y6
         nyjsZr69FgoW8Z6jAhgFSFAc0TClpg4HWNZvTAQnRZocYyYIcudWdNh4bLiPnGqm6RoT
         IJPUQ7Np4GBBKgDuseBJw/ok1+sP5FemF8ZsHGicvJLdfm/6D/NxIx1Mkr9ZcoEMPS4I
         rHHbB3z5gHWzxEhBEpKTMhoWgCrY94MCVlmj7DVYAahX7rZUC25XMq7WNt+a7SCpW0g4
         +U5g==
X-Gm-Message-State: AGi0PuZnDgRCmbns+aObgBT7f/TmK3Mfql+jfvHs7Zhfzo0zDwhlJdNh
        EheydUs3kk4ih+qNd88zXho43UDIS+c=
X-Google-Smtp-Source: APiQypLciRMa31xD2j/Urke7/OPOMzeydjOns1cyntcGB3H62zso+qpJDzMn+FPTuiGaST18y5oq4Q==
X-Received: by 2002:a17:90a:be18:: with SMTP id a24mr21215732pjs.92.1586792209614;
        Mon, 13 Apr 2020 08:36:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 198sm9176578pfa.87.2020.04.13.08.36.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 08:36:49 -0700 (PDT)
Message-ID: <5e948711.1c69fb81.5bb8c.cb21@mx.google.com>
Date:   Mon, 13 Apr 2020 08:36:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.219
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 65 boots: 1 failed,
 59 passed with 5 untried/unknown (v4.9.219)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 65 boots: 1 failed, 59 passed with 5 untried/unkno=
wn (v4.9.219)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.219/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.219/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.219
Git Commit: 5188957a315f664d46ff58fedecbc0f7503f1b22
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 13 SoC families, 16 builds out of 197

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
