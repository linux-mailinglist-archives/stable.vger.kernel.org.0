Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1865658DC
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 16:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiGDOmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 10:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGDOmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 10:42:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0F5CE4;
        Mon,  4 Jul 2022 07:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D1A7B8107D;
        Mon,  4 Jul 2022 14:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60112C3411E;
        Mon,  4 Jul 2022 14:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656945768;
        bh=tBhEgEpb/llK8t3VU9HDVFpw2usy/rSjHgRh8oQF1gI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NJ5MzfNlX0H0+s3vK5e6rTt1gky3hCjSBvlnwPgj9+IfjTNF0l9B5yVb8R+8Ih0ZT
         Pel+c/X7TDdCvTA4ifA7/yhsq4JM645cA2ZS4mw0spV1o7hjLCru4SGv+swywdTl8r
         /t5IVroIGW9HUgzpVu0N6w5dJdarplhkmkZEQfgs=
Date:   Mon, 4 Jul 2022 16:42:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 v3 0/7] xfs stable patches for 5.10.y (from v5.13)
Message-ID: <YsL8Zom5K3GjzMz+@kroah.com>
References: <20220703050456.3222610-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220703050456.3222610-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 03, 2022 at 08:04:49AM +0300, Amir Goldstein wrote:
> Hi Greg,
> 
> Following the 5.10.y/5.15.y common series, this is another small
> "5.10.y only" update.
> 
> I have two more of these (from v5.14 and v5.15) and after that,
> 5.10.y should be mostly following 5.15.y.
> 
> The backports from v5.14 are a little more involved, so the next
> "5.10.y only" update is going to take a while longer.

All now queued up, thanks.

greg k-h
