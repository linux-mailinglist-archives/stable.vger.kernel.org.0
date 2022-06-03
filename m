Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8B853CB87
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 16:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245079AbiFCOdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 10:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244009AbiFCOdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 10:33:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A3728E20;
        Fri,  3 Jun 2022 07:33:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 82E02CE23A2;
        Fri,  3 Jun 2022 14:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E9DC385A9;
        Fri,  3 Jun 2022 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654266778;
        bh=9g1TkF5RXob++DVAvJ+Q08Uj4F4cigdkgziPEkQcNKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PaEBXFLkd999DgjHojB5rIBkxN4fShXq0Axh7Mm2K4brW7abK+50HFo38AXe8Ehup
         Fah9YLt8V+rYQR483J44HuACH1IlnN6wJSl55HB5fR+RKynEOJLauxOTd9rMoQ0HHC
         26TswkItKoiwukThReV7kWA2h5/I7mLCDRZgK3C0=
Date:   Fri, 3 Jun 2022 16:32:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, Jan Kara <jack@suse.cz>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 v2 0/5] xfs fixes for 5.10.y (part 1)
Message-ID: <Ypoblx9ilQOGh50E@kroah.com>
References: <20220527130219.3110260-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527130219.3110260-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 04:02:14PM +0300, Amir Goldstein wrote:
> Hi Greg and Shasha!
> 
> It has been a while since you heard from xfs team.
> 
> We are trying to change things and get xfs fixes flowing to stable
> again. Crossing my fingers that we will make this last this time :)
> 
> Please see this message from Darrick [4] about xfs stable plans.
> My team will be focusing on 5.10.y and Ted and Leah's team will be
> focusing on 5.15.y at this time.
> 
> This v2 is being sent to stable after testing and after v1 was sent
> for review of the xfs list [5].
> 
> v2 includes an extra patch that Christoph has backported and tested
> and was going to send to stable.
> 
> Please see my cover letter to xfs with more details about my plans
> for 5.10.y below:

All now queued up, thanks for doing this and I look forward to more xfs
patches being sent to us!

greg k-h
