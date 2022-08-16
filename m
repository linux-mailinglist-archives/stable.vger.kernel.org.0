Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F1259593A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiHPLDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiHPLCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:02:32 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0F2FC319
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 03:16:33 -0700 (PDT)
Received: from quatroqueijos (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 527343F3BB;
        Tue, 16 Aug 2022 10:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660644991;
        bh=cGLkOgb0fFwpzJDjrwQMZS81n7ha+Et8e+c6NaA9Wt0=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=tRyLTfQujQJSVsGbfkU8H884rVeT+pGMMbGvx98yrzEKjGdi4aSz2pPjx+l2TDuvo
         9QTtlIu4eTgArk/ouXvt7/3LiGWWZ17KSS48/Eh+BDe677sogPAioySRrTjlQe+qSD
         uBfomAqRdYxsSrZy9wUglLczdC6m3pOxggiCLkKfpfF0EYTW1LNe9Jb3DDfmW5Tv+M
         eddFdQy8od58lJTs83yG3S4hyVIYDduHyZErXZotk0Xtv7a05pgneA2VN5QL3cm4JH
         jWck/QpAjy7dx2Z49CDvTXgtO2XZTGQbiWpuUTZ0+whcr/B3UetLlntYM6sLuIvRh9
         SENnJcagf5j8A==
Date:   Tue, 16 Aug 2022 07:16:25 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, paul.gortmaker@windriver.com,
        peterz@infradead.org, bp@suse.de, jpoimboe@kernel.org
Subject: Re: [PATCH 1/3] Revert "x86/ftrace: Use alternative RET encoding"
Message-ID: <YvtueWo2F3ZR/Y3r@quatroqueijos>
References: <20220816041224.GE73154@windriver.com>
 <20220816082658.172387-1-cascardo@canonical.com>
 <Yvtg/BOAKHQdU0V6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yvtg/BOAKHQdU0V6@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 11:18:52AM +0200, Greg KH wrote:
> On Tue, Aug 16, 2022 at 05:26:56AM -0300, Thadeu Lima de Souza Cascardo wrote:
> > This reverts commit 3af2ebf798c52b20de827b9dfec13472ab4a7964.
> > 
> > This temporarily reverts the backport of upstream commit
> > 1f001e9da6bbf482311e45e48f53c2bd2179e59c. It was not correct to copy the
> > ftrace stub as it would contain a relative jump to the return thunk which
> > would not apply to the context where it was being copied to, leading to
> > ftrace support to be broken.
> > 
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > ---
> >  arch/x86/kernel/ftrace.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> What stable tree(s) is this to be for?
> 
> Context is everything :)
> 
> thanks,
> 
> greg k-h

Yeah, I was just thinking that I missed it, and whether I would be able to
respond to my own message before you did.  :-)

This series is targed at 5.15. I will look at 5.10 next.

Thanks.
Cascardo.
