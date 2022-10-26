Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D145160E3FD
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbiJZPBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbiJZPBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:01:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A8372B54;
        Wed, 26 Oct 2022 08:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A646B822B7;
        Wed, 26 Oct 2022 15:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E5EC433D6;
        Wed, 26 Oct 2022 15:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796491;
        bh=n4/bSJRGPaHG6gg6DhxrLuyda0RfQUlRms8iW7cyv9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DtjaGLHEgVvgvBorqId6mVnIaKvj3wGP/gEMF2QcqWeinzpJsIECda6GShJvVnqVG
         WEdeZdMNa7UGrPlcv6SMER3sy0jAjnXYUbJAkh6pPbXb2AqM0XHJDRxGNIJfyQfZqI
         XbfMzf8LFDVIjLuwHxvAswDkb9YQ6f+JvAW0dIgI=
Date:   Wed, 26 Oct 2022 17:01:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH STABLE 5.15] btrfs: enhance unsupported compat RO flags
 handling
Message-ID: <Y1lLyEXl+XsD/Jjn@kroah.com>
References: <12f048b72ae2e2a465a519cf6402f0e6cf19321d.1666594445.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12f048b72ae2e2a465a519cf6402f0e6cf19321d.1666594445.git.wqu@suse.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 02:54:54PM +0800, Qu Wenruo wrote:
> commit 81d5d61454c365718655cfc87d8200c84e25d596 upstream.
> 
> Currently there are two corner cases not handling compat RO flags
> correctly:

Now queued up, thanks.

greg k-h
