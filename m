Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005356E4F53
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 19:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjDQRhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 13:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDQRhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 13:37:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDBB268A
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 10:36:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23229621E5
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 17:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCBFC433EF;
        Mon, 17 Apr 2023 17:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681753018;
        bh=Xp2HnRH3xAE2CbDrq1C4eD6tnnEYlkdNoCN7S/+r+xc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ughUkU0MrZPSRwztX3ydIdveuq86YDXcStVNtmlPB8yYuMfwLi9fjwre6y1qR5K1y
         k9xax3NskLl+AB2O1ZvydRRrjaPa3M71I2hh5RwDVER0sBy5QPsZyEG6JjUGQ5jV6u
         JZ8Y7Y+2dJFG+Fs1DfZscIEorBOYJfFPpd836jws=
Date:   Mon, 17 Apr 2023 19:36:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     stable@vger.kernel.org, linux-mtd <linux-mtd@lists.infradead.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        chengzhihao1 <chengzhihao1@huawei.com>,
        Nicolas Schichan <nschichan@freebox.fr>,
        George Kennedy <george.kennedy@oracle.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        yi zhang <yi.zhang@huawei.com>
Subject: Re: Request to pick "ubi: Fix failure attaching when vid_hdr offset
 equals to (sub)page size"
Message-ID: <2023041740-steering-palatable-5451@gregkh>
References: <ZDrmsnX5BHxtBNwf@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDrmsnX5BHxtBNwf@makrotopia.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 15, 2023 at 07:02:26PM +0100, Daniel Golle wrote:
> Hi,
> 
> please pick
> 
>  1e020e1b96afd ("ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size")
> 
> from linux-next to stable trees.
> The commit fixes a problem with another recent commit
> 
>  1b42b1a36fc94 ("ubi: ensure that VID header offset ... size")
> 
> which has already made it to stable trees and thereby broke attaching
> UBI and hence renders devices unbootable.
> 
> As a temporary fix I have applied this patch downstream in OpenWrt.

Now queued  up, thanks.

greg k-h
