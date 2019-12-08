Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1FAB116274
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 15:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfLHOuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 09:50:00 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34277 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfLHOuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 09:50:00 -0500
Received: by mail-pl1-f195.google.com with SMTP id h13so4697540plr.1;
        Sun, 08 Dec 2019 06:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H1ELSVHsVknGp/11Yyt/FGXIqph8XGH0LeCl+av56UI=;
        b=Figp//I1vhQxA6Y9DOowovKWTdMAMf/EKLfh/wVhrbWN9rW/lQWafWPT6xZ9LRtJu6
         icmLYGw26FTEHDzskHQxofdJTd/sstr3ZBC99YceBlYNSlInyZ5DkTJwflFDQzgltEMd
         6Q/DjYE9pREd03OjgTQ8pgxj4pmnrMjAT3Vy+1jYYELvPQ8Ttj4cs0JJWgdTnztRCG3d
         5aKHO8SbMFCsMoMFoJkJtRFxg79sZmYzZVaJcl9ijGaohohs7mSBOZTCUJvNpkeQFdJt
         cbcTiCpynerQZqrPXnuMGhTeGcdshX7g3n4/QFeyYXOiaiRybb3QvY5Nd1Xz3C85uWnm
         A4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H1ELSVHsVknGp/11Yyt/FGXIqph8XGH0LeCl+av56UI=;
        b=rYoPjQJ9z3IuZITwd5kacK46GuOmAjmpUcGfGJcocxHhIWmnAJbZOj15lxb38feEOR
         wNx+lftxNyEQdFskenv7q9GcNAPmnj8tS+MxkZLRaggk512IT2chioV4mIdlbT27nWoA
         5N1OdzBIzjT1ipWDhHH71Y49PS00rRipyzTbv0my9TnV481HYBEfz4e0nmEq1h+6tMZA
         I+pohSROc3qvAYwMIXwTCRSGXPnOxgoFMeCdHYpy/u6SGf3zxsm8rWBIvfxCh7q7s1x5
         0y+2z/iOc526aoUSft4PTQOgahZHkkR3kMlxuTVGxH+KuixqSc5UVc/LrExMbQusqXkB
         iqDA==
X-Gm-Message-State: APjAAAXc9mmultpr5OAzLXKw67nIt1Z7TvoPGHPzx8Twb6EkNh7feRLl
        nOSS/r7PFXOqPoO0HfoCUjrjGXDX
X-Google-Smtp-Source: APXvYqzSbwhdioteDX0lL/VPl2Y2j1hoQNvl8W3Pkm1S9rNfr3u5Y1I37v6pJLUEygAbg5rl9DdpwQ==
X-Received: by 2002:a17:902:ab98:: with SMTP id f24mr25113614plr.257.1575816599906;
        Sun, 08 Dec 2019 06:49:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y144sm24570986pfb.188.2019.12.08.06.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2019 06:49:59 -0800 (PST)
Subject: Re: [PATCH 3.16 00/72] 3.16.79-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
References: <lsq.1575813164.154362148@decadent.org.uk>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <13922804-86b3-2f3f-5b59-3fe19afbfeef@roeck-us.net>
Date:   Sun, 8 Dec 2019 06:49:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/8/19 5:52 AM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.79 release.
> There are 72 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue Dec 10 18:00:00 UTC 2019.
> Anything received after that time might be too late.
> 

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 229 pass: 229 fail: 0

Guenter
