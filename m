Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D165EAD81
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiIZRE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiIZREA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:04:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C029262;
        Mon, 26 Sep 2022 09:06:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34D8660F7C;
        Mon, 26 Sep 2022 16:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482EAC433C1;
        Mon, 26 Sep 2022 16:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664208396;
        bh=XVCnyjkSVy0eHL7/04pp3M6bOQCIW+P68Z2rj/ONwM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QSJabHrdGaqfx/GieQwHYSZFLGAs8eACqI2G+IrgXkrrLLUf3fs2rJeQ/RKvCMEHU
         xfM4KEP3wFrAKY8DXpryQbIfvAR/j1cMGI5dmGo5FsucdGhF5HVpCOiRyvPCjRncZj
         jqp4ztRQJFJaR2qebdha7k0RoQ50KdChP2mlIWSo=
Date:   Mon, 26 Sep 2022 18:06:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 04/30] video: fbdev: skeletonfb: Fix syntax errors in
 comments
Message-ID: <YzHOClQJcu24z4Io@kroah.com>
References: <20220926100736.153157100@linuxfoundation.org>
 <20220926100736.313886468@linuxfoundation.org>
 <20220926102801.GA8978@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926102801.GA8978@amd>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 12:28:01PM +0200, Pavel Machek wrote:
> On Mon 2022-09-26 12:11:35, Greg Kroah-Hartman wrote:
> > From: Xiang wangx <wangxiang@cdjrlc.com>
> > 
> > [ Upstream commit fc378794a2f7a19cf26010dc33b89ba608d4c70f ]
> > 
> > Delete the redundant word 'its'.
> 
> This does not belong in stable.

Agreed, I thought I caught this before.  Now dropped.

greg k-h
