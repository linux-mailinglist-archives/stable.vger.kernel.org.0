Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E4718319
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 03:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfEIBGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 21:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfEIBGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 21:06:03 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D653621479;
        Thu,  9 May 2019 01:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557363962;
        bh=600qRXLEDKMKeph/AjRgQT+N42KTSsWElKhQOKqFhe8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oPg5LdTAmRD2OhNEmBwJTTJmPX6CbMLJ90xwUz39kvxl1oA/GSKPUSv+b3lR9GPWl
         nSQW9zRFSc5byUJNsQAkQeMTqlkmxmbqN+V/jsgqhEInRiICHL4XGpDmP6dwSzR8Kf
         Iax1Wo8NaXsjSQBviB+p9Ck0C8WRJAmzapEjWbk8=
Date:   Wed, 8 May 2019 21:06:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "juliana.rodrigueiro@intra2net.com" 
        <juliana.rodrigueiro@intra2net.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] Drivers: hv: vmbus: Fix virt_to_hvpfn() for X86_PAE
Message-ID: <20190509010600.GQ1747@sasha-vm>
References: <1557215147-89776-1-git-send-email-decui@microsoft.com>
 <DM5PR2101MB09188A7DB0777CD50333F94ED7310@DM5PR2101MB0918.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DM5PR2101MB09188A7DB0777CD50333F94ED7310@DM5PR2101MB0918.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 12:51:51PM +0000, Michael Kelley wrote:
>From: Dexuan Cui <decui@microsoft.com> Sent: Tuesday, May 7, 2019 12:47 AM
>>
>> In the case of X86_PAE, unsigned long is u32, but the physical address type
>> should be u64. Due to the bug here, the netvsc driver can not load
>> successfully, and sometimes the VM can panic due to memory corruption (the
>> hypervisor writes data to the wrong location).
>>
>> Fixes: 6ba34171bcbd ("Drivers: hv: vmbus: Remove use of slow_virt_to_phys()")
>> Cc: stable@vger.kernel.org
>> Cc: Michael Kelley <mikelley@microsoft.com>
>> Reported-and-tested-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
>> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>
>Reviewed-by:  Michael Kelley <mikelley@microsoft.com>

Queued for hyperv-fixes, thanks!

--
Thanks,
Sasha
