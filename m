Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7136C2B15
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 08:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjCUHMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 03:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCUHMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 03:12:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1372ED72
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 00:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A283BB80A25
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 07:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D68C433D2;
        Tue, 21 Mar 2023 07:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679382742;
        bh=MYHwvAecIn/MJ1cf9GJkT4Tm9G9T1Dl3igb4+UHlAY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f9QcUSt6GhD+1fJOxZrB2iOk66NTs9zVXbCpSddEqtjZiyxta6MacLvognWrs0AcR
         NnwFk+HNsVH2SU/7v4Hz3LLMDbb0r+qPLuI+EZhGvlJsZ7hGlwiy2sTIDSNxxDliGn
         dyWcuqR9cyk3s3ceFi/kLgLj5Oh6fLpvQrvgUP9U=
Date:   Tue, 21 Mar 2023 08:12:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Cc:     John Harrison <John.C.Harrison@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Regression] drm/i915: Don't use BAR mappings for ring buffers
 with LLC alone creates issues in stable kernels
Message-ID: <ZBlY0yzJsT4k7bRL@kroah.com>
References: <8a1bbe56-4463-d18d-d5a9-d249171a569d@manjaro.org>
 <a0be2b31-9e72-1254-978e-570b27abb364@manjaro.org>
 <ZBhfhJ0ylxqXPHee@kroah.com>
 <efc7e85a-a170-ba1b-8746-b00784e81e39@manjaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <efc7e85a-a170-ba1b-8746-b00784e81e39@manjaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 07:58:44AM +0700, Philip Müller wrote:
> On 20.03.23 20:28, Greg Kroah-Hartman wrote:
> > On Sun, Mar 19, 2023 at 10:01:01AM +0700, Philip Müller wrote:
> > > Have to correct the affected kernels to these: 4.14.310, 4.19.278, 5.4.237,
> > > 5.10.175
> > 
> > Please don't top-post :(
> > 
> > Anyway, should be fixed in the next round of releases in a few days, if
> > not, please let us know.
> > 
> > greg k-h
> 
> Hi Greg,
> 
> seems the RCs work out. 4.19.279-rc1 and 5.10.176-rc1 were tested by a user
> who had the issue on i915. In 5.15 series the drm patch got reverted. I only
> see "drm/i915: Don't use stolen memory for ring buffers with LLC" there as
> "drm/i915: Don't use BAR mappings for ring buffers with LLC" was reverted
> with 5.15.101.

So is 5.15.y ok or not?  Sorry, I could not parse your response here.

thanks,

greg k-h
