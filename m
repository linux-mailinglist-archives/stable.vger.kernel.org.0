Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14307441563
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 09:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhKAIiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 04:38:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:49452 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhKAIiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 04:38:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="211025886"
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="211025886"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 01:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="637717981"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 01 Nov 2021 01:36:20 -0700
Subject: Re: [RFT PATCH] xhci: Fix commad ring abort, write all 64 bits to
 CRCR register.
To:     youling 257 <youling257@gmail.com>
Cc:     quic_pkondeti@quicinc.com, pkondeti@codeaurora.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <e96e2a96-00c4-6e6b-fc5a-e4a881325dc0@linux.intel.com>
 <20211029125154.438152-1-mathias.nyman@linux.intel.com>
 <CAOzgRdb4TRUxbKUcfLD6qPVw866BCHar2O0TiiEta7AFzW6T1Q@mail.gmail.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <1ec7e516-9db8-0508-fcf3-1aabc4b88b94@linux.intel.com>
Date:   Mon, 1 Nov 2021 10:37:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAOzgRdb4TRUxbKUcfLD6qPVw866BCHar2O0TiiEta7AFzW6T1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29.10.2021 18.35, youling 257 wrote:
> test it can work for me.
> 

Thanks for testing

-Mathias
