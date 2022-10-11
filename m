Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A00B5FB916
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 19:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiJKRTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 13:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJKRTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 13:19:38 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C890B93
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 10:19:34 -0700 (PDT)
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0286F3F474
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 17:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1665508773;
        bh=my6sVOU8VtRYMa675sr9CNOS9J5JEpSv1gx/NSSrwBI=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Zpysh8qOp94GjPZ/jJZLzO3BTlAremZ4A2XhVU3Q7ezYGAV5KcS/ubJ6I3Svy0DyU
         spvD/jnDVBkJg8xvgci07+Y9Ej/5+AwRY2zpYaIJ/BB4q1hd3pze7R29wnETJTQOxH
         CVUsTvt9Hb+qgn2hyc3a5gceAazp6k4mYCNgSIEloDrNFZXbUcOt2q72P9Jigm78b7
         olImkfI0uk1R1gicN+ffgWEPGLzPZEeRcM49B/fp9RikXaYAk2pPi6SKgLn7WvO6DB
         G03PHVNiud928U1TIfAJszbpvBpZnYm0sgFV58PER3tT7sHhHrP87o0InVZTBC/ydm
         DpGN7svgzZQgg==
Received: by mail-wr1-f70.google.com with SMTP id m20-20020adfa3d4000000b0022e2fa93dd1so4074389wrb.2
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 10:19:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=my6sVOU8VtRYMa675sr9CNOS9J5JEpSv1gx/NSSrwBI=;
        b=O0tiv59oIDFjZXW4Dmtn7f5r+1ZwzCwX/w7JBti0Walb0553UUVYzx47rHUR9nL+RJ
         H0PoftQlugQ+CqDg3KYnINmJP1M3szE9sMSdyIxZm90vBJcXVxO0zdmsyB8s6BeO4Kyf
         eCzHhRx7fQsSBdr/nynbH0tMAFMXPIRX81RPJ9pfMn3wG7womMLB9snftO98WXisPjsa
         v+Xgu9G3SvPxHHEjL6R1iMtGsoKTFvtaXKLyrYo2gEVCaeShIk9KuX9a1X5B1otZ+Ewm
         a9hw5Ay81ZqIO6dbw68IoSftlpX/oNdgt2c7C/zBGV1w6/jlA7eSIcMWoEbPCArryPym
         37OQ==
X-Gm-Message-State: ACrzQf2T9F0Q42rlTymwjvBZqiVFwUA0sdUpPhvmYfwhc1xBAhDwpN7j
        FbSBIECmtP6BXRdSabJQ22II1dTabRev91c+egVNuc6cBIjhk8pmHPrNg8gSpCHLepUSAgSuLqv
        n8KI07M250ddW9bcbsO7BxJEpYXAp1fZKYYlWtfUvYNqxnmgQbA==
X-Received: by 2002:a05:600c:418b:b0:3c6:c1e6:b01c with SMTP id p11-20020a05600c418b00b003c6c1e6b01cmr113408wmh.118.1665508770790;
        Tue, 11 Oct 2022 10:19:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6kEfxTPdaaZb76dTujH+ZaW2WgqT1q11a8LoW5U3WyutzRoB267icZUKz0P9CQZnC7l3DX49bwGyxx6kmMa2k=
X-Received: by 2002:a05:600c:418b:b0:3c6:c1e6:b01c with SMTP id
 p11-20020a05600c418b00b003c6c1e6b01cmr113396wmh.118.1665508770566; Tue, 11
 Oct 2022 10:19:30 -0700 (PDT)
MIME-Version: 1.0
References: <d6c9e249-08bd-4439-7dcc-371b32e7b851@canonical.com> <Y0WgwBgenhnk7/O2@spud>
In-Reply-To: <Y0WgwBgenhnk7/O2@spud>
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Date:   Tue, 11 Oct 2022 18:18:54 +0100
Message-ID: <CADWks+Y3xYc325x2_2jeRh-iyE6i0gi2Ldd_KKBLhB7s9nQhWA@mail.gmail.com>
Subject: Re: Regression: Fwd: Re: [PATCH] riscv: mmap with PROT_WRITE but no
 PROT_READ is invalid
