Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7121247F0F
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 09:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgHRHLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 03:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgHRHLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 03:11:40 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CE6C061342
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 00:11:40 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o18so20803029eje.7
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 00:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xI+FXK1XG8VncmlCxBQc+vLBfzyBbE/riCMJXbhjscc=;
        b=0mLXw7zPqAUFMddatDQVx/ceFmaDbOzFyZ+K2M9FYlOD7XnObv7VNNzzd4DQDF5YXV
         YJ/+5eQgKWop/kK1i0Kdr++X7fSXHpiD+92pHtNP45vchNE+ogHvbk2mJHh+1ZNLH74o
         InN5tz1CI6fm1kt8B4SCoiKhDEvLNv/LZGEKbNfGNKBz9A+eeBMZb7H7UeKShqTONlaz
         yVWC/PS9+9+eTltlxdyn03yQ8jVtXQ7M/a8LSlt4xZ5rLRaD42xLV6E1LI8y+aA/WtSz
         BWQVf8zF0QGaTEdah1HcmwqmwVwvTKXYx9c1Iz5tWVPezappFSz1lM/jpeH7DkPgDrxP
         CHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xI+FXK1XG8VncmlCxBQc+vLBfzyBbE/riCMJXbhjscc=;
        b=EklBg+3IAchq6rtpIBgPOsIAjanvQ4yHRVYhHWSsd/Wq0UQMHauuWEhLjvFAOxbRTI
         px6K2zfOuGdXwJeRQWScyM+e8mZ06WZFZ0YTBl/LHNaZ53j44LSllVUafxZTqrJRqjTJ
         5FGqJX0dERlG2kQv99ydn0ttvPZng89G2cQlFSardnnAxfYsdUDDgn1fHLYhavJ5OZ3o
         jS047mRaXUp3pqaNrEuSgwSQvwRINmXNrkr+ZqKBTQR4sZRRtnWt4S/ibZmXvP4cEyn3
         m83xL6GCuUdVUyqgJPJWECx4z+NsMUqSQ2rYOrE051Xq2UNZFTOhie0HyRtAcLkKCqj6
         HClQ==
X-Gm-Message-State: AOAM530v7T+8Ub9WFhqx+1rs3LZ5b3telAe6DVOu7+4VQ1/LQYjVgpJA
        OLRoq1K8GLQ/h3PgTPrXIl1fvq+E6M9OajYH
X-Google-Smtp-Source: ABdhPJxvLoUn038pCtxBKg84rUR4AufDWyHYqnJgMchLj54uU5wNlhlTDrZmKsvQq4qyg1EqEJOgfA==
X-Received: by 2002:a17:906:b110:: with SMTP id u16mr18271447ejy.483.1597734698502;
        Tue, 18 Aug 2020 00:11:38 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([109.130.153.1])
        by smtp.gmail.com with ESMTPSA id d25sm15190109edr.78.2020.08.18.00.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 00:11:37 -0700 (PDT)
Subject: Re: Patch "net: refactor bind_bucket fastreuse into helper" has been
 added to the 4.14-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, tim.froidcoeur@tessares.net,
        stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
References: <159765838685222@kroah.com>
 <9f27fa03-b205-9195-758c-c9c67b384a21@tessares.net>
 <20200818070831.GB3333@kroah.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <bf040796-d96b-d9a3-589f-317eed1e299b@tessares.net>
Date:   Tue, 18 Aug 2020 09:11:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818070831.GB3333@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/08/2020 09:08, Greg KH wrote:
> On Mon, Aug 17, 2020 at 09:28:48PM +0200, Matthieu Baerts wrote:
>> Hi Greg,
>>
>> On 17/08/2020 11:59, gregkh@linuxfoundation.org wrote:
>>>
>>> This is a note to let you know that I've just added the patch titled
>>>
>>>       net: refactor bind_bucket fastreuse into helper
>>>
>>> to the 4.14-stable tree which can be found at:
>>>       http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>>
>>> The filename of the patch is:
>>>        net-refactor-bind_bucket-fastreuse-into-helper.patch
>>> and it can be found in the queue-4.14 subdirectory.
>>>
>>> If you, or anyone else, feels it should not be added to the stable tree,
>>> please let <stable@vger.kernel.org> know about it.
>>
>> (...)
>>
>>> Patches currently in stable-queue which might be from tim.froidcoeur@tessares.net are
>>>
>>> queue-4.14/net-refactor-bind_bucket-fastreuse-into-helper.patch
>>
>> Thank you for backporting this patch!
>>
>> It seems the backport of the companion patch -- d76f3351cea2 ("net:
>> initialize fastreuse on inet_inherit_port") -- was lost somewhere for 4.14
>> version. It was backported in all other newer stable versions: 5.8, 5.7,
>> 5.4, 4.19 but not in 4.14.
>> The patch backported here is a preparation for the real fix which is the
>> missing patch.
>>
>> I guess the intention is to backport d76f3351cea2 to v4.14 as well. If not,
>> this refactoring is maybe not needed :)
> 
> Ugh, that was my fault, thanks for catching this.  I've now queued this
> up to 4.14.y.

Thank you for having added it!

All these backported patches look good to me!

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
