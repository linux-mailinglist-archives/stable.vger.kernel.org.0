Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1AA58FA9C
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 12:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiHKKVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 06:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiHKKVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 06:21:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B52B255B3
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 03:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 402D4B81F8B
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 10:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D05BC433D7;
        Thu, 11 Aug 2022 10:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660213275;
        bh=dUeODZ4qKtU3x4fpEIi6wefgjQfaZd2WH2diVhwRxz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NYTfaZciqRzMV9TiGezxDTypo7VVppQBfe0z8MjuqWHzfBIzq4MkSJ1kxzRoZWYgn
         hg0IZISQVDGKKodvcFhAevPgHG5o7v5nexPzuJnTrvXuhdGVPTsd1c8Uxa5WvFkIn3
         CxcQCmLUZaa5IJLqnV+8a8gAHD4qcHKCgr03wGZ8=
Date:   Thu, 11 Aug 2022 12:21:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/1] selinux: drop super_block backpointer from
 superblock_security_struct
Message-ID: <YvTYGJh2JQR4vOVZ@kroah.com>
References: <20220808115922.331003-1-theflamefire89@gmail.com>
 <YvEPfSBGdBV0ZohA@kroah.com>
 <7769a909-9054-3215-dd3e-00bfb822d003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7769a909-9054-3215-dd3e-00bfb822d003@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 11:46:09AM +0200, Alexander Grund wrote:
> On 08.08.22 15:28, Greg KH wrote:
> > But, we only take patches that actually do something.  This one doesn't
> > do anything at all, and has no measurable performance or bugfix that I
> > can determine at all.
> 
> Isn't "doing less" also worth the patch?
> I mean this patch removes a superflous pointer of the superblock struct
> making the kernel use less memory.

Also, how much measurable memory does this save?  You did not quantify
it.

