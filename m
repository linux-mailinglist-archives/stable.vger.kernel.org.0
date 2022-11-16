Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6B762C7BB
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 19:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiKPShX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 13:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiKPShW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 13:37:22 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746A45986B;
        Wed, 16 Nov 2022 10:37:22 -0800 (PST)
Received: from zn.tnic (p200300ea9733e74b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e74b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E1BF11EC04E2;
        Wed, 16 Nov 2022 19:37:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668623840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=l8fEpHyVz0JYmiAFOwc8p1b2tPQ92jNALgMFb0BRMbo=;
        b=BJJx0tRiFkrhdhffglf3PpGCmr1Z7UDz3ZMcB2wL7B1Dp9pAQk/iDMnm0lVWEmtMoWjlLo
        c5sO7oueh4Z2TjF7vc5HpZRp+nNiVNgYsjpzufMreV236zTXa6IIFBdPu8S+gZdEvI9Oy9
        Y6c94tUWBVPwoz+mJzmEl2Pj7DwZHQc=
Date:   Wed, 16 Nov 2022 19:37:20 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jason Baron <jbaron@akamai.com>
Cc:     linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Shuai Xue <xueshuai@linux.alibaba.com>, stable@vger.kernel.org
Subject: Re: [PATCH] EDAC/edac_module: order edac_init() before
 ghes_edac_register()
Message-ID: <Y3Ut4L18XI+PGCze@zn.tnic>
References: <20221116003729.194802-1-jbaron@akamai.com>
 <Y3TGFJn7ykeUMk+O@zn.tnic>
 <f1afc4ed-505e-109f-9c4c-1053af2c1bcd@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f1afc4ed-505e-109f-9c4c-1053af2c1bcd@akamai.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Nov 16, 2022 at 09:32:41AM -0500, Jason Baron wrote:
> Thanks, yes this looks like it will address the regression. Is this
> planned for 6.1?

6.2.

> Or 5.15 stable, which is where we hit this regression?

No, I don't think it is stable material.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
