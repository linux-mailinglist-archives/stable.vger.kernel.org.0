Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A57710F743
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 06:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfLCFZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 00:25:58 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37217 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfLCFZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 00:25:57 -0500
Received: by mail-pf1-f195.google.com with SMTP id s18so1250460pfm.4;
        Mon, 02 Dec 2019 21:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M+Srzhos+DQbPdSyVlOGh0ahebrnO+JHC74IMgDA9Bg=;
        b=eeKGjnxM0XbZKXZOPzIRMe8+dxlQhanLYSuWF9PAKWyivLmsJgQpCJnyComD2mfVwb
         SBH8A+xfUhFhdp6Tc4hCQQvlTET/BFBN4a2cRki+E4TLh0wEdVFfHiwM9tRHDSzX8XXS
         jpACCFmiGNed3ljP2KsWf6MRZ4Xllx4dqx4IVK8J+aCCvGoIiwXp+vTOpe4+e6Jwt4TC
         cD9t5uPXgF+5sNjAoLFNyiY/bAmtBEtS4ku9WLQPU6DL0NYthrOOJkYMTCJgDSoc25Vp
         6lB2NRAX51XHCoH/DWG5mcoGVy1G+nXEP83lV1bCIaJWVru6OCbNDRc1AgQOcJUXBM+X
         +uOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M+Srzhos+DQbPdSyVlOGh0ahebrnO+JHC74IMgDA9Bg=;
        b=rKXxfLM9Yl8If1j1SlBb/lXGL9QF4XIe5CA8M8wS557W63I+nV6X1IEgShdV7/QWWA
         iE9lQnDbnbZ2ifXMpm5ZDMiw7NAFU5xeCtjsUuhpceQPArf7m7l2lBk+hxkKg61TyRMB
         TxhnXP7whC+Xq7mvCDj16ArxT0A2g19oYSqRB/ewxbMfJ7ICHcK8nLgfG3sRux+uCFpe
         TeGdTE93Sr/ZwHeUbRyEV7ufRgDRwJGQo6L66Ys2gzo4O9ehmjazY4sIgtwfNZ9RpGco
         fDilUOK/g5eMDVJEKi1ebHZSXTiyU8JTiKyJ/Ym46ByodEVftdfipYVuL897J/rlbo1f
         zZyA==
X-Gm-Message-State: APjAAAU589XQYWSfwpglFX5qg44+Ua8FIntRPJ4tmazMxXOe3lTLodm4
        cVQu1TrVFcwrnmohPSIlikvwh4zO
X-Google-Smtp-Source: APXvYqxQfQdsIkgF7VkUdEOXCBieiD/yZesNsTlRPdQtfxS+Cny46WRXpQ+K97lot9VjQz+YLq+mMA==
X-Received: by 2002:a63:cb50:: with SMTP id m16mr3448077pgi.425.1575350756962;
        Mon, 02 Dec 2019 21:25:56 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q22sm1448697pfg.170.2019.12.02.21.25.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 21:25:56 -0800 (PST)
Subject: Re: [PATCH 4.4 000/132] 4.4.204-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
References: <20191127202857.270233486@linuxfoundation.org>
 <CA+G9fYs-ugvOrYBZbmieSK1rQrcRh6R9cL3Vz8xK59sB3aAqyg@mail.gmail.com>
 <20191129085350.GE3584430@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4808b398-aa8f-01a9-3783-a07344944944@roeck-us.net>
Date:   Mon, 2 Dec 2019 21:25:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191129085350.GE3584430@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/19 12:53 AM, Greg Kroah-Hartman wrote:
> On Thu, Nov 28, 2019 at 06:59:17PM +0530, Naresh Kamboju wrote:
>> On Thu, 28 Nov 2019 at 02:04, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> This is the start of the stable review cycle for the 4.4.204 release.
>>> There are 132 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.204-rc1.gz
>>> or in the git tree and branch at:
>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Results from Linaro’s test farm.
>> No regressions on arm64, arm, x86_64, and i386.
> 
> As you all are doing run-time tests, it would be interesting to see why
> I saw failures in the Android networking tests with this and the 4.9
> queue, but they did not show up in your testing :(
> 

Did you solve this problem, or am I going to get into trouble when I merge this
release ?

Guenter
