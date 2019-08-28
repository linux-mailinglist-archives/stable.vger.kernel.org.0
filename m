Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE9D9FBC8
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 09:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfH1HbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 03:31:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:23814 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbfH1HbR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 03:31:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 00:31:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="181944132"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.66]) ([10.237.72.66])
  by fmsmga007.fm.intel.com with ESMTP; 28 Aug 2019 00:31:15 -0700
Subject: Re: FAILED: patch "[PATCH] scsi: ufs: Fix NULL pointer dereference
 in" failed to apply to 4.4-stable tree
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     martin.petersen@oracle.com, stable@vger.kernel.org
References: <156680972724494@kroah.com>
 <450beed5-281b-be41-029e-fb98d2ba36ba@intel.com>
 <20190826132828.GA12281@kroah.com> <20190828040731.GZ5281@sasha-vm>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <10e26c6d-baa3-5ed4-70b1-eab053340dda@intel.com>
Date:   Wed, 28 Aug 2019 10:30:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828040731.GZ5281@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/08/19 7:07 AM, Sasha Levin wrote:
> On Mon, Aug 26, 2019 at 03:28:28PM +0200, Greg KH wrote:
>> On Mon, Aug 26, 2019 at 02:49:49PM +0300, Adrian Hunter wrote:
>>> Seems to works for me:
>>>
>>> $ git log | head -5
>>> commit 5e9f4d704f8698b6d655afa7e9fac3509da253bc
>>> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Date:   Sun Aug 25 10:53:06 2019 +0200
>>>
>>>     Linux 4.4.190
>>>
>>> $ git cherry-pick 7c7cfdcf7f1777c7376fc9a239980de04b6b5ea1
>>> warning: inexact rename detection was skipped due to too many files.
>>> warning: you may want to set your merge.renamelimit variable to at least
>>> 22729 and retry the command.
>>> [linux-4.4.y 9558a3c05149] scsi: ufs: Fix NULL pointer dereference in
>>> ufshcd_config_vreg_hpm()
>>>  Date: Wed Aug 14 15:59:50 2019 +0300
>>>  1 file changed, 3 insertions(+)
>>>
>>> $ git log | head -5
>>> commit 9558a3c05149ded7136c24325dd3952276fcdaaa
>>> Author: Adrian Hunter <adrian.hunter@intel.com>
>>> Date:   Wed Aug 14 15:59:50 2019 +0300
>>>
>>>     scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()
>>>
>>
>> I do not use cherry-pick, I use quilt.  Can you please provide the
>> resulting patch that you created here, after you verify that it really
>> is correct (see the git warning...)
> 
> Looks like the patched function moved around more than quilt liked. I've
> confirmed that what git does is correct and queued it for 4.4. It is not
> needed for 4.9, 4.14 and 4.19.

Thank you!

By the way, regular patch also works:

$ patch -p1 < 0001-scsi-ufs-Fix-NULL-pointer-dereference-in-ufshcd_conf.patch 
patching file drivers/scsi/ufs/ufshcd.c
Hunk #1 succeeded at 4418 (offset -2644 lines).

So maybe quilt should be made the same?
