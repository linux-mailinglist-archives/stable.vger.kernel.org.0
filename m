Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC7841D62B
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 11:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349326AbhI3JXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 05:23:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:18073 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349293AbhI3JXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 05:23:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="224800326"
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="224800326"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 02:21:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="487253919"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 30 Sep 2021 02:21:27 -0700
Subject: Re: [PATCH] USB: xhci: dbc: fix tty registration race
To:     Johan Hovold <johan@kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
References: <20210928120400.20704-1-johan@kernel.org>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <87c08115-06e0-6734-887a-7ae4e97fe5ab@linux.intel.com>
Date:   Thu, 30 Sep 2021 12:24:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210928120400.20704-1-johan@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.9.2021 15.04, Johan Hovold wrote:
> Make sure to allocate resources before registering the tty device to
> avoid having a racing open() and write() fail to enable rx or
> dereference a NULL pointer when accessing the uninitialised fifo.
> 
> Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
> Cc: stable@vger.kernel.org      # 4.16
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Thanks, adding to queue

-Mathias

