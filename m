Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7CE356C8E
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 14:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352387AbhDGMti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 08:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352383AbhDGMth (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 08:49:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F28466124B;
        Wed,  7 Apr 2021 12:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617799767;
        bh=UcdZRqik3FIPazhT6flZLxSjk/qVOJe8EBpJ0CUnf0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pfwtdF6Ad5RBhUtNIVrMDtgojFBCtlXRN0HpjdKOMYppLH0I46hzigfmId5BToN3n
         A/TICmXZPLf6OcGXpQZd8WDcl17N3aha8A+Y1bpkES0nTT4+l14xW2OoImZbCqJk5L
         qeWgxZN8ypBAuRzgZG3QvDUuc3hoNpGh6vHeqzeE=
Date:   Wed, 7 Apr 2021 14:49:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V2 v5.4 0/8] preserve DMA offsets when using swiotlb
Message-ID: <YG2qVItVrXXh/mU0@kroah.com>
References: <20210406204326.1932888-1-jxgao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406204326.1932888-1-jxgao@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 08:43:19PM +0000, Jianxiong Gao wrote:
> Hi all,
> 
> This series of backports fixes the SWIOTLB library to maintain the
> page offset when mapping a DMA address. The bug that motivated this
> patch series manifested when running a 5.4 kernel as a SEV guest with
> an NVMe device. However, any device that infers information from the
> page offset and is accessed through the SWIOTLB will benefit from this
> bug fix.

I feel like we have tried to backport this in the past, right?  Have you
looked in the stable archives?

What is wrong with just using 5.10.y instead for this type of hardware?
What prevents you from doing that instead of backporting this new
feature as this has never worked properly with this hardware on older
kernels.

thanks,

greg k-h
