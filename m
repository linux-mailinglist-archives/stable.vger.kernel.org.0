Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD09F915
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 06:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbfH1EHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 00:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfH1EHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 00:07:33 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3281D20830;
        Wed, 28 Aug 2019 04:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566965252;
        bh=wwG7oC/YhTlZOcdfeQvEtC1x3zTYqmJZ2wkjng7qlgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EYNjOTrx7uxmne5DpuYArqyLspQRv9kSfzvQeqI26NinjGnyb71g/5XUTgW4yZgj7
         M/xGCKhUZYePWZQDNOn6ZB//tXaOeBioHOApyDnUg2/FqFt/nDs+s7AmYohQiJO+S4
         40OrX+0XJAvVntZp3pCmnLR7jcBMSAyUcxedYhSs=
Date:   Wed, 28 Aug 2019 00:07:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        martin.petersen@oracle.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: ufs: Fix NULL pointer dereference
 in" failed to apply to 4.4-stable tree
Message-ID: <20190828040731.GZ5281@sasha-vm>
References: <156680972724494@kroah.com>
 <450beed5-281b-be41-029e-fb98d2ba36ba@intel.com>
 <20190826132828.GA12281@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190826132828.GA12281@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 03:28:28PM +0200, Greg KH wrote:
>On Mon, Aug 26, 2019 at 02:49:49PM +0300, Adrian Hunter wrote:
>> Seems to works for me:
>>
>> $ git log | head -5
>> commit 5e9f4d704f8698b6d655afa7e9fac3509da253bc
>> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Date:   Sun Aug 25 10:53:06 2019 +0200
>>
>>     Linux 4.4.190
>>
>> $ git cherry-pick 7c7cfdcf7f1777c7376fc9a239980de04b6b5ea1
>> warning: inexact rename detection was skipped due to too many files.
>> warning: you may want to set your merge.renamelimit variable to at least 22729 and retry the command.
>> [linux-4.4.y 9558a3c05149] scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()
>>  Date: Wed Aug 14 15:59:50 2019 +0300
>>  1 file changed, 3 insertions(+)
>>
>> $ git log | head -5
>> commit 9558a3c05149ded7136c24325dd3952276fcdaaa
>> Author: Adrian Hunter <adrian.hunter@intel.com>
>> Date:   Wed Aug 14 15:59:50 2019 +0300
>>
>>     scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()
>>
>
>I do not use cherry-pick, I use quilt.  Can you please provide the
>resulting patch that you created here, after you verify that it really
>is correct (see the git warning...)

Looks like the patched function moved around more than quilt liked. I've
confirmed that what git does is correct and queued it for 4.4. It is not
needed for 4.9, 4.14 and 4.19.

--
Thanks,
Sasha
