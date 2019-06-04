Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 410D134AF0
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 16:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfFDOuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 10:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727650AbfFDOuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 10:50:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0952420874;
        Tue,  4 Jun 2019 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559659809;
        bh=S03YKx9bIWntHQREO/UfabH4fV4H+Gaja2M7d9fnp0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E93p/Lh+UxDZ0t+4ZVKL3CbFnteE6cA3kVLMm1NaCTOK+Mv7aGp0bLjUXydIne9PG
         2vaj77+yxuwapiJ0/5qEistmbTLNC5IxvrzSd1NNQnrsS08sXERlRO9w+UBLBgc18y
         Yvy1Pwj7sdrO3C/gMs3CqcJAATYUCXgLriWYj4eA=
Date:   Tue, 4 Jun 2019 16:50:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.4] Security fixes
Message-ID: <20190604145007.GA5824@kroah.com>
References: <1559226139.2631.30.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559226139.2631.30.camel@codethink.co.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 03:22:19PM +0100, Ben Hutchings wrote:
> I've attached the following fixes to 4.4, as an mbox:
> 
> - binder: Replace "%p" with "%pK" for stable
> - binder: replace "%p" with "%pK"
> - net: create skb_gso_validate_mac_len()
> - bnx2x: disable GSO where gso_size is too big for hardware
> - brcmfmac: Add length checks on firmware events
> - brcmfmac: screening firmware event packet
> - brcmfmac: revise handling events in receive path
> - brcmfmac: fix incorrect event channel deduction
> - brcmfmac: add length checks in scheduled scan result handler
> - brcmfmac: add subtype check for event handling in data path
> - userfaultfd: don't pin the user memory in userfaultfd_file_create()
> - coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping
> 
> The userfaultfd commit might not be a security fix but the next one
> depends on it.

All now applied, thanks.

greg k-h
