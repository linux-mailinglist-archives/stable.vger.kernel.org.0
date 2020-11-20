Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF0C2BB1CC
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 18:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgKTRwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 12:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728933AbgKTRwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 12:52:23 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A56C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 09:52:23 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 34so7895034pgp.10
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 09:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=pVdeI1sYIriKSKU0FAfSE1onJx9VqHW2QxdMQfohHlE=;
        b=S6cwSJFWciVZJ/O4DHvzItNqZhYkCFL9lFZO7Qs64qtIAqATlt0VYH86pyz+tW3WBq
         CclLKbfZPizwx0HhcjbDfpWC97MMxpUQ8ixhUUKywAXQlX76kzf3RN8wFoTCCJrDv2vT
         lthKMxELdfxmMAoSU9+tLj90ajl3rZJyy8sXg4ikj6V3RljjwtP9SUoAZevsMGj1KPq9
         UnJKIPmI0pOXI5g/WHJ6BCtRartbfrzpGWziVVQQOBD8kR9buf87mqfbtmdqjkKbMrcM
         3qsw2pqxv8DrVC6Xo6ydCJF96zlD0OVww/Q81mL2RoEM/rRRSH/nNZtzl7ZROo2kMmOc
         d1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=pVdeI1sYIriKSKU0FAfSE1onJx9VqHW2QxdMQfohHlE=;
        b=qbHrxpxP4A52lkoOuZVXkif4ZkXXEn8I/zXzB+pKHU1R31jwV19gHmhAg7OuZJvGUW
         9dJAuBseGaH7CoX7wCUNKPIns0zKiVeUNDUtk5/wyTidpR9UCwVrLxj6aYcnTHJu5GZc
         1FFKNnIhTTzxWSpDMeGbT1GoK63EMBK9dd+Y8v0wPpm+UuwKIPHq+SI4gcmTArs+mvKK
         EV5byheX6LgdhzDI5TBtgzZQ7RIuVz/huSNT3v1zBh8eSOukmj+5pTJ7zh0ZQcIpWIlZ
         5Ui1e77Dz0k4bHG1iLAvC08tWUppn34N2QSmuxUEAv4atkO7855GWcq2D5atTkEOp5K/
         I1FQ==
X-Gm-Message-State: AOAM532c6ERrY9ka+FGCAV8kszqlMVdlVqXGdWd9fdQ4i/iVsWUPoB4c
        dB8OqNJX7dwVbW8mXgn6ITDyTg==
X-Google-Smtp-Source: ABdhPJzScsu1nZ3ZInsLfW7bstHlr8/e/Q73vdfsiyNhdbmilFHXACO2L6p3BApzBa44g/4Bp+HceA==
X-Received: by 2002:a17:90a:fed:: with SMTP id 100mr12040112pjz.65.1605894743044;
        Fri, 20 Nov 2020 09:52:23 -0800 (PST)
Received: from debian ([171.49.186.209])
        by smtp.gmail.com with ESMTPSA id 138sm4131039pfy.88.2020.11.20.09.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 09:52:22 -0800 (PST)
Message-ID: <37c1365302a6c05e3d1fa6dd17d39e9eb71f932d.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.9 00/14] 5.9.10-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Fri, 20 Nov 2020 23:22:17 +0530
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
Content-Type: multipart/mixed; boundary="=-jhvfZqZ6WQlWS8Jd5dOF"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-jhvfZqZ6WQlWS8Jd5dOF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2020-11-20 at 12:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.10 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
hello,

Compiled and booted 5.9.10-rc1+. No issues with "dmesg -l err"
But "dmesg -l warn" shows something.

file dmesg-warn-nov-20-2020-portion.txt  is attached

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology - autonomous



--=-jhvfZqZ6WQlWS8Jd5dOF
Content-Disposition: attachment; filename="dmesg-warn-nov-20-2020-portion.txt"
Content-Type: text/plain; name="dmesg-warn-nov-20-2020-portion.txt"; charset="UTF-8"
Content-Transfer-Encoding: base64

WyAxMTM1Ljc1ODE2NV0gcGNpZXBvcnQgMDAwMDowMDoxYy41OiBQQ0llIEJ1cyBFcnJvcjogc2V2
ZXJpdHk9Q29ycmVjdGVkLCB0eXBlPURhdGEgTGluayBMYXllciwgKFRyYW5zbWl0dGVyIElEKQpb
IDExMzUuNzU4MTc0XSBwY2llcG9ydCAwMDAwOjAwOjFjLjU6ICAgZGV2aWNlIFs4MDg2OjlkMTVd
IGVycm9yIHN0YXR1cy9tYXNrPTAwMDAxMDAwLzAwMDAyMDAwClsgMTEzNS43NTgxODNdIHBjaWVw
b3J0IDAwMDA6MDA6MWMuNTogICAgWzEyXSBUaW1lb3V0ICAgICAgICAgICAgICAgCg==


--=-jhvfZqZ6WQlWS8Jd5dOF--

