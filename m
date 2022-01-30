Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A424A34E6
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 08:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354322AbiA3HdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 02:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240201AbiA3HdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 02:33:04 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4214BC061714;
        Sat, 29 Jan 2022 23:33:04 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id i65so10053149pfc.9;
        Sat, 29 Jan 2022 23:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:cc:in-reply-to:content-transfer-encoding;
        bh=qJPBzIbO8eW+rcurNbjgWYFog1ZNNPK/BN3tB4SsNtI=;
        b=otsEfXzNPp53yBsSrW8Xb+zxrYpf3Q6yl/0qr3dlci0l/8nuEHOE12kRyLXc8wN7Bk
         /sgB4rzxoBbT8cNj2Snom11cVTG4VFK2Cbufk4zRPVtAzqrdjcOZOzuwsV8aVztDvqdZ
         MvI0AYHOyT1DGAOs41fkw5mlxirLngwHj9O0qdJMhoz8DKBvMJukb+SFQRaOxx2azdjW
         WVgYxEe1owfy2eScd/wpTTCgK/UhOrFUD2A3nzUbh+uVNW2N2Sc2R+Jif0Y1bRwg7o+9
         Uvt8FIiKh8IBEIbF250r6VsW+WFGsW0U/uduJs+LcqZ1FQb6jRZAAndv4dP+Tog0jXLC
         HRMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:cc:in-reply-to
         :content-transfer-encoding;
        bh=qJPBzIbO8eW+rcurNbjgWYFog1ZNNPK/BN3tB4SsNtI=;
        b=6OD5UsJj4XIsUWjEU4ATTWDZcFtUQp6iX2+OtQGSnTvw8xqVyv4m1UMsq3gpKNs8Ct
         3eqlxAna8rjQ4p7Xve5r6R8WW0hvY1f54+vjItfdN+ttT1bFOD/YOrYddFLEQbih9p/Q
         klY1i+MGDNLP+dgXxo0r4MnQTS7p2oit6sJ3GOwkxisusjSKSR/3hg2qHSmFOTCYxczp
         VTwsPBU5ixHCL+l35olaP1GNy6zrK0zpgDoLqDyx1o9Pd+ceNlpxtOB+3K7iRJNvE1Bm
         uECcWvwcb5Y85YfBjray/efILj4CDpVSQpGiawiNfBqFmW5ztpWLzcnmT05Ypf+ZoEOd
         8iSw==
X-Gm-Message-State: AOAM530LziM0tNtByhDJE+btRcoSTcDaW/xO9isJ4AmpLJymT0U1NFJF
        b8Qq13DXNYpjM7ZDckuBpVRmXdPxa6efiQ==
X-Google-Smtp-Source: ABdhPJz+5f14UOb67fRdcpqnpP+G2cla6iBDtgGJY8LwWa9tkCRxWe5lVke3j0fd9DPbuHt6LwA0JQ==
X-Received: by 2002:a63:4e26:: with SMTP id c38mr12398923pgb.475.1643527983675;
        Sat, 29 Jan 2022 23:33:03 -0800 (PST)
Received: from [192.168.14.123] ([59.99.141.233])
        by smtp.gmail.com with ESMTPSA id c14sm13928959pfm.169.2022.01.29.23.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jan 2022 23:33:03 -0800 (PST)
Message-ID: <5db614fe-096b-bdab-b727-a7b138922ad4@gmail.com>
Date:   Sun, 30 Jan 2022 13:02:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: Regression in 5.16.3 with mt7921e
Content-Language: en-US
To:     Linux stable <stable@vger.kernel.org>,
        Linux wireless <linux-wireless@vger.kernel.org>
References: <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
From:   Abhijeet Viswa <abhijeetviswa@gmail.com>
Cc:     Felipe Contreras <felipe.contreras@gmail.com>
In-Reply-To: <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I can confirm this regression. I have an Asus TUF laptop.

I've also tried "resetting" the chip by holding down the power button 
for 60 seconds. This usually helped in previous versions.

If it helps, this issue does not exist in Windows (I have a dualboot).

This is the dmesg log when trying to bring the interface up: 
https://dpaste.org/Wouy

Happy to help diagnosing this further.

Thanks
Abhijeet

On 30/01/22 00:35, Felipe Contreras wrote:
> Hello,
> 
> I've always had trouble with this driver in my Asus Zephyrus laptop,
> but I was able to use it eventually, that's until 5.16.3 landed.
> 
> This version completely broke it. I'm unable to bring the interface
> up, no matter what I try.
> 
> Before, sometimes I was able to make the chip work by suspending the
> laptop, but in 5.16.3 the machine doesn't wake up (which is probably
> another issue).
> 
> Reverting back to 5.16.2 makes it work.
> 
> Let me know if you need more information, or if you would like me to
> bisect the issue.
> 
> Cheers.
> 
