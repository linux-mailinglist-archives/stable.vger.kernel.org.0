Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205CDADF90
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 21:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405789AbfIITjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 15:39:49 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45416 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405742AbfIITjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 15:39:49 -0400
Received: by mail-pg1-f195.google.com with SMTP id 4so8371815pgm.12;
        Mon, 09 Sep 2019 12:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y2erjT3c8ybRv/zd+E7tOXJu2HvnWGFGkPllvVSZFHY=;
        b=FqRMICh899Y0PXAC3tCANcA2ENhyOThcLzlZ9pIHL7d+hSG6mmCXTOZjrg0l8THihg
         UH8i/s+D+oJByU2+wEByWO8Cvu1NcUfFGw4poLQ86PeuJMpvYaOQP0HIrow5HjWHC2jO
         IZH76yNdI64mbq84ifNhr9SdoFV4lm2PtZbbc5paIB1YewMwjQBRuwk0OYGHw/pFglo+
         KZcXN1uEN4P5cFoaVt8XCZXseglzOIcKu70NrfIrBUQuHKQzzli7M7PB1PzruXewWIQd
         qSEpX4hoqhEylGSzzBtHr4KzpIEjf51DaCBWdYUkI8/DJhFCjKMW3EZZhV2GR4ibWx1y
         gpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y2erjT3c8ybRv/zd+E7tOXJu2HvnWGFGkPllvVSZFHY=;
        b=KTB5Pm4cdAEe+KBXVZf39f52zk57WXuPzGqaKbIPJfXe4B7IDXapx3B0locZHTjQXr
         AD4ianrqOOFbXm5Li51pDTvn92jvO5GyPk+kErnG49hC61O4RvPIKdjZsk/7DmZawno3
         5smdXebA7Tinnl79zqbuoiF87GSrVvq230iKErkw64RWUDxl2X2cxJAHS64qXarxsDX/
         BRvWXCdZDpDMtkGCayW+QX10OrqPlWjOIwt8Y1dre/0oOOtyK+t3wos8hWBRm3F+kqhb
         zMVMYoKktu7mAIkUaZBT0hvlYAlU6bdl2cho+65xAoC/WL7V3h6y1Yw46Du/n4S2sOL4
         OYuA==
X-Gm-Message-State: APjAAAUH4tAZPhj6303bZtZZH7R9Wgztok4keS7uROeWsmbaLf3zpm5/
        hOW2MuBxqc0Rsj6jBUoKjBY=
X-Google-Smtp-Source: APXvYqzZRX3r18X+6RDufDAOq6LpcuCbbz1yUD3SX6leuOTTnhyHlqygS8htNTg2NxNCSKm7ufNAig==
X-Received: by 2002:aa7:953c:: with SMTP id c28mr29773229pfp.106.1568057988853;
        Mon, 09 Sep 2019 12:39:48 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e24sm21385915pgk.21.2019.09.09.12.39.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 12:39:48 -0700 (PDT)
Date:   Mon, 9 Sep 2019 12:39:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/57] 4.19.72-stable review
Message-ID: <20190909193947.GC22633@roeck-us.net>
References: <20190908121125.608195329@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 08, 2019 at 01:41:24PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.72 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
