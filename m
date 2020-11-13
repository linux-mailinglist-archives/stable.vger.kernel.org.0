Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93BF2B1DAE
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 15:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgKMOrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 09:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgKMOrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 09:47:21 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCC2C0613D1;
        Fri, 13 Nov 2020 06:47:21 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id n15so9110243otl.8;
        Fri, 13 Nov 2020 06:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=grU8H/KguaHoMwmJMkHUlAaKVmi6QrCxjzxZ5xt2rd8=;
        b=bI6ho+WI7Hj3viwbxlnmbzDL+h6+2x71spKWS4S5KGYMUJhyGdMFcjCqzGbtRaSB3o
         up4gZClozIpQ33AmAC2bU0nq7IC8jDFwB99+VSpwZt65+7y+3LTvzSMW7Rj2+4Sxnj2v
         yHeweGa0qdHoLROQ7bFTVpjr2i/EEUElWfXf/rZeca4FrV1/4FtUQD9gw1xcemiU16R1
         6PK85YrTH2dHOm8GGy+Ru3KbfxqQrxEhPU2P1zBulyS4MEJLRjo9iLqm+50wC/bjvG64
         7xs0Hrn8RyjhQLa6KYoJeA8cPyXzv28iPtGPfXHEpXFbJbJ+P/g0ntTEBVOykdABjWAL
         4s5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=grU8H/KguaHoMwmJMkHUlAaKVmi6QrCxjzxZ5xt2rd8=;
        b=DYw3MCcQREdAeHBkQDWs4cqQlPXD+K9CN+4pnLnOzYHrSk5t9MtwAFL3spEQ027NRF
         Sj4pR781itPFO9l0A9ZCfSXnH6B5rFMCBVD/DCbMNAh+wSNEVhE/3402SaKoxIqk/W+X
         EckFXE9bAowDNrqSyphQm0Nf+PQdW4Rg9YoX69NJRfxq+NfXgiJbu0xSk8BKHgndJipp
         ouqr1mZf0Adb5KZhWOF7LihfgZ91CsW3kwN/2e4rZaKn05yx/IWQ4O/TFTfFt9dUwoe3
         hWtNeFsSLxfoMZg0HsxolFSWkwaAiY7EWufkcbGUL6IV87oJMFBhVZIP8KSDD53+tB98
         ro/g==
X-Gm-Message-State: AOAM532w1YAUzSfDRzVVpv1QJdETpUh5MivtE9KG1gmh1a3rCC2yc/DW
        jB/+sNPqXf//i7IK9nALLn0cU1/zvLQ=
X-Google-Smtp-Source: ABdhPJyQTCE57lH/5q17EUm/6E7EBkys8R6EN/TPdpYeSBkogeaIT4/u0YphgGS4zph62nTBML+0rA==
X-Received: by 2002:a9d:7e84:: with SMTP id m4mr1763623otp.199.1605278840978;
        Fri, 13 Nov 2020 06:47:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x63sm1908844oif.37.2020.11.13.06.47.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 06:47:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] hwmon: amd_energy: modify the visibility of the counters
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Naveen Krishna Chatradhi <nchatrad@amd.com>,
        linux-hwmon@vger.kernel.org, naveenkrishna.ch@gmail.com,
        stable@vger.kernel.org
References: <20201112172159.8781-1-nchatrad@amd.com>
 <238e3cf7-582f-a265-5300-9b44948107b0@roeck-us.net>
 <20201113135834.GA354992@eldamar.lan>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <e15bce7b-2aa7-1bd6-8419-b35233b9cca8@roeck-us.net>
Date:   Fri, 13 Nov 2020 06:47:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201113135834.GA354992@eldamar.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/13/20 5:58 AM, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Thu, Nov 12, 2020 at 09:24:22AM -0800, Guenter Roeck wrote:
>> On 11/12/20 9:21 AM, Naveen Krishna Chatradhi wrote:
>>> This patch limits the visibility to owner and groups only for the
>>> energy counters exposed through the hwmon based amd_energy driver.
>>>
>>> Cc: stable@vger.kernel.org
>>> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Signed-off-by: Naveen Krishna Chatradhi <nchatrad@amd.com>
>>
>> This is very unusual, and may mess up the "sensors" command.
>> What problem is this trying to solve ?
> 
> Is this related to
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1897402
> https://support.lenovo.com/lu/uk/product_security/LEN-50481
> https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-12912
> 

I guess so. The real fix would presumably be to read the power
in the background. Of course, that won't work because reading
it continuously or frequently causes power fluctuations. I'll
apply the patch, but if there are complaints from users
afterwards that "sensors" is broken I'll simply revert the
entire driver.

Guenter
