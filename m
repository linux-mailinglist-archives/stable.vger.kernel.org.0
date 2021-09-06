Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DD1401894
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 11:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbhIFJFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 05:05:17 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3748 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhIFJFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 05:05:16 -0400
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H32Ts39Tmz67bZY;
        Mon,  6 Sep 2021 17:02:25 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 6 Sep 2021 11:04:10 +0200
Received: from localhost (10.52.120.86) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 6 Sep 2021
 10:04:09 +0100
Date:   Mon, 6 Sep 2021 10:04:10 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     <linux-cxl@vger.kernel.org>, <stable@vger.kernel.org>,
        "Li Qiang (Johnny Li)" <johnny.li@montage-tech.com>,
        <alison.schofield@intel.com>, <ben.widawsky@intel.com>
Subject: Re: [PATCH 3/6] cxl/pci: Fix debug message in cxl_probe_regs()
Message-ID: <20210906100410.00003d5b@Huawei.com>
In-Reply-To: <163072205089.2250120.8103605864156687395.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
        <163072205089.2250120.8103605864156687395.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.120.86]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 Sep 2021 19:20:50 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Li Qiang (Johnny Li) <johnny.li@montage-tech.com>
> 
> Indicator string for mbox and memdev register set to status
> incorrectly in error message.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 30af97296f48 ("cxl/pci: Map registers based on capabilities")
> Signed-off-by: Li Qiang (Johnny Li) <johnny.li@montage-tech.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
fwiw obviously correct.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/pci.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 37903259ee79..8e45aa07d662 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -1041,8 +1041,8 @@ static int cxl_probe_regs(struct cxl_mem *cxlm, void __iomem *base,
>  		    !dev_map->memdev.valid) {
>  			dev_err(dev, "registers not found: %s%s%s\n",
>  				!dev_map->status.valid ? "status " : "",
> -				!dev_map->mbox.valid ? "status " : "",
> -				!dev_map->memdev.valid ? "status " : "");
> +				!dev_map->mbox.valid ? "mbox " : "",
> +				!dev_map->memdev.valid ? "memdev " : "");
>  			return -ENXIO;
>  		}
>  
> 

