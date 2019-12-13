Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE3511E50E
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 14:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfLMN4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 08:56:45 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36157 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727578AbfLMN4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 08:56:44 -0500
Received: by mail-pl1-f193.google.com with SMTP id d15so1283001pll.3;
        Fri, 13 Dec 2019 05:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yOTiVTN6TRqhsiKXyuXZAhjh4xoZddWaYpKSnXhSel4=;
        b=b29/nw7LjKjjtDsfIHyDRy89fMafLkL3tjAMHTk9Us6zjIH9NG/JAc4hnIjwQeioNE
         VWKGJ+QgOfOvDuFq3Ed1S8wDHsyOw84lK0l+loINKOTBl4wpzaPxaIqSc1lqgKJZzwWa
         oyQhJQlHmbFTT4lfmN0nk/jSIuS62OEVM9aXBT6SK93n0x2WHFrJylc6SizYkVAFjUuu
         xwf+JqhKx/4qOtcCDv0orGHxThbuT++dUmL+H4CHZeIv2RDFvA//G5pwebolT/2dU3tP
         j/C2H1LyLffEd4yLljNvnFQ+PQY49fcpVmTFTtnBUdhy5NIpyhwHSdJN5XBTuHyYPnHP
         SzLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yOTiVTN6TRqhsiKXyuXZAhjh4xoZddWaYpKSnXhSel4=;
        b=WrXcicGXXr0lbFx24GOk20L+fxjaG2PZ0mL5/BTGbDDLIGx2/KlcHsAm3L6qx7wZwq
         y9hIOhueNbjncrOn98hTU6YobsT9G26K1aajRN4pCSiZcE5RXTVzdq+zbBOpZiJE57T2
         kc7eP/rVcvsdHGyWvUfeSOdlqtGo9uFwovPuuYX44uB6F9L5b4L7g443FsNig70kMOWp
         ki5eOywIsNUcJQoggMJnZkgNDpTRzMzT92FYiMJy5hweC6Yu3ecbQM9qVZJN9sc+nSpw
         I3t07+38O8gORGaBuk0mSEZL3EAqnFk0dlg2q/s9zuA4929h8oRcBviI6Tuz0NHuXnNv
         7heg==
X-Gm-Message-State: APjAAAVP2sBRcuP1Rgimf2GNJT65JWotyfYpP4bIkJlOBHEDll7uZO3c
        55rGsKRp1oBfhYhICJmx5jX54FU5
X-Google-Smtp-Source: APXvYqxSnU8c+K3bHypBX2JvZR/ol+6V0HxmeKddZGGp+dpfva7PqMSkcSEsQPmDBV0BK5+V/M5tEQ==
X-Received: by 2002:a17:902:7287:: with SMTP id d7mr15699726pll.17.1576245403682;
        Fri, 13 Dec 2019 05:56:43 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n15sm11332899pgf.17.2019.12.13.05.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 05:56:42 -0800 (PST)
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191211150339.185439726@linuxfoundation.org>
 <20191213093035.GA27637@amd>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <b9a5af67-c7db-a2f1-b573-cbf25c1f03f6@roeck-us.net>
Date:   Fri, 13 Dec 2019 05:56:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213093035.GA27637@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/19 1:30 AM, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 4.19.89 release.
>> There are 243 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
>> Anything received after that time might be too late.
> 
> Is there something funny going on with the timing, again? I see that
> 4.19.89 is already out:
> 

Just for the record, in my opinion it is perfectly fine to publish stable
releases early after all expected feedback is in. That lets me merge the
release early today and gives me time to fix any merge related problems.
I don't see the benefit of waiting until 14:46:07.

Guenter

> commit 312017a460d5ea31d646e7148e400e13db799ddc
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Fri Dec 13 08:52:59 2019 +0100
> 
>      Linux 4.19.89
> 
> Best regards,
> 								Pavel
> 

