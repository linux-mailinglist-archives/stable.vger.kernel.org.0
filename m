Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0796459F90C
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 14:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbiHXMKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 08:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbiHXMKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 08:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDD43CBCA
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 05:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7977E61978
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 12:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C901C433C1;
        Wed, 24 Aug 2022 12:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661343013;
        bh=F2YLkXUGAvRl48RIOlzNr8FE+/+6p1ERwGx5pTSE3VE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1pH/UocznpjiCps8ensqsYUuh19qmlT006/eMPQ3gvPUu6eOHTHt0zXjoqQvngdD1
         niBCxTh988+N28oSV/So4zv6nyfX8NiycP73fCS0AecxtnvX02Yf5+GG8MTmwTntKu
         AxiHCRRSpKqRutyAOpKguKlgTG/b9rUhKchZ8Kh4=
Date:   Wed, 24 Aug 2022 14:10:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: Backport request
Message-ID: <YwYVIgnHnKUnoChu@kroah.com>
References: <f02f8fb3-2e68-a405-aaef-adc769754bd3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f02f8fb3-2e68-a405-aaef-adc769754bd3@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 01:20:22PM +0200, Juergen Gross wrote:
> Hi Greg,
> 
> stable kernels 5.18 and 5.15 seem to be missing upstream patch
> c64cc2802a78 ("x86/entry: Move CLD to the start of the idtentry macro").
> This is a prerequisite patch for 64cbd0acb582 ("x86/entry: Don't call
> error_entry() for XENPV"), which is included in 5.15.y and 5.18.y.
> 
> Could you please take c64cc2802a78 for 5.15 and 5.18?

5.18 is end-of-life, so that's impossible to do now :(

For 5.15.y, the commit does not apply cleanly, can you provide a working
backport?

thanks,

greg k-h
