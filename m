Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1B852D290
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbiESMer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiESMer (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:34:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D1BA5A8D
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:34:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E9C1B82427
        for <stable@vger.kernel.org>; Thu, 19 May 2022 12:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCFBC385B8;
        Thu, 19 May 2022 12:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652963683;
        bh=TtbPhTphrj12ksgpclKbq8GVcZlRB5gBTbo1Set17tY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N6IK2JCO81BvyIDXAHo8LpUyk9OJs303008rVDDCBpTFZyFAu0kI5AOqzxDjpx2bk
         uzlPz+mvnFHVvtgD9kJjuQmWiLs7TOLQVuW1IHu9xchO7RTmc8vPS0Kk2trrqU1ycg
         oddPoanVtp9CMFsE8v2yg3/8Wm1DuhxvqVGh16bU=
Date:   Thu, 19 May 2022 14:34:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Cherry-pick patch request for 5.15-stable
Message-ID: <YoY5YKsUp4zIXqC7@kroah.com>
References: <032e7301-10ef-c392-04ed-345763e893da@kernel.dk>
 <b0d16f69-f345-3a6a-3e42-122016fb601a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0d16f69-f345-3a6a-3e42-122016fb601a@kernel.dk>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 06:10:46AM -0600, Jens Axboe wrote:
> On 5/17/22 8:37 PM, Jens Axboe wrote:
> > Hi,
> > 
> > Can you cherrypick:
> > 
> > commit e74ead135bc4459f7d40b1f8edab1333a28b54e8
> > Author: Pavel Begunkov <asml.silence@gmail.com>
> > Date:   Sun Oct 17 00:07:08 2021 +0100
> > 
> >     io_uring: arm poll for non-nowait files
> > 
> > into 5.15-stable? It should apply cleanly.
> 
> I didn't see this in the 5.15.41 release that just happened
> yesterday, just a ping to remind you that this is needed for
> 5.15-stable.

I already had the -rc releases out when you requested this, please give
me a chance to catch up, it's been less than 2 days!  :)

I'll queue this up now...

greg k-h
