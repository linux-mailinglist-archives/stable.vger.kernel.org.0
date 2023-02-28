Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C31A6A5ED1
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 19:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjB1SgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 13:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB1SgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 13:36:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE7D21282;
        Tue, 28 Feb 2023 10:36:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35D8161048;
        Tue, 28 Feb 2023 18:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4234DC433EF;
        Tue, 28 Feb 2023 18:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677609368;
        bh=4i2w3IjZpNVaaX/QXWl+jjxOp48vuN+cZ/1cr/Gy4Rs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IswZsZP2rr/5zrUJ4S89pykp6mhI3haKo9AF2OjnaKwOp3TjtAToT56/rrl4tIB0q
         WJeXQ5zTXfYFlqXFVpdYF7TNx43GWpXXjGncCwD29RDwA02vJ/6ESQXeR+QABIrhVz
         W+fit+7HPEi6Hh6O9ilQ/VD6R1Jqmgr2f0KDYvNQ=
Date:   Tue, 28 Feb 2023 19:36:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc:     stable@vger.kernel.org, Storm Dragon <stormdragon2976@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Please backport commit ae3419fbac84 ("vc_screen: don't clobber
 return value in vcs_read")
Message-ID: <Y/5Jlg3M/2KYtfzV@kroah.com>
References: <15acd998-ea8a-4897-9920-dd19fc06a996@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15acd998-ea8a-4897-9920-dd19fc06a996@t-8ch.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 03:42:12AM +0000, Thomas Weißschuh wrote:
> Hi,
> 
> please backport the following commit[0] to all stable releases that
> contain the commit
> 226fae124b2d ("vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF")
> 
> Commit 46d733d0efc7 ("vc_screen: modify vcs_size() handling in vcs_read()") [1]
> also tries to fix this commit but should not actually be necessary for a
> proper fix. It may make sense to also backport for consistency.

Now queued up, thanks.

greg k-h
