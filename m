Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802C75A93A1
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 11:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiIAJwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 05:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbiIAJwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 05:52:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05260133F19;
        Thu,  1 Sep 2022 02:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7BDCB824F7;
        Thu,  1 Sep 2022 09:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4EFC433C1;
        Thu,  1 Sep 2022 09:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662025963;
        bh=Pu2avmmVv8x1BTeyTUu8i1JoYWP7q5sTolozUY3AjGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AERBJ4pPwmQ9JuEiOpD5biZ0AYwKDCRGWaLGZd/STAMZPj3v9n2YkS8lmzCSml/l2
         A12d6r3ZlEL2fh9AM5ubdDAAUruCPhtBN/wdEqFhtvYmhJkllvHHuC4tURs8GkcYDC
         Elwte4syBAOTvgwFR5RnJLvCHZfey9J1RwdZNrsg=
Date:   Thu, 1 Sep 2022 11:52:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v2 1/2] Drivers: hv: balloon: Support status report for
 larger page sizes
Message-ID: <YxCA6PMT2iuQFYzR@kroah.com>
References: <20220325023212.1570049-1-boqun.feng@gmail.com>
 <20220325023212.1570049-2-boqun.feng@gmail.com>
 <Yw+yWFFpU+mwT97H@boqun-archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw+yWFFpU+mwT97H@boqun-archlinux>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 12:11:20PM -0700, Boqun Feng wrote:
> Hi,
> 
> I think we also want this patch in the 5.15 stable. Without this patch,
> hv_balloon() will report incorrect memory usage to hypervisor when
> running on ARM64 with PAGE_SIZE > 4k. Only 5.15 needs this because ARM64
> support of HyperV guests arrived in 5.15.
> 
> Upstream id b3d6dd09ff00fdcf4f7c0cb54700ffd5dd343502
> 
> Cc: <stable@vger.kernel.org> # 5.15.x

Now queued up, thanks.

greg k-h
