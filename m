Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053D1332FC
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 17:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfFCPB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 11:01:28 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:35881 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbfFCPB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 11:01:28 -0400
Received: by mail-wr1-f42.google.com with SMTP id n4so9393398wrs.3
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 08:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vqm1HfyKlx7kXvXfV/7917TkSslzuRGRJYlsCpZ14dM=;
        b=q683T0KYgks5Mlmw4ybVm+Mj4CsFC2b3gvomVL5PVEE54FDGqZCdorFtfPwGuyUZbs
         reQRBojyBElE6z/5EHLGOcqk8v9tfcZlcCS6LwB1gi64Jm7FZOW3/mIgOfHw97ptICeI
         nCzCRoPMvQnQ41Q+n9tcFu28yNjl1lEEOPtN2neJOjpis75Hbc7bp28vl3Z6eDddqdQJ
         sQl2XDpSYbBoSDrqN4EOU+9QMW1uc3ftgXXvLfEICPkBMK9GPgC81zxKCTEUTPKR8GqM
         E4g2STkfzHdckh1oklAZ49GBuP7FuqueXaFTFvmL4dNpPecruQ6FCzkXf4EjAuiwJXrS
         wtLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vqm1HfyKlx7kXvXfV/7917TkSslzuRGRJYlsCpZ14dM=;
        b=qQEC0FYKWTrjgQCmYI/6t25dR2Ujtxy6QM0+f1paHPWii0iKhXJpPxYE9DwU+8IRAL
         toZBUY60/hVa/7OnxTIwUa8n7c1MybjytOyQvBXu+lTLSRIJIZCMJAwLEE5Om5E1wvzr
         04vmpjbZ/Hyz6Ke0dqj7lvgJQWcLHJe6tSb4XPXHqE+6/DP9CSvCJZ/HomjLrGcmglhs
         PD1//FUjKq4k9ASOSz3392ppvoJMxmFaKvjA1LwT+qy+loXyVnCRagRH0ekb9QpTOKC6
         kpeaxdOeO3+RIrnT4hLSkA6cxosQghD9I4s1YHCnbTWfBt5CexDHlP3/irQBjddW/2oU
         cjyQ==
X-Gm-Message-State: APjAAAVpjydBM8tQAJuO9pLvZD6e3ARH+DejJUPf2PEZiaPtMQ/jgdqD
        WAj3M8Pve1MIiVi4R0hDSRd3BQHuWtlS8Q==
X-Google-Smtp-Source: APXvYqwdqb+rXbnEwMzxobUkSZT0hY+RhqgkENXWkh7oVJA2XpMOKvPRXLJlFpLQc1RQM6P+FoS3sw==
X-Received: by 2002:adf:afd5:: with SMTP id y21mr16393684wrd.12.1559574086748;
        Mon, 03 Jun 2019 08:01:26 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l18sm13027043wrv.38.2019.06.03.08.01.25
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 08:01:25 -0700 (PDT)
Message-ID: <5cf53645.1c69fb81.7dc9f.5d91@mx.google.com>
Date:   Mon, 03 Jun 2019 08:01:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.47-33-g322f4070727b
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 126 boots: 0 failed,
 126 passed (v4.19.47-33-g322f4070727b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 126 boots: 0 failed, 126 passed (v4.19.47-33-g=
322f4070727b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.47-33-g322f4070727b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.47-33-g322f4070727b/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.47-33-g322f4070727b
Git Commit: 322f4070727b6cedd9f682203efe5b910b4daceb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
