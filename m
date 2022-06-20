Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F72551F14
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbiFTOjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348394AbiFTOil (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 10:38:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67682A1;
        Mon, 20 Jun 2022 06:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8669BB80EA6;
        Mon, 20 Jun 2022 13:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C85C3411B;
        Mon, 20 Jun 2022 13:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655733290;
        bh=0Zhtxbgb+akc5i+LjMc0sF526d+LBvTZ8zqGUTfm/TM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jHimN9yGrIvEPjZHz0UJPPXbeEp1Z0dgTpG0GogBI+3NXR6bwNPrJHDeaMO/ckFJW
         VNn+GSRVf5L9QHpn56ZwagnBU7mHjEV5gECCf5PGGYl43ET3PQt0//elTSlm6BQDgM
         iZVYil4RZWXJiZsi6OYLyI7u2cI9267mDQc89iSA=
Date:   Mon, 20 Jun 2022 15:54:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.18 081/141] net: remove noblock parameter from
 skb_recv_datagram()
Message-ID: <YrB8Jpk9FUqIxT/1@kroah.com>
References: <20220620124729.509745706@linuxfoundation.org>
 <20220620124731.932460774@linuxfoundation.org>
 <04920243-e585-edf6-a849-cfa5a2ff6ba1@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04920243-e585-edf6-a849-cfa5a2ff6ba1@hartkopp.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 03:44:08PM +0200, Oliver Hartkopp wrote:
> Hello Greg,
> 
> as already answered to Sascha:
> 
> ---
> 
> Hello Sasha,
> 
> this patch is some kind of improvement/simplification to reduce and clean up
> the number of variables passed through skb_recv_datagram() call.
> 
> There is no functional change and therefore no need to backport this patch
> IMO.

It is needed by a follow-on patch that fixes a real issue.

thanks,

greg k-h
