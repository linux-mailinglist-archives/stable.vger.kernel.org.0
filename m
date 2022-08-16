Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F74595CB3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 15:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiHPND3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 09:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbiHPNDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 09:03:07 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA5CB5A4C;
        Tue, 16 Aug 2022 06:01:39 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9855329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9855:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1C7131EC01D4;
        Tue, 16 Aug 2022 15:01:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660654894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDaKfCiFgyxx3ZrcVJwM3i4NjJJIQ4/lD6ZRQjvQcgk=;
        b=JXU2pzIcu9Fk1uibAAqMT0OC4FflwKs80pbYWItFXioWQdaFZNreBGN1NXA/rznno491xy
        ffGHUinTK6RVZeMNT7TE1w9yuag6UNy+jhGNDiuc/qvf/gbTCbZ3JtaAVCchngo24l0onV
        lGQV6b7t4AiDjv5br40xFa1R+hRKztE=
Date:   Tue, 16 Aug 2022 15:01:33 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
Message-ID: <YvuVLUXjCBkLf8sJ@zn.tnic>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
 <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
 <82d09944-9118-e727-705d-da513eca0bf1@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82d09944-9118-e727-705d-da513eca0bf1@citrix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 12:52:58PM +0000, Andrew Cooper wrote:
> One minor point.  Stuff 32 slots.
> 
> There are Intel parts out in the world with RSBs larger than 32 entries,
> and this loop does not fill the entire RSB on those.
> 
> This is why the 32-entry stuffing loop is explicitly not supported on
> eIBRS hardware as a general mechanism.

I'm guessing there will be an Intel patch forthcoming, making that
RSB_CLEAR_LOOPS more dynamic, based on the current model.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
