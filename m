Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229CC4F978
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 04:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFWCAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 22:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfFWCAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 22:00:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7432620820;
        Sun, 23 Jun 2019 02:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561255247;
        bh=7IogDO7ShfSg5Sa1fLvusYWasM6MnE6o+2GI08bxft0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NjXtPFxVj0aCCTOrVKuyWYkd1AxoVoZIPVdDRWNE/PIUi7K4kHIud1GReFWwL46UR
         bpLaekB06XeVFcZTWjmCsLfbzakKV7jCR707qSW6k0NyFFme3wnaqwKF5Q+AlClOIr
         zU8VdDpZGBZEB7xzis8U5nZxwrF8HVLIzZuWeXDw=
Date:   Sat, 22 Jun 2019 22:00:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Laura Abbott <labbott@redhat.com>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        stable <stable@vger.kernel.org>,
        Major Hayden <mhayden@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] s390/jump_label: Use "jdd" constraint on gcc9
Message-ID: <20190623020046.GK2226@sasha-vm>
References: <99840513-9a7d-2c91-1e41-5355f88babcf@redhat.com>
 <20190621153912.9528-1-iii@linux.ibm.com>
 <9210d2cc-8cca-208a-a1b4-5ccb49f4e3f8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9210d2cc-8cca-208a-a1b4-5ccb49f4e3f8@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 01:46:46PM -0400, Laura Abbott wrote:
>On 6/21/19 11:39 AM, Ilya Leoshkevich wrote:
>>>Ah okay, I didn't realize there was more needed, I was just looking at
>>>the clean cherry-pick. I'm not sure how to do the backport, if you
>>>give me the patch I can verify.
>>
>>Please find the cherry-picked 146448524bdd below.
>>
>>I also had to cherry-pick 159491f3b509 to fix an unrelated compilation
>>error and make the build fully work.
>>
>
>Yes, this worked for me (plus 159491f3b509). Thanks!

I've queued the backport of 146448524bdd and 159491f3b509 to 4.19, thank
you.

--
Thanks,
Sasha
