Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAFD8C0C3
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 20:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfHMSh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 14:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfHMSh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 14:37:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3CB22064A;
        Tue, 13 Aug 2019 18:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565721478;
        bh=O6RKQJ/j6cRpcnAVTNHmol+XRXnvK/WIJ5ApLiBdhes=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lTBZlZSsGCNJBJUkb2isnHVaAbBp10OnDoqk4uBpWJmJiKLNWLX1ombgiOB8wNdMb
         NstjyPikTjPb85Xd2IEVP+J5I/4LGez7y4Q7HlGe1UeahHF8DkbAvUwluxJ3/1Rtt/
         sljN82Nm4TXysFKCK5Bt7BJWvLfhqB/m34geUKFs=
Date:   Tue, 13 Aug 2019 20:37:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, mathieu.poirier@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] coresight: Fix DEBUG_LOCKS_WARN_ON for uninitialized
 attribute
Message-ID: <20190813183755.GD6582@kroah.com>
References: <20190812135328.30952-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812135328.30952-1-suzuki.poulose@arm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 12, 2019 at 02:53:28PM +0100, Suzuki K Poulose wrote:
> commit 5511c0c309db4c526a6e9f8b2b8a1483771574bc upstream
> 
> While running the linux-next with CONFIG_DEBUG_LOCKS_ALLOC enabled,
> I get the following splat.
> 

Thanks for the backport, now queued up.

greg k-h
