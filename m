Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5A66D7C85
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 14:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjDEM0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 08:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237803AbjDEM0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 08:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1F559FD
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 05:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5669863C30
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 12:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314D2C43442;
        Wed,  5 Apr 2023 12:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680697567;
        bh=KS8UqgSelhGa7C+gRLifjXnPKoyBsz+vUIa+iXWQ5jQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jFwXGszDtHNor+m5NLnXCGo7JLSrGFpU/+wjixjF4g9hmLb36BDXr4i4De7CuMr8z
         OnfU/kl0xNvZbe2r+gFWZ45JlRnZn/EBbkaM/VVlsfx16HjUQ/qvAaO0+UIwuhMH5j
         NfF2cBssGxS4OLIp6qUZl8JSO9B0Cr7760ZkTaSY=
Date:   Wed, 5 Apr 2023 14:26:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pratyush Yadav <ptyadav@amazon.de>
Cc:     kernel test robot <lkp@intel.com>, stable@vger.kernel.org,
        oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.4] cifs/smb3: Fix NULL pointer dereference in
 smb2_query_info_compound()
Message-ID: <2023040539-cherub-flattered-bcc0@gregkh>
References: <ZC1fJiHvpbXcysXi@ec83ac1404bb>
 <mafs0o7o2h7o7.fsf@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0o7o2h7o7.fsf@amazon.de>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 01:47:52PM +0200, Pratyush Yadav wrote:
> On Wed, Apr 05 2023, kernel test robot wrote:
> 
> > Hi,
> >
> > Thanks for your patch.
> >
> > FYI: kernel test robot notices the stable kernel rule is not satisfied.
> >
> > Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> 
> I think the robot should also learn to look at the 'To:' header :-)

Nope, the robot is correct, you submitted this incorrectly.

thanks,

greg k-h
