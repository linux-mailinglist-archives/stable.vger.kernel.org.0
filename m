Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2150C388928
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 10:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbhESIMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 04:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237518AbhESIMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 04:12:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00900610A2;
        Wed, 19 May 2021 08:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621411880;
        bh=/zr0PHowEjmcA1VKWh07Xdh5ZlxoJOTHc9TqGLD1VR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QD3TDsCOON4lkKSYmseoPt+5K0iJR3e5rrDxfcWszHPSBrBJEEpZD9F9vfV9DNqOw
         89U86bha6xgzF8Pw6qX3gwfnVYEfrPOBIUtb8uNIF/jCuy6rCjEd0HT4fbNfluNIYh
         YWbqMxUyGFbmSoIl6iIABWxG1/JLlVp1zWQOwiw8=
Date:   Wed, 19 May 2021 10:11:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Subject: Re: [PATCH 5.4 v2 0/9] preserve DMA offsets when using swiotlb
Message-ID: <YKTIJsD2KmiV3mIb@kroah.com>
References: <20210518221818.2963918-1-jxgao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518221818.2963918-1-jxgao@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 10:18:09PM +0000, Jianxiong Gao wrote:
> We observed several NVMe failures when running with SWIOTLB. The root
> cause of the issue is that when data is mapped via SWIOTLB, the address
> offset is not preserved. Several device drivers including the NVMe
> driver relies on this offset to function correctly.
> 
> Even though we discovered the error when running using AMD SEV, we have
> reproduced the same error in Rhel 8 without SEV. By adding swiotlb=force
> option to the boot command line parameter, NVMe funcionality is
> impacted. For example formatting a disk into xfs format returns an
> error.

I still fail to understand why you can not just use the 5.10.y kernel or
newer.  What is preventing you from doing this if you wish to use this
type of hardware?  This is not a "regression" in that the 5.4.y kernel
has never worked with this hardware before, it feels like a new feature.

Please, just use 5.10.y or newer, your life will be so much easier in
the longrun.

thanks,

greg k-h
