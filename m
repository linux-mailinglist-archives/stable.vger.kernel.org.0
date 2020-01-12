Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9ED138469
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 02:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731870AbgALBTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 20:19:02 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37743 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731867AbgALBTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 20:19:02 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so5269948wru.4
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 17:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L5QS+6uB0v5haeHsBrYX5yXS4ZS8JN19nSwhG30brEw=;
        b=BlORCNskG0gGZABunIcIjGLmjg+IlUt9BXIPscXqERLrCwCNE7M4gN1dZWq3CXPDHf
         tvdov2W92yKiP3kIjlA6y+V4HTTTqRFYTOARfVcc/YZunsnXwFMwetVkHQ0ouOOHeaOQ
         4Gj9h4FCNyoF1LILAxkiY9Zlk2Fo834wmZIdLiwbHRwkY8xVvv0j7V5X/cq6Ij8J34Lp
         eiucvlQjIwynPp7cK1OV4ZEZWdAMrVUSIo4/cHmb0HrSbPlZMSaGaRQddBHUP70IKpr2
         vNM+QY3FOM24fR8GebPXezrMprjV6ApqZ8BfrkCDpOU/sLnx/HP75VV03jyHf/J31bti
         2GtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L5QS+6uB0v5haeHsBrYX5yXS4ZS8JN19nSwhG30brEw=;
        b=ClpOGzG28buWShDx6P/MNSVQ//2sCiPadOaHV/WeZQATViuo7gHPMwD2JIXAxqOdD9
         itjMx9QHBckkKhGuSyLvY8bLhmoL/pEmkbAJysJ28Yt8GI1U/LocvHUr3KJ8mKlVUO+q
         NNCl/BdON5yH5IizX8n3q82+rsruAC/ppp42hA1wcvNY0lVsNIJzAZl9ec4dzHK+RDF8
         memIIeabka9OclWAL3WRZ/Dns/SBUbEyUUlvOBP3PW99H0R0c6PtymjjkuFVP5C6eJ/6
         OOFJPFw5UcvPgeRM0+t7jCZUIjIZUzBu75fdGGwKCjK11+OyaMkepKJkjKawqbceC6LP
         Zhfg==
X-Gm-Message-State: APjAAAU3Hvc3UJtZyMhxQwCh6wPwQIfBa9bk0/fcqcBf9a3ku/Hy+Noi
        yHV2wm4KxNVIoaSVH2pgECCn+QeeE61PhQ==
X-Google-Smtp-Source: APXvYqwIeIjsV25sl1I2IA5MLeBBPC9PjWNDwWbqe4/OQ1+iFgUenqMRhWDkKyYN9Lrg/cRexdZ20Q==
X-Received: by 2002:a5d:4d8d:: with SMTP id b13mr11477460wru.6.1578791940297;
        Sat, 11 Jan 2020 17:19:00 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k11sm8033677wmc.20.2020.01.11.17.18.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 17:18:59 -0800 (PST)
Message-ID: <5e1a7403.1c69fb81.89099.2014@mx.google.com>
Date:   Sat, 11 Jan 2020 17:18:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.94-84-g4f77fc728c70
Subject: stable-rc/linux-4.19.y boot: 80 boots: 1 failed,
 78 passed with 1 untried/unknown (v4.19.94-84-g4f77fc728c70)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 80 boots: 1 failed, 78 passed with 1 untried/u=
nknown (v4.19.94-84-g4f77fc728c70)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.94-84-g4f77fc728c70/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.94-84-g4f77fc728c70/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.94-84-g4f77fc728c70
Git Commit: 4f77fc728c7082f1c925966660d42fcd34780e6c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 16 SoC families, 15 builds out of 206

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
