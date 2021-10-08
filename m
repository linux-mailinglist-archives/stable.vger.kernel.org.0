Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663F5426A52
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240228AbhJHL7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:59:54 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3949 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhJHL7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 07:59:54 -0400
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HQmnS37cSz6H6jV;
        Fri,  8 Oct 2021 19:54:20 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 8 Oct 2021 13:57:56 +0200
Received: from [10.47.80.141] (10.47.80.141) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 8 Oct 2021
 12:57:55 +0100
Subject: Re: [PATCH v3] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
To:     Dexuan Cui <decui@microsoft.com>, <kys@microsoft.com>,
        <sthemmin@microsoft.com>, <wei.liu@kernel.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <haiyangz@microsoft.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>, <longli@microsoft.com>,
        <mikelley@microsoft.com>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20211008043546.6006-1-decui@microsoft.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8c87879b-ad28-e7bd-71ec-0c8a2ee99e7c@huawei.com>
Date:   Fri, 8 Oct 2021 13:00:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211008043546.6006-1-decui@microsoft.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.141]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/10/2021 05:35, Dexuan Cui wrote:
> After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
> boot because the hv_storvsc driver sets scsi_driver.can_queue to an "int"
> value that exceeds SHRT_MAX, and hence scsi_add_host_with_dma() sets
> shost->cmd_per_lun to a negative "short" value.
> 
> Use min_t(int, ...) to fix the issue.
> 
> Fixes: ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at can_queue")
> Cc:stable@vger.kernel.org
> Signed-off-by: Dexuan Cui<decui@microsoft.com>
> Reviewed-by: Haiyang Zhang<haiyangz@microsoft.com>
> Reviewed-by: Ming Lei<ming.lei@redhat.com>

Reviewed-by: John Garry <john.garry@huawei.com>

thanks
