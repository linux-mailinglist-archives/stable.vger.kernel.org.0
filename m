Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090794A3665
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 13:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354825AbiA3Mxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 07:53:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45998 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354822AbiA3Mxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 07:53:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3207D61193;
        Sun, 30 Jan 2022 12:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1BFC340E4;
        Sun, 30 Jan 2022 12:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643547232;
        bh=ix1rZRsh3GJ87yam2pz0u3uNlg02VbKX/BPceT2WZAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uCaRGfQ9lXNbe3ene2zEpcqjXprloxdXknURwMfEViSCPCSdugBF93gG2t2UlYFP2
         XRXCt5wNeAWsSBZQUanLfnNH8L7wWXP47ggiMEe/GWDdsOOUr0D/49obiOk/mhgGSM
         fKnL5whSgTJ4lV8ByHDDgdiWwgdV1zbWsLJT6zV0=
Date:   Sun, 30 Jan 2022 13:53:49 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] [Rebased for 4.14] lkdtm: Fix content of section
 containing lkdtm_rodata_do_nothing()
Message-ID: <YfaKXdEHXbwkndw9@kroah.com>
References: <32bbc122ba24b863d048f51ff13fe391b16b9f2e.1643536487.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32bbc122ba24b863d048f51ff13fe391b16b9f2e.1643536487.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 30, 2022 at 09:55:39AM +0000, Christophe Leroy wrote:
> This is backport for 4.14
> 
> (cherry picked from commit bc93a22a19eb2b68a16ecf04cdf4b2ed65aaf398)
> 

Now queued up, thanks.

greg k-h
