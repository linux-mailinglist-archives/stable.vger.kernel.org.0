Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CBD410790
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 18:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhIRQTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 12:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231415AbhIRQTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Sep 2021 12:19:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 731E761052;
        Sat, 18 Sep 2021 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631981875;
        bh=4MmZgnlBDHssMDEomRSED6gu2ktiZoxIz5uMUNmuMdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ix6Zsmct2JyKHOU30dEUG9KELrLWpEzTbY3eoiujk03VIjA0uZJQqf5RNLKEYf/qL
         yjGRGFI8VKhsytIfiQVimh6hsWPga1Zf+sGi6XRBtEG7KBujjDGxPbmStICX4O6VHh
         f+1CBxVmoo8GwY439R6D/qxVt0xS3UgqR6uwi6JY=
Date:   Sat, 18 Sep 2021 18:17:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Ghiti <alex@ghiti.fr>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <Atish.Patra@wdc.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] riscv: Flush current cpu icache before other cpus
Message-ID: <YUYRMAAQ/G27vofr@kroah.com>
References: <20210918160221.111902-1-alex@ghiti.fr>
 <66013f6b-e3d0-2fbf-c02b-93899c2b4696@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66013f6b-e3d0-2fbf-c02b-93899c2b4696@ghiti.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 18, 2021 at 06:05:09PM +0200, Alex Ghiti wrote:
> (+cc stable)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
