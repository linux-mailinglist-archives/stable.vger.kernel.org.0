Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF893E7BA0
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 17:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242498AbhHJPDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 11:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240677AbhHJPDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 11:03:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5EF160F02;
        Tue, 10 Aug 2021 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628607803;
        bh=vqMTZKhTdDZX5E8puA+HiV17moykUJQpBQOrLZ1EM/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oSAEaFh4dsg4P2SVFPedD6dueP58RiAljUQ08QcEgbJd+ENCMb9w4RyLdG7+wIs7Y
         yFmIWhX0kPNKhVUt9Y12N5TsjjqhyAV3nItZwnK6gk3iWr0K0zvVQKm+4/xLcD5p33
         eX28HtYYelcgErqAsB4JV/61fZMKsM8cs0v69wzI=
Date:   Tue, 10 Aug 2021 17:03:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     stable@vger.kernel.org, will@kernel.org
Subject: Re: [PATCH 5.10.y] arm64: fix compat syscall return truncation
Message-ID: <YRKVNuRbVyRN0dF4@kroah.com>
References: <20210810144355.33235-1-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810144355.33235-1-mark.rutland@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 03:43:55PM +0100, Mark Rutland wrote:
> commit e30e8d46cf605d216a799a28c77b8a41c328613a upstream.
> 
> Due to inconsistencies in the way we manipulate compat GPRs, we have a
> few issues today:
> 
> * For audit and tracing, where error codes are handled as a (native)

<snip>

Thanks, both now queued up.

greg k-h
