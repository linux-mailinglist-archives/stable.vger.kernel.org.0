Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A1D136010
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 19:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388451AbgAISTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 13:19:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730866AbgAISTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 13:19:32 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B34F206ED;
        Thu,  9 Jan 2020 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578593971;
        bh=esBkzg5MYq/rPsyZTQhy8c+0I4QwYWJszwLKr0+BckQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y40oKJo5S+aJROlCQAeCBmSo6v+tYzRFEQ7hWu0EHzcWxUkmarx/3xnKrOiOabEN4
         eYdtB8nBB8tdU5f9XTkP5WFdXXjzAh9aRsmFtW4m0Jkj6iCPCgvPOMjh0diFsK3mzt
         fcRuz0Tj/zoS2MqDOqvlu4D8GYtfcr9QcaHxhlMw=
Date:   Thu, 9 Jan 2020 13:19:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     yeyunfeng@huawei.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ACPI: sysfs: Change ACPI_MASKABLE_GPE_MAX
 to 0x100" failed to apply to 4.14-stable tree
Message-ID: <20200109181930.GH1706@sasha-vm>
References: <1578402908237122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1578402908237122@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 02:15:08PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From a7583e72a5f22470d3e6fd3b6ba912892242339f Mon Sep 17 00:00:00 2001
>From: Yunfeng Ye <yeyunfeng@huawei.com>
>Date: Thu, 14 Nov 2019 15:16:24 +0800
>Subject: [PATCH] ACPI: sysfs: Change ACPI_MASKABLE_GPE_MAX to 0x100
>
>The commit 0f27cff8597d ("ACPI: sysfs: Make ACPI GPE mask kernel
>parameter cover all GPEs") says:
>  "Use a bitmap of size 0xFF instead of a u64 for the GPE mask so 256
>   GPEs can be masked"
>
>But the masking of GPE 0xFF it not supported and the check condition
>"gpe > ACPI_MASKABLE_GPE_MAX" is not valid because the type of gpe is
>u8.
>
>So modify the macro ACPI_MASKABLE_GPE_MAX to 0x100, and drop the "gpe >
>ACPI_MASKABLE_GPE_MAX" check. In addition, update the docs "Format" for
>acpi_mask_gpe parameter.
>
>Fixes: 0f27cff8597d ("ACPI: sysfs: Make ACPI GPE mask kernel parameter cover all GPEs")
>Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
>[ rjw: Use u16 as gpe data type in acpi_gpe_apply_masked_gpes() ]
>Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

We don't need this on 4.14 and older becuase they don't have
0f27cff8597d ("ACPI: sysfs: Make ACPI GPE mask kernel parameter cover
all GPEs").

-- 
Thanks,
Sasha
