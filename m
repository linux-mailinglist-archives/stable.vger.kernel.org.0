Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117342A1A7C
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 21:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgJaUJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 16:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbgJaUJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 16:09:18 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FE9C0617A6;
        Sat, 31 Oct 2020 13:09:17 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id z14so2409206oom.10;
        Sat, 31 Oct 2020 13:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eMoSHc2uNC2YaSp3RaTeoZY7BLRrcEGKmLlufKOkpg0=;
        b=tLzjiJXL9ej9p9lRSw/XkeE/FW67vOMzeAb7tCJI09iyU6qnaoZ10Uou7zBn+gkFmh
         D5xjMsVvvjhZgwrfXuQLyu6prjQ8OO3HMBkv0ytxoZvSq7HhZebdu2dVxt43QkdxfHc5
         Yx6bcnr4cSkUJV3C0q1pa+qTMR3JMZ3PKbMkf2gj3MTisKc8OX00SQ8x1YV3nJqlnaV7
         S4BgKD1dRUdwUGc3QyUtV/3B4rAxYQFEel1GutEsAx0eMkg/B4W4m0PiIf+ScBqd7J+R
         BMfpEc5BpAK3JbY2ruX2gzg9HQPaUVDi/hVYa/m7JbDl6HZ/V8aN4xd4smFHtp2SAp79
         OFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=eMoSHc2uNC2YaSp3RaTeoZY7BLRrcEGKmLlufKOkpg0=;
        b=LqjQsoMQx5QUpM7oQHhrydeNy6NIxwmEinKzmZrmKHWMJ/UM+Gk+fq0HIPJl6mszA9
         +y736iTccdC5KksQs+VvzgPaohVcboDEIPXjcXH80epRzOm3SwBTSkNur8xA31JgKZiD
         RItUcLvHS5iw4hU+7OyiiW6zle+AD/GPOKSnszVGrHkqIOKbgQQqqDxW73VSjJefuXYj
         hE1gO2rZa0fqdHK4we0SqIAFnmQGPwLIrW6kg7cK/fFbqEACqelTLzH9ENgH9IBx56BQ
         uGvT6LNAxbuxKrQozjbwsDrh2OqG+YGTvkJN2XUEuSxlD0T2ulGTpkEUlvUZQ4B5qza5
         IZBA==
X-Gm-Message-State: AOAM5320nuBKkSi0yQUlefAej09m0L7VTCnO+AQJcCPMCl7eHOGKBDqT
        JnKvJ6fVADG9mGqrh67oPyw=
X-Google-Smtp-Source: ABdhPJy08/HuoymmbBZtkj5u9ZOR7vdHNWT+efP1zjqsqlQ8N6HUn5+7CrdL5oiwJLLwjxJwfrLjTw==
X-Received: by 2002:a4a:b34a:: with SMTP id n10mr6654963ooo.46.1604174957329;
        Sat, 31 Oct 2020 13:09:17 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u138sm356840oie.33.2020.10.31.13.09.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 31 Oct 2020 13:09:16 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 31 Oct 2020 13:09:15 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/74] 5.9.3-rc1 review
Message-ID: <20201031200915.GC45965@roeck-us.net>
References: <20201031113500.031279088@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 12:35:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.3 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
