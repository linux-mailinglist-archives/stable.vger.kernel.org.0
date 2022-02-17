Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9634BA8B0
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 19:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbiBQSrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 13:47:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbiBQSrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 13:47:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD23B3CFCD
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 10:46:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 942C2B823D1
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 18:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCEAC340E8;
        Thu, 17 Feb 2022 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645123607;
        bh=Uuyhnd4F80taPf8d3Ei9USdGvhCNG7RIDK0xoggXpFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHOaU3V4z110SUL03URjRVUbAROmHGixKmCMWq6cqAC6Zf9W6Drz28PKpxwOb020F
         29Ozq795BH6NYjriLwlgRCg7oLFdaijjLIK5Yl+DCdH+BXNsc8pAn+JvvYhQoeaoCn
         y2MtNJd+c2gwP/3oMxLS9AAHcmEsuVjRN0TkDFXc=
Date:   Thu, 17 Feb 2022 19:46:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        egorenar@linux.ibm.com, hannes@cmpxchg.org, jeremy.linton@arm.com,
        longman@redhat.com, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm: memcg: synchronize objcg lists with a
 dedicated spinlock" failed to apply to 5.10-stable tree
Message-ID: <Yg6YFPHQs2HqWxlx@kroah.com>
References: <164475140586254@kroah.com>
 <YgqqOQLwHdNtvS//@carbon.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgqqOQLwHdNtvS//@carbon.dhcp.thefacebook.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 11:15:05AM -0800, Roman Gushchin wrote:
> On Sun, Feb 13, 2022 at 12:23:25PM +0100, Greg Kroah-Hartman wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> 
> Hi Greg!
> 
> Below is the backport of 0764db9b49c9 ("mm: memcg: synchronize objcg lists with a dedicated spinlock")
> to 5.10-stable.

Now queued up,t hanks.

greg k-h
