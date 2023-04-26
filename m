Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C936EED72
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 07:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239147AbjDZFKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 01:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDZFKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 01:10:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A8F271F;
        Tue, 25 Apr 2023 22:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA202632CC;
        Wed, 26 Apr 2023 05:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27568C433D2;
        Wed, 26 Apr 2023 05:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682485833;
        bh=D8jVwqPWYpV+QASfiyG3ATYpzbA1cgRTfhXgLMfZqkw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pGOIerkE12nmZPC3Rqxpys4Vgd2arehfJ2FHCa1c5t1BlxUjhDV+120E8nzlZstWn
         lX6GnUURw+I5rP7w5MZQC3vanvdLYodCTRSpsotrUNEMklEp28vhU3UTyMiJxzjNpl
         fTnLhglpd7jWOKntqop4JEHDzWY3Ip3HyFwcxV/PkkUJBUMLcnt1KG2wPgSC0mBIxd
         gSMSr5ObOY+bHTQJoqslGDx4qkuXdV3M9Xgb6aAoWpUYDYqcgeob5eV9Z/HqBQfSeH
         nvbl18AnVyvtL5KEQDixpH6UOo6M0nlj0/EG/WISgZkx3zDpnjtwpN9duj1VanK+9o
         jNmzKSGsnjx9g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <stable@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wifi: rtw89: 8852b: adjust quota to avoid SER L1 caused by access null page
References: <20230426034737.24870-1-pkshih@realtek.com>
Date:   Wed, 26 Apr 2023 08:10:27 +0300
In-Reply-To: <20230426034737.24870-1-pkshih@realtek.com> (Ping-Ke Shih's
        message of "Wed, 26 Apr 2023 11:47:37 +0800")
Message-ID: <87r0s7teik.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> writes:

> Though SER can recover this case, traffic can get stuck for a while. Fix it
> by adjusting page quota to avoid hardware access null page of CMAC/DMAC.
>
> Fixes: a1cb097168fa ("wifi: rtw89: 8852b: configure DLE mem")
> Fixes: 3e870b481733 ("wifi: rtw89: 8852b: add HFC quota arrays")
> Cc: stable@vger.kernel.org
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> Link: https://github.com/lwfinger/rtw89/issues/226#issuecomment-1520776761
> Link: https://github.com/lwfinger/rtw89/issues/240
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
> v2: add Fixes, Cc and Tested-by tags suggested by Larry.

Should this go to wireless tree for v6.4?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
