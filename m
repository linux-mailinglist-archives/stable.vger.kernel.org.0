Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA782585E82
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 12:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiGaKuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 06:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiGaKuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 06:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63056189
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 03:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACD7760BBD
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 10:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6FEC433D6;
        Sun, 31 Jul 2022 10:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659264606;
        bh=CxgEiSQ7IIyV57oVgI3sAmZYGjgYpm3qaBQ4SbIvKV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PpBU0Lsz6qf8fT76rjobOF56S9Lv1zuP2V+zBh/cSUYRxXd7Dz8A9671HTiVfMvvi
         +whmnaXrHBjVGtge5iIvxR/hcBL8jGTZdznuQxyPxLt3yeHoM19dCxFmH6GK8poae0
         xdKJDCPIl2AEXVTP9jlMuk0c0pCCPIXTVxZEWS0A=
Date:   Sun, 31 Jul 2022 12:50:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yan Xinyu <sdlyyxy@bupt.edu.cn>
Cc:     stable@vger.kernel.org
Subject: Re: Backport request for 829eea7c94e0 ("mt7601u: add USB device ID
 for some versions of XiaoDu WiFi Dongle.")
Message-ID: <YuZeWzYdpZ2sTNUQ@kroah.com>
References: <ED02634A-1156-4A85-A2AD-EBFD32BF5549@bupt.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ED02634A-1156-4A85-A2AD-EBFD32BF5549@bupt.edu.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 29, 2022 at 05:12:16PM +0800, Yan Xinyu wrote:
> Hi Greg,
> 
> Could you please backport the following patch to 4.9/4.14/4.19/5.4/5.10?
> 
> 829eea7c94e0 ("mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.")
> 
> The patch has been merged to mainline on 5.14. This will make the
> devices run on these older kernels.
> 
> The original patch need to be offset 8 lines for 4.9/4.14/4.19. If it
> cannot be applied, please let me know and I will send new patches.

Now queued up, thanks.

greg k-h
