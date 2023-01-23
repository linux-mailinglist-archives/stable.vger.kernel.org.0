Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32EF6777B5
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 10:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjAWJtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 04:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjAWJtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 04:49:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44330126F9
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 01:49:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D478F60DBB
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 09:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C74C433EF;
        Mon, 23 Jan 2023 09:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674467351;
        bh=2mKQFRpMo3GG/cuQfSyt8ZK5sa4K5KG2m8MEzqEkMRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ybJ/uDtZ/qjWkwzZs3Q1niyWg2k/k1Lkf96RCX89DjU5DuejI3AqKLbNnj7C2CqQD
         87u1+tq4sVmpMp/Belx8MMQbu/4KSjCZyDbHO4GhgsfIg/8FHKWiur8zsNARO+X7AW
         nyB34oa2RqB8htQGjBbMvdwnw17uKDyYCLGHjarU=
Date:   Mon, 23 Jan 2023 10:49:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: Missing 5.10/5.15 stable patches
Message-ID: <Y85YFKN4mX4JFNNX@kroah.com>
References: <68f7505b-e6e4-bcaa-63ed-418e247a143f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68f7505b-e6e4-bcaa-63ed-418e247a143f@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 10:47:42AM -0700, Jens Axboe wrote:
> Hi Greg,
> 
> As mentioned, two of them could be discarded. Here are the 4 that should
> indeed get applied, ported to 5.10/15 stable and tested. The series
> applies cleanly to both trees, so just sending one set rather than applying
> to the individual "failed to apply" emails.

Thanks for these, all now queued up!

greg k-h
