Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF50260E58F
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiJZQnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiJZQnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:43:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD65DBCB5;
        Wed, 26 Oct 2022 09:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D28FB82387;
        Wed, 26 Oct 2022 16:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B6EC433D6;
        Wed, 26 Oct 2022 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666802585;
        bh=6BdUDzrTWv7lQM9PT7jH50q2oQbyw0zx9UeXFuq2mys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2WS3IOjYid/UHum4bQD1Wu+XM7qJnGfLhg0J+sy4guBg1vVqgJ40P48QPU3LKCj5a
         1TzfbMZKQhom60prmAv8UvyA/xV33tsAfBwHmp3zXl26akfVNxFd7ifkmKTgMxHamG
         dYA6VOX1SlFTZ9k930V/m3tlXdrXZG7lBgh0THp4=
Date:   Wed, 26 Oct 2022 18:43:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     mdecandia@gmail.com
Cc:     akpm@linux-foundation.org, bsegall@google.com, edumazet@google.com,
        jbaron@akamai.com, khazhy@google.com, linux-kernel@vger.kernel.org,
        r@hev.cc, rpenyaev@suse.de, shakeelb@google.com, stable@kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 5.4 051/389] epoll: autoremove wakers even more
 aggressively
Message-ID: <Y1ljluiq8Ojp4vdL@kroah.com>
References: <20220823080117.738248512@linuxfoundation.org>
 <20221026160051.5340-1-mdecandia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026160051.5340-1-mdecandia@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 06:00:51PM +0200, mdecandia@gmail.com wrote:
> 
> Subject: [PATCH 5.4 051/389] epoll: autoremove wakers even more aggressively
> 
> Hi all,
> I'm facing an hangup of runc command during startup of containers on Ubuntu 20.04,
> just adding this patch to my updated linux kernel 5.4.210.

I do not understand what you mean by this, sorry.

What kernel causes problems?

What commit causes issues?

What commit fixed the issue?

confused,

greg k-h
