Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71BBCE548
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfJGObw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:31:52 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33795 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbfJGObw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:31:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id y35so8359640pgl.1;
        Mon, 07 Oct 2019 07:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gckGdavBtKFWRIHGZmeKvufg1AyV7AwXk7yb6Y2b4fw=;
        b=MqziUeDBawiefRrX/hlHZeMy0c0DetjRZ3H1cRQ48996qOzEsMxV+79QZugTHhKMIq
         N7ySJ5P7bS8bzdzAZWu44HwJ12biDDJvWzy2y7vYf/aRFuqXJKphLi36PFh+8vQUs3xz
         sMetf36c51ECkOyyc2fcQhGmuCjFi9tq+d5qgNV4b9YtAD2pI1tu6MySlO3PgLarFqlH
         EhRaZQGVyggJefVF9lXvlaD6Jj0C0mWkcSAH4vej+by40IZ0mGx9+4iz4Ve3vINrqT4v
         rubeah8cgCuM//AiQ38VsMA3cCfoEq3M4DlCOcA2kSyXz1EdeQ/UhaoiAhMthojQeUNk
         6afA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gckGdavBtKFWRIHGZmeKvufg1AyV7AwXk7yb6Y2b4fw=;
        b=Rn+6pbYKhffITRhgE0LOWv2VieYuZmGj2h19+p5F1+ZNcBnHFPBWKGGr9bgZpxFtUv
         xGPHLK1uQ6DGKkZqvzd5cIf0jb2N9i+zCINmNU84Mkk32ce3M8CkK6fD5ozdKSyBOhka
         vh4SHBsctxCpSvVaUdzJOTCHo9AhqtCuYyp2uj1OKMxGOB7tK1gcD/Fa4mfy4ht81OJ0
         gPJmfT4sbXPtQ4p9zbp4/h4F6zfTaacsjWUWvVnfVieDmftwh47KsSmHniRjiIfnUOus
         at7sFP/k0nFECDRqFayTSY9buPxuqxc7i3lXJwcByTC1sOQjgm6/5RoBqhPqF95P2Jg7
         vuhQ==
X-Gm-Message-State: APjAAAVW2lZ/QgcX5Ky/69XIo7M8vY7GLqmCBkF3DJVkVngO373JDdte
        Xs+F0UVLu7biTjQHznQxeufRQVGm
X-Google-Smtp-Source: APXvYqwzlVtrS1Cq6vygaL2hPwhyprlTf4e30PGxJSDLYXqtHz9Ia9E9pyCqTg3NiUTp5JkpkoEYIQ==
X-Received: by 2002:a17:90a:154f:: with SMTP id y15mr668845pja.73.1570458711372;
        Mon, 07 Oct 2019 07:31:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v133sm4533617pgb.74.2019.10.07.07.31.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 07:31:50 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/47] 4.9.196-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006172016.873463083@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <0a21241c-1b68-84a4-48f2-da0e4b722de6@roeck-us.net>
Date:   Mon, 7 Oct 2019 07:31:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006172016.873463083@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/6/19 10:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.196 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:19:59 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter

