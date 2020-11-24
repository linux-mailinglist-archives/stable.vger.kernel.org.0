Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7372C26D6
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 14:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387608AbgKXNK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 08:10:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:57460 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387582AbgKXNKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 08:10:25 -0500
IronPort-SDR: 14e21FFz6PKapXR54lGlXsJ9Y1ZZBzKwfQJGt8y5Wggq7KM0/A3JA9NKfvJjtE5gst6dtWkm2N
 TCv9C2UkZMHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="190065321"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="190065321"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 05:10:25 -0800
IronPort-SDR: mJrVMzwaCSVvK+lHDeSxpNM70cSXr9AW1IGVs3JHPvbItXWdnnTDOwg0euZmoeNJzu+kADjFhY
 R37+4eR0PxCA==
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="536470044"
Received: from ndavidso-mobl4.ger.corp.intel.com (HELO Win10on49-0007.SSPE.ch.intel.com) ([10.255.198.190])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 05:10:23 -0800
Subject: Re: [Intel-gfx] [PATCH] dma-buf/dma-resv: Respect num_fences when
 initializing the shared fence list.
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
References: <20201124115707.406917-1-maarten.lankhorst@linux.intel.com>
From:   =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>
Message-ID: <a40b62d6-3285-abe6-17b7-47b89a53d89f@linux.intel.com>
Date:   Tue, 24 Nov 2020 14:10:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201124115707.406917-1-maarten.lankhorst@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/24/20 12:57 PM, Maarten Lankhorst wrote:
> We hardcode the maximum number of shared fences to 4, instead of
> respecting num_fences. Use a minimum of 4, but more if num_fences
> is higher.
>
> This seems to have been an oversight when first implementing the
> api.
>
> Fixes: 04a5faa8cbe5 ("reservation: update api and add some helpers")
> Cc: <stable@vger.kernel.org> # v3.17+
> Reported-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> ---
>   drivers/dma-buf/dma-resv.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>


