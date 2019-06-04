Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BBD34ABC
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 16:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfFDOqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 10:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbfFDOqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 10:46:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FA5924A66;
        Tue,  4 Jun 2019 14:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559659580;
        bh=fYS98lka5+1xJUYuJk8ZF9fHmswmiKdzos/aceIuW9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y0H6tYbdMUOG/X4Y2fXnu2mEcvJuWvUdMzHgFUa8+XN/+9+dd493Slg3Fm2YyJF2j
         99h3GMWpShB3G4/DVqN8kitIViJmiG5Tily1uYk9gKFgDWoK1xiLrrU9sPHcpzsi0P
         zQ9BafxH3LSfKKG2pdaJMLThOQroqVsf5RfW6VtA=
Date:   Tue, 4 Jun 2019 16:45:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.9] Security fixes
Message-ID: <20190604144554.GA22987@kroah.com>
References: <1559217157.2631.17.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559217157.2631.17.camel@codethink.co.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 12:52:37PM +0100, Ben Hutchings wrote:
> I've attached the following fixes to 4.9, as an mbox:
> 
> - brcmfmac: add length checks in scheduled scan result handler
> - brcmfmac: assure SSID length from firmware is limited
> - brcmfmac: add subtype check for event handling in data path
> - binder: Replace "%p" with "%pK" for stable
> - binder: replace "%p" with "%pK"
> - fs: prevent page refcount overflow in pipe_buf_get
> - mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages
> - mm, gup: ensure real head page is ref-counted when using hugepages
> - mm: prevent get_user_pages() from overflowing page refcount
> - mm: make page ref count overflow check tighter and more explicit
> - coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping
> 
> The first two "mm, gup" commits might not be strictly security fixes
> but the next one depends on them.

All now queued up, thanks!

greg k-h
