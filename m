Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B6D83D45
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 00:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfHFWSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 18:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbfHFWSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 18:18:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77F8221874;
        Tue,  6 Aug 2019 22:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565129924;
        bh=WzSjqcmpCELnmaCL2N5FBPAr3U4Jd2Zzzio6k+U2Ef0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L6KYmZSKBItEBppqEpd15l1KB+ZxXjbrsQzE103gnD2J3PWh4PIhpKNWRQpEdTzL+
         HCqGNAWfgLSRBYl0lylgGhYqDHhLvFIKYgfT+KFtEKNRk3ZXyRbwdFjqjHymltK6x6
         TxT99vhvxtHFHtL/+UXzUFXvXTu8ty7l5dmFB6wg=
Date:   Tue, 6 Aug 2019 18:18:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [5.2-stable PATCH 1/2] libnvdimm/bus: Prepare the nd_ioctl()
 path to be re-entrant
Message-ID: <20190806221843.GP17747@sasha-vm>
References: <156505494437.1043830.9239219668937125315.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156505494437.1043830.9239219668937125315.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 06:29:04PM -0700, Dan Williams wrote:
>commit 6de5d06e657acdbcf9637dac37916a4a5309e0f4 upstream.
>
>In preparation for not holding a lock over the execution of nd_ioctl(),
>update the implementation to allow multiple threads to be attempting
>ioctls at the same time. The bus lock still prevents multiple in-flight
>->ndctl() invocations from corrupting each other's state, but static
>global staging buffers are moved to the heap.
>
>Reported-by: Vishal Verma <vishal.l.verma@intel.com>
>Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
>Tested-by: Vishal Verma <vishal.l.verma@intel.com>
>Link: https://lore.kernel.org/r/156341208947.292348.10560140326807607481.stgit@dwillia2-desk3.amr.corp.intel.com
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I've queued up both the 5.2 and 4.19 patches, thanks!

--
Thanks,
Sasha
