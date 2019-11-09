Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 037AAF6012
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 16:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfKIPkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 10:40:16 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37236 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbfKIPkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Nov 2019 10:40:15 -0500
Received: by mail-pf1-f196.google.com with SMTP id p24so7195536pfn.4;
        Sat, 09 Nov 2019 07:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zlAGe4aRTAFO57FUA4sybRZyopoGgYG3Ziv/a4D1r0w=;
        b=CkO0/Xkc61tkT2QOcsmMGV7HA2uxVC2fb3Qc0socgzKdUnrbSCO/lEfHuuSwfZkrLo
         zmeZF2ugkjC+xaOpRuD7EQdIah1Kfcy2spE1VhOwI5i8Oj4l+UYXEn+Ei+VoGSv9Ye1M
         8EwP28jWBACW2cymqJ/hRN14rl7o9oAIv8X2Jirr7yBdA4mLKrBRmWVopkVTJih/Pctw
         c11ZXW3XVy+tl88Cq0ioI9GaRSIFzbvPY0zPhf4gKmXg77dBZzPAGjf6wx/1u1YC0Lza
         bNBuMpqbyuTTfQHg/pT5W6UpT4eqYFK7aa+mHFZCeZodDoz+tQRfmKyTF1VX9mg83e25
         mifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zlAGe4aRTAFO57FUA4sybRZyopoGgYG3Ziv/a4D1r0w=;
        b=K7gnv25fs+ZMymUK1ieF52lOspOBiDBwlMsw05Z/X4p4WcLL2k/DGTSIm4T17VjDA9
         KhrscdeAkymdnK8aRZroZqKHQeGOCemar/TND/YbjDA6zRV72NJL83PL5l3m8pkDCdpI
         kKN2loBiFHAH+lLIWJbyyEHh/s/ScjQaOE89pdC5oTnSU75nKmQCWZb9j4Graj2hcHUZ
         DLPc5gsnGkdPHQK7QDMuxqT1ZoeN5XIP/Fj681vifbuNf5BzBVc3KnXjmMcjXLgZTOER
         peVYd5vKwZtCBv6fZcsi82OU7lEVuQxlO+GjW8Y5rp/G6PafyjKug+Lg0aGKIHqF02uY
         NNXA==
X-Gm-Message-State: APjAAAX+KzI2wU+R+HsYps4X0lXv7b5yE3b5NQaRxmZe153Sd+A4eGYi
        OrW0F1U2c3wqe3RZCGLhy/TGlClz
X-Google-Smtp-Source: APXvYqxLmS2MrTLky2vpQOF1MPy/MGW+vgrGs9zHNLt7ow94oJ0G3NBSEXvDxwQgJRSJc4fKg9pIqQ==
X-Received: by 2002:a63:750f:: with SMTP id q15mr19053106pgc.422.1573314014884;
        Sat, 09 Nov 2019 07:40:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y36sm8971510pgk.66.2019.11.09.07.40.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 07:40:14 -0800 (PST)
Subject: Re: [PATCH 4.14 00/62] 4.14.153-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191108174719.228826381@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <5ade9d06-43e4-d9a4-3112-a88088c31422@roeck-us.net>
Date:   Sat, 9 Nov 2019 07:40:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/19 10:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.153 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter

