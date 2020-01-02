Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E212D12E499
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 10:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgABJws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 04:52:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39980 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgABJwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 04:52:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so38647201wrn.7
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 01:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=drDwGgal5TUYRLkCDV6SsqvW+d2Wey2XiKi6dv44ATY=;
        b=M48W68hhx6dqwANSVa+YttvAs1Fke/PFY6dUEYVqlFuc5tyv9YWRjYsSxpSbuWjuM/
         +FSFKHG1+ZE3dRT4C80R+nR1fc+wLZoJe+X3TsgaI7b53fRY9r2sL5jZ1ZtXsbiCQ6ad
         rPJK8e3KQnKAWaQB53BpnwzPnMEzxXHULkGFqwxOGVSayMkElkJDkkIJ/D83OPGi4WuR
         8qSONrllLNlrS5bwLXBufAxp5qmtzFld87JD4gVNsJwsFPWyh1eDCQSpkTPtGp5pd6Ew
         +bP6vXr3DSMsipOGRU3HrydMJEpSCVFLJYyfpL6T7IyM3bA6o5VIFyIa6gX8OvDy4T+Q
         RKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=drDwGgal5TUYRLkCDV6SsqvW+d2Wey2XiKi6dv44ATY=;
        b=FNvQ0lCZ6NW6J5KBGK34UQwsFgvwIBqNmEs3KJwjHFGoZyV8n3zdWheJsyWx78lcUo
         qlXbsEnsQh/u3DWPfmZNbSu7TWtcfp64aaBjKTRXKVKKlEf2HKSpywJFA1P/N35kfcQo
         s6JrBZQmWPQzeVNVKIeC/HKyopF/0EMww4aFn+ZZiuXdy4cJYJuYH6G9lXZjQpPRR9zN
         v3V7H2tWXbXZOcMlgfjJPFiYwxmJmOki0CPrAXCxgeTyZAbpWrNRa7YoX7hH4MQ/ZkyQ
         MUyCJHlQcZSy2NNEP82CZOnDmqTIFssI794bTZVYe8t1dX/X7Cjs/39zrAv6Mdqce1Wb
         ahwQ==
X-Gm-Message-State: APjAAAV8H743UgQHorzx2tm+43xow0oPPPOQxH7v8fh/GhPQqBuopABt
        ZZ35t7W9WxR4yvEvH4T46P3SeEyN
X-Google-Smtp-Source: APXvYqyPog459cZCP0PqUZSdWTG+XjchNRieUa10dBVQ+SY5+QYyb9y3hPCF7REwZ99QphicT2mqhw==
X-Received: by 2002:a5d:46d0:: with SMTP id g16mr85841438wrs.287.1577958765784;
        Thu, 02 Jan 2020 01:52:45 -0800 (PST)
Received: from [192.168.2.41] ([46.227.18.67])
        by smtp.gmail.com with ESMTPSA id h8sm57952794wrx.63.2020.01.02.01.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 01:52:45 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] tty/serial: atmel: fix out of range clock
 divider handling" failed to apply to 4.19-stable tree
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     david.engraf@sysgo.com, ludovic.desroches@microchip.com,
        stable@vger.kernel.org
References: <1577634359228165@kroah.com> <20200102004729.GB16372@sasha-vm>
From:   Richard Genoud <richard.genoud@gmail.com>
Message-ID: <184e09a3-1c45-f774-84f4-d27271593f91@gmail.com>
Date:   Thu, 2 Jan 2020 10:52:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200102004729.GB16372@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 02/01/2020 à 01:47, Sasha Levin a écrit :
> On Sun, Dec 29, 2019 at 04:45:59PM +0100, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.19-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From cb47b9f8630ae3fa3f5fbd0c7003faba7abdf711 Mon Sep 17 00:00:00 2001
>> From: David Engraf <david.engraf@sysgo.com>
>> Date: Mon, 16 Dec 2019 09:54:03 +0100
>> Subject: [PATCH] tty/serial: atmel: fix out of range clock divider
>> handling
>>
>> Use MCK_DIV8 when the clock divider is > 65535. Unfortunately the mode
>> register was already written thus the clock selection is ignored.
>>
>> Fix by doing the baud rate calulation before setting the mode.
>>
>> Fixes: 5bf5635ac170 ("tty/serial: atmel: add fractional baud rate
>> support")
>> Signed-off-by: David Engraf <david.engraf@sysgo.com>
>> Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
>> Acked-by: Richard Genoud <richard.genoud@gmail.com>
>> Cc: stable <stable@vger.kernel.org>
>> Link:
>> https://lore.kernel.org/r/20191216085403.17050-1-david.engraf@sysgo.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Fixed up context due to missing 377fedd1866a ("tty/serial: atmel: add
> ISO7816
> support"), queued for 4.19-4.9.
> 
Thanks for taking care of this Sacha !

regards,
Richard
