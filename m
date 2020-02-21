Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5383F167DD0
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 13:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgBUM7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 07:59:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46274 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgBUM7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 07:59:04 -0500
Received: by mail-pf1-f196.google.com with SMTP id k29so1151078pfp.13
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 04:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=294cdso95aWPgbfhUJIwWwUnmvcQMbMlyQX6pC1/bds=;
        b=Xp6HmDoOUzUfp2kR46eFqOK2ulcAJmRigN6jLkeimY3BrzlhUoGResujIdc8GkC5j2
         GLhbchoLgPG9UqvUvtw1WWJoA2ha9oB7YRJsh0hOU/I8wIZc7XVkErZ5yqNI4d0Wp0zY
         BfRj92Lp0tjYPCUTQZXtE0O+WyN+tS3oMuSMEIS8Fey8hQ6D1Nc4qmZJcgzWnWM7AbGZ
         3HMX/EMpW1qsH6V5hEW+tY3Yt2fcusz4o2I0HU2geA9zm5ZoO4Mq0J4tQLv+Mf48wZ33
         UUYUvcppdZNq1TRoxEhUAPq0oYCHoYdmenqtCtkokxj0/HM3EVngPKqkprvy62eHiNGj
         W1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=294cdso95aWPgbfhUJIwWwUnmvcQMbMlyQX6pC1/bds=;
        b=JbEyehocdjsZIclhw26pcNOJ5yDWAq5+FCVNqfvCX25Ub8Cae66snJHMCkDxYu22pT
         jogZ1e4/oLf/CnZY7Xg95WJNQc+womnAsBbqi5JPcaeIuWOtYjeNegUOurq3eiABjE7c
         8jZ5AH8AiF6MWxQvYtSRkhZc4N/0zK4VjRsVZmgL6EW4UIBXia9aRqhctcfH9hi5WA0t
         l1aqUFRIWta8lYKxXbAK+lo5itLMGWMzgerXPapjwFPa9EFzAzBvM8ttRnlvy3xr5VgQ
         87Fqq8abfGNdz6p8i2Adh3jqUzPPuHya0sLfSDm8AW4LyG+maqWYXwJNjSU9shP5limB
         F/jg==
X-Gm-Message-State: APjAAAUn+/aU0r4ra0e0EnCyKrIviwoGTSL4m+T56WoLH/1jd6wR04Vu
        c5y48nLxq0HkW8a1EBOi7Bu44pEwOKA=
X-Google-Smtp-Source: APXvYqyHJpHSTubUTEBDEwvbSTcnCigEcxzp2n1OgY10UTXTtygDo2+N8gmhe/SiPokteuS3fjijNA==
X-Received: by 2002:a63:ee4d:: with SMTP id n13mr2491197pgk.434.1582289943165;
        Fri, 21 Feb 2020 04:59:03 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f9sm2767189pfd.141.2020.02.21.04.59.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 04:59:02 -0800 (PST)
Message-ID: <5e4fd416.1c69fb81.b35f7.878b@mx.google.com>
Date:   Fri, 21 Feb 2020 04:59:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.214
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 13 boots: 1 failed, 12 passed (v4.4.214)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 13 boots: 1 failed, 12 passed (v4.4.214)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.214/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.214/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.214
Git Commit: 76e5c6fd6d163f1aa63969cc982e79be1fee87a7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 10 unique boards, 4 SoC families, 5 builds out of 129

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
