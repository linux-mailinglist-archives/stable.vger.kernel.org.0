Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD5969ADBB
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjBQOPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBQOPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:15:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3846C00F
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 06:15:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9854AB82C06
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 14:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0963FC4339B;
        Fri, 17 Feb 2023 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676643267;
        bh=83Da/xcz+aAIbqnU3rPf5qEH62XdhyC4xQohCmPtOHk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fdEgXn6UoJzXDH9rxXMSff6PNaSj+K2IDb1jsY2bIsyznRlNP/OlT3v/mA+4Fv3iF
         WUR9kfCj0Lm23E/DbwJEy8MyjuduaN61u8OWaCvlroy3EPPN6jD2aBoPSxWI6bAudF
         0RR+5ZOSkruBZsIjxQDsJKDb/kDb7LXFC6M3JkN8=
Date:   Fri, 17 Feb 2023 15:14:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qingfang DENG <dqfext@gmail.com>
Cc:     stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Shell Chen <xierch@gmail.com>
Subject: Re: [PATCH 5.15,5.10,5.4,4.19] netfilter: nft_tproxy: restrict to
 prerouting hook
Message-ID: <Y++LwO5sw8amUIFV@kroah.com>
References: <20230216124755.51762-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216124755.51762-1-dqfext@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 16, 2023 at 08:47:55PM +0800, Qingfang DENG wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> commit 18bbc3213383a82b05383827f4b1b882e3f0a5a5 upstream.
> 
> TPROXY is only allowed from prerouting, but nft_tproxy doesn't check this.
> This fixes a crash (null dereference) when using tproxy from e.g. output.
> 
> Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
> Reported-by: Shell Chen <xierch@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Qingfang DENG <dqfext@gmail.com>
> ---
>  net/netfilter/nft_tproxy.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Now queued up, thanks.

greg k-h
