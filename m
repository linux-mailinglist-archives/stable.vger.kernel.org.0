Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1CD1234DD
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 19:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfLQScC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 13:32:02 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40922 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfLQScC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 13:32:02 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so6479854plp.7;
        Tue, 17 Dec 2019 10:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Jt9igp/vb3Q4imVycGHAIChk8Rd9kKBHmsaYFmp6Y7o=;
        b=N7LjdDasH4+CqBepfgfMlE44vLxYadjQ67o+oL4zFoXyrMfU7okw0uW4mSe5x3Htfo
         UkAiTrsYVYfxgqDvIuH+2KQyQ0ERJKbUJx5/5bWr+b+lXGSCx1rVdWnGJBdDVZ23dVpS
         mmk87XHA+7PvbKmkqc8uLcer8HcL6Slcn1s00QmAZxR8kyIXOyVuI7dxt0PBMJu9mkp6
         z30iHL3T8qBoYehiyo3jaI9+BmLori12ZbIKe2V+oHALmcQQa2Yz/P94/yKIM2DNShrw
         6P+KLDPEVLWXEsRU4GxUsQdM5z8KWnFklXH09NBSEb7OjR6g1xfLQTFGnWLfe6dXpMme
         oUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Jt9igp/vb3Q4imVycGHAIChk8Rd9kKBHmsaYFmp6Y7o=;
        b=ef4ez/MgN/NnuNB1UHV6o0Op7es+4Q3vWzgQQMjcXurDThv5VfXST/R4zM5k8iYfdn
         s2vGXzon9WErEmnTGo4Brmt4qXxxgj1T6NbtJft29K6QMShtl/tP+TfASSSq5qzfQOca
         SM4bdeSU3X72HePKRLrBrvUtv5H7ma+O0ZFoCWoYYnXD4NZMaA77I8A8NgrRVfNVWfP0
         qbiqbNbkiw3OxRy+mMrUmpTehzPc45rnSprIJoIxhZi5wz/W1QbzO/fmAw2EABDrU9yk
         EyO6Yd9talPfEmiR+/SByl1vIs6tZhNwdVrMxrcd4oCkG7A07gh0/4GuJDTdx3Ohkn1V
         Dk2w==
X-Gm-Message-State: APjAAAXbEn6UOuiwoAn55xacAyZEKAk99yQys1xF/O3GU35Jsfionc5A
        X3aEyIFnQw72iJSgwq7052679/3C
X-Google-Smtp-Source: APXvYqytROhdFNm7gtHFIYzQThGI9Cm4KPk4pN7Lte39uDB9Dpss2233RTNPTm5a05S1YiowJ/D9Fw==
X-Received: by 2002:a17:90a:6587:: with SMTP id k7mr7540210pjj.40.1576607521697;
        Tue, 17 Dec 2019 10:32:01 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r6sm27579405pfh.91.2019.12.17.10.32.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Dec 2019 10:32:00 -0800 (PST)
Date:   Tue, 17 Dec 2019 10:31:59 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/177] 5.4.4-stable review
Message-ID: <20191217183159.GB29679@roeck-us.net>
References: <20191216174811.158424118@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 06:47:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.4 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 387 pass: 387 fail: 0

Guenter
