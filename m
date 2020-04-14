Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA201A8A70
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 21:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504540AbgDNTA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 15:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504580AbgDNTA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 15:00:58 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F005EC061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 12:00:57 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t11so326825pgg.2
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 12:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TWQZ+0xzJdBtnACZDfzeKd76vNmy9v6PQw2/9kJuD6E=;
        b=TnNoFL6jHgByak/LXCkSEQ3hlXxj55HpIPFuzwcW9qY/l54QUrL3YTqBomsSJhD/zg
         wQI+iF37dEiOKuS5OcKLY6T26AbI9JwjeYbc5KtUs4fVUZUY4f0d4jwFkAwglSPYwcYw
         7N8vUeYuSUMsER1cXIYwP86ueTgBxVongrTQdAnppMX+h8ozjPjYWV7Ryi35wIVZth3X
         WB+br72+WSMHeYuKbCaPjIeEX/Uz0xf0eeMpeyXChLTZgSEpOmwe5aKC52WDTOQak1l7
         SnH9wHvvkr2zQkIiu+9f/Ni79JQwcA3cLEx4y1mWbQENI8ko2kFzlcEHZYLFOGzK4Vi2
         ZqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TWQZ+0xzJdBtnACZDfzeKd76vNmy9v6PQw2/9kJuD6E=;
        b=H9hc8/e3glOPzoi+tbedfWwAxMU4Vyg4pmAa071XsXlw5nSlUkxpGRdcTzVahaAtWR
         rfg5PmlgHESI3P2dD/DciY9fINS81vXZAbt/HiNQMZ+OeH1tgpDr/L4RHeiw/4yKhqiy
         QGRaYE3ILEWKsGK+LTmqa+AEZ5oSatxgit6EMZzs+7LgxoL6v2ThFfcjbpisb7sAeVR1
         4oxI3Pqd9qbDPllj1xq8zZUH5MYJ/J4NVPqrSaRxpg/Y/xKG93ZTatVwTpAdgqLgRICa
         q9kiukZVufh286cexOWZ0cY3YsgaFWKDHICJHn/JyiLEAZI4OSnRAVuyN/iRFSMAFrD9
         hPVg==
X-Gm-Message-State: AGi0PuayMtMtN/JE0WArbgzPO2diUUdvJ4/yeGK7L9sC7gYJcmdLtT7m
        Eq2yoH1/XZtEEA/TLDBKhQN0VdKUZ/IneQ==
X-Google-Smtp-Source: APiQypKWwjoUmW8EVF86c9qs5uJBliuuKXDuNIQjiaGPcNKyOPrRocnO7C/21HepkmxqY6xIk3htBA==
X-Received: by 2002:a65:68c9:: with SMTP id k9mr24367294pgt.355.1586890857108;
        Tue, 14 Apr 2020 12:00:57 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q9sm8960340pgt.32.2020.04.14.12.00.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 12:00:56 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: honor original task
 RLIMIT_FSIZE" failed to apply to 5.4-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <15868668307141@kroah.com>
 <898eca01-58e5-8452-34b3-100de2506b38@kernel.dk>
 <6b6323fa-670e-a656-1bb6-82d89ed692ae@kernel.dk>
 <20200414174244.GB1035385@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <75159fa1-8562-9693-1a99-4b2441383db2@kernel.dk>
Date:   Tue, 14 Apr 2020 13:00:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200414174244.GB1035385@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/20 11:42 AM, Greg KH wrote:
> On Tue, Apr 14, 2020 at 10:38:41AM -0600, Jens Axboe wrote:
>> On 4/14/20 10:31 AM, Jens Axboe wrote:
>>> On 4/14/20 6:20 AM, gregkh@linuxfoundation.org wrote:
>>>>
>>>> The patch below does not apply to the 5.4-stable tree.
>>>> If someone wants it applied there, or to any other stable or longterm
>>>> tree, then please email the backport, including the original git commit
>>>> id to <stable@vger.kernel.org>.
>>>
>>> Here's a 5.4 backport.
>>
>> Sorry, please use this one!
> 
> Now queued up, along with the other backports, thanks!

Thanks Greg!

-- 
Jens Axboe

