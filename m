Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC01115A221
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 08:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgBLHfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 02:35:39 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33532 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgBLHfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 02:35:38 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so767030pgk.0
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 23:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EN24PHoL1c5EckXyWXEkiUAAxQ60wRtO9V7+zWJYg8U=;
        b=z3JHxKcjLvyN8xJNxbH/8bUzaNeB3igBVuUd8FZwqHRKYWItclh6mrpIqT7Q/cvHjX
         3FPSfWsTbozU06H4q+55kUmJAJTxZPfV+r0ULkwpmPFUU6Iz0ERIK/9HQadlqD6e8yNP
         TLuG3NB6l9lwaStIi6sxUFx1OlVNj1miSwyzNol2tYSnYlo0lx/ZHxCe/DaJrZzFbVIz
         r98CmO7655V3G/XYl/ANGupSxIftB6W4elam10HshwfV+nGftxXa9HYbVUiwKgsrqIhG
         f2Os9PAHzMBTMLUSj7vNjAOOlEKKGsWAPkuH/0+W4TRPHyMlCxO/zUuPfQEHUocNSoS/
         THlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EN24PHoL1c5EckXyWXEkiUAAxQ60wRtO9V7+zWJYg8U=;
        b=XqC/SYxzL/ZDmaiinHvk9FvqpvOev75Xooo9pZomVGJ7hdhlaLRRfSCj5uQC3q2waF
         1fTbeKokGq09fcCO7a253wuuC+BwuNhb8EpJek73ilI1CasGU6up7QLxDEThbgYC6+Kj
         IClST68KrOYFmGmFkLjCPc2jjM4kTogSuqYqEt21FXJaazWVbRZwAgzBojtB/r54OWfl
         e+FKqUWav7NI4YYVsLA5//7EztuJkdDYXhvmfdPt+klJtyacSjCOkpfhZKZ78W/i6o+N
         c4qN2klfI2KVH0iYOIvMAz6wqOku/JJ4X33XhoRXLFW4wa+9PTeg44X/YwHPftTkOl/T
         IFVA==
X-Gm-Message-State: APjAAAUnn8bjVZ741g6VCbyVoYHAAvi5C0GsgBRbyW4LRPfo3fqGpwHH
        z8Hf+3lvxf665fHfrBkMMnlqoQ==
X-Google-Smtp-Source: APXvYqxmgt2KZUSfhP0WhnMu4qXXYy171DEbvOTGl4HbZC8mg21wvj7n7mf3SNBTff2ssAoZJs/pOg==
X-Received: by 2002:aa7:9aeb:: with SMTP id y11mr7426959pfp.63.1581492938059;
        Tue, 11 Feb 2020 23:35:38 -0800 (PST)
Received: from debian ([122.183.169.124])
        by smtp.gmail.com with ESMTPSA id b12sm6916795pfr.26.2020.02.11.23.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 23:35:37 -0800 (PST)
Date:   Wed, 12 Feb 2020 13:05:31 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.4 000/309] 5.4.19-stable review
Message-ID: <20200212073531.GA5184@debian>
References: <20200210122406.106356946@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 04:29:16AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.19 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

hello ,

compiled and booted 5.4.19-rc1+ . No new error according to "sudo dmesg -l err"

--
software engineer
rajagiri school of engineering and technology