To:     Conor Dooley <conor@kernel.org>
Cc:     regressions@lists.linux.dev, stable@vger.kernel.org,
        Eva Kotova <nyandarknessgirl@gmail.com>,
        linux-riscv@lists.infradead.org, coelacanthus@outlook.com,
        kernel-team@lists.ubuntu.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Oct 2022 at 17:58, Conor Dooley <conor@kernel.org> wrote:
>
> On Tue, Oct 11, 2022 at 05:52:13PM +0100, Dimitri John Ledkov wrote:
> > #regzbot ^introduced 2139619bcad7ac44cc8f6f749089120594056613
> >
> > Over at https://lore.kernel.org/linux-riscv/Yz80ewHKTPI5Rvuz@spud/T/#ebde47064434d4ca4807b4abb8eb39898c48a8de2
> > it is reported that 2139619bcad7ac44cc8f6f749089120594056613
> > regresses userspace (openjdk) on riscv64.
> >
> > This commit has already been released in v6.0 kernel upstream,
> > but has also been included in the stable patch series all the
> > way back to v4.19.y
> >
> > There is a proposed fix for this at
> > https://lore.kernel.org/linux-riscv/20220915193702.2201018-1-abrestic@rivosinc.com/
> > which has not yet been merged upstream or in stable series.
> >
> > Please review and merge above proposed fix, or please revert
> > 2139619bcad7ac44cc8f6f749089120594056613 to stop the regression
> > spreading to all the distributions.
>
> Out of curiosity, and given the CC list lacks a CC of the maintainer,
> who are you actually asking to review and/or merge this?
>

Good point, this is my first time escalating a regression which is now
in all the stable trees. I guess I should have CC'ed all the M: from
RISC-V in the Maintainers file. Not just the riscv list.

> I'll go bump the fix itself.

Thanks.

>
> Thanks,
> Conor.
>
> >
> > In Ubuntu this regression will be tracked as https://bugs.launchpad.net/bugs/+bug/1992484
> >
> > -------- Forwarded Message --------
> > Subject: Re: [PATCH] riscv: mmap with PROT_WRITE but no PROT_READ is invalid
> > Date: Thu, 6 Oct 2022 22:20:02 +0300
> > From: Eva Kotova <nyandarknessgirl@gmail.com>
> > Reply-To: PH7PR14MB559464DBDD310E755F5B21E8CEDC9@PH7PR14MB5594.namprd14.prod.outlook.com
> > To: coelacanthus@outlook.com
> > CC: c141028@gmail.com, dramforever@live.com, linux-riscv@lists.infradead.org, palmer@dabbelt.com, xc-tan@outlook.com
> >
> > On Tue, 31 May 2022 00:56:52 PDT (-0700), coelacanthus@outlook.com wrote:
> > > As mentioned in Table 4.5 in RISC-V spec Volume 2 Section 4.3, write
> > > but not read is "Reserved for future use.". For now, they are not valid.
> > > In the current code, -wx is marked as invalid, but -w- is not marked
> > > as invalid.
> >
> > This patch breaks OpenJDK/Java on RISC-V, as it tries to create a w-only
> > protective page:
> >
> > #
> > # There is insufficient memory for the Java Runtime Environment to continue.
> > # Native memory allocation (mmap) failed to map 4096 bytes for failed to
> > allocate memory for PaX check.
> > # An error report file with more information is saved as:
> > # /root/hs_err_pid107.log
> >
> > I bisected to this commit since on Linux 5.19+ java no longer works.
> > Perhaps some fallback should be implemented, to prevent userspace
> > breakage. It is currently documented, that at least on i386 PROT_WRITE
> > mappings imply PROT_READ (See man mmap(2) NOTES), this would be a good
> > place to start.
> >
> > Best regards,
> > Eva
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
> >
>
>
>


-- 
okurrr,

Dimitri
