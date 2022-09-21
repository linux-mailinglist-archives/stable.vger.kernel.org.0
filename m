Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA675BF9E8
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 10:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiIUI5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 04:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIUI5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 04:57:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEC07B299
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 01:57:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B673623C9
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 08:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CD1C433D6;
        Wed, 21 Sep 2022 08:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663750636;
        bh=UxHFpcNKVFyM6v4tg93jidtbSdfTCwLY9XSOhtZRXCo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HH6Ws7siv0cv/RaYpB823AWMfu2Wdq28pKvzcjwDpw2pDdjDW62KeolmqUSulcN+2
         /EFVpqGeI+XbHD2HgdkbJUHmJ/+pDGaruby3qZ/8xd+027pASYx80q8MT7dVkTmvOu
         qM+u/B1giUPTMYizpn25b4jYCbdaDTw6xEf3tnnU=
Date:   Wed, 21 Sep 2022 10:57:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sewook Seo <sewookseo@google.com>
Cc:     stable@vger.kernel.org, Sehee Lee <seheele@google.com>,
        Amruth Ramachandran <amruthr@google.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Subject: Re: Merge of e22aa14866684f77b4f6b6cae98539e520ddb731
Message-ID: <YyrR55VKSEOs77ny@kroah.com>
References: <CABhgAgdbHH2hORTF-6UeCSroY6Hbpdr2+v-XBdWhTt67ndgoUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABhgAgdbHH2hORTF-6UeCSroY6Hbpdr2+v-XBdWhTt67ndgoUQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 05:22:58AM +0900, Sewook Seo wrote:
> Hi,
> 
> I kindly request to merge below commit to be merged into the relevant
> stable trees.
> 
> commit id: e22aa14866684f77b4f6b6cae98539e520ddb731
> target version: 5.4, 5.10 and 5.15.

Why are you wanting to skip 5.19.y?

And as the commit does not even apply to 5.10.y or 5.4.y, how was this
tested?

Please provide a working backport for 5.10.y and 5.4.y if you wish to
have this backported there, I've queued it up now for 5.19.y and 5.15.y.

thanks,

greg k-h
