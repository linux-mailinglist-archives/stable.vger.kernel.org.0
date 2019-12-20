Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 787FF128270
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 19:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfLTSuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 13:50:44 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36763 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTSuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 13:50:44 -0500
Received: by mail-pf1-f195.google.com with SMTP id x184so5701677pfb.3;
        Fri, 20 Dec 2019 10:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ak7VGqCjH/jK0JxWIx/zXhSXNOG6BUrxQ8Rmu2KD6CE=;
        b=BKn111MNvB0QoAOY8pnbxUhjwIgBr9HUNkGeF7VB2Z6sFbFqykqa3kb9qdhv3LLC+Y
         jiU6F5VU+5ax8CUKj4D1uI7p2eabylBaJBLMyZMiK6dEvSTQ1Oq5VrPUogQits5s5sU2
         pA40bp7tczWZt8r963ScrEGkgKypLL7sQCvi5jGlf/y7IsFc/wkinm5fSppfXM/TSxfG
         MShQsqT5sTHJLR2Gdww6+AsRlagsMRv/lHIJRM0XjRzcAdN5GPYQ0xuzqFfrIGG2l6Uc
         4fS8OYz0TFBfMHlxqUPWGiGBj2BYPjQhTNGKtK3MxMINVtX2M0wPY6Vfxbg7zrppDu4v
         wsdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ak7VGqCjH/jK0JxWIx/zXhSXNOG6BUrxQ8Rmu2KD6CE=;
        b=m2dBhyodiOwfWb3lS+h9NzpmFGtLb6Q27gwieqpTMtt2rleAPHMELQZeOTzCSwEepp
         fgeyQknfDThQqf4dh6eNzZyPzLr68/yNkEfKQ2L/sOI+nXLwlQ6Ft1JR7JmzUsJQ2xEw
         6xJtevKGI3ERQw7w/X8YgF5PAdunBejfk3SPBHAPy6mebwQCVi9C+jqfu2IkScCErBlE
         nizrqhU2f0d+ttFYHr9eGMyaO86OcN64cbllg0oSuVSESKcGpHj06iQ2lMwzgcxN+5gf
         +N557o3BCW0xFvjGqFjsVd14fY7zB4X7SkLf2anoWWZE9q+1nYPyERKYA22syto82Age
         RSDA==
X-Gm-Message-State: APjAAAWpiTi/5lAkJc31lXBXJnfiLAdJI5aHU5wgCW1X4D2H+z6np4sg
        rnYagyZcNXRM8daxOtZfiRg=
X-Google-Smtp-Source: APXvYqwOSBw1YhQulOPHVztDZwVIS0Viru8PJxZMXRGaSRHeBMWYLb2YwjJS67S67SeX+ppLYWE1uQ==
X-Received: by 2002:a63:5b0a:: with SMTP id p10mr16281847pgb.228.1576867843930;
        Fri, 20 Dec 2019 10:50:43 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x33sm12150402pga.86.2019.12.20.10.50.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Dec 2019 10:50:43 -0800 (PST)
Date:   Fri, 20 Dec 2019 10:50:42 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/80] 5.4.6-stable review
Message-ID: <20191220185042.GE26293@roeck-us.net>
References: <20191219183031.278083125@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 07:33:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.6 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 387 pass: 387 fail: 0

Guenter
