Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322516C89B0
	for <lists+stable@lfdr.de>; Sat, 25 Mar 2023 01:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjCYAmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 20:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCYAmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 20:42:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1AC40E3
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 17:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CBF662D17
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 00:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4841BC433D2;
        Sat, 25 Mar 2023 00:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679704967;
        bh=ZUL52AQe7FK6a0BAVySlZIDveFk09AKSXIrhRw/mnIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CaMlCXuPqmtyFOMlGn1d4s3IIdkHKX6M8W9cDcQ070tg5Byuwuq7a1yCIESrggSmH
         vrQpt8MZProzOsAwgVF8JDO1hPoCwUphaVCsI0IirWHsmvO7khrpfAagP1/xdSWr1/
         VN+Q+2zsWrbXufsDwszMl21ak190s0Of3XxhtMSQghpuaUtNY+0rz2wlffsAhMeiwd
         3/BurSpi8T1dqDQcaWbWC9ZpcAvhMU6RcIs86rgo+dhh6vrJFat2J2Lfs71gxwpZbF
         o/MK6oiyyUwQ98KpfdO6YQVYVDD+5+s6rwTLsZ/ghIo+GxATM6LP25dYbu3VB7SoDd
         K5fzhFepEXuCQ==
Date:   Fri, 24 Mar 2023 20:42:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        hbh25y@gmail.com
Subject: Re: [PATCH 5.15 0/1] Request to cherry-pick 49c47cc21b5b to 5.15.y
Message-ID: <ZB5DhjiprG9I7c+q@sashalap>
References: <20230323005440.518172-1-meenashanmugam@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230323005440.518172-1-meenashanmugam@google.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 23, 2023 at 12:54:39AM +0000, Meena Shanmugam wrote:
>The commit 49c47cc21b5b (net: tls: fix possible race condition between
>do_tls_getsockopt_conf() and do_tls_setsockopt_conf()) fixes race
>condition and use after free. This patch didn't apply cleanly in 5.15
>kernel due to the added switch cases in do_tls_getsockopt_conf function.

Queued up (for all branches), thanks!

-- 
Thanks,
Sasha
