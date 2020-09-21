Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B7F272585
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 15:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgIUN2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 09:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgIUN2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 09:28:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A13002076E;
        Mon, 21 Sep 2020 13:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600694932;
        bh=1r7DcWIjp4lzc2I8YL279xRfgn4iIxtnCILn9XLY+HA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WandeW1aS97mB3J9AsdRGpYi4g7VGjqV4ORViImxsMhQpNk+Et7L/8aSNrCqkMN3q
         PvwqOnRSsKyT5lrtN5bOOSXZyuF2NqiOrIYlKyuC2ELARcClJjNagcnEFycmtnJf0D
         QRSvuOxWzWy7dTnvDGjL3+7Cjywz0mvyNBfVl2V0=
Date:   Mon, 21 Sep 2020 09:28:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     =?utf-8?B?bGloYWl3ZWko5p2O5rW35LyfKQ==?= <lihaiwei@tencent.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "KVM: Check the allocation of pv cpu mask" has been added
 to the 5.8-stable tree(Internet mail)
Message-ID: <20200921132850.GM2431@sasha-vm>
References: <20200921104234.9C539216C4@mail.kernel.org>
 <EE2DABCA-2B97-4D46-8AFB-7F94DED675F8@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EE2DABCA-2B97-4D46-8AFB-7F94DED675F8@tencent.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 10:54:38AM +0000, lihaiwei(李海伟) wrote:
>
>> On Sep 21, 2020, at 18:42, Sasha Levin <sashal@kernel.org> wrote:
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>    KVM: Check the allocation of pv cpu mask
>>
>> to the 5.8-stable tree which can be found at:
>>    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>     kvm-check-the-allocation-of-pv-cpu-mask.patch
>> and it can be found in the queue-5.8 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>>
>
>This patch is not a correct version, so please don’t add this to the stable tree, thanks.

What's wrong with it? That's what landed upstream.

-- 
Thanks,
Sasha
