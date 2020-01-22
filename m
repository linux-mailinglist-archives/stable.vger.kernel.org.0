Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C5D144B67
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 06:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgAVFpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 00:45:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:40212 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgAVFpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 00:45:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 21:45:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,348,1574150400"; 
   d="scan'208";a="215793095"
Received: from allen-box.sh.intel.com (HELO [10.239.159.138]) ([10.239.159.138])
  by orsmga007.jf.intel.com with ESMTP; 21 Jan 2020 21:45:11 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: call __dmar_remove_one_dev_info with valid
 pointer
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        iommu@lists.linux-foundation.org
References: <20200122003426.16079-1-jsnitsel@redhat.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <ac036343-18a2-de7e-6bc2-45966f429c16@linux.intel.com>
Date:   Wed, 22 Jan 2020 13:43:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200122003426.16079-1-jsnitsel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/22/20 8:34 AM, Jerry Snitselaar wrote:
> It is possible for archdata.iommu to be set to
> DEFER_DEVICE_DOMAIN_INFO or DUMMY_DEVICE_DOMAIN_INFO so check for
> those values before calling __dmar_remove_one_dev_info. Without a
> check it can result in a null pointer dereference. This has been seen
> while booting a kdump kernel on an HP dl380 gen9.
> 
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: stable@vger.kernel.org # 5.3+
> Cc: linux-kernel@vger.kernel.org
> Fixes: ae23bfb68f28 ("iommu/vt-d: Detach domain before using a private one")
> Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>

Acked-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
