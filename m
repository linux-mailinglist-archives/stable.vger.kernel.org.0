Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32AC57325F
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 11:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiGMJWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 05:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiGMJWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 05:22:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F260EA173;
        Wed, 13 Jul 2022 02:22:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 76BD222C86;
        Wed, 13 Jul 2022 09:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657704136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y/rRcSr0LdG+YdTaRLjdffwvOM+zTDAbKuKoY3nQK3A=;
        b=1sANN5OpLm5MMnf374XyYrYZkh2mg+WBG85fPf32+xJqHveYC/lrQb2XlWL4lYhgrCluvB
        7ZW+UOkLwht5QJwa6tBruwYDi6wkQncJF8+vx1/AiLp2KOH3vxqWoEnV2XneqEpobmOWhq
        5BF6p9J4cb6kIgmQbyr428kax4pj2tA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657704136;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y/rRcSr0LdG+YdTaRLjdffwvOM+zTDAbKuKoY3nQK3A=;
        b=Tiy9DwvhN5REdyRK1HjEBeDy6y4udrn8bY5EgBup7/E+aij6tZXTPAKpb2iEfDkigUkYAE
        QmMzDbyalDNH6nCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 67C9413754;
        Wed, 13 Jul 2022 09:22:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id l5s5GciOzmJIUQAAMHmgww
        (envelope-from <bp@suse.de>); Wed, 13 Jul 2022 09:22:16 +0000
Date:   Wed, 13 Jul 2022 11:21:30 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: Re: [PATCH 5.18 34/61] objtool: Update Retpoline validation
Message-ID: <Ys6OiDQCuP072GCX@nazgul.tnic>
References: <20220712183236.931648980@linuxfoundation.org>
 <20220712183238.342232911@linuxfoundation.org>
 <63e23f80-033f-f64e-7522-2816debbc367@kernel.org>
 <509dd891-73cc-31b9-18ac-2e930084c02f@kernel.org>
 <Ys5/ssHL076y4niP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ys5/ssHL076y4niP@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 10:17:54AM +0200, Greg Kroah-Hartman wrote:
> > A naive fix is:
> > --- a/arch/x86/kernel/head_32.S
> > +++ b/arch/x86/kernel/head_32.S
> > @@ -23,6 +23,7 @@
> >  #include <asm/cpufeatures.h>
> >  #include <asm/percpu.h>
> >  #include <asm/nops.h>
> > +#include <asm/nospec-branch.h>
> >  #include <asm/bootparam.h>
> >  #include <asm/export.h>
> >  #include <asm/pgtable_32.h>

Yap, pls send a proper patch.

> I doubt it should be doing that, but I'll let others answer more
> definitively.

I'd leave that question to the objtool folks.

Technically, the UNTRAIN_RET sequence is meant for both 32- and 64-bit
so there should be no reason not to mitigate that on 32-bit too. Not
that people should run 32-bit kernels...

> Your commit seems sane, for some reason I thought Boris tested i386
> builds, but maybe in the end something snuck in that broke it.

I caught one build breakage in relocate_kernel_32.S but this is a new
one.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
