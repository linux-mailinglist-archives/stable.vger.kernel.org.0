Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECDA718315
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 03:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfEIBCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 21:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfEIBCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 21:02:20 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09517214AF;
        Thu,  9 May 2019 00:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557363159;
        bh=gQIeq5M85t31GzmaN73GDCkT8GVmIEOY7wKJFnpbdmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LEXigFUI9tcY8j0SuPx5JioRaR9zUIDDMRV9oQWF523rpYWb2XWDGE5dEifU6z61C
         /JQU7UtixvPc3aaTsjum5B0AyaI8ksZ0sq3EeIo1+FTc3OkM+MhInECinE0k/S6KBI
         A9U7v9k3H0Fv+ujQU3UW3RLT6CCfpQmL/hlE7uFg=
Date:   Wed, 8 May 2019 20:52:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        stable kernel team <stable@vger.kernel.org>
Subject: Re: [PATCH] genirq: Prevent use-after-free and work list corruption]
Message-ID: <20190509005237.GP1747@sasha-vm>
References: <20190507060708.GA75860@gmail.com>
 <20190507062535.GA21061@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190507062535.GA21061@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 08:25:35AM +0200, Greg KH wrote:
>On Tue, May 07, 2019 at 08:07:08AM +0200, Ingo Molnar wrote:
>>
>> Hi Greg,
>>
>> We forgot to mark 59c39840f5abf4a71e1 for -stable, please apply. It
>> should apply cleanly all the way back to v3.0.
>
>Thanks, will do for the next round of releases after this one.

I've queued it for all branches.

--
Thanks,
Sasha
