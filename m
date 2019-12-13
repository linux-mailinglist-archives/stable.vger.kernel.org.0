Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E40411E4B7
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 14:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLMNcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 08:32:22 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:36051 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbfLMNcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 08:32:22 -0500
Received: by mail-wr1-f44.google.com with SMTP id z3so6675867wru.3
        for <stable@vger.kernel.org>; Fri, 13 Dec 2019 05:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+kWoOkG1cX6qkUlbNlG3Rgv/MjrvynAgtRzwL5JWl04=;
        b=zHbEidGmZwSYhGukKC28XIPrXC9W/EaIJCCdeJbKfh0CYtrR3FFDq+cSD7UIIVsc0/
         2zd4xY6MU6r0iPRP6M4Gef74g0GX4JDDdd39n3EHwnarXV70SBU3zgJRn5hpZbt2al5V
         mK/novBS3iN4FBPeNEVUD1W4a8WI27G08xhXgRWHZX3IAWcjbN7d/NKaX/xdeaeOA16d
         +YVWTTNkF6MX5aBuFRk1ah/1/P9F8TYBtwH5InM1fX83slmKPezc7aSGk5cvAjP23zFy
         Gv5PK1qCDpcbM8O/R3tkZm0cgJcet8C5vLnGGVx/AYX0EdQfZnshIdOQNwAweZGawOVS
         KOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+kWoOkG1cX6qkUlbNlG3Rgv/MjrvynAgtRzwL5JWl04=;
        b=dnkdHg3Sz7yEStp2u1tOfL1PF/360rAEXV/e06V8ldq5Swa127QhVeijb22cyxJWrp
         5E5gbdV9XclznyEL6qWl0muRRoOSL+zDQTpCNPXH2Fpoq1KE1HYIidblxmEWzOnMS+gj
         WGuplADLsPzb7fXk9gUpMDxw/A9tT2WIMKbPSdyVImTxug0FblZ0JR7qC1lLFdmj7W+2
         J/kEtHNnbYqNzfjgsQJv+ZLz8jhtyNGa0FnVf0u9JkCEHswTe4fD6/3pv3eQznV9Br2o
         4iZupCWcpHPhZMAx72G4bPfO4hXzUuKlqKkCd95ZKkUIVdEfoOLbYhD+wH70TJrV2htu
         ID7A==
X-Gm-Message-State: APjAAAXFKBJffH0ykI9mzK8sjX/bgfdjm3mIdz0d3NLvRgGq63XQRgL+
        u8YZn2aXZy2Udkt89tMB8x3aZ5VJsNR7nQ==
X-Google-Smtp-Source: APXvYqyApIQn6ySJubWLt2wIFJJ0dhhEO+k3Tc1Yp6j6x7k/Q2jfJKEEKPUT50P1rRFaSVTKmoeYxA==
X-Received: by 2002:a5d:608e:: with SMTP id w14mr13373290wrt.256.1576243939437;
        Fri, 13 Dec 2019 05:32:19 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m21sm2175781wmi.27.2019.12.13.05.32.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 05:32:18 -0800 (PST)
Message-ID: <5df392e2.1c69fb81.72d81.ab6c@mx.google.com>
Date:   Fri, 13 Dec 2019 05:32:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.16
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.3.y
Subject: stable/linux-5.3.y boot: 95 boots: 0 failed,
 94 passed with 1 untried/unknown (v5.3.16)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 95 boots: 0 failed, 94 passed with 1 untried/unkno=
wn (v5.3.16)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.16/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.16/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.16
Git Commit: 128f430ae9acb403059d02d9bbcbd9dcf52968a0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 61 unique boards, 18 SoC families, 15 builds out of 208

---
For more info write to <info@kernelci.org>
