Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CB8341BFF
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhCSMLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhCSMKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:10:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E2DA64F04;
        Fri, 19 Mar 2021 12:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616155834;
        bh=loxjt5Kt1K2yJiDF3zmLfNFmkIuApn0Q5LY4uyTMqxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L0BGQkpPD4e9cML7GxYxIFTJyZRJQbLG/0doBUkvuRoEKsxONb3zRKIJaOzzI04S/
         8VBsIa7tkfaiiOiSSxqenurFTUe7dtw99KnWmVGN9kgPvt4eIw2+MD0ZNfKWoco+3o
         ykLRVXtASVvkV9OSxZl9dHrrh3C1IF2LZR/JdRRxcpqhf+tSY5g6WlqXaORnYNA1mM
         rryBlAb7SoAmo0r47MzNvZzLLFaz3BL2lVKsL7sSi38VQu/Y+SfTUFOqIlQt1s453x
         jF7F1PZmIUNJccjkCa5BvKj6y+FJZHr8E978svSMIPHfXanMJykdn+8y7W479Nbml3
         cc7nctj3AU5zA==
Date:   Fri, 19 Mar 2021 08:10:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Thomas Backlund <tmb@tmb.nu>, Ard Biesheuvel <ardb@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: stable request
Message-ID: <YFSUuRCbjmpdSOhW@sashalap>
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu>
 <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
 <1e6eb02b-e699-d1ff-9cfb-4ef77255e244@tmb.nu>
 <9493dced-908e-a9bd-009a-6b20a8422ec1@tmb.nu>
 <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com>
 <YFNPiHAvEwDpGLrv@sashalap>
 <a39ebdf9-c7c3-990f-3d9d-81f138e55d94@tmb.nu>
 <YFSB3iLXC/DDtN1U@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YFSB3iLXC/DDtN1U@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 11:50:06AM +0100, Greg KH wrote:
>On Fri, Mar 19, 2021 at 07:35:44AM +0000, Thomas Backlund wrote:
>> Den 18-03-2021 kl. 15:03, skrev Sasha Levin:
>> >
>> > On Tue, Mar 16, 2021 at 01:35:40PM +0100, Ard Biesheuvel wrote:
>> >> On Tue, 16 Mar 2021 at 13:28, Thomas Backlund <tmb@tmb.nu> wrote:
>> >>>
>> >>>
>> >>> Den 16.3.2021 kl. 14:15, skrev Thomas Backlund:
>> >>>>
>> >>>> Den 16.3.2021 kl. 12:17, skrev Ard Biesheuvel:
>> >>>>> On Tue, 16 Mar 2021 at 10:21, Thomas Backlund <tmb@tmb.nu> wrote:
>> >>>>>> Den 16.3.2021 kl. 08:37, skrev Ard Biesheuvel:
>> >>>>>>> Please consider backporting commit
>> >>>>>>>
>> >>>>>>> 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
>> >>>>>>> crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
>>
>>
>> >
>> > Queued up for 5.10 and 5.11.
>> >
>>
>> I dont see:
>> 86ad60a65f29 ("crypto: x86/aes-ni-xts - use direct calls to and 4-way
>> stride")
>>
>> in 5.11 queue.
>
>Now added by me, Sasha might have forgotten to push his queue...

Thanks Greg, yes - it was sitting locally waiting for my build tests to
finish.

-- 
Thanks,
Sasha
