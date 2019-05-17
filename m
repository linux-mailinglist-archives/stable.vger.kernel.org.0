Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7336721167
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfEQAmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:42:53 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:42186 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfEQAmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 20:42:53 -0400
Received: by mail-wr1-f54.google.com with SMTP id l2so5213927wrb.9
        for <stable@vger.kernel.org>; Thu, 16 May 2019 17:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X1aY5rKVVdbScqVOQmS6JOYugPAKTgxglF8IlZ11Hs8=;
        b=emNBtInwAJCxPO/SHAW171F470sGZP8kLE1yUoOnfgY+Dl9pRxZGTFve3wSTTSS4P+
         ycPec1gWaK4OzrLa/SjJy5/7KGg43osW3sg1tqTcUm1glaALP3Rvmi+qXIz5aOBuHz3e
         CnYqhcj507ejROjmRLFShs64SbFflAj5JFR357ddH0Hta+v8M3JmiGN7VVAmiYHijnn5
         Mk0MRuNe49LmQfFA+8CIksdcqhHAYpuF/2V+pT7SCL/mdrswJUk1rsI7R9IpP1OXkXDE
         CBX5rF22/gVu6KRWoLway3eOOOk6DWSy8muKasC6XNVqrdwn0xca20DkLIezbKZpw99g
         Ot4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X1aY5rKVVdbScqVOQmS6JOYugPAKTgxglF8IlZ11Hs8=;
        b=LF3Etz2/n7E9D5JuglLTK94NTM356PUfHgQMqT0sWxCQx8P3SSymQZmL1P/qLwQHrn
         I/SqoK8//JELI4Rtqf+t6Dr0W1nq5upQ5ENlSNeSafBSkP0yUC7kr1eTDBIEEYwKRer5
         EDRZbTqQ7oHTg4eb2i3JJ97Gu/FsOH6W2p75JCG7rzi3Hv0GM1PPhHbW+J80WUopqxaR
         oxVAKI0qEIr6BS9B1pZAD3nc3imhqY3K5X5aPrFazEzVjwk7yFfH8mg7MpzEWFiZL/JM
         I5jVetJeALKqQdRpkbELhQP22UV5Vd3hYaUQ0x7NL0OBlYdiNf7c7a7XU77sXObtzsqY
         k7qg==
X-Gm-Message-State: APjAAAUma6QBletKMRy+sJHNVgEXjTlvaYfwGK1YYsWWFD+Y8BXIt+Qt
        zC2vEQIuymyhaOUnD409WFWTQzCTPgG+Cg==
X-Google-Smtp-Source: APXvYqyROOqtops1AmIjBEVyXhOZRqfONKZHPYIcDoDl/+jMQh0u4cQC24bqI5BK8EoBiwnPVQReng==
X-Received: by 2002:a5d:63c7:: with SMTP id c7mr2488772wrw.68.1558053771943;
        Thu, 16 May 2019 17:42:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a10sm7745297wrm.94.2019.05.16.17.42.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 17:42:51 -0700 (PDT)
Message-ID: <5cde038b.1c69fb81.c2410.d41f@mx.google.com>
Date:   Thu, 16 May 2019 17:42:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.17
Subject: stable/linux-5.0.y boot: 61 boots: 0 failed, 61 passed (v5.0.17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 61 boots: 0 failed, 61 passed (v5.0.17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.17/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.17/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.17
Git Commit: d59f5a01fa438635ae098b2e170a18644df73c06
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 14 SoC families, 11 builds out of 208

---
For more info write to <info@kernelci.org>
