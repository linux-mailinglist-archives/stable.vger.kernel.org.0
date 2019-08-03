Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65DCE80718
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 17:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbfHCP6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 11:58:12 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34600 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387466AbfHCP6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Aug 2019 11:58:12 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so37513186pfo.1;
        Sat, 03 Aug 2019 08:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c472KP7jesc/9gpLwEBPzWS9/GevyWJHPQk29+HFS98=;
        b=OLKdBM8+xRSmR6stSTno8xGUFbccfUX1B0+/uymt6Mwi8bxNpf46q7AN3w9/BAgFM4
         aU3SIn8JgR8IhwrlaqZW+bRTfPFJmbmAKXI4VmpnjLDt6FcnZ+dNt+af5CE5ThXTm3Eg
         rKa2879MeRYEwG3FFWHgW6QWQDp5p+QjAx5CbMnPJ4EoNmqBtqiVrgPdKHJxmy5vMtEy
         2mAPF2YqAjmg4F1qLcz6xCF4Hx8razFDq7x9f3dTSiseYM9omG08g9XetlDG0qnOg9sB
         7g65YChmMeS259cl8TYTkE8dunntcKAQvk23Rls8ZnBQsomGDNQOvmhYlUDswQmDaK7R
         O9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c472KP7jesc/9gpLwEBPzWS9/GevyWJHPQk29+HFS98=;
        b=ORmqkfEal4NjDET2+2NDMdlKXGlifFBSCe1fLDO/rT9h593im54sQhA7XB5Yjl/4MG
         rIfgIxnD6MqX1Zy0uSJ6ER0M4BHg2T1sRKBpfxHImF4zDTChNRNXji5vMCM2gikpchHO
         xR6WDrDFFtTc32yuNwxHBf4K4dzUhgr2K+cT4o8/C/GhjJgeHhuJaO6CTgxeXm891jcE
         LEE6qASBOyDNoFFXuk93FpTozou9/n/eLo8FXZvn3QAwaYXD8Ow1YuAR3K2gL6YmAvnl
         R81S/Ye99e75mrdRQhi0SJjVlC6pd//BxS8/YFyfN5XC3r/dfJoCOBRHPBEYdIhAtsDY
         dCvg==
X-Gm-Message-State: APjAAAVTd40vk9EkK9sRU/DDEawpZ3tSamKzEGpqFJAWbKAPNPuls5bk
        S76qTilU/PcFFdjt1+iQdWa8gW3I
X-Google-Smtp-Source: APXvYqwxwGkL/1NwOM36ivxd8gff2LSH37SMODIglU7zvWtuO4snJw7Hxut6VjGc/DRTMeNesTTHCA==
X-Received: by 2002:a62:be0c:: with SMTP id l12mr65568849pff.224.1564847891484;
        Sat, 03 Aug 2019 08:58:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w1sm11431407pjt.30.2019.08.03.08.58.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Aug 2019 08:58:11 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/223] 4.9.187-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190802092238.692035242@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <42e0bd62-16b9-027e-a444-47f16a100172@roeck-us.net>
Date:   Sat, 3 Aug 2019 08:58:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/2/19 2:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.187 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 333 pass: 333 fail: 0

Guenter
