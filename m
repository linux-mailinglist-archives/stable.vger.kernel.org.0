Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0568263B45
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 20:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbfGISlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 14:41:35 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36122 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729222AbfGISlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 14:41:35 -0400
Received: by mail-pf1-f194.google.com with SMTP id r7so9727303pfl.3;
        Tue, 09 Jul 2019 11:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yvt742O+duVAEGX5Myn3s7yyzU8e8C1p/eBX0aAF7XI=;
        b=CviQS4227WWglSWG8qgA5XT7mW+A4xU06IT2IyeLGDyP5TRN8t7/1mgq3BG0hxN8Zu
         TDtJSCduFuH/WX+J4DGmmHfviKatH6ExyjWhnpw7CQqrwqqGBKYs6EApkWfCBW/6BbKR
         0E4mghBGRceyFuU0NGI2VkHTOj6xvGvDkdy+S7xN8xTqKxW0ztR2xgvrv2+hk2Ibh0zs
         jAbXe4rdSqounE1TKmTLj1jtG59LJQKQAtMsBs4XbJKpmnsE2XX5HnWNCCo+di/3NTDH
         PvLDmjMore0xZE/e2bKZSK6JTEkZQq++MzVFWzwOid48cMJYly0wCpQCKi/hqyGErrQ0
         36wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yvt742O+duVAEGX5Myn3s7yyzU8e8C1p/eBX0aAF7XI=;
        b=jAsruwfZFbX4YXxQwwNE9UFFIiQCQcHHHq2hyNhrRfsW4UDU/FahLUEkKP0NCAw/SS
         v8a5zpmwGpTP+qHFIoFhkq0cFYu1i9gP+ELHIYrXIaovCwgr94PuPfAmGsHkJ/1EfzA0
         mVjJJ7x8RynSpgXIK5f0lci9fnak6+qIpgo9WfESFfTLeLmF0dYLUBb8F6WFHxyvVaSp
         K3kY1BBq6iYjEV1fSSEbYzECLzCw1mW0aAjJNPPQji43SYIa/CSRjstie5h9PGHRxPmj
         m4+UxCkQwSmgGHz4sqXVlSmoX2oN863SL5D38D7giAtJhTYDpv55EMo0HtgiQINoPOvv
         KVlg==
X-Gm-Message-State: APjAAAV7G44tf+uo0Nnf8D9YXSXeECtZvWHSuGPf6DxdYLoMOE3ZZ/TJ
        8UUs++8xI+pGCPS+bVOmAgI=
X-Google-Smtp-Source: APXvYqwd8vvQ5n1f0ntwBC5Pw+a8jgR0Mb7SmQOFPJq9SWqwfb8TqhwzQ1Z4Omw7XnU3m2+GLADdAg==
X-Received: by 2002:a17:90a:8a0b:: with SMTP id w11mr1617772pjn.125.1562697694806;
        Tue, 09 Jul 2019 11:41:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a3sm23242179pfi.63.2019.07.09.11.41.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 11:41:34 -0700 (PDT)
Date:   Tue, 9 Jul 2019 11:41:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/90] 4.19.58-stable review
Message-ID: <20190709184133.GC2656@roeck-us.net>
References: <20190708150521.829733162@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 05:12:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.58 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
