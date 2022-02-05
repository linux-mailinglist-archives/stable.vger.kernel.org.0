Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80814AA7FA
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 10:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359169AbiBEJry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 04:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352879AbiBEJrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 04:47:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33C1C061346
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 01:47:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D48B360A76
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 09:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7894EC340E8;
        Sat,  5 Feb 2022 09:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644054471;
        bh=B2dS+UWvPmW1TTR4xM5ZkGraz/XcxQbH7PyL8Hfbzoo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rig1a61h+IOPagUxf9c5kY7PGVww0TVXuv/NwahFGZEwNwkE/tWKwcDDDKz0sL2lv
         UyBL7l6v/Z8Im+iR8O8dVG63VdS/MZNlFMrxZ8BWUQZJN5NocYaY6P72JKHWZKIKco
         5AFLUl026yZEvGq7SPE9u/ZUZcXFc0Ud7n+gOkV4=
Date:   Sat, 5 Feb 2022 10:47:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tabitha Sable <tabitha.c.sable@gmail.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cgroup-v1: Require capabilities to set
 release_agent" failed to apply to 4.9-stable tree
Message-ID: <Yf5Hw+ozu8p8uACd@kroah.com>
References: <164396325327225@kroah.com>
 <CAM62SmKNsDeCQuU7CPtu-rZw_58Sb1d917ibWKYAG2yakNU80g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM62SmKNsDeCQuU7CPtu-rZw_58Sb1d917ibWKYAG2yakNU80g@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 11:28:19AM -0600, Tabitha Sable wrote:
> I'm happy to help with this, but I'm not familiar with the conventions for
> sending in backport diffs.
> 
> I've read through the docs on kernelnewbies and found them to be both
> overwhelmingly big and also not directly relevant to this particular
> situation. I think if I simply try to follow them I'll foul things up.

Yeah, it's not the same thing at all.

> Can I simply make the changes against the appropriate git branch, build and
> test, and then email in the diff to stable@vger.kernel.org copying most of
> what you've put in the original email, greg?

Yes, that's exactly what we need here.  Be sure to let me know what the
git id of the commit is in Linus's tree so we can properly track it (you
can put it in the changelog text somewhere.)

thanks,

greg k-h
