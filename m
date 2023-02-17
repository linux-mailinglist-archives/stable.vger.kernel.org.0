Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E3569AE2F
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjBQOjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjBQOjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:39:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF2C6D7BB
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 06:39:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 764A5CE264C
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 14:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0C7C433D2;
        Fri, 17 Feb 2023 14:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676644763;
        bh=8IEERcQuPU/nTuZx4ymEQOcvNsXp2Ue5LL1gQXxygP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fWh1HATPambORBiHp7j2wcteV4aUwOedWsRF4wjdyf5MBmQhHnpqq8WmCwn2S5bKZ
         oDzgaX+JksvpndKd/80vx827n7AN+qqKhpMOgljz0OhEWb/HnaA8LcrLLIaYTVkZ8B
         dFSmSjEXI71qZZYih6eHxQkMpyu9smt9YdpgSnFY=
Date:   Fri, 17 Feb 2023 15:39:21 +0100
From:   'Greg KH' <gregkh@linuxfoundation.org>
To:     Michael Nies <michael.nies@netclusive.com>
Cc:     "'stable@vger.kernel.org'" <stable@vger.kernel.org>
Subject: Re: AW: Kernel Bug 217013
Message-ID: <Y++RmSBlvzB7rgqs@kroah.com>
References: <HE1PR0902MB188277E37DED663AE440510BE1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
 <Y+ScSE/M54LxkzZu@kroah.com>
 <HE1PR0902MB1882314643322D58AD3A71F8E1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
 <HE1PR0902MB1882AE00D357F1794A25EA15E1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0902MB1882AE00D357F1794A25EA15E1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 09, 2023 at 08:04:52AM +0000, Michael Nies wrote:
> Hi Greg,
> 
> I noticed that gcc 4.6 is also the requirement for kernel 5.4:
> https://www.kernel.org/doc/html/v5.4/process/changes.html
> 
> So anyone who compiles 5.4 with gcc4.6 should also run into the problem.

Thanks for the info, I've queued up a fix for this in the 4.14.y and
4.19.y kernel trees, and it will be in the next release of them.

greg k-h
