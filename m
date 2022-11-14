Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC756284B3
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 17:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbiKNQLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 11:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbiKNQLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 11:11:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DCB17404
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 08:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A07B46129A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 16:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E66C433C1;
        Mon, 14 Nov 2022 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668442298;
        bh=+3Hej/Cb14Cf4yIBwT9ZwOu8H6ezViFPC1qIXL52W2I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UfLa2VTrHyHb/ncfDUmwf38ISH+S0bLnKjKC6lju+3nHWCuvdjRysSssDtinANVzF
         xEX4TS7QVcP8F1NU5ZWmsV4LuCBO/tMlov0Pur6oMX4CnFQhObA42Zt0liWFOvpZXq
         WX3lZRI2CltY1nBe4EhhpXICJI6DgHpgHd/tCSwg=
Date:   Mon, 14 Nov 2022 17:11:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc:     stable@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <Y3JotyM0Flj5ijVW@kroah.com>
References: <20221114131403.GA3807058@u2004>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114131403.GA3807058@u2004>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> Hi,
> 
> I'd like to request the follow commits to be backported to 5.15.y.
> 
> - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> - a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> 
> These patches fixed a data lost issue by preventing shmem pagecache from
> being removed by memory error.  These were not tagged for stable originally,
> but that's revisited recently.

And have you tested that these all apply properly (and in which order?)
and work correctly?

thanks,

greg k-h
