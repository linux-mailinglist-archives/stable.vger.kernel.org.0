Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC604B2FF
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 09:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbfFSHYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 03:24:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:52552 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfFSHYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 03:24:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 00:24:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="150528022"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.164]) ([10.237.72.164])
  by orsmga007.jf.intel.com with ESMTP; 19 Jun 2019 00:24:39 -0700
Subject: Re: [PATCH] usb: xhci: dbc: get rid of global pointer
To:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org
References: <20190611172416.12473-1-felipe.balbi@linux.intel.com>
 <20190614145236.GB3849@localhost> <877e9kiuew.fsf@linux.intel.com>
 <20190618143120.GI31871@localhost> <877e9if5iz.fsf@linux.intel.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <cbd4a9d6-fab9-2af0-54ce-b574a3491abf@linux.intel.com>
Date:   Wed, 19 Jun 2019 10:27:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <877e9if5iz.fsf@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.6.2019 9.33, Felipe Balbi wrote:
> 
> 
> @Mathias, can you drop the previous fix? I'll try to come up with a
> better version of this.

Dropped

-Mathias

