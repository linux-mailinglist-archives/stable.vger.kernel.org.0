Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC67557F28
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 17:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiFWP6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 11:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiFWP6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 11:58:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544A7DEB3
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 08:58:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6BC461E7C
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 15:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFEFC3411D;
        Thu, 23 Jun 2022 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655999917;
        bh=9mQBZ06Eph4t4VVV95CZslgBSVt8GsVjFeaeOvQeBDw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bDa6FRuBXhtXSen52051Jzh74W33w7ylYiJpPuSHFhQ51ytgN/IEADlLc5qHCYJvS
         R+THSf7LwAd5Vx4HQmXtx7uuU+0kDV6KxMNujQvmTna2vW+DkUJ24kirKRlSGBZjF8
         /IGF6UMQDxXAFtpoeu5A9HmoVkSF6fwEzx8FS7pM=
Date:   Thu, 23 Jun 2022 17:58:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        Amit Klein <aksecurity@gmail.com>
Subject: Re: [stable] Improved TCP source port randomisation
Message-ID: <YrSNqZazgv05N07+@kroah.com>
References: <c07281c6d7faa8042cff0a3da7a273eb617cfa13.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c07281c6d7faa8042cff0a3da7a273eb617cfa13.camel@decadent.org.uk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 22, 2022 at 12:24:19AM +0200, Ben Hutchings wrote:
> Please pick the following commits for 5.4 and 5.10 stable branches:
> 
> 90564f36f1c3071d1e0c617cde342f9706e250be tcp: add some entropy in __inet_hash_connect()
> 506884b616e95714af173c47b89e7d1f5157c190 tcp: use different parts of the port_offset for index and offset
> dabeb1baad260b2308477991f3006f4a1ac80d6d tcp: add small random increments to the source port
> 735ad25586cd381a3fdc8283e2d1cd4d65f0e9e7 tcp: dynamically allocate the perturb table used by source ports
> ada9e93075c7d54a7fd28bae5429ed30ddd89bfa tcp: increase source port perturb table to 2^16
> 82f233b30b728249d1c374b77d722b2e4f55a631 tcp: drop the hash_32() part from the index calculation

All of these commit ids are not in Linus's tree, are you sure you got
them correct?

thanks,

greg k-h
