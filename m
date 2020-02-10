Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAC815851B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 22:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbgBJVlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 16:41:36 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40250 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgBJVlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 16:41:36 -0500
Received: by mail-pj1-f68.google.com with SMTP id 12so317675pjb.5;
        Mon, 10 Feb 2020 13:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vdyK73yn9baQ3pTsUQEVOmqv7C5ZtRsphPTasUKqofQ=;
        b=Jd5xvk4TGEKAAASVYOhNqiwq97/3M5CrHEaChF7JBfZisC4EwvtpQqZmfaM+ybQrgM
         kWo6eW92tSnX0mK6fzRuYe2lt6elqEWL/qzxmXL1ofygtD+zsLcu9c5fZ0Xc2WjBVhJ0
         G4bQMTpghv6YOXUztwk/ABUisqAwe+Il8Gf9/YRLElPlzzEP4tmqLbOx9rOwv3MGY+kG
         JQt6cEIp7slcQa5UazA4/eootHthlvYYv/W0mCmBYGZrebW+d3M/4OclKnZ9YI+sSl6R
         t1zmY1Sn9rTp5H/WjyVp1cqtHsqesO2mVn8hCwWqcn1KN9t+D8/FtUy/sJLGbSUEkJAl
         OC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vdyK73yn9baQ3pTsUQEVOmqv7C5ZtRsphPTasUKqofQ=;
        b=bzmXqZPOecROo7ggakyyPOb+AtdcS6aeCmNVGNVH8/PPRftQQpIbVyS6Pw3UrhbeEl
         B2kKDqcK2ZcjQ8o0Fmw/1Mq3CyxBD/AWW28cy2gFqzs/R8WhSOEjt063mCSmfGdp3mgK
         0CXRmqG/Jv4tFensl9i8uXia0pJqElE1gYHmBaASf5/pormtYWCxtofP4ylNIGkGpueH
         VgaNCxsmBAYe3Ufi7XcFW4gjjvqex6bdReGu+JkG49FhLwOCCI4iXIO79ZZayCbFgt5K
         CjlVB8qmSyEE7a60QPpqjhLmdZNVutDIyQ8Ix2JD32+bK/0+SECgsl94TeAza+ngUNrz
         thYg==
X-Gm-Message-State: APjAAAXMmpZ3DFUDEiq5dbZABbYpKOEZqMJtRB3CoY25P8vp2etxJGCC
        JlWmhBItYrEzKkEcaN3cdck=
X-Google-Smtp-Source: APXvYqyGMcKC1mGDdDDjTMg563KOqUK97C2Sh/hWzQAHcR6DRwVldVBaaoh+fwJbgI9l8RONEsn4BA==
X-Received: by 2002:a17:902:7d8b:: with SMTP id a11mr13489203plm.99.1581370895897;
        Mon, 10 Feb 2020 13:41:35 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y23sm1306711pfn.101.2020.02.10.13.41.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Feb 2020 13:41:35 -0800 (PST)
Date:   Mon, 10 Feb 2020 13:41:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/309] 5.4.19-stable review
Message-ID: <20200210214134.GB26242@roeck-us.net>
References: <20200210122406.106356946@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
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

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 396 pass: 396 fail: 0

Guenter
