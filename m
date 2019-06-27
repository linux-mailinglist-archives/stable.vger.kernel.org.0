Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6A557582
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfF0A1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbfF0A1Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:27:24 -0400
Received: from localhost (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08FA52083B;
        Thu, 27 Jun 2019 00:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595243;
        bh=uhaynaqhaiNRiWR+el+3VKsZktd5cOez22t0B6otRO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F94wlCr+MI3B4J7cVI2XFVJ/sx5MDgOPP4LIJz6BO5UuH+ajbt11nIX8W7jzT5Q5d
         oTqk9gvHg5nlNaRz6QWkAUSdQfw9z7AeHryTNlCwBlE0Exfkcok6ylteiquU6Xe4Md
         puf0IsZ6J1npFbVkTAFMyYdxHXQwCvVbLyk4x8r8=
Date:   Wed, 26 Jun 2019 20:27:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH AUTOSEL 5.1 09/51] iommu/vt-d: Fix lock inversion between
 iommu->lock and device_domain_lock
Message-ID: <20190627002720.GQ7898@sasha-vm>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-9-sashal@kernel.org>
 <20190626065606.GT8151@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190626065606.GT8151@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 08:56:06AM +0200, Joerg Roedel wrote:
>Hi Sasha,
>
>On Tue, Jun 25, 2019 at 11:40:25PM -0400, Sasha Levin wrote:
>> From: Dave Jiang <dave.jiang@intel.com>
>>
>> [ Upstream commit 7560cc3ca7d9d11555f80c830544e463fcdb28b8 ]
>
>This commit was reverted upstream, please drop it from your stable
>queue. It caused new lockdep issues.

I've dropped it, thank you.

--
Thanks,
Sasha
