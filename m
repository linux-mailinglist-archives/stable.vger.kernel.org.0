Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB4413D1C5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 02:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgAPB5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 20:57:46 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:44378 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729615AbgAPB5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 20:57:45 -0500
Received: by mail-wr1-f47.google.com with SMTP id q10so17551230wrm.11
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 17:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c5y7wytds/SvQ/8ZCY8ukZZ6AVluMPob7gRMJL99dJo=;
        b=z2iwzKPdrUIFpSAYGM49oQdrWMw4MSEWEmaxm2Tm4vOdD37mLjME5HcCtwLUCychrn
         OXIH5tTVlAlAXUYKxiZjN759qQQs0768EAlSv4O/npahFPkppemdNtcqmjZyXobcQk+e
         F/Dzdo9n5z+WmhxOoTDj4u2CYBUh4jecjYlFuXSOllRPRdAHaAqfMDzIyKHP1gXa/6kD
         daSso+wsopsqLvF90nqkIUDs0fMlcTeODohWb6iNE9Isofei5YGCgmuOlyaC27iC6sZB
         LlzBBNBWpIObbEXgt9h6MukD2nXjduCOOB/7/bTOo4xoN0fgQYaLe1+P9m14GD1zGclQ
         vEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c5y7wytds/SvQ/8ZCY8ukZZ6AVluMPob7gRMJL99dJo=;
        b=W5BxPl41lw4zLnYHWNLBX8x0TCg+dRAsL+yQ32pTqTflhQ1p1zIHmMQPLD/hkHKHrr
         tmGQ4GDYiLfz4a3lfgqOGYl0kMqT9MURMZ/haY516sQlUt/VO9ka/Y1/RvBukFEJU3/J
         qxSpMrp/06D8VPyyAN32PGEhznd/to0o0zHxn2adXg+CF07QKB0rL4x+J4emyi+LW6/K
         K+yxIzwZX0Cy+o3ETZeZua7vVcHImZKP0/INiR5+clWp0qhhJY3/bz6Go3E+zOOGPeTx
         Id5vDVrtqFCuYPpYA1aHup4l06fDVMx+CH3gKBFdGE9YxMmOGNdT1XarSFd85TQdIqOT
         Wl6w==
X-Gm-Message-State: APjAAAX2xmhvYMVqKADGchhau/nxyQ+ZBvRg9TlV+RoGjfoamaDPwuqm
        JyvvFsnoZU95QlT6apZwyem0rjxBLH9lVA==
X-Google-Smtp-Source: APXvYqyvM2aJfisUU+5fFuVGd+F/6kp3eagqpo837c3ONa4Bqq3DbuQ3CXlkesoQJVqD3sLX/Sno5g==
X-Received: by 2002:a05:6000:12ce:: with SMTP id l14mr332670wrx.342.1579139863282;
        Wed, 15 Jan 2020 17:57:43 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j12sm29386207wrw.54.2020.01.15.17.57.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 17:57:42 -0800 (PST)
Message-ID: <5e1fc316.1c69fb81.6c370.af3f@mx.google.com>
Date:   Wed, 15 Jan 2020 17:57:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.210-18-geaad7a3ca6a3
Subject: stable-rc/linux-4.4.y boot: 48 boots: 0 failed,
 48 passed (v4.4.210-18-geaad7a3ca6a3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 48 boots: 0 failed, 48 passed (v4.4.210-18-geaa=
d7a3ca6a3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.210-18-geaad7a3ca6a3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.210-18-geaad7a3ca6a3/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.210-18-geaad7a3ca6a3
Git Commit: eaad7a3ca6a31dedfa382fc8b8037beb0de07d70
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 9 SoC families, 9 builds out of 190

---
For more info write to <info@kernelci.org>
