Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839A712CAB0
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 20:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfL2TxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 14:53:22 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:38406 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbfL2TxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 14:53:22 -0500
Received: by mail-il1-f195.google.com with SMTP id f5so26410174ilq.5
        for <stable@vger.kernel.org>; Sun, 29 Dec 2019 11:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RnRRyY8LlvE28Pwpjys2V4wf3yapu2EZd9STVU5QyNQ=;
        b=esvDUwhMpDyHO/rX9xxL0XiaBbMENkDbirKvqbe6Bkdd7zI3VHaklX+FoQ7ntxi8Ku
         KxAhffwbmd3c1s2kZ4sgQckQgXlKwAmdzcJ3aWc2Fi9qLcZxK23C9KpixGylnWYj9qqS
         96SLgB1tP42vPFWR+EbgxRyRaoLF9J0w3hug8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RnRRyY8LlvE28Pwpjys2V4wf3yapu2EZd9STVU5QyNQ=;
        b=lNfENeQWeB+lgYofjJ7fwL+Rk1y0QkF1Yxc3Od43YrIe7ZnLz7IAumadwsJw2KWnwg
         Tepf8Hem4ZhC3ArsuyA/Hm3bJfr8kVfCmglCNpZCvo6WzrrcRzDhgt1Eped+8BIRBYxU
         cS5HJwr/itDAreTue3/+gVzRYQdy0mxFCPKmv/VfOhL1Wle7c+WmxMMAODibJb7Ftsxp
         N7AEsBa2lS1nrWW/dim2oYb+dOCO+lWew3UPBcxDYFWRkSWvibpDUhwailLIbRhrGaGF
         VGv74aO07xiHJtOvdf2L+9gpoIx78t0B/j7DBOXCowMbgnAF6TksEJ7RIeGgyrADs6FY
         6QcA==
X-Gm-Message-State: APjAAAVLblRheFXn/yVQVivfdcO7pmbSwoW3XRPJs5vaHuMXAwJdoHFg
        oTZV6e9oeMZNI1BmSj/GrEZ4Sg==
X-Google-Smtp-Source: APXvYqxb33jK17afxMnkZjsY9By7Dd8fndHtSRHl8sU+FrctvgCEzwCWSxkiHAdCnTNcSfvt17ihIg==
X-Received: by 2002:a92:d84d:: with SMTP id h13mr53355305ilq.180.1577649201554;
        Sun, 29 Dec 2019 11:53:21 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z20sm6999870ilk.42.2019.12.29.11.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Dec 2019 11:53:21 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] usbip: Fix receive error in vhci-hcd when
 using" failed to apply to 4.4-stable tree
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, gregkh@linuxfoundation.org
Cc:     suwan.kim027@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <157762916119642@kroah.com> <20191229165645.GG1292@mail-itl>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b21f27b5-3963-7625-0e7f-a2370d4a4629@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 12:53:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191229165645.GG1292@mail-itl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/29/19 9:56 AM, Marek Marczykowski-Górecki wrote:
> On Sun, Dec 29, 2019 at 03:19:21PM +0100, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.4-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> 
> I think the bug this commit fixes (part of ea44d190764b commit) is not
> present in 4.4, nor 4.9 branches.
> In short: no need to backport it to 4.4 or 4.9 branch.
> 

Correct. We don't have to backport it to 4.4 and 4.9

thanks,
-- Shuah

