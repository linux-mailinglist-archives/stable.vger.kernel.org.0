Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F43E8969
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 14:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbfJ2NZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 09:25:07 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:44513 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730112AbfJ2NZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 09:25:07 -0400
Received: by mail-wr1-f54.google.com with SMTP id z11so13607031wro.11
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 06:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HPVCNDFiZpxarLuOJ8W+x4IeHqNpffk13GAp1Z7ew2Q=;
        b=Hbqtf8AzuJ7edw050bW7xlJels11gb4V2rPw9vABB5u4s8GasF0ut6fcjypwusCsNf
         RFZnIgNgKTMHeYadnffxSgxYVCw9DK8EKLJ+yhEXedHQv/MWuMT1CwBG0vyX+yCnJ4xu
         jK5/9gp87AX/wsdEZIX2gmfRpPwr7FbE22ibYWoDIhIPhXW3zyjW1mUa1CLHGVjJScAg
         HGXFoAIGP4C/dLFr4NpxmwF0TJjXLrLrcIqexBT5+WfZwMCrNCVuTZZk+tgaQuq+jejJ
         2LsloBxZ0Y7TwFuGaGI6ICj+2l8feZj9NDgP8AJpJPnXar6OYj4g6Al+jsGvYZzapkXy
         d3Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HPVCNDFiZpxarLuOJ8W+x4IeHqNpffk13GAp1Z7ew2Q=;
        b=NxIn0vdcNm82sRpTCm4I664SGFQY3gObSFludH5Bs/ZEEKyQcm/l5Rgo7OMwuQpzlh
         j+GcOW1TzA45/UB0ddZYibIH2t4v9JcVJULdd4XqBFEJZwJs/JgPVdICbOPNgY/nTnjv
         Wd9iNWQvsNJIp0v7koQ5TeO6HYr3QU2I6duX9+CFpwkz8dRTIob1OlJ/+Q/rKVgeqeSE
         /HnNu1WPxQbq8ntb01boOH5nbA8au2v8LQKN1ccW1JQwtUwsxlrSYlhQjDx6EmPMHiaO
         VdiDU56C4RzP6K0xATf4Mlg+z6d113JoT1ooY5AOV4E7GN2S/++91X0F/IEIpu+r8G+f
         /Uyw==
X-Gm-Message-State: APjAAAWDN84tydaQDYcV8QriYrGrKmLY5GdiRUynB487yFXwrqhHAPjm
        Af0i38P/BHQfyR0Cb0kw0I860Pll6Ytfgg==
X-Google-Smtp-Source: APXvYqw9MXT5zGQYEQ2zoQZKoKG7Bx/4ooYwYBebqbqnqPMTCkjMPUAyi66ZkeF0sN2DCR9x7bJ4Dw==
X-Received: by 2002:a5d:694a:: with SMTP id r10mr19982217wrw.117.1572355505405;
        Tue, 29 Oct 2019 06:25:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m6sm13372131wrs.58.2019.10.29.06.25.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 06:25:04 -0700 (PDT)
Message-ID: <5db83db0.1c69fb81.e8c98.3f87@mx.google.com>
Date:   Tue, 29 Oct 2019 06:25:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.151
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.14.y boot: 58 boots: 0 failed, 58 passed (v4.14.151)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 58 boots: 0 failed, 58 passed (v4.14.151)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.151/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.151/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.151
Git Commit: ddef1e8e3f6eb26034833b7255e3fa584d54a230
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 14 SoC families, 9 builds out of 201

---
For more info write to <info@kernelci.org>
