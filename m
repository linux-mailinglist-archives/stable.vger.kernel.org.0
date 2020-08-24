Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D1B2507DB
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgHXSg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgHXSg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:36:26 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B51C061573;
        Mon, 24 Aug 2020 11:36:26 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g33so4983616pgb.4;
        Mon, 24 Aug 2020 11:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zpnmRNIKkvjV2LPN01BqZu47Eb5w1mM1AyOClAtFrXI=;
        b=oqFFumLnpfknRGNiLUr2NDUPgiJonX285ro4dRlKv26w5hXD7FQPXcSSmJFKFNOrfu
         mJ/7vbLmealdw4NJnHRCKxzyKgsz159CS8BlAqAyf2gn6Tz5M4vrU3AhXQ1RlyNDZP8k
         5y2gkUjrArlhXwYAM7L4HywPst/WB1TP1BL/LWgJSpZAXIIDeoF5mbvWg2ntUSaVa4Zy
         YzfV+KH4TDu22vFFlebI+l98hH7/NN6i/HouH7ze7r2YLkjKZX6XILa5jexgey3LxeX2
         PrbbinG71YVnJ7JX8PFgfCmzk56CApyqVWko/GZrMSbxNmDRIoMXZtnlrm7/7uHDeBsh
         mg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zpnmRNIKkvjV2LPN01BqZu47Eb5w1mM1AyOClAtFrXI=;
        b=jBF9/y8ycMX1xg8pknNLOOz99YuaDHh1onc5rCG3nd8Q9figo3Kc8abYP+w0raFvB0
         zvgrNxHfyZVOb1R/47abajp/NMK0iXdHUBJ+gtcALIUNSJN7fVHLlufg0m11X+CWw0AF
         yXL41YFQdiKml5giR+2HFpBv832LCuLlxPm3uu15zf3NzFWWIYTuRddDCoChBYU5K9R7
         q8yELHEBC3TUuagSX0ykDnFMnwgcRTU9NsT+y3YgTbnW8VkeGnrsUjg/dL4YKxKFoT/c
         y4mn92CsMDeVBTLSnLggfY+/LOet6lBO53RoZNTDqZzczjZFKHAUpfQZzbq4El/GWBkE
         G2pw==
X-Gm-Message-State: AOAM533YBmA6AVqeVAvZmwbcasGVvLfZHjHwBLWsodliUBJGSKJqBxGc
        oM1lit+S0fyqzWlmjAvVo3U=
X-Google-Smtp-Source: ABdhPJzA74PH6fkzfA54h84m1jubls9NcJ307f/XM+aVW17ppXCAHQIMS5mz8GGn93A4L1wrXAjgYQ==
X-Received: by 2002:a17:902:8509:: with SMTP id bj9mr2360001plb.172.1598294185558;
        Mon, 24 Aug 2020 11:36:25 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u191sm10235065pgu.56.2020.08.24.11.36.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 11:36:24 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>
Subject: [PATCH stable 4.9 v3 0/2] arm64: entry: Place an SB sequence following an ERET instruction
Date:   Mon, 24 Aug 2020 11:36:20 -0700
Message-Id: <1598294182-34012-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes in v3:

- included missing preliminary patch to define the SB barrier instruction, see
  patch change log for details on how it was back ported into v4.9

Changes in v2:

- added missing hunk in hyp/entry.S per Will's feedback

Will Deacon (2):
  arm64: Add support for SB barrier and patch in over DSB; ISB sequences
  arm64: entry: Place an SB sequence following an ERET instruction

 arch/arm64/include/asm/assembler.h  | 13 +++++++++++++
 arch/arm64/include/asm/barrier.h    |  4 ++++
 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/include/asm/sysreg.h     | 13 +++++++++++++
 arch/arm64/include/asm/uaccess.h    |  3 +--
 arch/arm64/include/uapi/asm/hwcap.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 22 +++++++++++++++++++++-
 arch/arm64/kernel/cpuinfo.c         |  1 +
 arch/arm64/kernel/entry.S           |  2 ++
 arch/arm64/kvm/hyp/entry.S          |  2 ++
 arch/arm64/kvm/hyp/hyp-entry.S      |  4 ++++
 11 files changed, 64 insertions(+), 4 deletions(-)

-- 
2.7.4

