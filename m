Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4FDE123497
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 19:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLQSS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 13:18:56 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35072 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQSS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 13:18:56 -0500
Received: by mail-pj1-f66.google.com with SMTP id s7so227571pjc.0;
        Tue, 17 Dec 2019 10:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oD87gRQ27xmU5RLKDjEZg+o2lAboD5y/GOuaqhwyJYQ=;
        b=nvW8/8XUZql9NBVLx/WQWGFg0qLM526EvGFq81fGgqDWGqu11oCiRGbrb6xcVLxkEe
         bA4d6UCpBA9UJWZ+/MlAb/7p37PPvEZAC1X0ipIIS5DIrt7fQiDen2/GmG3/hzIqPbPw
         nYnXuXNm2/EiwgA87a2tPG+oUUEJ8FVwltvgyLsQuaZE2KPqacj09/ab/APdOuiEOxVO
         TgI1LhijJYeEyEdxXHPSESf6SoeRxyJR4dkfbwlCbZ+0MG7kQh7J+TdC9VN6d90e1NWu
         iwuP8+jTH4fd4vkjmq+7V2/oh0OvR6hSQaC0ieM7mIgGR0ba0Q2kiUw+GzO4LvOpxn8X
         QahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=oD87gRQ27xmU5RLKDjEZg+o2lAboD5y/GOuaqhwyJYQ=;
        b=YsnvZb4usiNNxDBxOmwqePMpFw704DDajKsdh84UONc8l7uvn7rvJgmjvw1VKPUkJE
         SmSqYlC/wqmhS65o7LWZKLPm9QJVUh9tNBJpRIz5I+xmfGOy8o4RqVtdSiUrnXkgJZx3
         wBBE/IGf0bWfneeyBftBX2pS0roQQgfugDYd1dKzhdCNaTkAXeMEsF7HPVzpcYKn0LNI
         5slqF1Yj2dRn5ioJXqYzfJcRkFkaPvAl85TJpeT1iWixNNZNzGWSxEup1On9cdQ+E/vY
         UVCt6lPOOr6i6i/ErIvBlyPBi1TLb/7+8rKZVNCtPRc4ypvdktYUKHuVIwYXys1yj6fA
         1Cdg==
X-Gm-Message-State: APjAAAWU/LNmcNe3UWnI7u23JfphDuKaj6rNyM7HmScKV/YQOv0Eg2m4
        vaxADticULfKW1OIPZeN1uQ=
X-Google-Smtp-Source: APXvYqx49QaTdZTuS4a1M0CHRgfG9wwg2vvyziCmwtw0My63LKdKdGh2+DZiU3j11B+gRyYuzaLamw==
X-Received: by 2002:a17:902:8d95:: with SMTP id v21mr24327772plo.61.1576606735408;
        Tue, 17 Dec 2019 10:18:55 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r3sm27511246pfg.145.2019.12.17.10.18.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Dec 2019 10:18:54 -0800 (PST)
Date:   Tue, 17 Dec 2019 10:18:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/140] 4.19.90-stable review
Message-ID: <20191217181854.GB6047@roeck-us.net>
References: <20191216174747.111154704@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 06:47:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.90 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Guenter
