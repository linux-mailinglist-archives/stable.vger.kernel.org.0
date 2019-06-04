Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7297834B60
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 17:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfFDPC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 11:02:28 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:43165 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbfFDPC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 11:02:28 -0400
Received: by mail-wr1-f53.google.com with SMTP id r18so7192798wrm.10
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 08:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fe3evbEgzdoAm0PbOtkdrf3OPyCTVl9pS6z3vnEUvUQ=;
        b=QZalOJ5n3PJRa6iMb4o7r9igqtjPd8k3cHsMzqIML/D2mSjq42IjK7IapcIX0ceAAX
         Usn7X7z/kHSbVg5sJtB1Vh0R4SGdxdVw5xu5bhFcgH8Jso/nwJKnyBio+6X1wT6A0+R8
         p+yO0+ajvEsbf87ZTslo7W6NtSlcLYKqFz1JKkEuvGdqYjUuLFgkYQrf9U39Q+8JggmD
         lRgEnB1nvtooOF2EEJrBvf/mBML4oUr71v1H0xNxAEv5+ji0PexK5RrEDh5/E1YElEdr
         Y56887ox8TvsTYUtTR5m5uJG3cAaEhR/vsxKQvW3O8B5YRwZOkx4B0YwcVJvtB12HBcU
         ZhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fe3evbEgzdoAm0PbOtkdrf3OPyCTVl9pS6z3vnEUvUQ=;
        b=YPD+gBLWmE2mA97slhgBHAHtjlLsGqBZIpzOuNpuoa+N6yrIp/IBe2tpM+YJw0FbO3
         ikLnxDREnuuhsA0OlowX7IdAQqjKxhYtR6eo1hmQg/R5li3/RYvUYJgVAOuXaqO+h0Am
         oMljhU3Qc3NF+6YLr1eyGO7WTG4eVB7pfmGTdZ60rsMkUo2I8qOSZGESsNcFEJq2E0mj
         zDYf40fwT7Y39wqhuqlopWVQNhu+0nHZ+BsJZQeW/L0VQ//OGFFkHETerfPqq83jzBqy
         FdApcuFfw86r+YEo9wBwWGe2beGcWb57JLS30lUrTh8SBJ0vKU4dVUBq1LAArCH+BPnA
         wd0g==
X-Gm-Message-State: APjAAAVb7eTyVm7rFhgy0U40MC+lfVVzfwfJgd9EP1x22gglzQWcYy77
        mammB+qaA4DKzVMgbwVuxc93Eh2NUvjUCw==
X-Google-Smtp-Source: APXvYqz5POtULPyHC1ZnPtTppJqNenHMxrg3iM1ztTWEPTu0K70SpPPRb+nLoPmOcrA8nyO4PlWWVQ==
X-Received: by 2002:a5d:5152:: with SMTP id u18mr15677014wrt.319.1559660546553;
        Tue, 04 Jun 2019 08:02:26 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l18sm15820713wrv.38.2019.06.04.08.02.25
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 08:02:25 -0700 (PDT)
Message-ID: <5cf68801.1c69fb81.7dc9f.76e4@mx.google.com>
Date:   Tue, 04 Jun 2019 08:02:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.0.21
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.0.y boot: 67 boots: 0 failed, 67 passed (v5.0.21)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 67 boots: 0 failed, 67 passed (v5.0.21)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.21/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.21/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.21
Git Commit: fd1594eb706427cc0d88fdfc2c1dbecd5abe7a83
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 16 SoC families, 11 builds out of 208

---
For more info write to <info@kernelci.org>
