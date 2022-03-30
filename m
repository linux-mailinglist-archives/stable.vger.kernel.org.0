Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48A64EBE06
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 11:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbiC3JtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 05:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243336AbiC3Js7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 05:48:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34D7266B6E
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 02:47:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E339B81BB9
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74ED5C340EE;
        Wed, 30 Mar 2022 09:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648633629;
        bh=cVEhe1wpDu2oB28IhRhiC+rtxqO2wSCQgGP1baTx0Og=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rsYQiAc3tBT9nPfQcCPwOJ1Gv0zMxXKXbhFrqF5kxFgULx/IGf8xaff4hNLFXeDOV
         S1L5x0r3qz5lxLuA6cMGeIBa52exDrirqIe9IDUdDPGoA6cwTiaQELOEX8SSvuGgBO
         1G74Wv5kIi9Y10cxFEagstOiwI3hEIf+6pLvZ36g=
Date:   Wed, 30 Mar 2022 11:47:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joshua Freedman <freedman.joshua@gmail.com>
Cc:     lis8215@gmail.com, paul@crapouillou.net, stable@vger.kernel.org,
        sboyd@kernel.org
Subject: Re: kernel 5.16.12 and above broke yoga c930 sound and mic
Message-ID: <YkQnGmxdi9GWZmfC@kroah.com>
References: <CAJQ3t4RxYXkREhwBb_JgYj4=ty+VtnV9m65U79ZLbmmj4mN7WA@mail.gmail.com>
 <YkQUGVC3MBSnc2LI@kroah.com>
 <CAJQ3t4TqK+q5zeHCQ2uxGvhT4q0Bpe6PBuDTm28HqyHwH5mzhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJQ3t4TqK+q5zeHCQ2uxGvhT4q0Bpe6PBuDTm28HqyHwH5mzhQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 05:42:45AM -0400, Joshua Freedman wrote:
> I just re-verified all this:
> 
> For audio and mic:
> 5.17.1 is broken.  Dummy Output.  5.16.12 is also dummy output.
> 5.16.11 was the last working version.   5.16.11-76051611-generic

Great, can you use 'git bisect' to track down the exact commit that
causes problems?  Odds are it's not this one, but perhaps an audio
change?

thanks,

greg k-h
