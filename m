Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1635859F3AC
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 08:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbiHXGj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 02:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbiHXGjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 02:39:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFC019288;
        Tue, 23 Aug 2022 23:39:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE5FBB8237C;
        Wed, 24 Aug 2022 06:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19167C43146;
        Wed, 24 Aug 2022 06:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661323191;
        bh=00RV+b9A8Zx/fTvdlJSC2DOpzQG29ULUnfYQyipPrbY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4AO0jEMu7XNiqxo0LTJOX8A/SD7rF2zMA4x0uX3xOsmVaTNlhPC7UuI07y779NV8
         5s0hZJK1w7IxV9KLqIgPzNQVnpvVXZUwd3hnpJ+Gl16VUg5ncnNW3OlgquqZA4CEmb
         qnBahdt6rqocmAIgZbZlnXl+k/u+/T1jfrULqdbo=
Date:   Wed, 24 Aug 2022 08:39:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     stable@vger.kernel.org, srinivas.kandagatla@linaro.org,
        stable-commits@vger.kernel.org
Subject: Re: Patch "soundwire: qcom: Check device status before reading
 devid" has been added to the 5.15-stable tree
Message-ID: <YwXHtBc2Du+a+rY3@kroah.com>
References: <16604006172842@kroah.com>
 <YwT537rlrckb0/VV@matsya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwT537rlrckb0/VV@matsya>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 09:31:35PM +0530, Vinod Koul wrote:
> On 13-08-22, 16:23, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     soundwire: qcom: Check device status before reading devid
> > 
> > to the 5.15-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      soundwire-qcom-check-device-status-before-reading-devid.patch
> > and it can be found in the queue-5.15 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> This is causing regression in rc1 so can this be dropped from stable
> please

This is already in the following released kernels:
	5.15.61 5.18.18 5.19.2
so when you get this resolved in Linus's tree, be sure to also add a cc:
stable to the patch so it will get picked up properly.

thanks,

greg k-h
