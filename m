Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328C96B3E9A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCJMD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCJMDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:03:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA29A80925
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:03:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93183B82285
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 12:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E1CC433EF;
        Fri, 10 Mar 2023 12:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678449830;
        bh=dxSE/QUP8quHyZb5MHgddYnWQuli4oIrINIzjRgn2fQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6qYH/EWSjvEOSVCBSabKTohj+0xQKnxN5bUlvxLpFCxD4vO8lf8b/x8H6w0rDDY2
         xX54rVBTfbPYrLWNQSrgr6o9WYbNKqDL+lO1PmolMArXl7C2UlOsaFYYj9V7WhA92l
         9QPOlIRcVY6x2WAvIvMTPJsg0x2MZ+0a4d6+uyCM=
Date:   Fri, 10 Mar 2023 13:03:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     stable@vger.kernel.org, liujian <liujian56@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [4.19/5.4/5.10] Please backport fdaf88531cfd.
Message-ID: <ZAsco1iU3rbBLj2F@kroah.com>
References: <20230308012905.10857-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308012905.10857-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 05:29:05PM -0800, Kuniyuki Iwashima wrote:
> Hi,
> 
> On 4.14, 4.19, 5.4, and 5.10, listen() does not return -EADDRINUSE when
> it fails to reserve a port.
> 
> The same issue happend on 5.15.88 and fdaf88531cfd ("tcp: Fix listen()
> regression in 5.15.88.") in the 5.15.y branch fixed it.
> 
> The commit can be applied cleanly to 4.19, 5.4, and 5.10.
> Could you backport the commit to these branch ?
> 
> For 4.14.y, I'll post another patch.

All now queued up, thanks!

greg k-h
