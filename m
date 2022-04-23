Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DBF50C897
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 11:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiDWJeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 05:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbiDWJeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 05:34:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BDC236691
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 02:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EDF860E17
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 09:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B74C385A0;
        Sat, 23 Apr 2022 09:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650706283;
        bh=aTtR0DGk6Kh6Dha5BLWbqzF8LElLcDOPk/HavMSIurY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FTrLondU86PbV8ldYWULmCc6wq9o4mxXw1uIJNTuGepayHmu2XFA0U5L987X2H5Om
         eVsVtMY1DdTjojvrN04SwMmSpnpC7PnA7RMNM3Cxi/5YNhUSqk9ekes8umuLgCZZmL
         xvKTqACzhsWJPgi544FLsjYtDJaRG7so70RjiM6M=
Date:   Sat, 23 Apr 2022 11:31:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Robert Kolchmeyer <rkolchmeyer@google.com>
Cc:     stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: Request to cherry-pick 3db09e762dc7 to 4.14+
Message-ID: <YmPHaOjWuegSYE6p@kroah.com>
References: <CAJc0_fxu9ehTRQYZ2A-WYhQ2bfXHoQGc1XL0cOrYLRavLMj71w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc0_fxu9ehTRQYZ2A-WYhQ2bfXHoQGc1XL0cOrYLRavLMj71w@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 22, 2022 at 04:39:01PM -0700, Robert Kolchmeyer wrote:
> Hi all,
> 
> Commit 3db09e762dc79584a69c10d74a6b98f89a9979f8 upstream ("net/sched:
> cls_u32: fix netns refcount changes in u32_change()") fixes a crash
> and seems like a good candidate for stable trees.
> 
> The change fixes 35c55fc156d8 ("cls_u32: use tcf_exts_get_net() before
> call_rcu()"), which was added in 4.14, so I think it might make sense
> to cherry-pick the fix to 4.14+.

Did not apply to 4.14.y or 4.19.y, so can you please provide a working
backport for those trees?

Queued up now for the other trees.

thanks,

greg k-h
