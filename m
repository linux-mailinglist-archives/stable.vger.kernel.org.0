Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A73852D29C
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbiESMgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiESMgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:36:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A241512081
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8435A60C81
        for <stable@vger.kernel.org>; Thu, 19 May 2022 12:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0D7C385AA;
        Thu, 19 May 2022 12:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652963768;
        bh=hkb/rfPf+bu8LTys5SsCL5pvGSNXOKgIfFOPK8BQvwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=01/6gFyGYQk08fmGPHG7/tv8y5UPe2t5CUyloYffMwvCBMAh9pQmI1vYKbijj1nxm
         Bni7INtNn9w6SMkNtAgK5IPUrEbdyWw5v+UjZaNxvzRVKJAOlGfW8qkiRUBvBwrigk
         vqX/zvsXpxyNo+sGIyBEpvRRb7kedxHQaiCqZsto=
Date:   Thu, 19 May 2022 14:36:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: Patch for 5.10-stable
Message-ID: <YoY5tZ//ENRFzEiU@kroah.com>
References: <543c3909-a7b6-23ac-2c2e-ce10dd2433e8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543c3909-a7b6-23ac-2c2e-ce10dd2433e8@kernel.dk>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 06:09:39AM -0600, Jens Axboe wrote:
> Hi,
> 
> Can we get this queued up for 5.10-stable? Thanks!

Now queued up, thanks.

greg k-h
