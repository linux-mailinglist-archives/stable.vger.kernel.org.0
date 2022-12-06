Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C9B6442F3
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiLFMHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiLFMHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:07:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBEB1054C
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 04:07:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F28B819B7
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 12:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC25C433D6;
        Tue,  6 Dec 2022 12:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670328449;
        bh=7l+CMCrRiZSpfpo12z7gZYPr1c4vuHGNpp7zubXW0Y8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=snsd6jRsbP65SXELt58uQAYOilU8u/6Smb6eDgKP4QjLJy3GtbZuVIkQ3cJ0TWQeN
         8R5yWzN9A/q+nF9SfnTrheL4stR7UHhWBKYc6lJr+NBP2vLygBjs1QRPjtZ+wHFjlW
         Uk4rsouoAwBfZEb1qZmR9g9OYp6DEMkO0RFoT1bI=
Date:   Tue, 6 Dec 2022 13:07:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     jannh@google.com, torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ipc/sem: Fix dangling sem_array access in
 semtimedop race" failed to apply to 5.10-stable tree
Message-ID: <Y48wfjx6OnFGb3lU@kroah.com>
References: <16703264291854@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16703264291854@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 12:33:49PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:

Looks like Sasha did the backports already, so no need for these.

greg k-h
