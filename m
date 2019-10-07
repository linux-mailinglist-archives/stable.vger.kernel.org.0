Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFCA2CE54E
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfJGOcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:32:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45141 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfJGOcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:32:55 -0400
Received: by mail-pf1-f196.google.com with SMTP id y72so8750100pfb.12;
        Mon, 07 Oct 2019 07:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FBS0pEcIhIOPtcL7kCdlaoIOm0OABWRCHi6bGk7b5eg=;
        b=aNI6L1tNk7JSvHNdTB/JCgUKtPl61lUQNvHYf8BsJqEWI95MlUZOLL23V4pYMKUfoB
         xlqbGQi9ghZdKOLzzuXKBLffCqwonRH+mipMM+wnVvK46DAmWrG+mTlXBmIfTPRlPkn5
         N//J60+5MXqyjjRdz1YGT82ul1klrUUkRiju5ZwbN8xTE29DsLye1QX1Hq9pqgRjsL3G
         fCtK+Djd3/EtP4qWUxDvQ1C14ev7GruGOuVI4sEDcFTnzvqtZjrrTqLes2yvJXaMqmju
         zZ6CLVip2ePJKzHBtVOAPXtPaMmaMPcfb9fn5Ujh3+KggDdUAuIiEP0gTpKg9yVQge5D
         JSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FBS0pEcIhIOPtcL7kCdlaoIOm0OABWRCHi6bGk7b5eg=;
        b=aD3pu6tVT5ty7+eTV3kYwLA4OsI+l9S8PgCwDt20VFR4zvT7Vm1tBJxQ8Adr+BAPzm
         2uIqEjehC2KgD/TG1f7bJJ/DsRj9EmSsWe+IbghGvn5Ze9S4aQ8NMa8PDxAknG2tVI0g
         3ZD5AtNpjiYk6AopzHOJ/+SAeHeK3rkH6Hg4S0c69tFgYFQ/UqFyXkAlbMRxq3c7U1uz
         4jNmismfNkJQo9UiYMvrOYbPHpFFX2gvmPE9h/SUhKUjM7MmLIRi4ByPBRO3vccmdh8s
         OWljkUqTtAaRPZ3gAgQ5XmZ7/c6VuNvNqSirn6FQq9SSsEF2t+I5LIjr2lFJwsl/v00E
         KDwg==
X-Gm-Message-State: APjAAAX544OyGwbe961s8rc/aCG/81wLseJoMmNU3ZPVwPNzQ/Bzk6LJ
        i1SMmCRAoqwFVU4gD+XucvDEkwsq
X-Google-Smtp-Source: APXvYqwlqA4cpG6QT+n8zHBq35CzAf1Gpx9UxZBrPbO95gUeROwVnSjWOs2VGMN6DsGLsH3TQaB+Pw==
X-Received: by 2002:a63:fc55:: with SMTP id r21mr29881171pgk.432.1570458774029;
        Mon, 07 Oct 2019 07:32:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m4sm12555666pjs.8.2019.10.07.07.32.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 07:32:53 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/106] 4.19.78-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006171124.641144086@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <5c7ca636-2f8d-76d1-e9f0-efa631600f02@roeck-us.net>
Date:   Mon, 7 Oct 2019 07:32:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/6/19 10:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.78 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
