Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236F31795BC
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 17:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCDQwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 11:52:53 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38686 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgCDQwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 11:52:53 -0500
Received: by mail-pl1-f194.google.com with SMTP id p7so1258764pli.5;
        Wed, 04 Mar 2020 08:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CqHoV/Gth3LKJ1OS/tKJsWiBqyl8qh5vcy94x875eIM=;
        b=N0rWIyUqRbydOtk1fAB8yQffmj9kEDaOuGt67fJgKka/G0ELwPdhlW1HBGwjonJ3CO
         0WOlHlMjJiEOnoYCGQFX4MutWloP8R/2OviBB6Kbz0qFc1YTxy18Jg1CtqgTpl/oVFg9
         wmesShBRKWz1Keso0ObX/A0ABvSHJFqtzyEJahx80MwMBF2t8ET1YSE/islwioBZgG3C
         sQJbj8ECOK1Vux6lw0tFK19AkWA5Rg25JmzDf1Q9hL1M0J4Xc8DhyxDW6TYB6Koa9Xiy
         3mVXrH+OroWo4+u4LRhHi8YQu8DaHx78OMFF/Ib8dqsqdGaqIy1I4DWj2U2VqMXEyh6g
         BOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=CqHoV/Gth3LKJ1OS/tKJsWiBqyl8qh5vcy94x875eIM=;
        b=CgTYBiTpjZrqh8tN09Lqzty6zWmRojUV93UxUgKEEUtbjAi/PZyoJTAjwFfSBtoQOD
         nwMdN2WKNMQpBYRdkrNuZ0XeFI9PGimkBCw2T/xgvBh9Xpj/EMmAyLtSBX6V+BIGie4h
         KVuGLA/NKJltjXGjX/kA6Juh8JsnTzpUCKh563kB2jq+V/q7Csrsr4O0fuYDMw0pkQ5Q
         lrqrfA7OIw9JmxgkknWfJTfq1PNnflMMd1yg5SXTk1oo+1cvGoKrV+SnaWraduNrRDzt
         Atk/BO7PLSjeuFnP2YLHWYdvl/0qfdNz7hGRMu4LzVzIpr7hvMEK5hHBVHjktd4024du
         edBw==
X-Gm-Message-State: ANhLgQ2V+wt9+KKCdcr0J2rz8NowfyY8hn2m3eVY9Td2zJMoY9GMMagR
        gL1FDaAudiOUf6FwzuGYwj+IUol5
X-Google-Smtp-Source: ADFU+vsW8LQeK74hrH0gIxOQpgXyjsHnD1TSYqujUlrg4fehdKtwWN9j1Z/0M6/RNcQHEt4Fu868Gg==
X-Received: by 2002:a17:90a:c587:: with SMTP id l7mr3957770pjt.82.1583340772259;
        Wed, 04 Mar 2020 08:52:52 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a88sm3251308pje.36.2020.03.04.08.52.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Mar 2020 08:52:51 -0800 (PST)
Date:   Wed, 4 Mar 2020 08:52:50 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/152] 5.4.24-stable review
Message-ID: <20200304165250.GB22358@roeck-us.net>
References: <20200303174302.523080016@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 06:41:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.24 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Mar 2020 17:42:10 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Guenter
