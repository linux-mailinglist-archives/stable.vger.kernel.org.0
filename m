Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFF7342C10
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhCTLYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229770AbhCTLXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:23:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F9316199D;
        Sat, 20 Mar 2021 10:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616236985;
        bh=GZ9R52XN0fG2aKJxYoYaimnAN2Ubt0WsDnCLdONpL6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nzdCKMWSgu9dQ7aBYVD3DO5nBIu35X4wqGbHFEKteWIc1GBjeNLqa/P5EP/iqbeEv
         oxDXETk6Ee3TtTwbuK8HWM4dFC/q74kyZ3eD5YWag4UGGoWV25/cAoicj3BXTFP8PG
         HPp/5Veap7Ggw8239zktM/Rs14eKO69i7FoSF98s=
Date:   Sat, 20 Mar 2021 11:43:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Piotr Krysiuk <piotras@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, stable@vger.kernel.org
Subject: Re: bpf speculative execution fixes for 4.14.y
Message-ID: <YFXRtrt5wPb8l0Sj@kroah.com>
References: <CAFzhf4qk9aFhhEtraUo0b9Si2y5taYDgdGwVZoSJ9Yj-59RGrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFzhf4qk9aFhhEtraUo0b9Si2y5taYDgdGwVZoSJ9Yj-59RGrw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 11:56:18PM +0000, Piotr Krysiuk wrote:
> I noticed that bpf speculative execution fixes are already queued for
> 4.14.y except for f232326f6966 ("bpf: Prohibit alu ops for pointer
> types not defining ptr_limit").
> 
> It is important that for all patches from this series to be applied
> together, so we avoid introducing a new vulnerability.
> 
> For the missing patch, I see conflicting lines in the context diffs
> due to API change that apparently caused import to fail.
> 
> I'm attaching a copy of the patch that is backported to 4.14.y. The
> only change comparing with version queued for newer version is that
> "verbose" API does not take "env" parameter.
> 
> Please queue or let me know how to proceed.

Now queued up, thanks!

greg k-h
