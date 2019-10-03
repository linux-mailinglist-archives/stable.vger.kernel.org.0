Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 081C1C9F5D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 15:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfJCNZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 09:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbfJCNZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 09:25:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 478952053B;
        Thu,  3 Oct 2019 13:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570109118;
        bh=reHgXz3ZOlw/PcAaqspTdBhkDQ+gy3fnG0o9/cR2XVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cmk1QeDl4UzDglByulktFncheF0UYhsrm+vSJESYoNofG+YBG36nuy7IAZpHvaJi0
         P4YudfBOaDFJL8ZUm0ZsFsZTkD/IIrPMPaaoKVRbX0o8zEjg78ZfTjvxhTqJTcnvH4
         4meAVEdPkJVKJYxMwSCebX2V1Kq1AIN8+azYeR4k=
Date:   Thu, 3 Oct 2019 09:25:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     gregkh@linuxfoundation.org, stefanb@linux.ibm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tpm_tis_core: Set TPM_CHIP_FLAG_IRQ
 before probing for" failed to apply to 4.9-stable tree
Message-ID: <20191003132517.GX17454@sasha-vm>
References: <1570088789234154@kroah.com>
 <20191003123246.GC10614@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191003123246.GC10614@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 03:32:46PM +0300, Jarkko Sakkinen wrote:
>On Thu, Oct 03, 2019 at 09:46:29AM +0200, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.9-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>
>Inspecting next week.

It looks to me like it's not relevant for 4.19 and older because it
needs 5b359c7c43727 ("tpm_tis_core: Turn on the TPM before probing
IRQ's"), which isn't present in 4.19.

-- 
Thanks,
Sasha
