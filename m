Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DC35A5B4E
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 07:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiH3F5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 01:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH3F5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 01:57:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8A7A2623
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 22:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69C69B81632
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 05:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF50C433C1;
        Tue, 30 Aug 2022 05:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661839054;
        bh=C2NsUQb+hGF0ybDJvRV8i25kmqR6jb0aqPpUheks3Ss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jGf7OpZae2tGNPNgdZ8PtgvoMT5IK70GCuJKrEOv0miz9T9Y37g49i6t/HLJCdMgD
         cxnDyhz+OXk78jxdaG082OSjgLrmVjJHWat62/pG5tn8GyGBpaY6R2ghLbhgX5yUiG
         UidFeAWkoTI5iP6FtI3Rte6540eNsgJwn8STQAGw=
Date:   Tue, 30 Aug 2022 07:57:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lucas Wei <lucaswei@google.com>
Cc:     stable@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Will Deacon <willdeacon@google.com>,
        Robin Peng <robinpeng@google.com>,
        Aaron Ding <aaronding@google.com>
Subject: Re: Request to cherry-pick into v5.15: arm64: errata: Add
 Cortex-A510 to the repeat tlbi list
Message-ID: <Yw2mylTWhMxTSSHY@kroah.com>
References: <CAPTxkvQJHAxYOSmXCro7Cf1uR4y202HTrYLVPCY0JNGc30Y0aA@mail.gmail.com>
 <CAPTxkvQXXeawY-LmmfVsM76MCUOQHRRQN=Sim7Fza0s0aAY6Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPTxkvQXXeawY-LmmfVsM76MCUOQHRRQN=Sim7Fza0s0aAY6Rw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 10:31:35AM +0800, Lucas Wei wrote:
> Dear Linux stable kernel maintainers,
> 
> I would like to apply the below patch into kernel v5.15-stable.
>  - subject:arm64: errata: Add Cortex-A510 to the repeat tlbi list
>  - Upstream Commit ID: 39fdb65f52e9a53d32a6ba719f96669fd300ae78
>  - Targeted LTS release: v5.15
> 
> This patch is an errata of #2441009. Since v5.15 is still in its LTS
> lifecycle, I think it fits the rule of "New device IDs and quirks are
> also accepted" and I want to request to apply this patch to kernel
> v5.15.

You also need it in 5.19.y, right?  And you never want someone to
upgrade from an older kernel to a newer one and have a regression.

This commit does not cleanly cherry-pick, I need a working backport in
order to apply it.  As I'm sure you already have a working and tested
backport of it (otherwise you wouldn't have asked for it), can you
please send it to us so that it can be applied?

Same for 5.19.y too.

thanks,

greg k-h
