Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A5E58FDB9
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 15:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbiHKNvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 09:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiHKNvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 09:51:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD554B00
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:51:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DDBA9CE21DB
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 13:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0195DC433C1;
        Thu, 11 Aug 2022 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660225863;
        bh=53Nk797ArZXMGSzbyEtX9cAODRtkRy0ViUu392MxOFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=viTXI4u9iEfIu80ZAXjpUdZv6vW+9Eo+biV6EOCCJPa+MJcYA64zH6EjCRZzxu5pl
         Sra445StBG4m+oPIQ1M7PKCfFxHOum+aUftfrNhKZBB05YhbKbabZvXtue9T6hbZgH
         1uxPGw5M5ANZCHAwi7q+r3hzyuI1Wt2pW11GVlO0=
Date:   Thu, 11 Aug 2022 15:51:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeongik Cha <jeongik@google.com>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        Alistair Delva <adelva@google.com>,
        JaeMan Park <jaeman@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: wifi: mac80211_hwsim: fix race condition in pending packet
Message-ID: <YvUJRD9TKk/7xeZD@kroah.com>
References: <CAE7E4gmX=L8y26DJOkUbYtP59RJDRzob5K5oi0ZLGO-EfcQMjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE7E4gmX=L8y26DJOkUbYtP59RJDRzob5K5oi0ZLGO-EfcQMjA@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 12:53:58AM +0900, Jeongik Cha wrote:
> Hello everyone,
> 
> I'd like to request a review to merge these patches into stable releases.
> 
> These patches fix race conditions in pending packets from
> mac80211_hwsim which cause kernel panic after a device is running for
> a few hours. It makes test cases in Android(which uses mac80211_hwsim
> for test purposes) flaky, and also, makes Android emulator unstable.
> 
> It would be great if these patches could be merged after version 4.19.
> 
> If you have further questions, please let me know!
> 
> commit cc5250cdb43d444061412df7fae72d2b4acbdf97 wifi: mac80211_hwsim:
> use 32-bit skb cookie
> commit 58b6259d820d63c2adf1c7541b54cce5a2ae6073 wifi: mac80211_hwsim:
> add back erroneously removed cast
> commit 4ee186fa7e40ae06ebbfbad77e249e3746e14114 wifi: mac80211_hwsim:
> fix race condition in pending packet

Now queued up, thanks.

greg k-h
