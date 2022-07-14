Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B522F574C84
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 13:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbiGNLzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 07:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiGNLzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 07:55:21 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F7132B85;
        Thu, 14 Jul 2022 04:55:19 -0700 (PDT)
Received: from nazgul.tnic (unknown [193.86.92.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DF55C1EC04C2;
        Thu, 14 Jul 2022 13:55:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1657799714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=VigSIAP0vMooED+iGpln09ZtL2HUkXcMkFxO04zQRFc=;
        b=qlemYsAJq/zsR7aF/InNlmVZnmbXsupJ6sQI+8ovCd2BfHD0pmalslGdL64IkWQDm12Y6f
        ugFUEhilLs3vMlx/rvCrdKzde5qVJuv6HjgAhPq4sMeWRu9Ja96ctisAUTKVGqhBlD+tbw
        HN+rqBPo8VKNRvFj8Zkmmkg5x58bpB8=
Date:   Thu, 14 Jul 2022 13:54:29 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH] x86/kvm: fix FASTOP_SIZE when return thunks are enabled
Message-ID: <YtAD9S/9L6nT2OFw@nazgul.tnic>
References: <20220713171241.184026-1-cascardo@canonical.com>
 <Ys/ncSnSFEST4fgL@worktop.programming.kicks-ass.net>
 <976510d2-c7ad-2108-27e0-4c3b82c210f1@redhat.com>
 <YtACcLRLs3qlwbbV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YtACcLRLs3qlwbbV@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 01:48:00PM +0200, Greg Kroah-Hartman wrote:
> Shouldn't this go through the x86-urgent tree with the other retbleed
> fixes?

I zapped the simpler version I had in tip:x86/urgent so that Paolo can
route this one without conflicts to Linus.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
