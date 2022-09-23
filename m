Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA78D5E7FCB
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 18:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbiIWQaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 12:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiIWQaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 12:30:24 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F9FF1917;
        Fri, 23 Sep 2022 09:30:22 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e795329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e795:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 709C11EC0646;
        Fri, 23 Sep 2022 18:30:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663950617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=qw+3y1mCKoDwYTkZXX6OHqjYOHz56e8OXYAVyYAqElg=;
        b=jEjlAAoMPEhJ7BodIBhX2FOFktAKUxD5mgXRW9COoJFiwG1EZpw1usN2QkQQ84lqkd6e5D
        RoyIjhH6xytSE9QUa8VTpTO7q43cW5CcL7YYQlnaptzW6wOyYI6UNrtjgjSGx3PmXDmWuJ
        SvWOAj3APjubsujGZjMuOgmvC5rGoZc=
Date:   Fri, 23 Sep 2022 18:30:13 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     K Prateek Nayak <kprateek.nayak@amd.com>
Cc:     linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86,acpi: Limit "Dummy wait" workaround to older AMD
 and Intel processors
Message-ID: <Yy3fFciusHZ2h1GW@zn.tnic>
References: <20220923153801.9167-1-kprateek.nayak@amd.com>
 <Yy3U0fQ0GZYZnMa1@zn.tnic>
 <f020defb-df73-35ff-5d97-c07773bafb67@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f020defb-df73-35ff-5d97-c07773bafb67@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 23, 2022 at 09:55:02PM +0530, K Prateek Nayak wrote:
> Yes, I did see the patch, but Andreas replied to Dave's patch attached
> in v1 saying that he had seen this issue with AMD Athlon on a VIA
> chipset back in 2006. (https://lore.kernel.org/lkml/Yyy6l94G0O2B7Yh1@rhlx01.hs-esslingen.de/)
> Therefore, Dave's patch is not sufficient.

Well, AFAICT, that box is old and dead. And I'm being told that the AMD
machines which we care for and which are still alive should not need the
dummy read.

Which means, we could try the simple fix first and see who complains.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
