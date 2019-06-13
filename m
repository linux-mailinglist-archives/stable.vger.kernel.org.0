Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB53444F2E
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 00:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbfFMWiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 18:38:17 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43282 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfFMWiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 18:38:17 -0400
Received: by mail-pl1-f194.google.com with SMTP id cl9so121837plb.10;
        Thu, 13 Jun 2019 15:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nBv/R182uhuCafyQYbQVEhkRbrB37kIxJPAogDFYLDo=;
        b=C4ID1AGzLHSV4WlcejkSs+WUZYDDZRU0ceOadoCNvY5crkGII0Ax3BiBWFEJOs8hME
         uVgrS0bHKHuYqU8df8ZqblmPhmwLmIAPEFU5ZHSxheIq/fR3jy8BhDdd/PeHjEw17kMK
         NCqz2/0ApPegBel7QHf0YQUmUVl2+NdDeMfTJI8uVeEntD12dZqp9OsSIdhmp6S9pUS1
         pEJ3vcXXX9oojFcIMuP7zA8Bio4TFasdMsKTY9ZvwsZqDGkYjvA8kYvQ5JOnJP0XOfgv
         Ao9+JPkp2wbNRfh3Xgkw/ulzTy4JYtkxuUhmOHit+/SPQ63qmmDb6LzWP6peXEZKQjx6
         qgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nBv/R182uhuCafyQYbQVEhkRbrB37kIxJPAogDFYLDo=;
        b=RpNXXmueU1cYA0Gav6XJqSRFEW27MN8dSMZ1fU3QPKfckhNEG4jbyDSfxZRsFqCq14
         9aGOvO1GdcfqFGv4AvgNirgDhbvPfjxM92P0DgAjAMpRhh5aTGuQaRRLrKM2Z1KrMW87
         h2PcuMIS/GRFZDSoOZweGznsJ+8a8b8vy/A86ePUNnngVYM3HS9SzIwweQ/+7zo1Nozp
         fGprOqG4q3hcDIuLNKBj6H5yrXK+EgL+ENzogBinn4hSGJ7TSqM1Vjw/y5Mbr2knu8KS
         jRqvx/MpQsVDfIQU2DLCMrnkN2Re5Wk9J4pFJ8Y21o4g5iOS9TAYXSwTJxvI/xuf0yAD
         kx1g==
X-Gm-Message-State: APjAAAW7CNpH9YSwG5novLcEv0c9H0Q9w2tq9z9qc9tTR8NTWy+V+Jds
        9TXcCkB7LifJBL7FPcJeKRIfHQRV
X-Google-Smtp-Source: APXvYqwOYVT2Vf4vs1Ozh4HBWLARCY8WzAVyxtWkJRoaIjWdl2aQJIHePtegseZh1ArkIRkMH0Ia0A==
X-Received: by 2002:a17:902:22e:: with SMTP id 43mr86565994plc.272.1560465496554;
        Thu, 13 Jun 2019 15:38:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p1sm693427pff.74.2019.06.13.15.38.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 15:38:15 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/81] 4.14.126-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190613075649.074682929@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <39e4eba7-e40e-4e75-7c31-6e201980eaab@roeck-us.net>
Date:   Thu, 13 Jun 2019 15:38:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/19 1:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.126 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 15 Jun 2019 07:54:51 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 345 pass: 345 fail: 0

Guenter
