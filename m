Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4221110ED21
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfLBQ1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:27:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:37602 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbfLBQ1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 11:27:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 08:27:15 -0800
X-IronPort-AV: E=Sophos;i="5.69,268,1571727600"; 
   d="scan'208";a="208138887"
Received: from unknown (HELO [10.232.112.32]) ([10.232.112.32])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2019 08:27:14 -0800
Subject: Re: [PATCH] nvme: Namepace identification descriptor list is optional
To:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc:     stable@vger.kernel.org, Ingo Brunberg <ingo_brunberg@web.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org
References: <20191202155611.21549-1-kbusch@kernel.org>
 <20191202161545.GA7434@lst.de>
 <20191202162256.GA21631@redsun51.ssa.fujisawa.hgst.com>
From:   "Nadolski, Edmund" <edmund.nadolski@intel.com>
Message-ID: <10e6520d-bc8c-94ff-00c4-32a727131b89@intel.com>
Date:   Mon, 2 Dec 2019 09:27:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191202162256.GA21631@redsun51.ssa.fujisawa.hgst.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/2/2019 9:22 AM, Keith Busch wrote:
> On Mon, Dec 02, 2019 at 05:15:45PM +0100, Christoph Hellwig wrote:
>> On Tue, Dec 03, 2019 at 12:56:11AM +0900, Keith Busch wrote:
>> > Despite NVM Express specification 1.3 requires a controller claiming to
>> > be 1.3 or higher implement Identify CNS 03h (Namespace Identification
>> > Descriptor list), the driver doesn't really need this identification in
>> > order to use a namespace. The code had already documented in comments
>> > that we're not to consider an error to this command.
>> > 
>> > Return success if the controller provided any response to an
>> > namespace identification descriptors command.
>> > 
>> > Fixes: 538af88ea7d9de24 ("nvme: make nvme_report_ns_ids propagate error back")
>> > Reported-by: Ingo Brunberg <ingo_brunberg@web.de>
>> 
>> Why would we ignore the error?  Do you have a buggy controller messing
>> this up?
> 
> I don't have such a controller, but many apparently do. The regression
> was reported here:
> 
> http://lists.infradead.org/pipermail/linux-nvme/2019-December/028223.html
> 
> And of course it's the SMI controller ...

Does 5.4 show the exact error code?  Perhaps we should selectively allow just 
for that case?

Ed

