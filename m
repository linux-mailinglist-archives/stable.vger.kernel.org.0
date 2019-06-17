Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF27B49152
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 22:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfFQU0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 16:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbfFQU0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 16:26:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AA4D20861;
        Mon, 17 Jun 2019 20:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560803205;
        bh=3B+EgTk23Q2ngx/vipiVpBWzn1Ue5rkX3mfBnqFcHzA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FihulygP6bSANnpsQUei6O2S5RBxyzy7oDcg5GTU3CsNpq5iMg5Dhs89KwGd4NuIJ
         87bXjwSaFZWvTAUElPQJ8x4+ggn78tvIKjrssLWqb2ZBwYGF6OTEkdbyyZWNmwIT3l
         fCUQc5L2gKyWXMGIuNB0KQCY4DzHQ76ToUn7XdfU=
Date:   Mon, 17 Jun 2019 22:26:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     avagin@gmail.com, linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: stable-rc: ptrace: peeksiginfo failed on 4.19, 4.14, 4.9 and 4.4
Message-ID: <20190617202642.GA8067@kroah.com>
References: <CA+G9fYsFL5AH6dkdN2Qd6UP=wdiXRDR_ioQFPSCq=uUBcmtHXw@mail.gmail.com>
 <87lfy0pd63.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfy0pd63.fsf@xmission.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 08:13:56AM -0500, Eric W. Biederman wrote:
> Naresh Kamboju <naresh.kamboju@linaro.org> writes:
> 
> > selftests: ptrace: peeksiginfo failed on x86_64, i386, arm64 and arm.
> > FAILED on stable rc branches 4.19, 4.14, 4.9 and 4.4.
> > PASS on mainline, next and 5.1 stable rc branch.
> 
> Greg.
> 
> Looking in my email it appears 4.19, 4.14, 4.9, and 4.4 patches are
> missing the "found=1" line from the original change.   This explains
> the test failure.

Ugh, that was due to me doing the backport by hand, sorry about that.
Sasha, thanks for fixing this.

greg k-h
