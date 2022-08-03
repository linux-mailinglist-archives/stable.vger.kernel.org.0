Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A1E588B82
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 13:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiHCLrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 07:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiHCLrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 07:47:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEA16477
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 04:47:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52A87B82188
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 11:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2951C433C1;
        Wed,  3 Aug 2022 11:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659527232;
        bh=XCztqeaquaFspH07pvM5Izb2mSXo5sz/5dcl36bVbaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UDRMXAbMSqqJBYzVwroyOxYXusKKHWgwpEKp0La4fvFXJCvO0me/5XGHchg59Vh5M
         OmVe7o93ZpWQ0smRbHcW6Xpm8SJywRX2jMfGhvIA4k00v0/tQka+gCXw35YR+rMjT/
         +npDW8B7Ys1vKEwjkIdexEQFPrRQKIt8V8ZPQyrk=
Date:   Wed, 3 Aug 2022 13:47:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     bp@suse.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/speculation: Make all RETbleed
 mitigations 64-bit only" failed to apply to 5.10-stable tree
Message-ID: <YupgPRjztJ2Q6nxU@kroah.com>
References: <1658741699227195@kroah.com>
 <08d4bd45b7d9bfc10d7cf69185e7f81695ba905c.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08d4bd45b7d9bfc10d7cf69185e7f81695ba905c.camel@decadent.org.uk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 08:44:35PM +0200, Ben Hutchings wrote:
> 
> I'm attaching a backport that should work for all of 5.10, 5.15, and
> 5.18.

Thanks, now queued up.

greg k-h
