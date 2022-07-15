Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10173576A35
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 00:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiGOWvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 18:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbiGOWv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 18:51:27 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDCE45987;
        Fri, 15 Jul 2022 15:51:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o31-20020a17090a0a2200b001ef7bd037bbso7491630pjo.0;
        Fri, 15 Jul 2022 15:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8LRdXnGBkh1a1Ag07+rxl01ofzEnK6fRJxzyJOKUGrY=;
        b=XS3Z2gA2bLok1BviOoFR20EFum6E32EdzNTg8lz3RcXaR9CKnwHU5jEl8cCwB/5zxP
         lWg74saq9rF69oeq6z190xvyuNiPvPxRfpQEkXDzQ56K5avOqUVA28tuZqmNaZ2e1ztU
         OWxA4QhCJsNHPeYVGlloz1wRXWRTKPXfMMxKfEESYiOYaT1UQdZUVfZ2u8O4xIHwPDi6
         f5WPXsjMK9jP9kPsfRnQeUFJV+O2gkA90F8ryajynYiPLzf8s9OE9JwkKF/CLi7Q4R0s
         gnG6c2BN6FVuztpQi6ONCQmT/kSqm7nJXdIVZOrGHuckAB2Un0b94zHGgxH0TE225coI
         bt9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8LRdXnGBkh1a1Ag07+rxl01ofzEnK6fRJxzyJOKUGrY=;
        b=VHDQ+X7WuMB21rVVjSjlGghjLrMvi3nYPKoKjt17nS2psZwYmhomesqucP0MJLQ3Ir
         garhfBINNU5rRztiouHOM1Vvs4R9cyoXFXfv+gk+wCOsSOescKXBn9qm7zztkhTAE9zS
         lAdm5u1ZLQ4lWqPhOYVB2GDK6G8zLyrov6XQq6KTTTSGtZL270fCLdMfWpJnbd2bLMvl
         geFW00VMxDZJyhvPk5JykAcA8AJS+Gnwl8FMGmSpMIBjEkk0Zeg7hj+2C80gr3c0/DOf
         NWDI/jMlEdn704+AwAFovhAazHRQAGZ+1PRm5y9c9VMhJCuJfA6hHDbgNtslH4adYReT
         Tk8w==
X-Gm-Message-State: AJIora9upYrC7UdXgu9Fylxc67C4oYCd7TqixzYxjnwC9Z9vaKG2ISdN
        R8lTtztnQ/s1T3kICr+oU+wex8TL1Vpw7w==
X-Google-Smtp-Source: AGRyM1vDxDrRVno9jxas99X+Zh9FOmVCnHGLHj5I+mX6XzjJnOPXn8u8AHCmvBiDqqpyXHTxATkelw==
X-Received: by 2002:a17:902:f152:b0:16b:e29c:fbd5 with SMTP id d18-20020a170902f15200b0016be29cfbd5mr15776217plb.67.1657925485953;
        Fri, 15 Jul 2022 15:51:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b001677d4a9654sm4111063plx.265.2022.07.15.15.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 15:51:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Jul 2022 15:51:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        x86@kernel.org, ardb@kernel.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
Message-ID: <20220715225123.GA2177570@roeck-us.net>
References: <20220715194550.793957-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715194550.793957-1-cascardo@canonical.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 04:45:50PM -0300, Thadeu Lima de Souza Cascardo wrote:
> When running with return thunks enabled under 32-bit EFI, the system
> crashes with:
> 
> [    0.137688] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> [    0.138136] BUG: unable to handle page fault for address: 000000005bc02900
> [    0.138136] #PF: supervisor instruction fetch in kernel mode
> [    0.138136] #PF: error_code(0x0011) - permissions violation
> [    0.138136] PGD 18f7063 P4D 18f7063 PUD 18ff063 PMD 190e063 PTE 800000005bc02063
> [    0.138136] Oops: 0011 [#1] PREEMPT SMP PTI
> [    0.138136] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc6+ #166
> [    0.138136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> [    0.138136] RIP: 0010:0x5bc02900
> [    0.138136] Code: Unable to access opcode bytes at RIP 0x5bc028d6.
> [    0.138136] RSP: 0018:ffffffffb3203e10 EFLAGS: 00010046
> [    0.138136] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000048
> [    0.138136] RDX: 000000000190dfac RSI: 0000000000001710 RDI: 000000007eae823b
> [    0.138136] RBP: ffffffffb3203e70 R08: 0000000001970000 R09: ffffffffb3203e28
> [    0.138136] R10: 747563657865206c R11: 6c6977203a696665 R12: 0000000000001710
> [    0.138136] R13: 0000000000000030 R14: 0000000001970000 R15: 0000000000000001
> [    0.138136] FS:  0000000000000000(0000) GS:ffff8e013ca00000(0000) knlGS:0000000000000000
> [    0.138136] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
> [    0.138136] CR2: 000000005bc02900 CR3: 0000000001930000 CR4: 00000000000006f0
> [    0.138136] Call Trace:
> [    0.138136]  <TASK>
> [    0.138136]  ? efi_set_virtual_address_map+0x9c/0x175
> [    0.138136]  efi_enter_virtual_mode+0x4a6/0x53e
> [    0.138136]  start_kernel+0x67c/0x71e
> [    0.138136]  x86_64_start_reservations+0x24/0x2a
> [    0.138136]  x86_64_start_kernel+0xe9/0xf4
> [    0.138136]  secondary_startup_64_no_verify+0xe5/0xeb
> [    0.138136]  </TASK>
> 
> That's because it cannot jump to the return thunk from the 32-bit code.
> Using a naked RET and marking it as safe allows the system to proceed
> booting.
> 
> Fixes: aa3d480315ba ("x86: Use return-thunk in asm code")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: <stable@vger.kernel.org>

No more crashes with this patch applies on top of the mainline kernel
(sha e5d523f1ae8f).

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
