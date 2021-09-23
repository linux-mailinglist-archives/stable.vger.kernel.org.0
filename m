Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8204159BC
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 10:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbhIWIFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 04:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237451AbhIWIFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 04:05:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72B6761215;
        Thu, 23 Sep 2021 08:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632384225;
        bh=if9p63Bf0bnepPFMqPM3BOCO/20TaMmpCsQNbwAH8fU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BmZQxIP/XTtFdAtReAHKKD9ANamaO7LwaOSn9cAe0Pid43ksolGyjz3zNpqoAsIrV
         0ieFa5TTdy5SFzEmKSi8tQAi3BG63yL7eg9zKvFmMVHFDIB57XjJ36VmuD9rpXoSfq
         SVGxjtw+haEyCtyAgDTzDrHBSmD/NBxRGKSKRO44=
Date:   Thu, 23 Sep 2021 10:03:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH 5.10 STABLE] s390/pci_mmio: fully validate the VMA before
 calling follow_pte()
Message-ID: <YUw03qRuSKt6+VlC@kroah.com>
References: <1632128112176198@kroah.com>
 <20210920131749.9360-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920131749.9360-1-david@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 03:17:49PM +0200, David Hildenbrand wrote:
> commit a8b92b8c1eac8d655a97b1e90f4d83c25d9b9a18 upstream.
> 
> Note: We don't have vma_lookup() in the 5.4-stable tree, so perform the VMA
> check manually.

Both backports now queued up, thanks.

greg k-h
