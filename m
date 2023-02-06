Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D468E68B8D2
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 10:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjBFJkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 04:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjBFJjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 04:39:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D8F126F3
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 01:39:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3208FB80DFA
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 09:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB9FC433D2;
        Mon,  6 Feb 2023 09:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675676388;
        bh=U9LM5+a8qtFIi68vUm8HLqnKe1iZbiSapiJgISkNoZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F36ld6yWuumf7hpzEUC5WGgP1udJySXXZwnpd2zXCGYy8fjNIEWPpYfTM4sfU6Do7
         3+1oNRavfnKzGfW5N/WzowU+liTM7rXQwpfHwQnK+jTwRidPE63M1IJTzgX/UuuMZF
         niFVefRAq36QBmv/jdPk6kc11XMxuXy8ABY299F8=
Date:   Mon, 6 Feb 2023 10:39:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xinghui Li <korantwork@gmail.com>
Cc:     peterz@infradead.org, jpoimboe@redhat.com, tglx@linutronix.de,
        stable@vger.kernel.org, x86@kernel.org, alexs@kernel.org
Subject: Re: [bug report]warning about entry_64.S from objtool in v5.4 LTS
Message-ID: <Y+DK4fP/u7iYi7Kt@kroah.com>
References: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
 <Y+CSwTDESQjTzS8S@kroah.com>
 <CAEm4hYW-LzXbf-ZrsG59LrHB067NhuYkRSLzsd8RBfwzA8z1mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEm4hYW-LzXbf-ZrsG59LrHB067NhuYkRSLzsd8RBfwzA8z1mg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 06, 2023 at 05:22:54PM +0800, Xinghui Li wrote:
> Greg KH <gregkh@linuxfoundation.org> 于2023年2月6日周一 13:40写道：
> 
> > If you rely on the 5.4.y kernel tree, and you need this speculation
> > fixes and feel this is a real problem, please provide some backported
> > patches to resolve the problem.
> >
> > It's been reported many times in the past, but no one seems to actually
> > want to fix this bad enough to send in a patch :(
> >
> > Usually people just move to a newer kernel, what is preventing you from
> > doing that right now?
> >
> > thanks,
> >
> > greg k-h
> Thanks for your reply~ I am sorry about reporting the known Issue.
> I am trying to fix this issue right now. And I met the CFA issue, so I
> just want to discuss it with the community.

Is this an actual real problem that you can detect with testing?  Or is
it just a warning message in the build?

> We keep staying in v5.4 because we developed the product base on v5.4
> 3 years ago.
> So it is unstable and difficult to update the kernel version.

That is very odd, why is it hard to update to a new kernel?  What
happens if 5.4 stops being maintained tomorrow, what are your plans to
move to a more modern kernel?  Being stuck with an old kernel version
with no plans to move does not seem like a wise business decision:(

> I will try to find out a way to fix this issue.

Great, and we will be glad to review patches.

thanks,

greg k-h
