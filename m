Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40EDA169B09
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 01:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgBXAD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 19:03:28 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39960 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgBXAD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Feb 2020 19:03:28 -0500
Received: by mail-pl1-f193.google.com with SMTP id y1so3296986plp.7;
        Sun, 23 Feb 2020 16:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=18oRYkSQJ5CDqKpipuY8ehhqpaRemt5r3RZCizdeEpI=;
        b=R+LQ7BVMj+A/i6955rq5UFhJ2AGhjGbtH5b79lgGODLOGqBV6WJdqhIxl8I9kblKXS
         e/W0VrRX6W/VKFj2MZAO8KYzQEHinLLcY8xoeDcQ8Y4nTXgC4pYUXzsWF0+yRfXHUS+V
         T/UsJU0s8I3FE6MQfmBsq+ulIb8mXuelRGrRK7kZyE4fu12qolBU2sCE/BwA86TL3sWF
         29DUNa198+Z7ywmHDiwRavl8gj3eTw7Dqo56aZTWEdddD+JZMB845/3rXK77wSjUhZke
         kefJvYfWv8078B9Qvd0MNFyHPTC6umr+nvcSKA+9CNyXN7Q94gd0MxpKOCX+F34SertR
         KsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=18oRYkSQJ5CDqKpipuY8ehhqpaRemt5r3RZCizdeEpI=;
        b=Oaez5XfHzmFDDUPfsW30BWX3AN0wmRZV5ZX/b7WtasEuA3idleSW/653IHsgKKcSk+
         72t6v/dbhBhy+C6TyxCNRDSjwcvyYlry8JjyQrZs6HLc2HSlgILIyKXfYmRNb2Hpc9Ow
         t5Y4qZUBi5ihdsHZ0bGyoWTr3KDZul9eCuKWnPB7bw4Wl8AtFphQaEOBZ/oxwQ0KiRzl
         xnOxO4VYdqakwpglKixkHQWTgBQK3+9bnE3Lj+f6DNjsqVR/0iZOMUrWl62PmQ0zTtbG
         0KsSHvTmNZei/7jdvSVdvjP7eFqYTCKYClOS//1lxibLhDpr6vhK7jwcsxv7AUQApTWy
         ESwg==
X-Gm-Message-State: APjAAAWJ4hDpobz8Kfh65BHU2tVxF446zuKoWxJc1v6cxnE89ejViMfm
        s/j6x9Vdg7+oG6ZkmMjAY9gYfcoJ
X-Google-Smtp-Source: APXvYqzUaNlSXBx2vwtO2lpMvCMg2Hp5JdInETzu8qjszV+jx5JZtja+rsPLKxVnrOhvqzbjm5jBDQ==
X-Received: by 2002:a17:90a:8586:: with SMTP id m6mr17277639pjn.121.1582502607650;
        Sun, 23 Feb 2020 16:03:27 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ep2sm9823568pjb.31.2020.02.23.16.03.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 16:03:26 -0800 (PST)
Subject: Re: [PATCH 4.19 000/191] 4.19.106-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200221072250.732482588@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <0d50ada2-e0b2-6665-135b-b3720bea431b@roeck-us.net>
Date:   Sun, 23 Feb 2020 16:03:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/20 11:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.106 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 

For v4.19.105-185-g119e922a87ef:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 403 pass: 403 fail: 0

Guenter
