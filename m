Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B092110CC9C
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfK1QRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:17:07 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46448 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK1QRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:17:07 -0500
Received: by mail-oi1-f193.google.com with SMTP id a124so48750oii.13;
        Thu, 28 Nov 2019 08:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vQgXjttamt9llcJdFuZZy9/ek6RDUMBgmhmqoE3xlXM=;
        b=A159b5Ql0aiWYACd6UDbG66P9PhBJMq9D9O/BW5RcYaCAaZOLcKjYtjgHk3YW9iZIH
         W4v389V4CE24NxXoqwoJQ9X71vOE239UPS/WgNjDqDoceg3q5S58spIEMfJUNwj9VjMM
         x2YRwSVzbpRLUIO8ia+7kJvbkruv8GFsxIexrp4xjc/nwcII1rwTWr9QvBoGFvrSBexD
         1ZmcjmiDipg/5j0pFAryZjTR2jjremAuYazibufGXpCoSSj4tJHKAtZ2wafaDxh44mMo
         88jk4+dnyyWDA9asuluaK+TpzmC0LVH3v9VNY+qFrwPiuP+T72h3fBNvG+lNaNjv4bQG
         Pa0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vQgXjttamt9llcJdFuZZy9/ek6RDUMBgmhmqoE3xlXM=;
        b=CgM3jzBSRjkXDEYDMvMxT2dR1oE/69hFPzb9iv907PDDm/3KIP8eMH/GI6Fgmfderg
         jxbmNTsVm+Oy5gljYgmgz0EIWUhVqUN5bBVLjFLK3ZurSP+sFvOFfPAbmNIEaXcRVd0a
         JLi7Re1D93idjlLXUQTMDbTAJpEtkyb0MRm3KuF5eKbzkeHD9qudrht9iROO98Qe3r61
         GYKkpDtaI4aZK0u31PL3m9nqXgC23IZ/3fRJMwLIDpVldv7i6mtWXRTvBULKDfsoXLwX
         qDOzFfPSqtmNJXWH/Va9oNrEcAeZAkXONwSTpsk5F6Y3/TUUXhO6Sj4lIluRKP3dDZCE
         17/w==
X-Gm-Message-State: APjAAAVbOuU1ANR/jm2EJOTEm8FuaCC8ZzQHosJFrdJb2awBomV5uqUI
        AI0mUZrpqMJwyv5nBx9pszMk8sxD
X-Google-Smtp-Source: APXvYqxT3Ofy+B0ktM/9qs3vhMMbSj+A2ZXMBZx66BcBmccC1XEPmrnCDZQKdwwVknhim81a8v5ftA==
X-Received: by 2002:aca:57d4:: with SMTP id l203mr497238oib.113.1574957826263;
        Thu, 28 Nov 2019 08:17:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l3sm1515074oie.6.2019.11.28.08.17.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Nov 2019 08:17:05 -0800 (PST)
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191127203114.766709977@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <b099012b-abef-0991-7153-93f7c75e9e08@roeck-us.net>
Date:   Thu, 28 Nov 2019 08:17:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 12:27 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.87 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 151 fail: 5
Failed builds:
	i386:defconfig
	i386:allyesconfig
	i386:allmodconfig
	i386:allnoconfig
	i386:tinyconfig
Qemu test results:
	total: 390 pass: 365 fail: 25
Failed tests:
	<all i386>

As already reported.

Guenter
