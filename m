Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA8E12F94A
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 15:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgACOmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 09:42:25 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54319 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbgACOmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 09:42:25 -0500
Received: by mail-pj1-f67.google.com with SMTP id kx11so4676779pjb.4;
        Fri, 03 Jan 2020 06:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JshPeSWOOSIb8mFV+SIuZIYPc1RHhKOYhfPWibxQF+4=;
        b=e0eMo+efL/Z5fxSq3qSAC6eh+RMohEWj1ttf6QPFVP4oUeHywBb1CF3OGCtkBVC540
         fymnPt7RKLjlWXAunEvEouukTe8t2QNmI5ot6lopUP3IKIoG/mGyv3aHMOC/4d6j9a2o
         83MWPf+p9R17Y0z51Rvd4Zb8B/qq/NIEolIfhXfuCYxXZd7x42Jj3/zkrdr5fqi3jUws
         nMLRCo7geoTYk7KH8JzULWaJ7nuvFvj+DmRA+atmYcX3J6rVkSQv5HnScEZZjXnxwCge
         70dhq/XKVB58nTWjys13pVIIMv5nLEfGPytNvpvgC7qSZhFcgfS7f3jrIorMj4qqADxY
         0phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JshPeSWOOSIb8mFV+SIuZIYPc1RHhKOYhfPWibxQF+4=;
        b=cWyjICt93/KSZm0Iowsfws2ANEFtqkqefmy9L+/gMcKslc8qLySE/LmNY7T/aMTEMg
         6oHaTK44YPpTMePF8WmWGCwGCt6Jrw3Fq7TbJ3Z1k3UoJ27vzAiedYIb93lfVpDS268G
         U367VMgjFXDP65n39tLlD5TLO3cNjCRiGIPfu/8euorNMckbzrcBdwxCDNH18M8hJRuB
         T5P+RrcuxT/cepCy5GVzDQuamBpZjchNVN0GKgwqV/7DgTs8pVegIUvGwDd5eBjcN0cr
         nivZvtQh/V9oE2ho86BDjjpxA8XMweNWiogSdFt4ZB1zAnhmcDeuEKIhTrGSvLCC2cXO
         GCAQ==
X-Gm-Message-State: APjAAAVtoV/FgNDV42v3u1Ba+v5orFxmddyMxuoqSmu7SWAUiES1KEbF
        R08kLHnuyTLokG/id1tdq0r/JkRv
X-Google-Smtp-Source: APXvYqwhivL5/PxaPf05yyKEV2jBNyMcv8tYg8djnrhJEI8hSJ527IausfEWaVJnVbWY1xvDH79uzg==
X-Received: by 2002:a17:90a:a88d:: with SMTP id h13mr25757091pjq.55.1578062544178;
        Fri, 03 Jan 2020 06:42:24 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m3sm62968869pfh.116.2020.01.03.06.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 06:42:23 -0800 (PST)
Subject: Re: [PATCH 4.4 000/137] 4.4.208-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200102220546.618583146@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <628eb605-0613-0f85-b906-6b3cd78195ab@roeck-us.net>
Date:   Fri, 3 Jan 2020 06:42:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/20 2:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.208 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 22:02:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 325 pass: 325 fail: 0

Guenter
