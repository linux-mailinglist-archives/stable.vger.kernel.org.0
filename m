Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92315621034
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbiKHMTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiKHMTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:19:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B5B4FF9A;
        Tue,  8 Nov 2022 04:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFAE86151B;
        Tue,  8 Nov 2022 12:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F39C433D6;
        Tue,  8 Nov 2022 12:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667909952;
        bh=vaGB9U2rlqlyaopeED5o0EltCNuZ/88g3VWxR2AQADM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aTTlF5q1IAnQrmglZEz02guAWga8I32ZBQZzKM73aPY4G1+sgL0fzfX4ihcoAI8FU
         e2uHNi/BFhoWnVXyX5ZnSwDMHOKgejCJM3H98SDtWKCmlDZVBRCFg2ukWzT6JUbg0W
         Dpz6DwqikOlr8SpScMzIxE79PmEwfwYroEyapLo0=
Date:   Tue, 8 Nov 2022 13:19:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jintao Yin <nicememory@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Please apply "ext4,f2fs: fix readahead of verity data" to stable
Message-ID: <Y2pJPTSzgnNk37oA@kroah.com>
References: <Y2lL+lSibGY9hPEE@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2lL+lSibGY9hPEE@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 10:18:34AM -0800, Eric Biggers wrote:
> Stable maintainers,
> 
> Please apply commit 4fa0e3ff217f775cb58d2d6d51820ec519243fb9
> ("ext4,f2fs: fix readahead of verity data") to stable, 5.10 and later.  It
> cherry-picks cleanly to 6.0 and 5.15.  I'll send it out manually for 5.10.

All now queued up, thanks.

greg k-h
