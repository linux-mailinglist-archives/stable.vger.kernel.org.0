Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C11C77A86
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 18:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbfG0QHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 12:07:52 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42496 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387419AbfG0QHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jul 2019 12:07:52 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so25906581plb.9;
        Sat, 27 Jul 2019 09:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TdhMyA0f7GkaYro7VFqzIpVNCMN/yq8RzRd3YAwWKNc=;
        b=HBqa2TyhEsp1seVChsHeDkI4AxsQWX54WK7RVVHuTTP3Y7mibfnmHKWyw+M1U0unno
         ynmk+tYzQmF9+pJac6L0Kp7xOgCA5lQS5PEqhHIDc0Ezd0id9U275y4fk/Z8hisRqhDR
         d67YKh1QWhF6rFecBBlb9CcPjEkUneB+q9rRwnGkc8Y59QaDBh6tEyEWxNyepG6klsXh
         nsuRpTu8f+UYDLn8Icnm+YrpPmM5TM+M0lvCDwdHodJh728Vxmgw7nQR7WM4DYjN1Qez
         lWcEvh9kKboxAPGOGFXNyHBGOSTCkc6cg/tsCXfgB7gXxcowtCcE1bJfeixI3loFDTCn
         1y1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TdhMyA0f7GkaYro7VFqzIpVNCMN/yq8RzRd3YAwWKNc=;
        b=pOTdKaghVBKcOor1TMud7kZjlPGyk+H/ve35+yKwvyytApafsZfErazf1MzEs5iKxL
         OcEiOZyo9q1s1fgDaO8xH50HQhMJmxXJZyVFj3dDTYtGU8WkSvNlupJcQYWHLlmDKtFA
         ksr7zY26kkKTQnecIbY2/jK2Ki0S0aCLbnZl5ojizCaVUyUmseSrRfGL+et4PET6jCaF
         FTVIXz+aMMkRxRYHlTAqq9DtEuRRMxiWX6E4hR+0ZxM66gEW0YpQir6lBHgFqvBrQyNr
         4D+DJAx7Sur8j4jcE/A6dp8BJFHqfLlk+ZpfhSX0V4n4usEvpXhIRoZuajyOWVtpcvDX
         Rkmg==
X-Gm-Message-State: APjAAAXzuxkRM5aXcbtUcn0Q273zo9qWT4HwYwQe0w8L9Odkrtg4Oc1U
        ZorkFqBnnv/MzVY7xdDFfrPAHsGY
X-Google-Smtp-Source: APXvYqwZANIe3JXnpGimCQLlzGMzKQ3z09SjzzceNMeDay/ka4AXStj8I32eViy/jGE6L4NPs8rs0g==
X-Received: by 2002:a17:902:f46:: with SMTP id 64mr102720487ply.235.1564243671475;
        Sat, 27 Jul 2019 09:07:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q24sm50546239pjp.14.2019.07.27.09.07.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 09:07:51 -0700 (PDT)
Subject: Re: [PATCH 5.2 00/66] 5.2.4-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190726152301.936055394@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <9e69ade0-419d-a024-8b5e-988cbd69d4b4@roeck-us.net>
Date:   Sat, 27 Jul 2019 09:07:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/19 8:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.4 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
