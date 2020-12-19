Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6D62DF1DD
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 22:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgLSVu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 16:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgLSVu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 16:50:29 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6255C0617B0;
        Sat, 19 Dec 2020 13:49:41 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id o11so5476726ote.4;
        Sat, 19 Dec 2020 13:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h4h1GWJDuHU3MW49OR0XUF3Aew5S3WO33vPlpAX4rhQ=;
        b=otwauZyEHXfgI6QeZ6ZpNA2ls817ykRAsvIAf36g7d4JCoJfQNVTIZLUT0VzhyME9M
         BeklTi3h4FM/Ar8o7oVKzg+Gqa8vz+bmlRGcyjnvHhjamcpIps6PA3OmwgfL9eh6VbaE
         1wMVDsDiJq86YZI+30lrcegjEvUVR09hx+u3U+rRG4iqNPCmLEf6QpJiuVH+4//Ausoy
         /eIpzLVZ5YZT3x0deXZtbOM2LTuQO9UV4Azn+xfpQ/JjGtkDedDioqLA915zrECSC250
         t/vhbxU+QZaRV4RWq7wIjIq9i+VSVTbGG5PiC8qNlv6/p6INIKrixTn6wEOEUVFdKcsZ
         2Aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=h4h1GWJDuHU3MW49OR0XUF3Aew5S3WO33vPlpAX4rhQ=;
        b=QubGxzRRxrJ3jl8cSk1bwX5MZVD9CP+5lteOd//sos5s4bKWfT93D4NnSnNfMMR2Wb
         oWHtg+jsJgjBdal0UkQZZMiwR9pP/QdYW8YzrOTU71st3ariqD6iYhSJ10wHPXPtFZfq
         hL2DqlNYYk1rjVWR4dvisg/CSnQcypUwSZUTJW81alWhyk2nVgEqYju2g2kJmvu0G1QJ
         OsnH88u5xs3rWLim23AloelwS8BvqyaemJ87kN3StlPJixRhv5pwDSg+w9bMKJkMmM4e
         0oJTWyP+VTG4gr5CXo7SAfLAHj5xREjVPr3X2BBkWG0yw73fDXNSpbDa6ZnUmZhBr8yv
         274g==
X-Gm-Message-State: AOAM532ivoWtfB0LNceMAUC6UzpXFmVvk/Xn62HPvz5swHd4Hu0lyNnI
        i3aX+OzxH1SClPwsA8SmrBhPeWiHh6o=
X-Google-Smtp-Source: ABdhPJya/0jt6uMVUmWyXhSy/VN8/k2wDvZE+XBZqZDEriq/EBfBz8pLfa5s3S7Kv5u0IAUf9fao8Q==
X-Received: by 2002:a9d:a78:: with SMTP id 111mr7225734otg.94.1608414581292;
        Sat, 19 Dec 2020 13:49:41 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o17sm2792439otp.30.2020.12.19.13.49.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 19 Dec 2020 13:49:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 19 Dec 2020 13:49:39 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/49] 5.9.16-rc1 review
Message-ID: <20201219214939.GB22593@roeck-us.net>
References: <20201219125344.671832095@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 01:58:04PM +0100, Greg Kroah-Hartman wrote:
> ------------------
> Note, I would like to make this the past, or next-to-last 5.9.y kernel
> to be released.  If anyone knows of any reason they can not move to the
> 5.10.y kernel now, please let me know!
> ------------------
> 
> This is the start of the stable review cycle for the 5.9.16 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
