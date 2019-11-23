Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2322310800D
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 19:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKWSmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 13:42:51 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36234 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfKWSmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Nov 2019 13:42:51 -0500
Received: by mail-qv1-f66.google.com with SMTP id cv8so4210362qvb.3
        for <stable@vger.kernel.org>; Sat, 23 Nov 2019 10:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Q2GrtX0AOck8iCmFF+I/NrhB1n1RqIJjQ50w/9BE6bQ=;
        b=P8w9rpZryVmUkozaulDX/K7UXU/3IcPe7ndJ4ev45qUPiLQEgGENgx9NreZv35CcXL
         2t1wSK5ofVzIBNSDORfmgdSnTdjl/rHVXYQ7+FuDM8JV7It3JzJl9ifL71ZoeFgSmFmn
         3tv82WqIQB7lHUCFVg5Idom/KnijA54K60J8BW+v9v3+ljrGhYtiV7cZdsOfXXmXtBjZ
         HQfNtbNOALtNqiiBXH1mltH21vP4XR+0qXzsgAn1BHlCeQ1d3j7m/v2945d9H9mhnqqg
         qSldeAcBx8KXVMvVWvcPDfObnLhdwGzhxdv3tEBFE3A6ec8OeA9+7KbOuHa6cyOGvd+1
         j1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Q2GrtX0AOck8iCmFF+I/NrhB1n1RqIJjQ50w/9BE6bQ=;
        b=Lyjzj0OLm6CpsoMd0WreDBRi+nzUF2liPP+YYHX8wCyoLsXA3eUL3FW1Lf8TGt2B/Q
         G40OpnCQcdZEWCI+HWrNRU9i28QZr21bZxpzhUx6U5hWi4dmotzv/Bgpqucl9CiL1q2o
         1B7NIiK6v0xH11eoeTPBtfF3S5+XJYmxgMk30uEdYFIowqAWeM9vEFcinkHh8GPJsXPL
         00yFOGrHAjDThswUzIx9i5oX0Ys97hhh59D/+VjBioYOSTEUYuuhmdI3Zy/TNYwJEObq
         LgIyJorrelnsB6mmPBVLaSxkEI4wNwjkJ1hP6/YH+RcKBf7laN+3ruq4j0OOCE04F3nY
         4Xew==
X-Gm-Message-State: APjAAAWoc7UMzohHrUrQ8K2QrKY8DxOP4Fzl+Lmpir4irQg07AYPTLv/
        URzJ3TG3KkEFUBWNYN9TmaYKrk0R9hk=
X-Google-Smtp-Source: APXvYqzBnbDcb+1beDWZVa8VPUmNtLd6pPrW3DOKGSXYcl2R0a5SdD9Euzyfnrm2kP7dYMpr+IKNDA==
X-Received: by 2002:a0c:c68d:: with SMTP id d13mr9980793qvj.141.1574534569946;
        Sat, 23 Nov 2019 10:42:49 -0800 (PST)
Received: from [192.168.1.101] ([104.246.133.66])
        by smtp.gmail.com with ESMTPSA id k65sm995301qtd.14.2019.11.23.10.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 10:42:49 -0800 (PST)
Subject: Re: Bug Report - Kernel Branch 4.4.y - asus-wmi.c
To:     Willy Tarreau <w@1wt.eu>
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
References: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
 <20191123061446.GA14713@1wt.eu> <20191123062047.GB14713@1wt.eu>
From:   Bob Funk <bobfunk11@gmail.com>
Message-ID: <bf044d4f-2bd3-c7fd-9d29-1fb51b14b8f8@gmail.com>
Date:   Sat, 23 Nov 2019 12:41:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191123062047.GB14713@1wt.eu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I compiled kernel with the patch you attached and it does indeed correct
the problem as well. Perhaps backporting this patch to the 4.4 kernel
would be a better alternative than reverting as I had originally suggested.

Regards,
Bob Funk


On 11/23/19 12:20 AM, Willy Tarreau wrote:
> On Sat, Nov 23, 2019 at 07:14:46AM +0100, Willy Tarreau wrote:
>> I suspect that this is caused by missing commit 401fee81, which fixes
>> 78f3ac76d9e5, was backported to 4.19 but not to 4.4. However you will
>> have to backport it by hand as it doesn't apply due to context
>> differences, but it trivial to do.
> Please try the attached patch. I haven't even tried to compile it but
> I think it's OK.
>
> Willy
>
