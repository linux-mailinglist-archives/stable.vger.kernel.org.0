Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCAC62BB8E
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 12:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiKPLYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 06:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiKPLYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 06:24:31 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC162983F;
        Wed, 16 Nov 2022 03:14:35 -0800 (PST)
Received: from zn.tnic (p200300ea9733e74b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e74b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1E7C61EC053B;
        Wed, 16 Nov 2022 12:14:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668597274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=X1MDsyX35MKj8p8BBuZRg90EXQO3G67HQhry3OHcka8=;
        b=DSGOQbJpJv+KxURrpQgIQPuVJekdhfOZ00fJUqPkzhyKl4+ATbQeTQbVJOQXIHIfciSzVs
        xxPKTH/yyDuBQFHCD4YlURtYv/zVqNqSzLxv8mE28ihkkOgDkciTsuv8hZJ7mEiQDCY/4y
        HofKmWLWSlgW4eB+LM8+1t5LIiotDyc=
Date:   Wed, 16 Nov 2022 12:14:28 +0100
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
Message-ID: <Y3TGFJn7ykeUMk+O@zn.tnic>
References: <20221116003729.194802-1-jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221116003729.194802-1-jbaron@akamai.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 07:37:29PM -0500, Jason Baron wrote:
> Currently, ghes_edac_register() is called via ghes_init() from acpi_init()

https://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git/log/?h=edac-ghes

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
