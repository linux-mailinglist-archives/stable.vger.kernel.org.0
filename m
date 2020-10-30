Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69F2A07A1
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 15:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgJ3ORL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 10:17:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:58808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgJ3ORK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 10:17:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604067429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0zFJF0/0HMmsvSiiwiuhvOsceEPbeNpMnhtN4OzfsJA=;
        b=f2fsyHf5keNwU8fo/1Vn9hlruucKmy5i1B8Pd3nxv82Lm2WsCCBmuJZwJhtTlU3B2Nbd1V
        vgIXknZZgi0cwwqeJ0R46ac6AV4LLJAoOYxGQkq2LAyxz3FcdSADtEMxL8KwwlJCrW1/2v
        r6GvjQqyRsOQfRb0TQy6axAuQPwskyU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D3520ACC6;
        Fri, 30 Oct 2020 14:17:09 +0000 (UTC)
Subject: Re: Stable backport request for "xen/events: don't use chip_data for
 legacy IRQs"
To:     Ross Lagerwall <ross.lagerwall@citrix.com>, stable@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>
References: <0e4837c4-b750-4889-bb8c-8a36c73c7110@citrix.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <1a63ad59-c0d3-893b-8098-97146920214b@suse.com>
Date:   Fri, 30 Oct 2020 15:17:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <0e4837c4-b750-4889-bb8c-8a36c73c7110@citrix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.10.20 14:29, Ross Lagerwall wrote:
> Hi,
> 
> Please backport [1] to 4.4, 4.9, 4.14, 4.19.
> 
> It fixes a commit that has been backported to all the current stable releases but for some reason the fixup was only backported to 5.4 & 5.8.

Greg has told me he queued my backport already.


Juergen

> 
> Debian 9 no longer boots as a Xen HVM guest because it is missing the fixup patch.
> 
> Thanks,
> Ross
> 
> [1]:
> 
> commit 0891fb39ba67bd7ae023ea0d367297ffff010781
> Author: Juergen Gross <jgross@suse.com>
> Date:   Wed Sep 30 11:16:14 2020 +0200
> 
>      xen/events: don't use chip_data for legacy IRQs
> 
>      Since commit c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
>      Xen is using the chip_data pointer for storing IRQ specific data. When
>      running as a HVM domain this can result in problems for legacy IRQs, as
>      those might use chip_data for their own purposes.
> 
>      Use a local array for this purpose in case of legacy IRQs, avoiding the
>      double use.
> 
>      Cc: stable@vger.kernel.org
>      Fixes: c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
>      Signed-off-by: Juergen Gross <jgross@suse.com>
>      Tested-by: Stefan Bader <stefan.bader@canonical.com>
>      Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>      Link: https://lore.kernel.org/r/20200930091614.13660-1-jgross@suse.com
>      Signed-off-by: Juergen Gross <jgross@suse.com>
> 

