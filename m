Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE6D140E85
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 17:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgAQQBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 11:01:50 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:40378 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgAQQBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 11:01:50 -0500
Received: by mail-yb1-f193.google.com with SMTP id l197so4695319ybf.7;
        Fri, 17 Jan 2020 08:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G1m7fwdipTUrgXKvWUzuO8jGlXuTbd2dnX5HLdxRAbw=;
        b=K7yil8biJXivZFq89eCAVb75/rniuAHi9cRBM2jxFqmWxE1Sw0vkwpa3k274KPSqTZ
         PMRxPLqMsTTfYMLy16B6IZJWo1SKFvPFosH/RI/keGPhlhpZ3lpLtoSf2T/OOKY3Bxb9
         WHh5ootfqfVNuT+BEtblOL9VxkGnJLO8F9FvzLMSeoK6wgWQPxkYZRhdPwzukRtxGpjB
         8u4IJ56Fj2rZ2Gdrzg/J6Ap0jvVG3/K/n+edx6XVtJzmv56ypAv8LaeX9pOpDycSTDV8
         eRhDKmh7FerGEPNoE1Rz9eCnR9EI3VGM49G4goKuFOJ5RKeC8JVTs3uTpzUPyn33GxbB
         R8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=G1m7fwdipTUrgXKvWUzuO8jGlXuTbd2dnX5HLdxRAbw=;
        b=feRLYTjA9xqZj5SYIFtX0d2DXj71vgmNb+5NXtTwlSIPFr0sHWq3zV/Q8CMyK2eJ+1
         cE16H8xmvE/4FrChGALGNdMoEfUkkLnCOI3NyPU1Lgu7N5ZKyx7/nrXqba+XrUjI3/SP
         v+Td05KlKY49l3HoXDcYV8KnVMqlhGmpb3Dlxi14Im1x1ICIdJHVmOnGa7cPyBNak8Az
         bzLix3VsNMDvKcq3AGu0s+FHK4uOe1hsil6nPhcdKgYdgXY9l0W+VXixvcLyhWfmF6Ys
         3/hqJBbPjRLofwA7kfDfNggUUtRffuRBtSXF1U12ChW1AiIMHwuOV6/TAlnKLQqY4747
         zq9w==
X-Gm-Message-State: APjAAAU6Wx1rwHHuAZRuNracpW5vkAdXMdiBRS3qbYbsw48UnJQIxdfm
        UpWJu8rPmsNmXBaD/k8hao0=
X-Google-Smtp-Source: APXvYqwWhJbcJJ4v8rxGtVJ4XVwhdMD7O1nSa3sJO3UwDQQzybYU008Q6WKHDa/t/Rvr/1e3M4MI9g==
X-Received: by 2002:a5b:788:: with SMTP id b8mr17173343ybq.223.1579276909205;
        Fri, 17 Jan 2020 08:01:49 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t3sm12058062ywi.18.2020.01.17.08.01.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 Jan 2020 08:01:48 -0800 (PST)
Date:   Fri, 17 Jan 2020 08:01:47 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/203] 5.4.13-stable review
Message-ID: <20200117160147.GC25706@roeck-us.net>
References: <20200116231745.218684830@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 12:15:17AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.13 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 389 pass: 389 fail: 0

Guenter
