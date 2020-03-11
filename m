Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524891816C5
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 12:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgCKLYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 07:24:47 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46333 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgCKLYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 07:24:47 -0400
Received: by mail-pf1-f196.google.com with SMTP id c19so1139974pfo.13
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 04:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yMT/rec58y6bA8QOMgtfR9wuTY4xYwdPWMKqkysrs/Y=;
        b=G7nlHYqjNVMdtOjgr7bP5nWKQkwI7beDhVUWC+LMXtg2SqFDc6Yby4ycJvcUjf5nPR
         qXp/GrG9t9d2PFDE1LYdxY2kK40wTwknq2Q33QVxaGwDONoKBWXUCV+uLWpr1T6vUUJX
         JvZFNvPwWlaBFh6n2eUQ3yLTJBg0FES+R9pTG5ESRa3vTF7w2vvqXsZfQDmwJbPY0ahr
         f+FkG8EJix+eyel5C+KKVuAZvmZwMD310rNzOYFA4GpQNUTf2LSPrQsJduusE57Yi8Dj
         As5nGFXg84fUez7NHuClEMqVyBHEwpZicsOqdIJPpN2eywi05cgWgQLHBNAn+urDhpYA
         aXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yMT/rec58y6bA8QOMgtfR9wuTY4xYwdPWMKqkysrs/Y=;
        b=EYxZI/Z1/3cn/JQsdTQukIxYRdyNS51c0A8Ei0bc7Whk8MrTCetaOnCJ5JUT8uAWuV
         7lw+qDe4qEBa16NmHv5g/HZ7p1p/6gJe1SS2uTd1nBXPiCV2gjb2Ydo6cA/X24ghnMpb
         ThyikYeHpxJ2YB3xmBuYT2aoTD7gnOd5GG+lMnAY5DrhJ9S+sDt910ZGaGkdu8BZxdph
         JXVRs7/CJTA7wt0Od481YptkkMz90gCusgasgEdXmeYoyeyuPnYFoiqu6jo/5eFYwXrl
         kan8GCgHyxO3lW7kXW5Yiv5Zx2riPIz2bXDW/LoryWruS4Ui+01JkMRRxGiREQp/lCsv
         GViA==
X-Gm-Message-State: ANhLgQ0pRYUP7ESX9q8x9q6mP4MB8Qg96yz1skUU0bhM8swrpaOz3YWY
        28fKhGxVFVVu68BEnhGP0aJH/K7/qg8=
X-Google-Smtp-Source: ADFU+vuYlbdudSZy8WWkVW/olWz96npPt2OFjjxpJdYzcOA27eIqYz5Kb/bgmgzr7HMFkhhOccJb9A==
X-Received: by 2002:a63:180c:: with SMTP id y12mr2530578pgl.120.1583925884030;
        Wed, 11 Mar 2020 04:24:44 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w190sm301745pfc.219.2020.03.11.04.24.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 04:24:43 -0700 (PDT)
Message-ID: <5e68ca7b.1c69fb81.e8213.0815@mx.google.com>
Date:   Wed, 11 Mar 2020 04:24:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.216
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.4.y boot: 15 boots: 1 failed, 14 passed (v4.4.216)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 15 boots: 1 failed, 14 passed (v4.4.216)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.216/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.216/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.216
Git Commit: 6fd21f1d7907d9cfcd406bc64935aa00fa100b66
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 15 unique boards, 5 SoC families, 8 builds out of 190

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
