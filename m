Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779D039F991
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhFHOve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:32816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233577AbhFHOvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 10:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D2861183;
        Tue,  8 Jun 2021 14:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623163765;
        bh=wbEYYkcVbtbP/r5YphOklx/vAE+EMszFRrPLHOKliE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SgCumlPyzfmxhyWW8fcNC6zx/fUAT5Voa18zIR1V3o2SLZtckMfCoheyiZVhnHdYr
         P0ozyd9wVGUpVYYQuJqesrA1Tq06s7td/D7FyOZiF20wSmA1QDImz0DAgpkG6V3EwD
         vB1jfBCY17kVBmp0EJ2/Tx9Yos6jwGN033G0peX4=
Date:   Tue, 8 Jun 2021 16:49:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shaoying Xu <shaoyi@amazon.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        fllinden@amazon.com
Subject: Re: [PATCH 5.4] bpf, selftests: Adjust few selftest result_unpriv
 outcomes
Message-ID: <YL+Dc39oAl4VZ3lD@kroah.com>
References: <20210601170241.GA31268@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601170241.GA31268@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 05:02:41PM +0000, Shaoying Xu wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> commit 1bad6fd52be4ce12d207e2820ceb0f29ab31fc53 upstream
> 
> Given we don't need to simulate the speculative domain for registers with
> immediates anymore since the verifier uses direct imm-based rewrites instead
> of having to mask, we can also lift a few cases that were previously rejected.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> [shaoyi@amazon.com - backport to 5.4 with small contextual change]

What about 5.10 and 5.12, why wouldn't they also need this?

thanks,

greg k-h
