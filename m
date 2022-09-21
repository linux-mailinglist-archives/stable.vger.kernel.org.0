Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0115BFEAD
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 15:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiIUNLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 09:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiIUNLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 09:11:00 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D8AE6A;
        Wed, 21 Sep 2022 06:10:57 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e77f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e77f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 71DEB1EC04CB;
        Wed, 21 Sep 2022 15:10:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663765851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ozPGXkhQCcXW67WvAixWgantH6wjYoJ8SSScScLN3uU=;
        b=nnLOflJ9Jx3vMjKoksPafVEanEjnJJxfxqTctRswLDb92r8jDPojepDJ7VUSEwZvg0npTy
        Okm1+u9NG4eD7ypRILXypbMiQorbG9Y78qT5ykfLIpo0dWbYV/04byeaa1TodzozaA+lss
        0Hc9lGo0eA+lzGV03I/a+2HY2B6LQsk=
Date:   Wed, 21 Sep 2022 15:10:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     K Prateek Nayak <kprateek.nayak@amd.com>
Cc:     linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Message-ID: <YysNW3+Fc2zOYcCq@zn.tnic>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <YyrPqlo/ysCeh4qU@zn.tnic>
 <f927f969-028a-4ad4-7776-527ed537c77f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f927f969-028a-4ad4-7776-527ed537c77f@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 04:09:16PM +0530, K Prateek Nayak wrote:
> I was not aware of cpu_feature_enabled() and it makes perfect sense to
> use it here.

It is no difference what the callers use - we simply want to unify the
interfaces and not have boot_cpu* and cpu_feature_* and so on. One is
enough and we want to use cpu_feature_enabled() everywhere possible.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
