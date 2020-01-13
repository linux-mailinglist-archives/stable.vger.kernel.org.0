Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A658F1398E1
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 19:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgAMS1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 13:27:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728674AbgAMS1K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 13:27:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B3B72075B;
        Mon, 13 Jan 2020 18:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578940030;
        bh=bv0o5AUGwPRgCIx6EEmTDtkPb2FdqdcJWMKnZ+Wnc98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eUWCifuukUmn3+QtHelTkhqCWCWen40w9yKeqnbIBxLxnKTmZamDRKGTax4H6lKPk
         ewdJIONsnVxwrjY/YAshUvQjdQxc/AdrdeAjvQn3JSrV0Gu2bciFwPwWgxwV+als/n
         bq6bdZWeBwURucyLdJNKnBA87qWVT3B82WUruq+s=
Date:   Mon, 13 Jan 2020 19:27:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Please apply 0b9aefea8600 ("tcp: minimize false-positives on
 TCP/GRO check") to v4.9.y
Message-ID: <20200113182707.GI411698@kroah.com>
References: <20200113161827.GA22400@lorien.valinor.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113161827.GA22400@lorien.valinor.li>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 05:18:27PM +0100, Salvatore Bonaccorso wrote:
> Hi Greg, hi Sasha
> 
> As per https://bugzilla.kernel.org/show_bug.cgi?id=194569 applying the
> commit 0b9aefea8600 ("tcp: minimize false-positives on TCP/GRO check")
> would reduce the false-positives. dcb17d22e1c2 was introduced in v4.9.
> 
> Thoughs? Can you consider applying it for 4.9.y?

Sure, I'll go queue it up now, thanks!

greg k-h
