Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52843E5736
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbhHJJlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233409AbhHJJlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 05:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C07B61052;
        Tue, 10 Aug 2021 09:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628588480;
        bh=ifjWLtNNakbrvobAA7GQmhQorvj05jLq/kaLg7F4Rak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TRTDauqdbq6MZZKltb7fqrtq9SDphm1e+Wh4U2D6sitxoYNDfsQB+gjKogOm8RBgZ
         ROJZiSb0Qi1QGiAFDi8Pen8v3OGsDkSGe9W6vJzgv+biBKFTOouVl6kE/ansDHD37z
         1s8erBkfsNP2tyhut/DlMUD1YV8HvwWx52NQ6iFs=
Date:   Tue, 10 Aug 2021 11:41:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4 1/1] bpf, selftests: Adjust few selftest
 result_unpriv outcomes
Message-ID: <YRJJvol3o+VGWTXX@kroah.com>
References: <20210804172001.3909228-1-ovidiu.panait@windriver.com>
 <20210804172001.3909228-2-ovidiu.panait@windriver.com>
 <cfaedc65-9659-1c78-7bef-bf051c577fc0@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfaedc65-9659-1c78-7bef-bf051c577fc0@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 11:53:06AM +0300, Ovidiu Panait wrote:
> On 04.08.2021 20:20, Ovidiu Panait wrote:
> > From: Daniel Borkmann <daniel@iogearbox.net>
> > 
> > Given we don't need to simulate the speculative domain for registers with
> > immediates anymore since the verifier uses direct imm-based rewrites instead
> > of having to mask, we can also lift a few cases that were previously rejected.
> > 
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Acked-by: Alexei Starovoitov <ast@kernel.org>
> > [OP: backport to 5.4, small context adjustment in stack_ptr.c]
> > Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> 
> Hi Greg,
> 
> 
> It seems that this patch was missed for the previous 5.4 release, could it
> be included in the upcoming release?

Ick, sorry about that, I missed it, my fault.

I'll go queue it up now, thanks.

greg k-h
