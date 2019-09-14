Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2E2B2B87
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 16:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389108AbfINOGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 10:06:42 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35644 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389107AbfINOGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 10:06:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id s17so9634809plp.2;
        Sat, 14 Sep 2019 07:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fu2cxF+6VWTWyRggUGj8DVbYX/GdRgLnBTCQ58E7l5k=;
        b=RblVUsMcay+1HJyxvWBPHUwAOoKE6v2KsPk0Vfiq3ZvWcyNG4hEnFkeTkUwFhiKtvN
         6nJxXbOl8udByjQnPpFZ/iOXZgwwKnBXCt/OupyfmVYPzKtrTn93vEC5p3e+9zz/aqGG
         Yd9UeEjPLvauAtc/6wwl2cZJ/Y9/ZYHcgQAUg8YMFisKNfaOY/bZ3mvyYdsQA+dAHYmD
         JjtpbxMfN2q8G1JrTHU5mgUkBoxH3uljuWR/ORrCdRXIQ9WW40X7eEg9C99hPn4pUGfH
         N/1Bu2xbyz786pYFKfXiN6zvLja4d1fnIBSZnJMDdn2Xf+TjKwDYKNvivfZBy32UNYhn
         k8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fu2cxF+6VWTWyRggUGj8DVbYX/GdRgLnBTCQ58E7l5k=;
        b=sKLGNRcHCGP+80+6J7xqFiyJlj9VjzpJbcEkyK/lz+oqZPkziu5KJHz1nP2WXb9tGY
         GJobuBQfX1kZYPY2fea9eQmILmCX3TIvXIEdvouZRi5oMUUT3IdkrC8reBxKMF8oWq49
         jpDhENlrsNxvz9HjaELIaqrBag6ha4fE84tH2lXkcKhMrIh8uRNE4k8KqHi5obYlGECO
         jzmHHkGekH/pqhOgwRs27p/SnDnXyGldUYZ9Xt1QLND8ctdnq8c9UGsY5DcZywau+4pJ
         lzpADCBGGeLJrKyGj3RLLQgDDZz6LedhaCtyexUF9uusXqufNSsdNyd5Lmj2wbOTEWjO
         /9SA==
X-Gm-Message-State: APjAAAWHY0iLEjmdwk1TL0aPXeqjkhcQmPsaKTVO3COO2HvXhZHjKEO2
        VWqOkjEDS6IAvYE1kOP0or1H9WU3
X-Google-Smtp-Source: APXvYqwyaOkHI7w3L7txt3gLwjvf+FjUvAbC4nzF09souKZlOEvXG2QgONb08mzvpAOkXJooxbvU7w==
X-Received: by 2002:a17:902:690b:: with SMTP id j11mr56072811plk.35.1568470001150;
        Sat, 14 Sep 2019 07:06:41 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 7sm21446492pfi.91.2019.09.14.07.06.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 07:06:40 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/21] 4.14.144-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190913130501.285837292@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <0ada47e0-84db-6604-5cd0-55ab1daeae4a@roeck-us.net>
Date:   Sat, 14 Sep 2019 07:06:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913130501.285837292@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/19 6:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.144 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 168 fail: 4
Failed builds:
	arm:allmodconfig
	i386:allyesconfig
	i386:allmodconfig
	mips:allmodconfig
Qemu test results:
	total: 372 pass: 372 fail: 0

drivers/vhost/vhost.c: In function 'translate_desc':
include/linux/compiler.h:549:38: error:
	call to '__compiletime_assert_1879' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)

Affects all 32 bit builds with vhost enabled in v4.9.y and all more recent
branches. Caused by commit a89db445fbd7f1 ("vhost: block speculation of
translated descriptors").

Guenter
