Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBCC461688
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 14:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343781AbhK2Nhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 08:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244761AbhK2Nfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 08:35:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A09C002140
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 04:12:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E22A3CE1120
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82252C53FCB;
        Mon, 29 Nov 2021 12:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638187952;
        bh=NshuyIPsSwG4P24EuCkknARpNzHRd7femng/MUEGXEQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sdz/Uo5JpxiuKdf7CGuuGigehRchmSsiBm2R+IFsJu/Q+WJH+77VM8Sf+EdnTCNvi
         ogjwvIqEf2Y5naUw8mdmUuBLkMVrv4oefO2mtQXLlCkZxQQhLG8r2osXRmhl9d71QC
         HvyPNg0opG3Pb/xPWbeLQe7R2tdX8DhNdTOZwIRI=
Date:   Mon, 29 Nov 2021 13:12:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     stable@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        stfrench@microsoft.com
Subject: Re: [PATCH v2 BACKPORT for 5.15 stable] ksmbd: Fix an error handling
 path in 'smb2_sess_setup()'
Message-ID: <YaTDrOHHUfcqq1NX@kroah.com>
References: <20211128130403.10297-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128130403.10297-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 28, 2021 at 10:04:03PM +0900, Namjae Jeon wrote:
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> All the error handling paths of 'smb2_sess_setup()' end to 'out_err'.
> 
> All but the new error handling path added by the commit given in the Fixes
> tag below.
> 
> Fix this error handling path and branch to 'out_err' as well.
> 
> Fixes: 0d994cd482ee ("ksmbd: add buffer validation in session setup")
> Cc: stable@vger.kernel.org # v5.15
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  v2:
>    - add missing Steve's signoff tag.

What is the git id of this in Linus's tree?

And why no signed-off-by: from you?  Please add that when doing
backports and you have to change things.

thanks,

greg k-h
