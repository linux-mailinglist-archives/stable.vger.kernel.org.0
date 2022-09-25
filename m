Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418915E90DA
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 05:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiIYDSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 23:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiIYDSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 23:18:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB35140BC6;
        Sat, 24 Sep 2022 20:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57E2261207;
        Sun, 25 Sep 2022 03:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F4CC433C1;
        Sun, 25 Sep 2022 03:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664075912;
        bh=uqFM7PfQgGUpSCX1f9hr1rQTeJyyd1xV/4US1em1+gI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Up9RV47JuuhVNWam0DaJXzNnRgeRbt0EHpedkC90uc8zovkIwVUx6gGlKtUAYTJhl
         4HJsunjkbZUvhbEf3yordBhoZM22Hn/P1TKeF1aL68CytVdz93Buq5KdkrukKyDblw
         FChKjJAk2ise5S0KrFDRqBZUtE11C0VLOILP/lg95U5msfv7TvZSUMFqoziY+a8bF8
         PL0WsJeoGeYP5KaS83ALx0qyNWqsVB5BcqwE4QZfILCJSlVU6zEvZBD90I9Q/MckOA
         ojeMMVolZmLUKTvdF9WOBz+xM8ZqRDztj9Xip6anULfCi5VzGl+Ik5lSsMopgR78qF
         b96YcyXGp4/kw==
Date:   Sat, 24 Sep 2022 23:18:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 01/16] Drivers: hv: Never allocate anything
 besides framebuffer from framebuffer memory region
Message-ID: <Yy/IhxtFBvq0VoKN@sashalap>
References: <20220921155332.234913-1-sashal@kernel.org>
 <87illgog69.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87illgog69.fsf@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 06:17:34PM +0200, Vitaly Kuznetsov wrote:
>Sasha Levin <sashal@kernel.org> writes:
>
>> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>>
>> [ Upstream commit f0880e2cb7e1f8039a048fdd01ce45ab77247221 ]
>>
>
>(this comment applies to all stable branches)
>
>While this change seems to be worthy on its own, the underlying issue
>with Gen1 Hyper-V VMs won't be resolved without
>
>commit 2a8a8afba0c3053d0ea8686182f6b2104293037e
>Author: Vitaly Kuznetsov <vkuznets@redhat.com>
>Date:   Sat Aug 27 15:03:44 2022 +0200
>
>    Drivers: hv: Always reserve framebuffer region for Gen1 VMs
>
>as 'fb_mmio' is still going to be unset in some cases without it.

Which seems to fail building. Backports welcome :)

-- 
Thanks,
Sasha
