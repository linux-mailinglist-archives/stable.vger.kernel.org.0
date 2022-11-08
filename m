Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA1162104E
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiKHMUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbiKHMUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:20:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF234FFB6;
        Tue,  8 Nov 2022 04:20:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 466B2B81A69;
        Tue,  8 Nov 2022 12:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1736C433D6;
        Tue,  8 Nov 2022 12:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667910045;
        bh=EmhbBfqm6Wz9ofZAbrQbo/5Jq/Wf3+r+IChgNTSUb5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G3WKqhP0/1qPs2ezTNrqNOPnmTgX9tPLn5oCBlTa+hMRQB3eTuVwj9/5O9FO4gjDL
         8F9K+mUXYBxXp06Zm5zvVBCrhHq4KvAw+JwpDu1ThkxbPrFWEbqHQ51pOKZUuHSvpI
         QwlvT/hnnSkdRPB+e9m+9SKb2LFRDMDxh8gVGTfU=
Date:   Tue, 8 Nov 2022 13:20:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Stable <stable@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Fwd: patch for stable "cifs: fix regression in very old smb1
 mounts"
Message-ID: <Y2pJmgDHdN2cfnpm@kroah.com>
References: <CAH2r5mub3G42yb48gN-KY7tgqen8oeT-mmE7y23vyQ0e5ihctQ@mail.gmail.com>
 <CAH2r5muthiUdk9Lgt5noXLZo4Kkh25VmF1x9mFnWtFVqXxAoyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muthiUdk9Lgt5noXLZo4Kkh25VmF1x9mFnWtFVqXxAoyw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 05:55:27PM -0600, Steve French wrote:
> ---------- Forwarded message ---------
> From: Steve French <smfrench@gmail.com>
> Date: Mon, Nov 7, 2022 at 5:54 PM
> Subject: patch for stable "cifs: fix regression in very old smb1 mounts"
> To: Stable <stable@vger.kernel.org>
> Cc: CIFS <linux-cifs@vger.kernel.org>, Thorsten Leemhuis
> <regressions@leemhuis.info>, ronnie sahlberg
> <ronniesahlberg@gmail.com>
> 
> 
> commit 2f6f19c7aaad "cifs: fix regression in very old smb1 mounts" upstream
> 
> Also attached upstream commit.
> 
> For 5.15 and 6.0 stable kernels

Now queued up, thanks.

greg k-h
