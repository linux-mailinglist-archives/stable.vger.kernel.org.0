Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93C044155F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 09:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhKAIht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 04:37:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:33317 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhKAIht (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 04:37:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="231235452"
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="231235452"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 01:35:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="637717756"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 01 Nov 2021 01:35:14 -0700
To:     Pavan Kondeti <quic_pkondeti@quicinc.com>
Cc:     youling257@gmail.com, pkondeti@codeaurora.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <e96e2a96-00c4-6e6b-fc5a-e4a881325dc0@linux.intel.com>
 <20211029125154.438152-1-mathias.nyman@linux.intel.com>
 <20211101033154.GA28038@hu-pkondeti-hyd.qualcomm.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [RFT PATCH] xhci: Fix commad ring abort, write all 64 bits to
 CRCR register.
Message-ID: <a613da78-a69b-33d8-9cd2-73f6955d43b4@linux.intel.com>
Date:   Mon, 1 Nov 2021 10:36:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211101033154.GA28038@hu-pkondeti-hyd.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1.11.2021 5.31, Pavan Kondeti wrote:

> Thanks for the patch. I don't see any issues with this patch.
> 
> Feel free to add
> 
> Tested-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
> 

Thanks, will do

-Mathias

