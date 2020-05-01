Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0E01C2079
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 00:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgEAWSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 18:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgEAWSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 18:18:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C937C061A0C;
        Fri,  1 May 2020 15:18:33 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id r14so2171939pfg.2;
        Fri, 01 May 2020 15:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MSZ85RFQ7IUhZsF9jO/p7n0EJoXIwqWHxV7g4grXlFs=;
        b=NXm40yQqR5jOz1kmv+KHZ7ALZri/nOn+acl0YxdqpgaOqYJDM6+bJL65F2UDkPQDzF
         Cy77/tZknrnvSfHZcHyvDJInaWGAGT3HGcDvPCgjbxs/4ttEFBHwmnc1MRsBtxceUmu2
         RYdEBhtOmwg1g4uRs/wMrqz+xS6bhUe9tuGNj5teZ7l1pXRcfqOEQSOhS3NVY8UCg9RK
         y+TJiqrJ0qUOje8lv8luyWwfBr+yoMsXN8ZVapqY/EItOqcqLSbqoJdJZHfi+Elo0L2+
         WL2iB8UmhfVcaRwG+JeOK0C46gXpwOpO7InJmusRVBGxRNuxQaedcFIQR5N/Fmdzja5s
         3ZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MSZ85RFQ7IUhZsF9jO/p7n0EJoXIwqWHxV7g4grXlFs=;
        b=S/JDYxOh2QmXpCCd7ZR7xeLsPQ1PeXIzHrLNteAar/VENp+sHGIOHkYI5Jpjy/e103
         RLBEcUZTPHSQdkd6KRFj0ZlA/AnD86VP6NxHI8M8nndoS99q+E7/f2HFZ/6ikenoJC/a
         RUOMVYcA8f0CM8mrd9DmELvLR66U72XYP5OFSCRV5Tgs3boizqTamHyT6md2iNc610XD
         i0wmZUwB/XSaopQFbkwKtsf57HB6RZeFHSiQbQ68mg65PeJHu2v3VO5GEDDZBltGfMCG
         gUXQzbJjLjyKm38mfkTpJZewPy6D56Ka3cv06JPdKWLwCIkVg6JQcpB8ZerWvzqRWRxb
         Sesg==
X-Gm-Message-State: AGi0PuapO/3K6oPc7jpJHkzEbJLGbwqVS/5+G6zv3AFy7vJpCfHz/UjT
        taZWbX1V8mwNSiFcYNCDZGI=
X-Google-Smtp-Source: APiQypKK3Ozzr5Yu0qzjmYA4ZsD/HMRzx1awNo2uacPpltUAcS/a7yg9W21Zz6IItVzKPwRl6CNZAw==
X-Received: by 2002:a62:a10c:: with SMTP id b12mr6465144pff.14.1588371512673;
        Fri, 01 May 2020 15:18:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v7sm3071200pfm.146.2020.05.01.15.18.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 May 2020 15:18:32 -0700 (PDT)
Date:   Fri, 1 May 2020 15:18:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/106] 5.6.9-rc1 review
Message-ID: <20200501221831.GF44185@roeck-us.net>
References: <20200501131543.421333643@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 03:22:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.9 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Guenter
