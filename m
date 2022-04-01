Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEE34EEBCD
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345198AbiDAKuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242078AbiDAKut (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:50:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DDB12ADD
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 03:49:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9F91B82412
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 10:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A0CC2BBE4;
        Fri,  1 Apr 2022 10:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648810137;
        bh=xU+skedm7SjYZEqxAQoDC7D2n7ma/MTsELfcpTY4BbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mICuEc8HIa658CVKgCNUaxSbI16UxhYhx3Lxn22UZGXOV8+jMaD1sxwPyv9fEd93j
         ne27+XCM5tftmP3EQZgC0tFmJxJoQ3jGY8lN43RLO8t2ujqz9c1fbwgL2yATvn/wCX
         QHt/wieSRfaWII75NjjoeEQ+gVyp+ienL9/lNcPc=
Date:   Fri, 1 Apr 2022 12:46:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joshua Freedman <freedman.joshua@gmail.com>
Cc:     lis8215@gmail.com, paul@crapouillou.net, stable@vger.kernel.org,
        sboyd@kernel.org
Subject: Re: kernel 5.16.12 and above broke yoga c930 sound and mic
Message-ID: <YkbX9qFwz4mKOI3n@kroah.com>
References: <CAJQ3t4RxYXkREhwBb_JgYj4=ty+VtnV9m65U79ZLbmmj4mN7WA@mail.gmail.com>
 <YkQUGVC3MBSnc2LI@kroah.com>
 <CAJQ3t4TqK+q5zeHCQ2uxGvhT4q0Bpe6PBuDTm28HqyHwH5mzhQ@mail.gmail.com>
 <YkQnGmxdi9GWZmfC@kroah.com>
 <CAJQ3t4SnNyHEaWizzVDbaMSdHDRe9wHGx2RdgJJea=G4sFmdnw@mail.gmail.com>
 <YkQ44cqrnIH6aoxg@kroah.com>
 <CAJQ3t4Rg2WhDoynG=NmHX5dgt3u5BB3gfpAbskb4gQ_R8qxmxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJQ3t4Rg2WhDoynG=NmHX5dgt3u5BB3gfpAbskb4gQ_R8qxmxA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 04:54:53PM -0400, Joshua Freedman wrote:
> This felt really anti-climactic haha,  but hopefully it's useful?
> cat bisect.log
> Bisecting: 81 revisions left to test after this (roughly 6 steps)
> [770aac3c84e0c83a19985413fa9fbfc126cc0ff6] net: mdio-ipq4019: add delay
> after clock enable

Ok, great!  Can you start a new thread and add the developers of that
change to to it to help track down the issue?

thanks,

greg k-h
