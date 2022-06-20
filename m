Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E08551F2B
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbiFTOmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242598AbiFTOli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 10:41:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD4020BF8;
        Mon, 20 Jun 2022 07:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AC7561554;
        Mon, 20 Jun 2022 14:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E924C341D4;
        Mon, 20 Jun 2022 14:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655733687;
        bh=YUMrB+Vdzup5odUrd4n3f4Voh/iVMt/UvWkmdgl7bjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I8oPIB+lsSO9Mtao44SoBnFSHRevd4oPy4WmK4q5iTeLWqh0u+xh+zNrrh5KAThpw
         i6lhhUrb7uatDl9f0fxeaSFZAW0MRmTQOPrH/TdspLVlLdBzS2Q/7bC4GDJ8KbV3hD
         lu1EV30hiusY4cFrlb+zCV1gqwJ5rkmZ6C0xLw3o=
Date:   Mon, 20 Jun 2022 16:01:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.18 081/141] net: remove noblock parameter from
 skb_recv_datagram()
Message-ID: <YrB9s+6L/fWW1kay@kroah.com>
References: <20220620124729.509745706@linuxfoundation.org>
 <20220620124731.932460774@linuxfoundation.org>
 <04920243-e585-edf6-a849-cfa5a2ff6ba1@hartkopp.net>
 <YrB8Jpk9FUqIxT/1@kroah.com>
 <4a53cf90-6ed9-c1b6-2974-3a0d1836c3b3@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a53cf90-6ed9-c1b6-2974-3a0d1836c3b3@hartkopp.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 03:56:08PM +0200, Oliver Hartkopp wrote:
> 
> 
> On 6/20/22 15:54, Greg Kroah-Hartman wrote:
> > On Mon, Jun 20, 2022 at 03:44:08PM +0200, Oliver Hartkopp wrote:
> > > Hello Greg,
> > > 
> > > as already answered to Sascha:
> > > 
> > > ---
> > > 
> > > Hello Sasha,
> > > 
> > > this patch is some kind of improvement/simplification to reduce and clean up
> > > the number of variables passed through skb_recv_datagram() call.
> > > 
> > > There is no functional change and therefore no need to backport this patch
> > > IMO.
> > 
> > It is needed by a follow-on patch that fixes a real issue.
> 
> Ah, ok! Wasn't aware of that follow-on patch.
> 
> Sorry for the noise ;-)

Not noise at all, thanks for the review,that's always appreciated.

greg k-h
