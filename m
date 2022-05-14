Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FE85272E1
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiENQYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 12:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiENQYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 12:24:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF29935246;
        Sat, 14 May 2022 09:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5438060FEA;
        Sat, 14 May 2022 16:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948F2C340EE;
        Sat, 14 May 2022 16:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652545491;
        bh=eTkF5/i+lhD2Pn11Xw4lTm8GQmEctfUQ0Y2SZiQkE7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oKzD4h1eBmj12BmiSOwtxlum3c7ryEZdVjHRTFzFucAMIVOOZsluAuADNlzpOZ/P4
         iOgXmADY97dh1vGcDkQWayW3EzphY3XsOpUb1Vxl55Ezz4BRIWLf2IB7BgsXEecnDv
         EEC+SoiegC5A6O06OyaJzDzxdHgLnGe1OHQhB38h/CWE2ra/k5JLyCKsSxho7PMPNz
         zGPc614IyAtWYk5T9Cje0oVIaP9nLU6mL6G3HqPdFNSox1plI7B17QQWJQufkGn+9g
         T0jZ8hyWLn5T7NJnwCE1zvyP6iMYdoqh+POmJGZkOgf3pQLMRNzJcwkqftFU3+L/Jg
         5DIEYMcYa4kzA==
Date:   Sat, 14 May 2022 12:24:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Helge Deller <deller@gmx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James.Bottomley@hansenpartnership.com, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 21/21] Revert "parisc: Fix patch code
 locking and flushing"
Message-ID: <Yn/X0quyI58WVTfJ@sashalap>
References: <20220510154340.153400-1-sashal@kernel.org>
 <20220510154340.153400-21-sashal@kernel.org>
 <37d6bcac-bca4-06a6-ecab-bf83bd3468cd@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <37d6bcac-bca4-06a6-ecab-bf83bd3468cd@gmx.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 05:49:31PM +0200, Helge Deller wrote:
>Hello Sascha,
>
>please drop this patch from all your stable-series queues....
>It shouldn't be backported.

I've dropped it, but... why?

-- 
Thanks,
Sasha
