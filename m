Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DA4576D93
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 13:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiGPLmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jul 2022 07:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiGPLmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jul 2022 07:42:19 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C257C13D63;
        Sat, 16 Jul 2022 04:42:18 -0700 (PDT)
Received: from zn.tnic (p200300ea9729766f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:766f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B7A2F1EC02AD;
        Sat, 16 Jul 2022 13:42:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1657971732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=TrWzbl6mvGD+VhoF3wfcgTYjQ8begmaufTzu3BvWSfI=;
        b=C1ExD3plau1kTCEQtER4H4Afs2+xeOeYPdQkVI3hVtoyEHvXXh4x8ST6pfJ8nCPkw5vdB6
        V/2P5mRnswj3HgN4AytzdE54tUOQgR8o4d6HIrp5I000qDMrxEZopxWIJ4elhwERZ9O4iV
        6zUwd1IRMq3uG3UdGZ568ut+/m+6Clo=
Date:   Sat, 16 Jul 2022 13:42:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Chuck Zmudzinski <brchuckz@netscape.net>
Cc:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        jbeulich@suse.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "# 5 . 17" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 0/3] x86: make pat and mtrr independent from each other
Message-ID: <YtKkECIpM5q+TCT9@zn.tnic>
References: <20220715142549.25223-1-jgross@suse.com>
 <7bf307c7-0b05-781b-a2a3-19b47589eb8a@netscape.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7bf307c7-0b05-781b-a2a3-19b47589eb8a@netscape.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 16, 2022 at 07:32:46AM -0400, Chuck Zmudzinski wrote:
> Can you confirm that with this patch series you are trying
> to fix that regression?

Yes, this patchset is aimed to fix the whole situation but please don't
do anything yet - I need to find time and look at the whole approach
before you can test it. Just be patient and we'll ping you when the time
comes.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
