Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD383680582
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 06:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbjA3FRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 00:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjA3FRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 00:17:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AEA21943;
        Sun, 29 Jan 2023 21:17:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BD1060EC7;
        Mon, 30 Jan 2023 05:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A012C433EF;
        Mon, 30 Jan 2023 05:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675055848;
        bh=OOny9V0NNOxjWU7U8LS8cmdVxuHyt/C2Q+c4prqwLx4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hjb3tmMcg5wzK2eiMeyUbYgKD+825BrseUBhffyRZchGkKNgoi5XeKoMBVTrrmL31
         +GDd8a0ViaCIBFWLCu/2C5O2ZT4n1BYlIRLP1jqUJNxsyq4MQYhLiX0R26wRpbUxWK
         4vdqXiXqEh6t5gRe1UH66h4VWfu4Posz9SACKF5A=
Date:   Mon, 30 Jan 2023 06:17:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Kujau <lists@nerdbynature.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: External USB disks not recognized with v6.1.8 when using Xen
Message-ID: <Y9dS5ZlYR4f/didU@kroah.com>
References: <4fe9541e-4d4c-2b2a-f8c8-2d34a7284930@nerdbynature.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fe9541e-4d4c-2b2a-f8c8-2d34a7284930@nerdbynature.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 30, 2023 at 04:46:02AM +0100, Christian Kujau wrote:
> [CC stable as I only tested the stable tree for now]

The stable list is only for adding new things to stable releases, it's
not going to reach the developers involved in the changes you are having
issues with at all.

Try cc:ing the xen and usb mailing lists instead.  And using 'git
bisect' as you said, will help out a lot here in tracking down the
issue.

thanks,

greg k-h
