Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9FE21C4F
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 19:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfEQRTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 13:19:43 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:39176 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfEQRTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 13:19:43 -0400
Received: by mail-wm1-f46.google.com with SMTP id n25so7077052wmk.4
        for <stable@vger.kernel.org>; Fri, 17 May 2019 10:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G3uFDQl4Q8RNv5F1w6KDAH0NmcKYtSWSTt62zs9i4Js=;
        b=0AbAxgx9bZ0FBQ02wclxeI660+PIuq+Ckswl1Ip2WWT7/VjySTS30nl+qpK4I5W5LY
         lMdPeuRrCMSmYvEudqOyTR7sgYpl2BfEE3MthpguRHTQApT2AucWURQ1MW3WGRbCuU7y
         T/lOfFRRo6AOaCN4zQ9C56iORyyt2fl/d6YNz1BFAeMuBH4U+jOquES5YA0oNQK2jfC5
         aGA8D3xADZN0NXj5jKhgZuKHtLdxS/RjBvK+nzcqnBIVDxD/bKkEaP1D5il5/1/uH5km
         yildnnUxIztvJIpwWzlh4lBMqmc3m30LJ2rXwXJRiXMKUu1Re8A2k5GZCpLaIT6gnUsi
         6c7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G3uFDQl4Q8RNv5F1w6KDAH0NmcKYtSWSTt62zs9i4Js=;
        b=oQfT2XQXRspHf/LGMmCLObeQtjcv2Tzkimz9IQNq2QL/guxVO1l/vi6/7G0adFUmCK
         eGrTm8IEz5EHrEf21A//Noh1Gr/Dushmxp6SYnzms6ibVu/bpya/SW/RqlaUrVtvwO0O
         /Yh9jkx4YXeF2Du30J/ka92aeQ8YV7N7GPviB7aylds2xb+176Aa8nf3DhYCJByBDbuh
         gU37lf6FjB8Qzb4/MGvUbiWzqwckH09J3P0TExfLFNHo7hYgYsawm4OrpZ9woA+F0ekb
         q58Y/CCiK3Hx3ilol9j3DQCh9PSqEswa1yi9vIvgGVVpu6TY909AbHVdqWAAEqZptIQf
         /nWw==
X-Gm-Message-State: APjAAAVDl63rWt+cimJPBj9OxOZsYoQ/hCfXHidaMf+j++g/IcYfqEn9
        Mt9ROa9BQaTQ+zBh1TlqLGFpwYDEEeD1DQ==
X-Google-Smtp-Source: APXvYqxPPcHhGcGkcEbZLVWIsKjg+bxU6Lo8ckA6PFwOHU3a9vhEMmF5byyVRjWZutRuz3HPN2OX8A==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr3176061wmk.9.1558113581651;
        Fri, 17 May 2019 10:19:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g6sm12243129wro.29.2019.05.17.10.19.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 10:19:41 -0700 (PDT)
Message-ID: <5cdeed2d.1c69fb81.5fa5b.891f@mx.google.com>
Date:   Fri, 17 May 2019 10:19:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.3
Subject: stable/linux-5.1.y boot: 67 boots: 1 failed, 66 passed (v5.1.3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 67 boots: 1 failed, 66 passed (v5.1.3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.3/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.3/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.3
Git Commit: 7cb9c5d341b95274b4f1fccfc5db122f945f6730
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 16 SoC families, 11 builds out of 209

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
