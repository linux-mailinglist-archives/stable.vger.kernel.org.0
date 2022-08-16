Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6CB595BD4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiHPMhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiHPMhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:37:01 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B5294EFE;
        Tue, 16 Aug 2022 05:36:59 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9855329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9855:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8C0171EC0258;
        Tue, 16 Aug 2022 14:36:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660653413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KrgqImSAk47knMlrRM2ewxLQS3YXG//jQh8+BkhLPBs=;
        b=cTBC0GBMHr8YFzcsOGC2wdjZKq4O1V73JLMzJkXbxnUlzmyux4CvN2VQF6rQfnUpfGCUy2
        tYAy3Tu9aWALZTU0cYOKSN4FHIRgCY6oJi5gI+7akhLQQD37cL+KeYZDThqVZovorNFMjx
        uaa/3cZ5sgQl0Fx7U+QKO5XaUhZy48s=
Date:   Tue, 16 Aug 2022 14:36:53 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
Message-ID: <YvuPZYhoZLaSRKmr@zn.tnic>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
 <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
 <YvuOnkhj/Z8naRmN@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YvuOnkhj/Z8naRmN@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 02:33:34PM +0200, Greg Kroah-Hartman wrote:
> I need an Intel person

Daniel?

> to test this as I have no idea how to do so as his is an issue in
> tLinus's tree.

If this passes - and I have my both fingers crossed - this will be an
amazing simplification.

Might wanna take it into stable too, when ready.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
