Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE126633CA9
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 13:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbiKVMiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 07:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiKVMiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 07:38:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B2912D3A
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 04:38:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8BD6B81AB1
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 12:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77BDC433C1;
        Tue, 22 Nov 2022 12:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669120677;
        bh=XqZ44koxRfHZqL+mmtTr62oSj8u/Y3jbpHmCu0bagv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e0hzmp7Nov8Jrb1JEo/VOY3sspJ4FRcpzR9N610AkaKRgQKChnXrNzBMAUBbz0Nb6
         ZzGRiBQsDdjtLhvEP3GN+nvRwMuS3Aj6JHzl4f+rqGSr/6jTcXqMtyauTapFbzHWcm
         +ZKfrPOpPqeqH1S5od9MDjFKcjrZtMCT6dDQ3XC4=
Date:   Tue, 22 Nov 2022 13:37:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6.0 1/2] nvme: restrict management ioctls to admin
Message-ID: <Y3zCoVMSiwUlVfYh@kroah.com>
References: <20221122110810.3568811-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122110810.3568811-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 22, 2022 at 01:08:09PM +0200, Ovidiu Panait wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> commit 23e085b2dead13b51fe86d27069895b740f749c0 upstream.
> 
> The passthrough commands already have this restriction, but the other
> operations do not. Require the same capabilities for all users as all of
> these operations, which include resets and rescans, can be disruptive.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> These backports are for CVE-2022-3169.
> 
>  drivers/nvme/host/ioctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)

All now queued up, thanks.

greg k-h
