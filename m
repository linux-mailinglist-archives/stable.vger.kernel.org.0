Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FD43F94A6
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 08:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244235AbhH0G5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 02:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243036AbhH0G52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 02:57:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B946D60EE9;
        Fri, 27 Aug 2021 06:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630047400;
        bh=ny6f4lzmpCGyhd2J7fXTQxRESmvT2VU0QnnckaPrpJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fVQy2z86G0kW+PGWN2dTYEURNhA4ZL/k3fZGCbh11js3hIWIpfcn1aMNYLuhKNyCk
         +bFOhRzhHaW2OPM498UQDN4zRH6dXZjhuLtk+aOrLxYTQK7QloMJXg2qAhlL8P4R6k
         pVdJ2pCzCDuMSsLvdyygwb1j2TPOMNUmjC6YIrMU=
Date:   Fri, 27 Aug 2021 08:56:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kate Hsuan <hpa@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Hans de Goede <hdegoede@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/1] libata: libata: add ATA_HORKAGE_NO_NCQ_TRIM for
 Samsung 860 and 870 SSDs
Message-ID: <YSiMoQWPXbv44biI@kroah.com>
References: <20210827053344.15087-1-hpa@redhat.com>
 <20210827053344.15087-2-hpa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827053344.15087-2-hpa@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 27, 2021 at 01:33:44AM -0400, Kate Hsuan wrote:
> A flag ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL is added to disable NCQ
> on AMD/MAREL/ASMEDIA chipsets.
> 
> Samsung 860/870 SSD are disabled to use NCQ trim functions but it will
> lead to performace drop. From the bugzilla, we could realize the issues
> only appears on those chipset mentioned above. So this flag could be
> used to only disable NCQ on specific chipsets.
> 
> Fixes: ca6bfcb2f6d9 ("libata: Enable queued TRIM for Samsung SSD 860")
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=203475
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Kate Hsuan <hpa@redhat.com>
> ---
>  drivers/ata/libata-core.c | 37 ++++++++++++++++++++++++++++++++-----
>  include/linux/libata.h    |  3 +++
>  2 files changed, 35 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
