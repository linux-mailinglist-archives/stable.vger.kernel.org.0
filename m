Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3814D7D53
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 09:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237626AbiCNIKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 04:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbiCNIKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 04:10:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2E23EA8D;
        Mon, 14 Mar 2022 01:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8717B6120E;
        Mon, 14 Mar 2022 08:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8152C340EE;
        Mon, 14 Mar 2022 08:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647245330;
        bh=i0tqRLWwHkIcHdHsjVnbUaxEIivvKa02E341WSxRgCQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bXKvVS9qMgQuBuVwd9GE7Icau+ZGa9IWq/vT/qs/ZMPB3Smjvh7C8ax7+7GUSfoKN
         hqZTOff7+I/ufJFKvvzqLoG5EwUT8cmYf/VIhslaL9bBWDdyiNqBZNgR5SdhPPFKTx
         G5oBSE32AC1N8UFVy03N+5WHrNpnrIu9sKZqBFlfcmGZYIO/o5ii8p6jGbu34ykPmF
         Z/cz7cuieBIQY7hBcQR58g4a5I/C1YPAEVB4i0/fNwMLFsfR4RS5IEMDbiyegDDOLt
         mMsWS1uRtdAoRM1uUFaS6y003mPreELVe/xKML2fnySg69UeSGw5viKjCKUA8kjAro
         nm1HdiZM59uDg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] rtw88: Fix missing support for Realtek 8821CE RFE Type 6
References: <20220313164358.30426-1-Larry.Finger@lwfinger.net>
        <9ae5780119e24142bffd855d915a5e92@realtek.com>
Date:   Mon, 14 Mar 2022 10:08:48 +0200
In-Reply-To: <9ae5780119e24142bffd855d915a5e92@realtek.com> (Pkshih's message
        of "Mon, 14 Mar 2022 00:21:45 +0000")
Message-ID: <87y21dot0v.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

>> -----Original Message-----
>> From: Larry Finger <Larry.Finger@lwfinger.net>
>> Sent: Monday, March 14, 2022 12:44 AM
>> To: kvalo@kernel.org
>> Cc: linux-wireless@vger.kernel.org; Larry Finger
>> <Larry.Finger@lwfinger.net>; Pkshih <pkshih@realtek.com>;
>> stable@vger.kernel.org
>> Subject: [PATCH] rtw88: Fix missing support for Realtek 8821CE RFE Type 6
>> 
>> The rtl8821ce with RFE Type 6 behaves the same as ones with RFE Type 0.
>> 
>> This change has been tested in the repo at git://GitHub.com/lwfinger/rtw88.git.
>> It fixes commit 769a29ce2af4 ("rtw88: 8821c: add basic functions").
>> 
>> Fixes: 769a29ce2af4 ("rtw88: 8821c: add basic functions").
>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: stable@vger.kernel.org # 5.9+
>> ---
>> Kalle,
>> 
>> This patch file was prepared a couple of months ago, but apparently not submitted
>> then. It should be applied as soon as possible.
>> 
>> Larry
>
> Hi Larry,
>
> This patch has been merged [1]. The git link of wireless driver next has been
> changed [2]. That may be the reason you can't find the patch.
>
> [1]
> https://lore.kernel.org/all/164364407205.21641.13263478436415544062.kvalo@kernel.org/
> [2] git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git

So the commit id is:

e109e3617e5d rtw88: rtw8821c: enable rfe 6 devices

And the commit should be in v5.18-rc1, which is most likely released in
three weeks.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
