Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284104A7722
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 18:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbiBBRx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 12:53:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37342 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbiBBRx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 12:53:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02CDAB8321D
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 17:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272C7C004E1;
        Wed,  2 Feb 2022 17:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643824435;
        bh=DsVmF3Uf7WIUaEITILmNu8PpaHjsNvDIzgiu/+s8bqE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+E6a6YAk501KTtQ2CNHH53zzouRFkJK3rYh21CUpAhRq0nhJDERnHifYHaIyrnfv
         34c7KPhDdO+IKRVYBmP6A2/nRzqiDOt8TXmgq1KZilpQPECyee52xZaNEnQRXWEZMP
         1mtNDQD8UvaV6X0tujPSv9e8oOR6hF0QfkZh8hjI=
Date:   Wed, 2 Feb 2022 18:53:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Bertholon <guillaume.bertholon@ens.fr>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.4] Input: i8042 - Fix misplaced backport of "add ASUS
 Zenbook Flip to noselftest list"
Message-ID: <YfrFMWv76MZdzuxe@kroah.com>
References: <1643810603-6968-1-git-send-email-guillaume.bertholon@ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643810603-6968-1-git-send-email-guillaume.bertholon@ens.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 03:03:23PM +0100, Guillaume Bertholon wrote:
> The upstream commit b5d6e7ab7fe7 ("Input: i8042 - add ASUS Zenbook Flip to
> noselftest list") inserted a new entry in the `i8042_dmi_noselftest_table`
> table, further patched by commit daa58c8eec0a ("Input: i8042 - fix Pegatron
> C15B ID entry") to insert a missing separator.
> 
> However, their backported version in stable (commit e480ccf433be
> ("Input: i8042 - add ASUS Zenbook Flip to noselftest list") and
> commit 7444a4152ac3 ("Input: i8042 - fix Pegatron C15B ID entry"))
> inserted this entry in `i8042_dmi_forcemux_table` instead.
> 
> This patch moves the entry back into `i8042_dmi_noselftest_table`.
> 
> Fixes: e480ccf433be ("Input: i8042 - add ASUS Zenbook Flip to noselftest list")
> Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
> ---
>  drivers/input/serio/i8042-x86ia64io.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 

Now queued up, thanks.

greg k-h
