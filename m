Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0167F67142C
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 07:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjARGbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 01:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjARG1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 01:27:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EB79EF6;
        Tue, 17 Jan 2023 22:17:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 867C0615C7;
        Wed, 18 Jan 2023 06:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDFFC433EF;
        Wed, 18 Jan 2023 06:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674022655;
        bh=5t37Ai/P3bD8k3GkXMhRpgj72Kl2747MpH1LbclMmlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PziMD9iw2RsS2YaumAqDgSWNSOMtHnx1UJye50UjK2Tn/q5lO6EdSgb3HGBuUXo9s
         x5vEI8xjVACxq2kCOiL0b6DEc1RwYpSKR0j/S0EpyGKRu4C0iD8cGWT36raFwEBRJi
         LnjnhMIePJHDApTN6J4dn+G5rso91AJimuP2qat8=
Date:   Wed, 18 Jan 2023 07:17:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     mkv22@cantab.net
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: Mainline stable kernel kbd backlight stops working from 6.1.6 in
 t2 Macs
Message-ID: <Y8eO/DK5erUthu1S@kroah.com>
References: <CAC+-fDs=YHjsWvNAUVT=D=+JU9FQ-dJ_L4esqJveQiiGLcW2Lw@mail.gmail.com>
 <Y8VjBJVei/I+Q67G@kroah.com>
 <CAC+-fDvrzAY1nferGW9zRwGT3_yFEH36A66Bs+zfLbc3OV3jng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC+-fDvrzAY1nferGW9zRwGT3_yFEH36A66Bs+zfLbc3OV3jng@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 02:26:37AM +0530, mkv22@cantab.net wrote:
> OK. I just read about git bisect. Should I do it on the t2 github page from
> where things are downloaded and compiled and installed or on the mainline
> kernel github pages? Many thanks.

Nit, we don't use github for kernel development, but rather,
git.kernel.org :)

> It works fine till 6.1.5.

I recommend using the "t2 github" repo as odds are there are still
out-of-tree patches in there that you rely on.

Let us know how that goes, and watch out with sending html mail to our
mailing lists, they get automatically rejected.

thanks,

greg k-h
