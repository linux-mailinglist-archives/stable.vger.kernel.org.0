Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BF16576C0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 14:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiL1NG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 08:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiL1NGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 08:06:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A63A1F6;
        Wed, 28 Dec 2022 05:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE779B816A1;
        Wed, 28 Dec 2022 13:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AA0C433D2;
        Wed, 28 Dec 2022 13:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672232767;
        bh=ATwUlg/tbIXPMZTvYJ7vS+zZ/a0LrZMERd8wbI4fLjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QAe/STBH6fNvDlxc+yzpa/l3wbUF1otUxpqrVidEAuJOsVBvmjABGYKHzhAkMSAcH
         eKie2t4smDJnhi9R17viR2QYMPizKFncu7aG92xQZCssZjlou2C2QOZFctgacFCvwD
         uzqzV8pCTeb6Lmo3yeWkO3pdaYiqUAaqhkFK3938=
Date:   Wed, 28 Dec 2022 14:06:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Diederik de Haas <didi.debian@cknow.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        LABBE Corentin <clabbe@baylibre.com>
Subject: Re: crypto-rockchip patches queued for 6.1
Message-ID: <Y6w/O6zY3Jfe8ZKv@kroah.com>
References: <2236134.UumAgOJHRH@prancing-pony>
 <Y6wdZHlnUIzzreTA@kroah.com>
 <2589096.039tgBz4BG@prancing-pony>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2589096.039tgBz4BG@prancing-pony>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 12:11:40PM +0100, Diederik de Haas wrote:
> On Wednesday, 28 December 2022 11:41:40 CET Greg KH wrote:
> > > All those patches have been merged into Linus' tree for 6.2 and there's a
> > > hotfix planned to be submitted for 6.2 here:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git/
> > > commit/?h=v6.2-armsoc/dtsfixes&id=53e8e1e6e9c1653095211a8edf17912f2374bb03
> > > 
> > > Wouldn't it make more sense to queue the whole patch set for 6.1?
> > > Or (at least) the whole crypto rockchip part as mentioned here:
> > > https://lore.kernel.org/all/Y5mGGrBJaDL6mnQJ@gondor.apana.org.au/
> > > under the "Corentin Labbe (32):" label?
> > 
> > Please provide us a list of the specific git commits and in the order in
> > which you wish to see them applied and we will be glad to review them.
> > 
> > Looking at random links (that are wrapped and not able to be easily
> > used) is not going to work well.
> 
> These are the commits from Linus' tree (in the correct order):
> 
> https://git.kernel.org/linus/299c481fa5c121f892420d97f1123a853b7f1079
> https://git.kernel.org/linus/8ccd9c8cd1d1618f5e073c86ffcfe15f292eefe6
> https://git.kernel.org/linus/c50ef1411c8cbad0c7db100c477126076b6e3348
> https://git.kernel.org/linus/6d11c9387865723fd779be00ae37a4588e60133d
> https://git.kernel.org/linus/87e356c4966444866186f68f05832fdcc0f351a3
> https://git.kernel.org/linus/68ef8af09a1a912a5ed2cfaa4cca7606f52cef90
> https://git.kernel.org/linus/816600485cb597b3ff7d6806a95a78512839f775
> https://git.kernel.org/linus/d6b23ccef82816050c2fd458c9dabfa0e0af09b9
> https://git.kernel.org/linus/bb3c7b73363c9a149b12b74c44ae94b73a8fddf8
> https://git.kernel.org/linus/57d67c6e8219b2a034c16d6149e30fb40fd39935
> https://git.kernel.org/linus/6d55c4a206d29006c733b5083ba5da8391abbdbd
> https://git.kernel.org/linus/48d904d428b68080abd9161148ca2ab1331124a4
> https://git.kernel.org/linus/a216be3964c15661579005012b1f0d7d20a1f265
> https://git.kernel.org/linus/6f61192549d0214f8d9d1e1d3152e450658ed1e9
> https://git.kernel.org/linus/3a6fd464f48ad35d8cf15d81fd92094132dc862a
> https://git.kernel.org/linus/e803188400d32d28ecfbef0878c289e3c7026723
> https://git.kernel.org/linus/37bc22159c456ad43fb852fc6ed60f4081df25df
> https://git.kernel.org/linus/456698746b40008eb0924eb7e9ec908330948b2d
> https://git.kernel.org/linus/e65e90101329de0fe304e2df057f68c5f0fa4748
> https://git.kernel.org/linus/a7fa0644dd0b91fab97398de7ea4672a6526261f
> https://git.kernel.org/linus/2e3b149578c30275db9c3501c1d9dec36d16622a
> https://git.kernel.org/linus/c018c7a9dd198ce965ca4d10c7b083849bc533be
> https://git.kernel.org/linus/ea389be9857721252367fd2cf81bc8068e060693
> https://git.kernel.org/linus/81aaf680e85207d6521b250b2a80ba7c91cc9cbe
> https://git.kernel.org/linus/d1b5749687618d969c0be6428174a18a7e94ebd2
> https://git.kernel.org/linus/b136468a0024ea90c1259767c732eed12ce6edba
> https://git.kernel.org/linus/d1152bc533c941f7e267bf53d344cee510ea2808
> https://git.kernel.org/linus/8c701fa6e38c43dba75282e4d919298a5cfc5b05
> https://git.kernel.org/linus/2d3c756adcd7a7ee15b6a55cf01b363e3f134e79
> https://git.kernel.org/linus/e220e6719438f7a99fe0a73e6e126481380202fa
> https://git.kernel.org/linus/0d31b14c9e4178a129a1aa5e491e4da1489c07de
> https://git.kernel.org/linus/c5a1e104c35e5134b6048f1e03960a6ac9c42935
> https://git.kernel.org/linus/9dcd71c863a6f6476378d076d3e9189c854d49fd

That's a lot, I'll look at them in a week or so after catching up with
the rest of the stable queue.

Any reason why you all didn't properly mark these for the stable tree
beforehand?

> These commands will show them too:
> git log --oneline -25 d1b5749687618d969c0be6428174a18a7e94ebd2 --reverse
> git log --oneline -1 b136468a0024ea90c1259767c732eed12ce6edba
> git log --oneline -2 8c701fa6e38c43dba75282e4d919298a5cfc5b05 --reverse
> git log --oneline -5 9dcd71c863a6f6476378d076d3e9189c854d49fd --reverse
> 
> And this is the hotfix, planned for 6.2 (unwrapped):
> https://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git/commit?id=53e8e1e6e9c1653095211a8edf17912f2374bb03

fix for what?  When will it be sent to Linus?

thanks,

greg k-h
