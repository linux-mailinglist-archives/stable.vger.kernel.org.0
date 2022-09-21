Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517325E53EF
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 21:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiIUTsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 15:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIUTsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 15:48:20 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FFCA0254;
        Wed, 21 Sep 2022 12:48:19 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e77f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e77f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 90A921EC04E4;
        Wed, 21 Sep 2022 21:48:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663789693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RQsSCmnaA3tja2xxzLfdQayRM2Puy3vWH21v7at91H8=;
        b=BhqYk4Apw3euLWYnEfH1ZSXzy2nIQwCIItrx7JT1KgUH3QjrHXIXwWuIKzq4Jp6WS8bd4z
        Ne0pLLDtHIF4r/o5rdtQyGdAlvopxks92MXl007Unbp6yDIM5qBV9U6fGkSyK2T0K+xpNr
        FYsrp7QrFQ3xsziRJslwmeUfYvzN32Y=
Date:   Wed, 21 Sep 2022 21:48:13 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, mario.limonciello@amd.com, rui.zhang@intel.com,
        gpiccoli@igalia.com, daniel.lezcano@linaro.org,
        ananth.narayan@amd.com, gautham.shenoy@amd.com,
        Calvin Ong <calvin.ong@amd.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Message-ID: <YytqfVUCWfv0XyZO@zn.tnic>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <YysnE8rcZAOOj28A@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YysnE8rcZAOOj28A@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 05:00:35PM +0200, Peter Zijlstra wrote:
> On Wed, Sep 21, 2022 at 12:06:38PM +0530, K Prateek Nayak wrote:
> > Processors based on the Zen microarchitecture support IOPORT based deeper
> > C-states. 
> 
> I've just gotta ask; why the heck are you using IO port based idle
> states in 2022 ?!?! You have have MWAIT, right?

They have both. And both is Intel technology. And as I'm sure you
know AMD can't do their own thing - they kinda have to follow Intel.
Unfortunately.

Are you saying modern Intel chipsets don't do IO-based C-states anymore?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
