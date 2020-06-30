Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC9F20FA64
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 19:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbgF3RUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 13:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730584AbgF3RUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 13:20:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13F7C061755;
        Tue, 30 Jun 2020 10:20:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i4so9763366pjd.0;
        Tue, 30 Jun 2020 10:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6t7g+Ebmk3HWeCBQ3UwI9AfnBADQabi1L2XSE+VG9QQ=;
        b=HG/P2MUaGllU2YggEaqw5S2Ed9YCQywfjXkDCwcl/C9W2st5LlXxHG9/wFflQBTkv2
         1vc4i3D+irlmIzYjIFMy1x7mIdoPkt/OzOw3pob5vRsoBYkBHPUwmkCEDjz7CJpVzai9
         G9tyhTTpTRxUj14fzsjIsg4Ra9MzcbpL4aBobLxlCs6EL2Zm1JyonuFW2rNKLF/YDHMc
         t02tyPMCClir+5Hqw1//xelYONyNGALoXGSsAclccntyWD/6gitq7p/wfbjNaREbG2uT
         fGhuLpx4VzGj9k+dWmS3A391JYSLderL8pD2D3rWy9uDP1f0JQc+LnVC12UWZNXfhsKd
         I5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=6t7g+Ebmk3HWeCBQ3UwI9AfnBADQabi1L2XSE+VG9QQ=;
        b=j1Xk20HwFPr3CrGLyFOtshY+Kexok3ESpILC/MGNmOPXe+HbnHLECUIrVZD70d55aI
         7wuR0aQfEth2XVKW7/ss1W/2JOr0VqnKAvJTyxOHHVwFMecLg1q9de7CVlO7uK8QbYPd
         Od8d/1J1kB3y7mbk7CvquA1Gkbzl12eOejPKworriIPcbmHe1+IIM1ry6oe3UD+VaiWy
         /cfNg7OLKP/YctfLaEx/r9M+fBavUopNkDGWMGRuAODOSIH6hxy2vWuAoYw3+4ZPEh93
         jSx5vZtCjPgxQsN0YRiY/mQwkdLEy+cGGZD7HNjPQt0Ew6ZeCVh1rYgwIvKvYCeFbGXm
         5YWg==
X-Gm-Message-State: AOAM530acBj4ykAJUdBJOyj4+MQbS6awlQWiTFb9BQx5b4h8IplRjnzp
        3JS0BB+oZTOL+5p6yF1fRoLQnuh/
X-Google-Smtp-Source: ABdhPJxkCqbDyJLorhIgDocL6i3VNst5UG+PxsvNnrC2Qnwyx0zDdco3jdZy6lgp3juHQgD7ex9Fmw==
X-Received: by 2002:a17:90b:3612:: with SMTP id ml18mr10686088pjb.193.1593537604500;
        Tue, 30 Jun 2020 10:20:04 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bg6sm2833718pjb.51.2020.06.30.10.20.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Jun 2020 10:20:03 -0700 (PDT)
Date:   Tue, 30 Jun 2020 10:20:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.4 000/135] 4.4.229-rc1 review
Message-ID: <20200630172002.GA629@roeck-us.net>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 11:50:54AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.4.229 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:53:07 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 331 pass: 331 fail: 0

Guenter
