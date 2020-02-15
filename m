Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D077160071
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 21:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgBOUYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Feb 2020 15:24:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgBOUX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Feb 2020 15:23:59 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FEEF207FF;
        Sat, 15 Feb 2020 20:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581798239;
        bh=+aNvcajYzDF5wcHUt5BosByL9Fp5GkGYQkD9lOG69vA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sDr8jYSCZzXS/+2KU0PQ2IyOZAsWzGZL+pqA3A2lRjPLn1yiJenngGF6HEtZdFnOu
         bLQBoFjXW+jt3BebT98QJ61xcVQT2vWZVjwnAfRegCWPB77FEPKpVvqt0XaWCnX19S
         fIGPH0ihjGzTcCelX7O6PrQJxnr7jgxQumobPLJM=
Date:   Sat, 15 Feb 2020 15:23:58 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, nico@linaro.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <Miles.Chen@mediatek.com>
Subject: Re: please cherry pick 75fea300d73a to 4.14.y
Message-ID: <20200215202358.GJ1734@sasha-vm>
References: <CAKwvOdnYPvov5ULB_BHodeLde4V1Zg+UF0X=V=i1yH77XvhXZg@mail.gmail.com>
 <20200213192322.GA3778561@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200213192322.GA3778561@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 11:23:22AM -0800, Greg KH wrote:
>On Thu, Feb 13, 2020 at 11:19:16AM -0800, Nick Desaulniers wrote:
>> Hi Greg, Sasha,
>> Would you please cherry pick
>> commit 75fea300d73a ("ARM: 8723/2: always assume the "unified" syntax
>> for assembly code")
>> which first landed in v4.16-rc1 into 4.14.y?
>>
>> In my experience, it cherry-picks cleanly.  It fixes a stream of
>> warnings we see when building 32b ARM kernels with Clang, like:
>>
>> /tmp/signal-1ac549.s: Assembler messages:
>> /tmp/signal-1ac549.s:76: conditional infixes are deprecated in unified syntax
>>
>> We'll make immediate use of it in Android; if anyone objects to
>> landing in stable let us know and we can carry it out of tree.
>
>Seems sane, I'll queue it up after this latest round of stable kernels
>are released in a few days.

I've queued this one on 4.14.

-- 
Thanks,
Sasha
