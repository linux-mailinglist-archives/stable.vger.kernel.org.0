Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843184971F9
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbiAWOSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236513AbiAWOSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:18:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA13CC06173B;
        Sun, 23 Jan 2022 06:18:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EDB1B80CF1;
        Sun, 23 Jan 2022 14:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A17C340E2;
        Sun, 23 Jan 2022 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947529;
        bh=OhPzRW6i8QjI1RtDekgoVj3RFhnerhar0Xjsn/1V6R4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y8/nEOmtekv/y+P3T4QPAv+79csERTuDyzB3mfA8H6gn0LMm/gIT8QLddefFalgME
         2xkn3/7YmvEZuPAEw65cWkwqHWP9VfpicdYfW3lsFaZcuKNsvk+rSXr60YPotzYnkx
         SdXlBN2Z/Y/rj5NF/SMCyuivNfxBzWGJlCdplqQg=
Date:   Sun, 23 Jan 2022 15:18:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     stable@vger.kernel.org, smfrench@gmail.com,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH 5.16.y 0/4] ksmbd stable patches for 5.16.y
Message-ID: <Ye1jxiwqfcUqWa7D@kroah.com>
References: <20220121235427.10349-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121235427.10349-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 22, 2022 at 08:54:23AM +0900, Namjae Jeon wrote:
> These patches include 2 patches to run the recently updated
> ksmbd.mountd(3.4.4) and 2 other patches to fix issues to avoid out of
> memory issues caused by many outstanding smb2 locks. These are
> important patches applied to linux-5.17-rc1, but they cannot be applied
> to the stable kernel, so they are sent as separately backported patches.
> 
> Namjae Jeon (4):
>   ksmbd: add support for smb2 max credit parameter
>   ksmbd: move credit charge deduction under processing request
>   ksmbd: limits exceeding the maximum allowable outstanding requests
>   ksmbd: add reserved room in ipc request/response
> 
>  fs/ksmbd/connection.c    |  1 +
>  fs/ksmbd/connection.h    |  4 ++--
>  fs/ksmbd/ksmbd_netlink.h | 12 +++++++++++-
>  fs/ksmbd/smb2misc.c      | 18 ++++++++++++------
>  fs/ksmbd/smb2ops.c       | 16 ++++++++++++----
>  fs/ksmbd/smb2pdu.c       | 25 +++++++++++++++----------
>  fs/ksmbd/smb2pdu.h       |  1 +
>  fs/ksmbd/smb_common.h    |  1 +
>  fs/ksmbd/transport_ipc.c |  2 ++
>  9 files changed, 57 insertions(+), 23 deletions(-)
> 
> -- 
> 2.25.1
> 

All now queued up, thanks.

greg k-h
