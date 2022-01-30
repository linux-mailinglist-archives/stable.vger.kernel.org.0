Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF0E4A3661
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 13:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbiA3Mw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 07:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347113AbiA3Mw1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 07:52:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1528C061714;
        Sun, 30 Jan 2022 04:52:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D21B611B1;
        Sun, 30 Jan 2022 12:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10524C340E4;
        Sun, 30 Jan 2022 12:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643547146;
        bh=J2ohbNox5M7G8hZEGVJymXNqq72+9+B2XPrlnwdfpig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MHyDiwRhbqKkVsQUnt9qvhzl2vKGs+vPNnR6o8cgzvk+sf9Mw5X4bJpY/SL+5Qyk6
         YnT34fI1b/x2DBBlFVHAO2OVUiDHPHGM/VaTGLhnBcQHERNY4fpsMN9dnvYp+/Bb+8
         uDS/TELy2lVwnRlcSY7HuFtBi4XieJpISCCXlXn0=
Date:   Sun, 30 Jan 2022 13:52:23 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Erhard Furtner <erhard_f@mailbox.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] [Rebased for 4.19 and 4.14] powerpc/32: Fix boot failure
 with GCC latent entropy plugin
Message-ID: <YfaKBw4YMSdahMvc@kroah.com>
References: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e230a64554197468089375631e040b4249789fbd.1643535825.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 30, 2022 at 09:45:10AM +0000, Christophe Leroy wrote:
> This is backport for 4.19 and 4.14
> 
> (cherry picked from commit bba496656a73fc1d1330b49c7f82843836e9feb1)
> 
> Boot fails with GCC latent entropy plugin enabled.

All now queued up, thanks,

greg k-h
