Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD04248B494
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 18:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344709AbiAKRwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 12:52:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52060 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344295AbiAKRwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 12:52:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EE5F61708
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 17:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2ED1C36AE9;
        Tue, 11 Jan 2022 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641923526;
        bh=ssLMbVAwWtQjsFy8iv3/fjkWlo2ZZGrDiLiqOLP2z5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zt04b+ZixxQpSE3+aA+S4iU3Z+MEQJhNbNVAgQQY5bCGTIPe6CjLTaNAuoXcT4WsJ
         w7XpJqvhQGxanEI3MnWa79nIMXhJgMM2spV6sUERyB8OjeyT1Lg6gcovc+FQa0TLin
         HSReGx6huUVM848ljuFXhdbgdSpWndrqDLkgFY9A=
Date:   Tue, 11 Jan 2022 18:52:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amy Fong <Amy_Fong@mentor.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 4.19 stable 0/5] Backport netfilter: nf_tables: autoload
 modules from the abort path
Message-ID: <Yd3DwxeKXDM2FMl8@kroah.com>
References: <Yd2kKZEWm6AdBYDE@cat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd2kKZEWm6AdBYDE@cat>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 10:37:13AM -0500, Amy Fong wrote:
> The following series backports netfilter: nf_tables: autoload modules from abort path
> which fixes the bug mentioned in the following:
> 
>    https://syzkaller.appspot.com/bug?extid=437bf61d165c87bd40fb

Also, why is this bug special?  Can it be triggered by userspace?  What
is the fallout from it?  Who is hitting this in real systems and why
must just this one syzbot problem be backported, but others not?

In other words, we need a lot more information here to judge if this is
really needed, and if the backport is acceptable.

thanks,

greg k-h
