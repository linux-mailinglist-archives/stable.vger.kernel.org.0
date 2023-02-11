Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC3A69312C
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 14:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBKNFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 08:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBKNFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 08:05:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A49340BE2;
        Sat, 11 Feb 2023 05:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BCC8B802C3;
        Sat, 11 Feb 2023 13:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFEBC433D2;
        Sat, 11 Feb 2023 13:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676120739;
        bh=n5Ozbl7or5SWI2es/CuKzgz4iu3RjGOvAnskch5o0pA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sDUoqpf4zvgM0iqyH67Dy86VEs9MRbrKW7pyQyqmOkT2ClWno5IIO0WbINsMqzAG5
         PbklYKG7ffDrWxw5M5Lxs8AxFAxYf976d+ciEp/fHMqHXQwIDlBiUNtz7R6mZhCi1X
         kttL52vOPkTE1jv/Dv2oF3nW1KcGAljpJe47jde8=
Date:   Sat, 11 Feb 2023 14:05:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     Sasha Levin <sashal@kernel.org>,
        Bastien Nocera <hadess@hadess.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: Heads-up: one change merged for -rc8 that might be good to have
 in the next 6.1.y release
Message-ID: <Y+eSoNuIUDAU1x/J@kroah.com>
References: <git-mailbomb-linux-master-690eb7dec72ae52d1d710d14a451844b4d0f4f19@kernel.org>
 <b74b2c93-bd0b-84c2-868b-d5376a16b020@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b74b2c93-bd0b-84c2-868b-d5376a16b020@leemhuis.info>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 11, 2023 at 01:42:25PM +0100, Linux regression tracking (Thorsten Leemhuis) wrote:
> Hi Greg. Would be great if you could pick up 690eb7dec72a ("HID:
> logitech: Disable hi-res scrolling on USB") for the next 6.1.y release,
> as it's fixing a regression I saw multiple people report.
> 
> The commit (see below) that was recently merged to mainline and has a
> proper stable "Cc: <stable@...>" tag, so I guess you scripts will at
> some point pick it up automatically. But I noticed you updated the
> stable queue and hour ago and this patch afaics is not in it yet
> (despite some other patches being in it that were merged later), so I
> thought: just to be sure send a quick heads up.

Thanks, this is still part of my "patches applied in this -rc cycle"
queue.  I'll go apply it now, thanks.

greg k-h
