Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6C296B67
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 23:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbfHTVZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 17:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHTVZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 17:25:41 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBAF5206DD;
        Tue, 20 Aug 2019 21:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566336340;
        bh=gusMECkDMjWw3c1ux6jK6VP03aT8O7UmZ1AqrmC4KTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OZepsdjiVSXBZvLQdpaMi/ISX450KYs1gNAYLVarbulSAydq+rKSm5Xjjpd3KJO0n
         NY7oSizLhAEnGT6n3X9n79Svl9V7yvrRiUJLJiQjm0KmfOdHP3EusWi6IkmYFASbvx
         WeS7FPZ+dvjMoSi/78rqDWUBCCwuWdxjZwhV5EzY=
Date:   Tue, 20 Aug 2019 17:25:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2
 to prevent Clang from emitting libcalls to undefined SW FP routines") to
 4.19.y
Message-ID: <20190820212539.GA1581@sasha-vm>
References: <CAKwvOdm0sWCF=PiNJvKWxt7CaTXSF13cZNuYPhKC=Kq8ooi1HA@mail.gmail.com>
 <20190820210716.GA31292@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190820210716.GA31292@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 02:07:16PM -0700, Greg KH wrote:
>On Tue, Aug 20, 2019 at 02:00:21PM -0700, Nick Desaulniers wrote:
>> Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2 to
>> prevent Clang from emitting libcalls to undefined SW FP routines") to
>> 4.19.y.
>>
>> It will help with AMD based chromebooks for ChromeOS.
>
>That commit id is not in Linus's tree, are you sure you got it correct?

That's a linux-next commit.

--
Thanks,
Sasha
