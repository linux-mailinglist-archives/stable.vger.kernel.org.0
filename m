Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41BA50B10
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 14:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfFXMsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 08:48:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43854 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfFXMsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 08:48:38 -0400
Received: by mail-pf1-f194.google.com with SMTP id i189so7451296pfg.10;
        Mon, 24 Jun 2019 05:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oaaCCz6Ys2dbIc0p/CMP6uj9ujUCXgqFExQh+n5j2Rk=;
        b=uHTwKx27KstqwiD7lY0j5caPzg2Gzx5Qy6ziWW7s63fR4LI7SGQ+y57hfRnzgKcBwC
         mOPzWtdgr7OwI8Zmn4NVfrSmGS8swNdwxlEqcHSaGpLEaHDtjsV+ZRcTQochyEzJwDT7
         ZLNgayqP+nQz4JPmWqlQpv7rWKqB7NZVJfFEgoDwhyaaosR9lyosrdgGlcHiNPAhhO0D
         Hex+L3c/JJkXRoHZDYx+jlwnVQtLzFteyZu660l7sJ46qbub4AwHukFWGDNAJNbcrSaF
         j/2aOoCQmLDIyV1pvpMkA1vyxxskd6Jyo9Dns/sYOggqfQSXrgQRrdDMLFNBmjcQjcFR
         rUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oaaCCz6Ys2dbIc0p/CMP6uj9ujUCXgqFExQh+n5j2Rk=;
        b=bMz9vnfDLfx/JdRp1dZ8ogTakJN1ymQG5LEwDcyn6cT4P4yYjB1///BZYLlR/2zccd
         dYaK6dxxUFRCedugn9sVe1TnIMxmpgtaLwoRwml15GGk/qekwC6zTpFx99XZTHSZdarO
         gh5PrE9It2Hs0Iv9ZMgfOErL+7iS0V5Kr+6xaBFK4lF8SUWxrRuYcEtqP855pnqQeMVL
         qVOXZYUBbMwc1gmpr3b4wrmbMvCknd0NDdT3OIehaaWjqhQ03LTipYBaDNhA5X8Prdzk
         BcXCeH3+0Ld5kIpJKrMVvXJil4x/U1dhbcniEB5oMEfaMTRF8jY2eGfjo/gkb6B7Ishb
         PJrg==
X-Gm-Message-State: APjAAAWT7i+tsYAj0i1J7d+2bvEGaX97tZ9aHmiQy4yIv6mrHsbQYLpf
        jmEDlkwL9aA8NCouMKYW8FzyOLIg
X-Google-Smtp-Source: APXvYqwHN6OC1XcAWnXQDioUHvCsS/51HWtiliZEnI3l3tIbJiNf2IZ/BOi9bq/+WosluBQxvZZDNQ==
X-Received: by 2002:a17:90a:af8e:: with SMTP id w14mr25120501pjq.89.1561380517258;
        Mon, 24 Jun 2019 05:48:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t70sm4046967pgc.13.2019.06.24.05.48.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 05:48:36 -0700 (PDT)
Subject: Re: [PATCH 5.1 000/121] 5.1.15-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190624092320.652599624@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <a37d3054-c0a4-da0f-8316-051f0ce293ca@roeck-us.net>
Date:   Mon, 24 Jun 2019 05:48:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/24/19 2:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.15 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> Anything received after that time might be too late.
> 

Early feedback:

Building nds32:allmodconfig ... failed
--------------
Error log:
arch/nds32/math-emu/fpuemu.c: In function 'fpu_emu':
arch/nds32/math-emu/fpuemu.c:308:48: error: 'FPCSR_mskALLE_NO_UDFE' undeclared (first use in this function); did you mean 'FPCSR_mskALLE_NO_UDF_IEXE'?
   if (((fpu_reg->fpcsr << 5) & fpu_reg->fpcsr & FPCSR_mskALLE_NO_UDFE) ||
                                                 ^~~~~~~~~~~~~~~~~~~~~
                                                 FPCSR_mskALLE_NO_UDF_IEXE
arch/nds32/math-emu/fpuemu.c:308:48: note: each undeclared identifier is reported only once for each function it appears in
arch/nds32/math-emu/fpuemu.c:309:52: error: 'struct fpu_struct' has no member named 'UDF_trap'; did you mean 'UDF_IEX_trap'?
       ((fpu_reg->fpcsr & FPCSR_mskUDF) && (fpu_reg->UDF_trap)))
                                                     ^~~~~~~~
                                                     UDF_IEX_trap

Guenter
