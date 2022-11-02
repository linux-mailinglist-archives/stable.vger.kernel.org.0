Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C23D615BA2
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 05:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKBE6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 00:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKBE6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 00:58:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B886E10E6;
        Tue,  1 Nov 2022 21:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A09AB820BB;
        Wed,  2 Nov 2022 04:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB326C433C1;
        Wed,  2 Nov 2022 04:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667365098;
        bh=kOzIq9EyC4fDMAzs4YGklmDZT3mFY3v1MqN1V44mblQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y2JAyjY85RDwqxFFeIveaG0L96n1uLOz0pLF3nd4r3u0yMm1BE4qJGRuVjg9kgodd
         Y24Wk8YPy7UNGZ5ZVMWTsFuRLv7rL28Kvo5zlmbcOEdGQLjcSKmPl3efG9tmcktndC
         sjlXeaH60OH4Xici4Uv9WiIow94e0vOkH7ZShvk8=
Date:   Wed, 2 Nov 2022 05:59:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     stable@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@denx.de>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH] Documentation: process: Describe kernel version prefix
 for third option
Message-ID: <Y2H5Hs7UQJw8T2IX@kroah.com>
References: <20221101131743.371340-1-bagasdotme@gmail.com>
 <Y2EfhWxk0j/oVLJx@kroah.com>
 <b1914779-0303-3d37-a504-e1715f7ee0af@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1914779-0303-3d37-a504-e1715f7ee0af@gmail.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 02, 2022 at 11:19:44AM +0700, Bagas Sanjaya wrote:
> On 11/1/22 20:30, Greg Kroah-Hartman wrote:
> > 
> > No, sorry, this is not needed and does not have to be in the subject
> > line at all.
> > 
> > The current wording is fine, it's just that people don't always read it.
> > 
> > so consider this a NAK.
> > 
> 
> Hi Greg,
> 
> There was a case when a submitter submitted multiple backports (which
> qualified for third option) without specifying the prefix, hence a
> reviewer complained [1].
> 
> [1]: https://lore.kernel.org/all/20221101074351.GA8310@amd/

Yes, and as I said on that thread, to you directly:
	https://lore.kernel.org/all/Y2Ef0hK4rTmAoEUs@kroah.com/
the submission was done correctly, no one should have complained, and
the patches were applied by me to the correct branches without any
problems at all.

This is not an issue, this change is not needed at all.

greg k-h
