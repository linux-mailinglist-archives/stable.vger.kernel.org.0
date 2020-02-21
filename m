Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA811167D73
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 13:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgBUMZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 07:25:44 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41852 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgBUMZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 07:25:43 -0500
Received: by mail-pl1-f196.google.com with SMTP id t14so780639plr.8
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 04:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2OsEJ59i7p8Hzd3dXKRxtFSEcJiS51N/CiaPxjGXG7Y=;
        b=sBoZ4Znm40H+OoMBBVXJrjBmUMoWUVuOWnVH2QmUcIyKkhfzSItVZ2R2kOtXoX2feM
         9mHM8BmRAL0Gl8CKX4fLloNVgXVhD2TahnzhCd+F6XNzmjPEI40gvyt4yVsXT1zcvlJ0
         pvO5w4jCNg8glOy1YgEyKjr7NWnvrujbjUwhvQ8T9Q+lAAGFmlGBNX1mDEQ9yzldi8ti
         Rr7vS0bIf9BmWgfUQN0UZfrnLKRTruFne9YQV4ssQ5TM/NO1ccwDeaFmXGNcmv0QRVdZ
         k43eYIvcP8RT8s69yysRisxgmjJT6lJ9WhQyRw1I/I/t6tibtcHOLHMkrlcuc3XlxLSS
         CW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2OsEJ59i7p8Hzd3dXKRxtFSEcJiS51N/CiaPxjGXG7Y=;
        b=InSH3K5YSM7szcWaPSft9meyh/Mbu6ysKjsDq5t0f4j01FJPh/CWhgMw56W/luze8Y
         R+4FhWCHQE1EE2NiW6YYJA4Fb0FyVNzZnmBME4SW4a+jbhnMznDoThIvF50Xh+wv3gqx
         S19waK1nTbzXEZj8iN3YfxA8MEMrwpXBpyId+StPSChhYu6k9YpLCucBGPdwzJh2SfXP
         8ON5aG/gHDPMrJAY5C2U8ICAAFeVGYbtYbNpVKeY2iU6tbcEJM/zlJndfu+g9LkBgbAe
         r+mJSM2AcvHqTCVZGF7h79mwX8hRBnsSWE7eNqPybxTzBTMKP4sHkxjd8ex+WLJS1JGI
         FRTA==
X-Gm-Message-State: APjAAAX2lOQZ/DbU9hpmH/Ssj+myg80ESjhenjS5KV3fOpxRQOzRd6ly
        /wewqKizVHvGiUhcGyhzIf8DYrkVbJw=
X-Google-Smtp-Source: APXvYqzkPLBR/tkkGqRvpBzY9T3Gvt7ltsrHtfMgH2vTMOHvDmLc2ZmouvXRztgiBLcevIpTZfl5Tw==
X-Received: by 2002:a17:902:9b93:: with SMTP id y19mr35896158plp.89.1582287942848;
        Fri, 21 Feb 2020 04:25:42 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c68sm2809670pfc.156.2020.02.21.04.25.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 04:25:42 -0800 (PST)
Message-ID: <5e4fcc46.1c69fb81.22b78.89e9@mx.google.com>
Date:   Fri, 21 Feb 2020 04:25:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.105
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 53 boots: 1 failed, 52 passed (v4.19.105)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 53 boots: 1 failed, 52 passed (v4.19.105)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.105/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.105/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.105
Git Commit: 4fccc2503536a564a4ba31a1d50439854201659f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 14 SoC families, 11 builds out of 176

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
