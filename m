Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A03104F7F
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 10:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKUJmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 04:42:54 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42578 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUJmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 04:42:54 -0500
Received: by mail-pf1-f196.google.com with SMTP id s5so1378534pfh.9
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 01:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uayjKl6096yQejZH/u6ZFMYkKiU/WJ+6RR2akfnWBw0=;
        b=Q46g7mq23AcnzsYh6whyltYRxOjhlsHAdkPrzc0cIVekuA3/vzuDzTsHYSi/aHvD3m
         +pnW6pESPzxCAVdtcaPt1eKYm5vgfwE8gnxmjOTS/ptJ3/L2r5/xkdfVN4cIjLyKZ4Wa
         rX8bEVkIY4X5Iz8Vp1gSCm6PX4gy8KEhqELeT6eNn0Ia3tIdC9onlyfoGOAfM1LSS4AG
         nbuUhnYF1R8pEkIL+f7UHl/HtTGjwhr5Vt+fh8FgiCuygOAT65koygQRIRynUyBXezut
         MBfdm+8Ray3w71ZOvZY6lBlaoHSQkdKMVlvurR2aFx28neRz8nEsHhSyYCH0diMVmn0w
         w63g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uayjKl6096yQejZH/u6ZFMYkKiU/WJ+6RR2akfnWBw0=;
        b=IsoM6wAbI/egT4ZZZ802MXyWjOMxO+bVHl6NjIEkRBX64ZO6gVoq4VT3dn2Qo3t3KA
         b6rzgSE2kPkTfNdSWzb7qqKXVzmrkzIu7KGv89t8FgqM5U2XgI5u933/o8pOuKGz0ygU
         iOqYyohDn063mvCLv1gcUx32fYwSRzcYzOC50jvuNYTu2IO/z1QVYC2JKzL086XtB2qv
         l1dryPFDBF+qzrZ80pm5RFpm3c8EN+P9Qro/N+00dOzaB99PrK/HU1RuxMY/OG+eFXwC
         4rzvt/SfoQRomUkkuT6jPa/c8rUZEVhTSLA4qKdPv/4gRfEiaOYw8JVLWtJ2bpWFNShf
         bTHQ==
X-Gm-Message-State: APjAAAW3FAAFq6uGUYMTZ8SGrMiFkFTCWD34CAiT/BN9L/qJ9g+Lqpuh
        IT+AsE9Aw7SJ8o2TuSEeoJM=
X-Google-Smtp-Source: APXvYqxxCKxc/LMnGurpNO1lM9k2vAkPHF/i6LU4AuqE1LxfvWgvvapwIKhrqIv8d4x24ytnGstZiA==
X-Received: by 2002:a63:4556:: with SMTP id u22mr8139936pgk.2.1574329373574;
        Thu, 21 Nov 2019 01:42:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v23sm2675609pfm.175.2019.11.21.01.42.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 01:42:52 -0800 (PST)
Subject: Re: Patches missing from v4.14.y/v4.19.y after most recent stable
 release
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, sashal@kernel.org
References: <20191120220238.GA21382@roeck-us.net>
 <20191121065301.GB340798@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <f10c28e4-b50b-82b6-1aed-79883525befc@roeck-us.net>
Date:   Thu, 21 Nov 2019 01:42:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191121065301.GB340798@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/20/19 10:53 PM, Greg KH wrote:
> On Wed, Nov 20, 2019 at 02:02:38PM -0800, Guenter Roeck wrote:
>> Hi,
>>
>> when merging the most recent stable releases into chromeos-4.14 and
>> chromeos-4.19, I noticed that the following patches are missing
>> in v4.14.y and v4.19.y. In both cases a backported fix was later fixed
>> upstream, but the fix of the fix was not backported.
>>
>> v4.14.y, v4.19.y:
>>
>> commit a4d8f64f7267 ("spi: mediatek: use correct mata->xfer_len when in fifo transfer")
>>
>>          Fixes commit 6237e9d0715a ("spi: mediatek: Don't modify spi_transfer
>>          when transfer."), but is not marked for stable/fixes.
> 
> How did you figure that out?  That's not in the text of the changelog at
> all?
> 
Both patches were already in chromeos-4.14 and chromeos-4.19. When merging
the latest upstream stable release, I got a conflict, tracked it down, and
from the description of a4d8f64f7267 as well as the code itself concluded
that it fixes 6237e9d0715a.

Guenter

> Anyway, now queued up, thanks.
> 
>> v4.19.y:
>>
>> commit bc1a7f75c85e ("i2c: mediatek: modify threshold passed to i2c_get_dma_safe_msg_buf()")
>>
>>          Fixes: fc66b39fe36a ("i2c: mediatek: Use DMA safe buffers for i2c transactions")
> 
> Now queued up, thanks.
> 
> greg k-h
> 

