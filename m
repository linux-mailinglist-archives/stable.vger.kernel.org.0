Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A755E673C
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiIVPgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiIVPgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:36:31 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F51B100A8D;
        Thu, 22 Sep 2022 08:36:30 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e7fe329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7fe:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 84D9B1EC03EA;
        Thu, 22 Sep 2022 17:36:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663860984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=wRMP9slYyN0/QDW1WIR4Q0VabXcD/EBlo0OElvXvF1M=;
        b=P9oPtr/R8OYSyNe2qXmpk0vA3zKYyaaOGV85o6RKATj0lPSE0L86zkRGg+NGRBPTBYMsBx
        x6TR1a2rIucS1tovgxro51vEOkKkMxxoFXue7hc69IdkCqdIfZ3b0POcCScmdP1V3WhmwN
        PJOBRFSrmCJuett0M62R6ujii54McQc=
Date:   Thu, 22 Sep 2022 17:36:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, andi@lisas.de,
        Pu Wen <puwen@hygon.cn>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        ananth.narayan@amd.com, gautham.shenoy@amd.com,
        Calvin Ong <calvin.ong@amd.com>,
        Stable <stable@vger.kernel.org>, regressions@lists.linux.dev
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Message-ID: <YyyA9AV9qiPxmmpb@zn.tnic>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <YysnE8rcZAOOj28A@hirez.programming.kicks-ass.net>
 <YytqfVUCWfv0XyZO@zn.tnic>
 <YywaAcTdLSuDlRfl@hirez.programming.kicks-ass.net>
 <CAJZ5v0i9P-srVxrSPZOkXhKVCA2vEQqm5B4ZZifS=ivpwv+A-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJZ5v0i9P-srVxrSPZOkXhKVCA2vEQqm5B4ZZifS=ivpwv+A-w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 05:21:21PM +0200, Rafael J. Wysocki wrote:
> Well, it can be forced to use ACPI idle instead.

Yeah, I did that earlier. The dummy IO read in question costs ~3K on
average on my Coffeelake box here.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
