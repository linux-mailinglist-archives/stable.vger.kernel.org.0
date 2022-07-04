Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B6D56592F
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiGDPFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 11:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiGDPFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 11:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650F6E0FD
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 08:05:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3CB1616E3
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 15:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0702C3411E;
        Mon,  4 Jul 2022 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656947107;
        bh=Y6bErOlOd7mFGjxa4RWaH+HvOylZNUIAH5jDs/q65XI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zphypHVE5bon1od9Zs8cTutn+NNIYufkLH26vbEHs+c6hvgP2z73djfnw/RrXhXZl
         Udpi8gRTv6RjzBEen2+9pQv+hnmq32KYMaTgwbFOz5+251mkq9k79c6kwiwNiWk4tK
         0c2asvQ1qSBKCyL0CE6iQSy6ueIjrV2k6PPAtOx4=
Date:   Mon, 4 Jul 2022 17:05:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Bin Yang <bin.yang@intel.com>,
        Mark Gross <mark.gross@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19] x86/mm/cpa: Unconditionally avoid WBINDV when we can
Message-ID: <YsMBoNUxDiMVkLDA@kroah.com>
References: <20220704082817.4596-1-wenyang@linux.alibaba.com>
 <YsLJiSZ0mCCEckR2@kroah.com>
 <a3b54463-2a4b-d244-9c3a-b26ddda734e2@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3b54463-2a4b-d244-9c3a-b26ddda734e2@linux.alibaba.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 04, 2022 at 10:29:57PM +0800, Wen Yang wrote:
> 
> 
> 在 2022/7/4 下午7:05, Greg Kroah-Hartman 写道:
> > On Mon, Jul 04, 2022 at 04:28:17PM +0800, Wen Yang wrote:
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > 
> > > commit ab3e9c0b75dcb13e9254ef68caa7f15bc66b6471 upstream.
> > 
> > This commit id is not in Linus's tree :(
> 
> 
> Sorry, accidentally added the internal id.
> 
> It is this commit id in Linus' tree:
> ddd07b750382adc2b78fdfbec47af8a6e0d8ef37
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ddd07b750382adc2b78fdfbec47af8a6e0d8ef37

Please fix up the patch and resend it with this information.

thanks,

greg k-h
