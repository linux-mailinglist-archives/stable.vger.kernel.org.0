Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D03D58F063
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 18:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiHJQ03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 12:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiHJQ02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 12:26:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076896068D
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 09:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACB0FB81D92
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 16:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DF7C433C1;
        Wed, 10 Aug 2022 16:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660148785;
        bh=S3g6ZWeaRPAa/NofMtT88TAiH7RW2eXJdctAd9/e37g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z3Kj+blDdIsob9ME/M7ut0wg8lIcSGqW0H9E0SE3ZqK3xSkXDBmR4pVApMyhHKDLl
         OVR935zhFgiiohpQeMoIY7HX9x9cSZyoyFtuH9IHd3UpFbyMfUQb1yoMdhfudXik+u
         o1cim0wFwjQIpS6CtWBr2vEz8LgS1T6ryFoIsQ1U=
Date:   Wed, 10 Aug 2022 18:26:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeongik Cha <jeongik@google.com>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        Alistair Delva <adelva@google.com>,
        JaeMan Park <jaeman@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: wifi: mac80211_hwsim: fix race condition in pending packet
Message-ID: <YvPcLoR4ebjvDboo@kroah.com>
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

This is listed in reverse order, correct?

thanks,

greg k-h
