Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E6B551575
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 12:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbiFTKJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 06:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240646AbiFTKJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 06:09:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D914643B
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 03:09:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A54EB8100B
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 10:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8E5C3411B;
        Mon, 20 Jun 2022 10:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655719752;
        bh=PM6Y44UzjLe5OnDI8cdhldGJGLFihO62UDJw8JucUU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CbVJ9iA3ot5z7jE1qI6nax3vc0GzIb8/MrLRGiYanVJheHMxmxEbleNJ/WsbxqQlN
         ACuGbz5b8g29Purvs8zHWcT5mIwEq/y9MGenYH33ZHWLqoeUbk4dFjgYFOLDkvHdtH
         O2I5ebRznoa5lW2j6O5uTwHREY0MfSs5hVj2B/B8=
Date:   Mon, 20 Jun 2022 12:09:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     andy.chi@canonical.com, stable@vger.kernel.org, tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/realtek: fix right sounds and
 mute/micmute LEDs for" failed to apply to 5.15-stable tree
Message-ID: <YrBHQVW+DaHTnZ6Q@kroah.com>
References: <16529705705957@kroah.com>
 <YqzsgnG5xtEela9L@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqzsgnG5xtEela9L@debian>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 17, 2022 at 10:05:06PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Thu, May 19, 2022 at 04:29:30PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

All now queued up, thanks.

greg k-h
