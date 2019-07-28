Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 708CE78030
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 17:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfG1P3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 11:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfG1P3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 11:29:17 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E7632077C;
        Sun, 28 Jul 2019 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564327756;
        bh=it/c594nq63bawVbXYDdCfpOHcrl2SNnrKBSMfDSlVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QNV3qT/MLrxNCORulzbIpehxK8OS68l4tUkZAdAW0RsniquleeP51fbR6mEAjNSF2
         RdHU1udaoGJxmg/RCHVBGoJkVKH78yygJVpsyZEH7XyK4RJuwipIpGJAAhaDm1xF1n
         E/s7aOmSYo7OHvYhKKHv23kZ5OXnJzgH9SsEwReU=
Date:   Sun, 28 Jul 2019 11:29:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jan =?iso-8859-1?Q?H=F6ppner?= <hoeppner@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Haberland <sth@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH AUTOSEL 5.2 149/171] s390/dasd: Make layout analysis ESE
 compatible
Message-ID: <20190728152915.GF8637@sasha-vm>
References: <20190719035643.14300-1-sashal@kernel.org>
 <20190719035643.14300-149-sashal@kernel.org>
 <a8ad62c7-383a-a890-ca20-4348d8ab9dec@de.ibm.com>
 <018f17c4-07c9-7fcf-1f22-0a712b452b25@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <018f17c4-07c9-7fcf-1f22-0a712b452b25@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 10:47:42AM +0200, Jan Höppner wrote:
>On 19.07.19 09:47, Christian Borntraeger wrote:
>> The comment is true for all stable versions.
>>
>> This patch is part of a larger series that enables ESE volumes.
>> I think it should not go alone as other patches like
>> 5e2b17e712cf s390/dasd: Add dynamic formatting support for ESE volumes
>> are needed to actually work with ESE volumes.
>> So I suggest to drop this patch.
>> Jan, Stefan, do you agree?
>>
>
>This patch is a requirement for ESE volumes to work and doesn't
>add any value alone. I suggest to drop this patch as well.

I've dropped it from everywhere, thank you!

--
Thanks,
Sasha
