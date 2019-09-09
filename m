Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F50AADF94
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 21:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405822AbfIITkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 15:40:11 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46914 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405742AbfIITkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 15:40:10 -0400
Received: by mail-pl1-f196.google.com with SMTP id t1so7044557plq.13;
        Mon, 09 Sep 2019 12:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k2rJm4CvH7ItooDwGblk7C556UgxQ12QlPbAY4dgCvo=;
        b=t5udcyTTtFusDIAv00yIHTd8JqEAe+ZYWx63Ch1wybLIi4SWr/4uYM6l5hcqnvrpGY
         IXLNyEz2To25QeMzA2+EaFL+8/E1e7SaLpFDEm1Z/pvcmMNYxoa7082ShsS982ikDgYP
         C6OM1wxkehNO6hJGs3xhHdtnjEQ4zf2hxD4EFGPoe4TCFevakfve6hF+0xEWfF+09iWc
         d4z+rPrky50JaH+lTCtBxhEeZMTSTPXAR6NE2eKQj0fXa5i+kh0dnbEP5SXVyj4LSqP1
         3tqMFc3O2U/jbpHtIwANrFS+TLUTt9IWCpD/R1DcPQIa+lpO2e+tnbmAoyttlFBentqN
         UQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=k2rJm4CvH7ItooDwGblk7C556UgxQ12QlPbAY4dgCvo=;
        b=RXp61uNeiUHvbu9wJ9i0kSgqUqlcSA7PsCEvUVHSuisUwKpE9zWrRbZHkWYE+EstHP
         dJSLn8FFehHmBwlDAdGwDYyVppmURmoj3uM3OGhc5urwysFiLL8ebFzkRwCo3Cbxa2Sv
         KgQ3YQqim+PA0IXviq8KoAUTveDLCLK4nXaruL/K8jHKLeXcdvyhUxMTeR36rjsPN+8g
         ePFZ++VdE1+4+J0zhzyOL95eZ21ocIAtypfed42WsWYgvmRzit/+/WWbgVUNjBhBSZ9T
         fm3Pr6hyCCGFR3smfdA3rtMAuYk5cBBBCudvAjhX5TpqXGdhGNASdn/Hmbnj3ksrQcsu
         Q/5A==
X-Gm-Message-State: APjAAAWiE2GZb8Jl9Oa686IyMiUFs67UQVBukzSl+PqSgcsvwbjXpvZi
        XP4d3bODdjCNzjR43/Lnl6A=
X-Google-Smtp-Source: APXvYqw2bPlVQJ/6oKoqhHbTwK+WILfFIcVuWcQH+JPfKFpsofBZKOpHXPLi5dZ3GHd4OW0a+7ukKg==
X-Received: by 2002:a17:902:b598:: with SMTP id a24mr26743032pls.5.1568058009111;
        Mon, 09 Sep 2019 12:40:09 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r18sm14843158pfc.3.2019.09.09.12.40.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 12:40:08 -0700 (PDT)
Date:   Mon, 9 Sep 2019 12:40:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/94] 5.2.14-stable review
Message-ID: <20190909194007.GD22633@roeck-us.net>
References: <20190908121150.420989666@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 08, 2019 at 01:40:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.14 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
