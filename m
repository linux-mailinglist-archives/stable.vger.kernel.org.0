Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67673DB066
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 02:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhG3ApZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 20:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbhG3ApZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 20:45:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70C6B6052B;
        Fri, 30 Jul 2021 00:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627605921;
        bh=IKk7BX1ONbfPnv8s4mwXVo9+RGln8d3bOeRSwAddPO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b0FNddH7tZzNv0/r9imFIx+MXyPhXQKMovGjhi0J2KdGypSiPqknCUZUZXcaYiBNH
         iSr3r3Pt0aNeNDCqjkcv5FFoiFAYiBHkWjzDPyLOd3MOvZ6aOMl5rhf1RULksXh+BR
         jOOA/8xkDHplNcnfcw+bHeyvhWnejduJwxGntZZFaYjbf3LTXr27uK2kT6mdPAqRSs
         JfHdwOQeB/PUA6EQbZb6bbIG6UCetiK7UoGuSGoMNauzCRpBEI7wIDOp30T0VtviUD
         JjSXhTNrnNykYCIci0FKRGvjQmw+2LlUr8ARQiH3+61ZK3SrB2nsXv7jzRu3vvsLX9
         J7kU0ZK+vqH6A==
Date:   Fri, 30 Jul 2021 03:45:17 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Adrian Ratiu <adrian.ratiu@collabora.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] char: tpm: Kconfig: remove bad i2c cr50 select
Message-ID: <20210730004517.w66o7cyas2h3t6oj@kernel.org>
References: <20210727171313.2452236-1-adrian.ratiu@collabora.com>
 <20210728215346.rmgvn4woou4iehqx@kernel.org>
 <87h7gdqstj.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7gdqstj.fsf@collabora.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 02:10:16PM +0300, Adrian Ratiu wrote:
> On Thu, 29 Jul 2021, Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > On Tue, Jul 27, 2021 at 08:13:12PM +0300, Adrian Ratiu wrote:
> > > This fixes a minor bug which went unnoticed during the initial
> > > driver upstreaming review: TCG_CR50 does not exist in mainline
> > > kernels, so remove it.   Fixes: 3a253caaad11 ("char: tpm: add i2c
> > > driver for cr50") Cc: stable@vger.kernel.org Reviewed-by: Jarkko
> > > Sakkinen <jarkko@kernel.org> Signed-off-by: Adrian Ratiu
> > > <adrian.ratiu@collabora.com> ---
> > 
> > These are missing changelog. I guess tags are added, and nothing else?
> 
> Hi. That is correct, I've only added the tags you suggested on the first
> patch, the second patch is identical.

OK, cool. I'll pick this up then. Thank you.

/Jarkko
