Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B895A534EF5
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 14:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345948AbiEZMQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 08:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiEZMQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 08:16:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F9753728
        for <stable@vger.kernel.org>; Thu, 26 May 2022 05:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCC1EB81EC9
        for <stable@vger.kernel.org>; Thu, 26 May 2022 12:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03752C34119;
        Thu, 26 May 2022 12:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653567370;
        bh=WYfdgZ412LQjGpEk1YDa38g14ljYkDqL4/finM7LIZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VHG1l90/mIlIRoWWWtUlR3rxqOkN7JktBOz0345NaatUszVFUEC7ujgTzAqZV/JHj
         i9mvg4bsZHhIjk4dsqpU6oJxwUHuCwitIdEb7GPNf/3mhI4O9+eJk10XbaY1Kk4le8
         OiB2RToUqOSY7SrHxqwdDBowmliLCjjuRMg6sTAw=
Date:   Thu, 26 May 2022 14:16:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, sashal@kernel.org,
        stable@vger.kernel.org, bjorn@kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Shaw <jeffrey.b.shaw@intel.com>
Subject: Re: [PATCH 5.15] ice: fix crash at allocation failure
Message-ID: <Yo9vh9Pb6q5u8WhS@kroah.com>
References: <20220525071953.27755-1-magnus.karlsson@gmail.com>
 <Yo37DLxvEAf2aYGB@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo37DLxvEAf2aYGB@boxer>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 25, 2022 at 11:46:52AM +0200, Maciej Fijalkowski wrote:
> On Wed, May 25, 2022 at 09:19:53AM +0200, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > 
> > Fix a crash in the zero-copy driver that occurs when it fails to
> > allocate buffers from user-space. This crash can easily be triggered
> > by a malicious program that does not provide any buffers in the fill
> > ring for the kernel to use.
> > 
> > Note that this bug does not exist in upstream since the batched buffer
> > allocation interface got introduced in 5.16 and replaced this code.
> > 
> > Reported-by: Jeff Shaw <jeffrey.b.shaw@intel.com>
> > Tested-by: Jeff Shaw <jeffrey.b.shaw@intel.com>
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 

Now queued up, thanks.

greg k-h
