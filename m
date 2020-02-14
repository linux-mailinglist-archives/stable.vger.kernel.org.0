Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6388215D19B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 06:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgBNF0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 00:26:15 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43770 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgBNF0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 00:26:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id s1so4288352pfh.10;
        Thu, 13 Feb 2020 21:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j+QHJ+ytinEzAhJPaPqwn64TO36jemkUIvlnRAU/kWQ=;
        b=ldyMmk3bJ/yGdmidNy5XDUZgJ1Yye4Vy32Jq3OnZhGE6UB9Dwhc+yq0vIQDAemWVvQ
         EU24jv9j0YHaryQTfC7vIpjDz/omvgvzJu3In44/7TlIfmkXW3LFSRYMmUsuZoFzZw5t
         giCA1smHku69qBWLB0jXuNdEh+5mSywIH7FWKH6S7wu36P2lzY/JWlbiO4xwyZIHgJij
         VyVSq3Q4qRRTftRGgzgaUdPBEAS9Njbif5oQ7pbjBGGacuRiwgFWYyBNGRe52amHM1CZ
         oMU4Hg2pThUwgcTOlf1PygBef/uhbTHYQTYbhz0fer9YhNqovelK1HBkaH/UywswWizb
         Pamg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j+QHJ+ytinEzAhJPaPqwn64TO36jemkUIvlnRAU/kWQ=;
        b=djmIiWtH3R66P8MaORmse4mfxni1GwwzK3FcTB5HV6jHAfcuQEhFEeYg20JYw/P3gT
         BdchILUrh+Yof/jjEY7dOo0KyW7VFiYIEXk5+PYnx+xatWO2ZiKan4etv5BL6RlCNDu0
         2WuAxp4xVVw+gN9gCwCd5gkz/83Mxa0H82dODIQA2+9viP7aoFeeQg5vn/brTtNAW6C4
         oUC/LF+m9JMxjc7ImNk4LrG4IOM7FccKCp1D6MBR0iyHIpIroE1uTckEtBPiJUerDpw6
         dG53BchkvztItdYwcU/cnVJ0vNSrL54z0XbTW+8Hbqme5FcuwBsVxhOSUEzZXSoJdSEQ
         Z9ig==
X-Gm-Message-State: APjAAAUJ2nb23E3nl/cNqCAmaUt1eELDahVxpyFNynk5kBJUS/2yzFtR
        iVcVGgsTRpZtRrdGDBZWF7gOGpWv
X-Google-Smtp-Source: APXvYqyynCI+dGN+NsZSihvtKz+xEQzd9B1lezMbUEtTDaTZR5RfbOR7mLlBD8lYtdCFKqSD9Fge0A==
X-Received: by 2002:a65:4d0d:: with SMTP id i13mr1588760pgt.346.1581657974683;
        Thu, 13 Feb 2020 21:26:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b6sm5200096pfg.17.2020.02.13.21.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 21:26:13 -0800 (PST)
Subject: Re: [PATCH 4.4 00/91] 4.4.214-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200213151821.384445454@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <b59e9413-f1e5-41e8-f9e8-2af5614942fe@roeck-us.net>
Date:   Thu, 13 Feb 2020 21:26:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/20 7:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.214 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Guenter
