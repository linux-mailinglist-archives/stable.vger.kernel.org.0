Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A772010F7DD
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 07:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfLCGiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 01:38:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfLCGiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 01:38:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD90C20684;
        Tue,  3 Dec 2019 06:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575355085;
        bh=ZUEsjU69DjVINI78vAzOTqnd8jGMNBseJWEUeRtyYi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lZt11CkkvrytPC5YVdGA6nJ1FxbIQfqZhe32eRU2lfgRcQWxB5WLu5MOqBMv2mE0Q
         jRVXPxeCY67bp1zR+NrpPJW2zC6MNLW7rfEO781BrsrlKuZpDJnk04VKhsCSOfmoon
         x6ZN/Q2/8eY6LVYz8ESI8ESJga61YfYzCjEO8SeI=
Date:   Tue, 3 Dec 2019 07:38:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Barret Rhoden <brho@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: x86/fpu: Don't cache access to fpu_fpregs_owner_ctx
Message-ID: <20191203063802.GA1772990@kroah.com>
References: <edb74a15-c20d-2a8e-0560-97c038541ab6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edb74a15-c20d-2a8e-0560-97c038541ab6@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 06:24:49PM -0500, Barret Rhoden wrote:
> commit 59c4bd853abcea95eccc167a7d7fd5f1a5f47b98 upstream
> 
> Hi -
> 
> Please apply to 5.4.  This commit fixes floating point register corruption
> that became triggerable starting with v5.2.

Now queued up, thanks.

greg k-h
