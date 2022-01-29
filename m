Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F524A2AD2
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 02:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351946AbiA2BE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 20:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351945AbiA2BE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 20:04:28 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59307C061714;
        Fri, 28 Jan 2022 17:04:28 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id o9-20020a9d7189000000b0059ee49b4f0fso7401276otj.2;
        Fri, 28 Jan 2022 17:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ik8YQ891pvmkpDkBxKnymFMif/2T/cw+f5yDRvjXSk4=;
        b=pqfs5ocZYtuu+G9bqEsQxYMNa17kEluT4e+y2CP/9a+AxCvnf0ZPrnTt3sy7bvP5HD
         9ngBmkyreg8eElVSvK8vqrhMJjkbIELJ55RClBoUxzkm+gt76IQj9axQbWKWncvwKiS9
         M5y2BhiguERMcw2fUMVN4OSr1d78C0/6dZy9xNCOAUfnYEdha2w0g5lch68I6qGCv+1D
         MiR/57ibd2zWPot+BHrm8lM7ezRLdvcRTcHICpZVjOQW1A8BsMaF3ov/gUKiX2lVkUnJ
         fo6/xXbC2oeaku+R9EJmve535Id3iD9ZMjicn+lt/woCNssqlpSoGoovOXR7EZxZj3c9
         zz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Ik8YQ891pvmkpDkBxKnymFMif/2T/cw+f5yDRvjXSk4=;
        b=FXHcqI4ePZrIjNXAlD9u2GHEIOmhaQmZOeANsLJVSCjD5l4VPzJaHuu20+zVNNxH5U
         RGEQoepIuWuz+ikFbOSlNsHw81EnaMmsvAAjgrtuJC7tjYIbN51bHgDfO1XeezrjtsRx
         N/au5ypq9CBzAI+abV43+EinZAt3laCi2NUmqwsT99+Pl2zFlycK2i+yQnkriTEEZOiI
         9m8j9r4FTfdNuhMj+IruyDeuaD03VSWLVWGqw9nSxdlypKZC/gJmIGSQSXq2oyW/c6NX
         vO57IYFtTJf4+UkE+v7H/7ClwwOOuJ1Ljk1d1hXFt19r/34v7gKtEWBQwJ9K327oSs7J
         u3kw==
X-Gm-Message-State: AOAM5333dmFc+qJUDDw9S863n8tNkNi9mKL10AtOhvSSwPM65iPYNw/f
        XsdNMnlzJrO2GUeehSkL00PH3JTXedXHEg==
X-Google-Smtp-Source: ABdhPJxzGnrNGqoHvhin9pCZBLdXMyeyG0BdGEfTqcfXterVug9a+Hj1UCfWphHg4t1XMbdqAss99g==
X-Received: by 2002:a9d:356:: with SMTP id 80mr6479549otv.335.1643418267732;
        Fri, 28 Jan 2022 17:04:27 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 127sm9531309oih.8.2022.01.28.17.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 17:04:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Jan 2022 17:04:24 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 4.4 0/1] 4.4.301-rc1 review
Message-ID: <20220129010424.GA732042@roeck-us.net>
References: <20220127180256.347004543@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180256.347004543@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 07:08:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.301 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 342 pass: 342 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
