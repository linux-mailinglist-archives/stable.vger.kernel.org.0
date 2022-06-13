Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28BD5482C8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbiFMJJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240062AbiFMJJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345A6EE1C
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:09:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABD9AB80E41
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 09:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2693BC34114;
        Mon, 13 Jun 2022 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655111360;
        bh=C1GGeLLqOUP1Uqq8a/peVbcxO+P4+4GcrUo/KiI3Qho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ndETvf67eaf8wDSVVW656Fwc0PXIVLlTImp90yGwbget1ivItbtQt7YZwP9PzJfl0
         4sqjN5u8ZHr6ZGrOEEajXzMjkPOBoMmhCLblogDnX+egVQKd8kt4AqUTOlZddO4EH3
         MK3051CEIvy0UBaEtty9higVxiDgBFnLV9qZ7Xew=
Date:   Mon, 13 Jun 2022 11:09:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yerong Li <yerong.li@outlook.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: external monitor no signal with HDMI port apple-gmux.c
Message-ID: <Yqb+vtXP5DzVK+dz@kroah.com>
References: <SG2PR03MB41529020102E6D613A0E651CFFA69@SG2PR03MB4152.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SG2PR03MB41529020102E6D613A0E651CFFA69@SG2PR03MB4152.apcprd03.prod.outlook.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 02:57:37PM -0500, Yerong Li wrote:
> Hi there:
> 
> I am using debian 11 linux with a macbook pro 2013 15-inch. i7-3740QM CPU
> (NIVIDIA-GPU switch)
> 
> I think on my macbook pro the HDMI port with external monitor is not working
> while the DP port /thunderbolt 2 is working. (Actually one of my 2 DP port
> is working the other is not) These three ports work under MacOS system:
> 
> https://forums.developer.nvidia.com/t/external-monitor-not-working-nvidia-optimus/216573/2
> 
> Many users met similar issues: HDMI got detected by xrandr while the
> external monitor got no signals. Could you help us?
> 
> https://forums.developer.nvidia.com/t/no-signal-with-hdmi-or-dp-0-ports-on-macbookpro10-1-gt-650m-only-dp-1-works/49777/5
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/platform/x86/apple-gmux.c#n311

I do not think this is a regression with the kernel as it never has
worked before.

Please contact the graphics developers so that they can help you out
with this.

Good luck!

greg k-h
