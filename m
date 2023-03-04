Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B935E6AAB21
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 17:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjCDQ34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 11:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDQ34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 11:29:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D43BEC4B
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 08:29:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CC1860018
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 16:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA241C433EF;
        Sat,  4 Mar 2023 16:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677947394;
        bh=umcemy53qtUEgWpL2tTKrKeIQakV5HeE4WLED07PO+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mS+8Z8zjABOax/2EbhHpD4lwOdmcWbCa6y/lSdraiS//az2rzVbsPzlwsSv7BGeAe
         noOE0NBCPi6W0ZOzerfUqyyXio269QYLxScv06Gdg29EtMcJWI5VsCa1x882ZcxyR1
         Llswzjs98WoMdC/MvpgCwrmIKMaJVy3iteS4AaQE=
Date:   Sat, 4 Mar 2023 17:29:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Laurent Lyaudet <laurent.lyaudet@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Too many BDL entries regression
Message-ID: <ZANx/xXokp2ju4Uw@kroah.com>
References: <CAB1LBmv1kY+kuUBWvXRoe+mbQBjtJOFvZB8Smmbcuy2MdvgJnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB1LBmv1kY+kuUBWvXRoe+mbQBjtJOFvZB8Smmbcuy2MdvgJnA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 04, 2023 at 04:41:23PM +0100, Laurent Lyaudet wrote:
> Hello,
> 
> Thanks for your hard work :)
> Ubuntu 22.10 shipped kernel 5.19.0-35 thursday.

There's not much we can do about this old and obsolete kernel version,
sorry.  Please work with your distro to resolve it.

If you use a kernel.org release, we will be glad to help you out, as you
point out, that is much newer as can be seen on the front page of
www.kernel.org

thanks!

greg k-h
