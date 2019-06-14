Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E57345CB8
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 14:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfFNMXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 08:23:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:23216 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727362AbfFNMXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 08:23:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 05:23:51 -0700
X-ExtLoop1: 1
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.164]) ([10.237.72.164])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2019 05:23:50 -0700
Subject: Re: [PATCH] usb: xhci: dbc: get rid of global pointer
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org
References: <20190611172416.12473-1-felipe.balbi@linux.intel.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <6daea602-58e3-3811-f1f6-6a9464d8af2e@linux.intel.com>
Date:   Fri, 14 Jun 2019 15:26:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190611172416.12473-1-felipe.balbi@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11.6.2019 20.24, Felipe Balbi wrote:
> If we happen to have two XHCI controllers with DbC capability, then
> there's no hope this will ever work as the global pointer will be
> overwritten by the controller that probes last.
> 
> Avoid this problem by keeping the tty_driver struct pointer inside
> struct xhci_dbc.
> 
> Fixes: dfba2174dc42 usb: xhci: Add DbC support in xHCI driver
> Cc: <stable@vger.kernel.org> # v4.16+
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> ---

Thanks, adding to queue

-Mathias
