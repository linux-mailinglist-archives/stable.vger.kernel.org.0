Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0786C68CFD3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 07:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjBGGwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 01:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjBGGwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 01:52:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD1C12F06
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 22:52:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF251611D7
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 06:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B1BC433EF;
        Tue,  7 Feb 2023 06:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675752736;
        bh=a/5voOp3y/aZIrK0C4R366R+m61mokM7kNZGeMuraVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=weOPeeWDkKfXDJt1KtfBmL3mO4DQD6tslc2bIPxHs/lIXMEf4do5dWKyjGZMNa3eB
         JVCw3shO4uR/srrK0XwXB6NzHBIpBW2YRAzLtVGBpo1NxHEh92zKNxsQqanyfnFVui
         jDbDGJSOwm06UqgAdWUImkrFvJNd8H3hTTsmBiXs=
Date:   Tue, 7 Feb 2023 07:52:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xinghui Li <korantwork@gmail.com>
Cc:     peterz@infradead.org, jpoimboe@redhat.com, tglx@linutronix.de,
        stable@vger.kernel.org, x86@kernel.org, alexs@kernel.org
Subject: Re: [bug report]warning about entry_64.S from objtool in v5.4 LTS
Message-ID: <Y+H1HRqfnULl/B9f@kroah.com>
References: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
 <Y+CSwTDESQjTzS8S@kroah.com>
 <CAEm4hYW-LzXbf-ZrsG59LrHB067NhuYkRSLzsd8RBfwzA8z1mg@mail.gmail.com>
 <Y+DK4fP/u7iYi7Kt@kroah.com>
 <CAEm4hYW+p3CdbPkKK8Aiv-ofisQbsBr3xv8Ne9D6QJXeOC9T9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEm4hYW+p3CdbPkKK8Aiv-ofisQbsBr3xv8Ne9D6QJXeOC9T9Q@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 02:43:17PM +0800, Xinghui Li wrote:
> Greg KH <gregkh@linuxfoundation.org> 于2023年2月6日周一 17:39写道：
> >
> > Is this an actual real problem that you can detect with testing?  Or is
> > it just a warning message in the build?
> >
> So far, I have not met the actual error in running time.
> But according to Kuniyuki's report, it seems like this commit will
> cause an actual running time error.

I do not understand the actual runtime error, sorry.  Stack traces don't
matter at runtime, do they?

> > That is very odd, why is it hard to update to a new kernel?  What
> > happens if 5.4 stops being maintained tomorrow, what are your plans to
> > move to a more modern kernel?  Being stuck with an old kernel version
> > with no plans to move does not seem like a wise business decision:(
> >
> The product base on v5.4 is the LTS version just like the
> stable-kernel in the upstream community.

That was not the question I asked :(

thanks,

greg k-h
