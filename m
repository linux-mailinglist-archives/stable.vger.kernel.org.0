Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E479F10ED67
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfLBQpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:45:35 -0500
Received: from mga06.intel.com ([134.134.136.31]:49215 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727418AbfLBQpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 11:45:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 08:45:32 -0800
X-IronPort-AV: E=Sophos;i="5.69,268,1571727600"; 
   d="scan'208";a="208145143"
Received: from unknown (HELO [10.232.112.32]) ([10.232.112.32])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2019 08:45:31 -0800
Subject: Re: [PATCH] nvme: Namepace identification descriptor list is optional
To:     Christoph Hellwig <hch@lst.de>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
        Ingo Brunberg <ingo_brunberg@web.de>, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
References: <20191202155611.21549-1-kbusch@kernel.org>
 <20191202161545.GA7434@lst.de>
 <20191202162256.GA21631@redsun51.ssa.fujisawa.hgst.com>
 <10e6520d-bc8c-94ff-00c4-32a727131b89@intel.com>
 <20191202162905.GA7683@lst.de>
From:   "Nadolski, Edmund" <edmund.nadolski@intel.com>
Message-ID: <6ff6ed7f-44f9-5d03-b4d5-2d38e7d16530@intel.com>
Date:   Mon, 2 Dec 2019 09:45:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191202162905.GA7683@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/2/2019 9:29 AM, Christoph Hellwig wrote:
> On Mon, Dec 02, 2019 at 09:27:14AM -0700, Nadolski, Edmund wrote:
>>> I don't have such a controller, but many apparently do. The regression
>>> was reported here:
>>>
>>> http://lists.infradead.org/pipermail/linux-nvme/2019-December/028223.html
>>>
>>> And of course it's the SMI controller ...
>>
>> Does 5.4 show the exact error code?  Perhaps we should selectively allow 
>> just for that case?
> 
> They'll find other ways to f***ck up.  Looks like at least the controller
> in the bug report also doesn't have an subnqn and the nguid/eui64 are
> bogus.  I wonder if we actually do users a favour by allowing that..

Agreed, tho since it looks like a regression, does it make sense to treat as a 
quirk?

Ed

