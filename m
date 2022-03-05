Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5965A4CE43B
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 11:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiCEKiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 05:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiCEKit (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 05:38:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE4613F06
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 02:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 508E1B8095A
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 10:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9368FC004E1;
        Sat,  5 Mar 2022 10:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646476677;
        bh=qAxXKcbLf+Wcl7Z6f9+pC47dp/2vMwlVkdizpLuJDQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QoGPg7fZyvJ6j64zhfeoHAlISz2t9p6XQAIY6VqLHVOh/Hs3Z3/IYTnL7nqSzbrJq
         72K5s0HD5zZ9nYob782sIy+voULkxVCQFdQCD47ti7m1p7yv1TSwLbBgL5plwsgD2b
         4VoexUKO4Q1dT7fAs83KIdivNN9TjNwwt82abUWg=
Date:   Sat, 5 Mar 2022 11:37:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Two more btrfs fixes for 5.16.x
Message-ID: <YiM9gVSMxbWQbXkE@kroah.com>
References: <20220304171245.GA12643@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304171245.GA12643@suse.cz>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 04, 2022 at 06:12:45PM +0100, David Sterba wrote:
> Hi,
> 
> there are two more patches that did not have the CC: stable tag from the
> recent series to fix defrag in btrfs. Please add them to 5.16 queue,
> both apply cleanly, thanks.
> 
> d5633b0dee02  btrfs: defrag: bring back the old file extent search behavior
> 199257a78bb0  btrfs: defrag: don't use merged extent map for their generation check

Both queued up, thanks.

Are you sure that the last patch above doesn't also belong in 5.15.y?

greg k-h
