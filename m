Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A9A164D5D
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 19:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgBSSJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 13:09:56 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45935 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgBSSJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 13:09:56 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so438743pfg.12;
        Wed, 19 Feb 2020 10:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gUc6iYIu77GVSs+UtHNasOCjUTr8dlq5hQEQBI5NlhQ=;
        b=Swrz8HEMPaydU4pD3iaNBxrYpyGjbEh9IVLjgYHtSjdepJEcwt2ElEwsEZAaU7UVCK
         /LyNzRhfvrhBaGyzFHRlmd7PaQ7VKdWGh9cgoXCOEHqsX0mvjk946b8/ITR/N9ttaCiS
         9BVMedNjTXVwS8XDypMsqVjgiaahK7aIQjr2JA6nrCiaASRcaBMMzZqj0YJJVfATYsbA
         ueNX+P0KhlF7yl6h4yaXEVvcwYQ/Dm81RFzfwljfCqo7Q4VR8P1SCnxg07zEhkBlBdCH
         ADab63L9LSCwk0qwOhvGkIMla2ozVbs7zFQfCOsSGXAlgoU1er9+rkhEG979XsegHah5
         MRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gUc6iYIu77GVSs+UtHNasOCjUTr8dlq5hQEQBI5NlhQ=;
        b=ia9Qp9cF89uGfB/SGO27b7Uis/V4YqreYFBVDV08LOyT9oMI5s6esYbko2I6Rf8RE2
         UjDXD8o+2qOVPVYuAgqsXa0qbcnfj69jUVAS4IgrMmEpKe8Pu7RzRPfhBqV5I2A2KoVH
         imenwJHra+gC3RLIvz3EFeqCI2zAIyMBHYTdK3Js+RYHn6aVt6qxlVUEKtKaonMZTelg
         JqsjJXs2E42XVyylvje/F+YhhHRNjLNaN4eWjr5Bukk1ba75Sr04kgutYssaJeDthKaX
         GZ5X/HmyPDO+N8DZicAvC2Ry2ZKvbdlkrnbbw/yBAqsqV/gx+/K1dpha5egmRSvsDKk/
         jEgg==
X-Gm-Message-State: APjAAAUJ7a4gYpSwacCWaNCBZhFey6s0nWuhMIuZ6tpX25qHbdlv8r8d
        NDwlMWPvGc6SZacXMoMO2b0=
X-Google-Smtp-Source: APXvYqy+W6yax+vaDQzK1opYCAm188MW+FPRGPCSop9w+xGOl1ftSD8ieYYtwzASs0xbXF/UwodmKg==
X-Received: by 2002:a63:c304:: with SMTP id c4mr29775917pgd.85.1582135795851;
        Wed, 19 Feb 2020 10:09:55 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x21sm290659pfq.76.2020.02.19.10.09.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Feb 2020 10:09:55 -0800 (PST)
Date:   Wed, 19 Feb 2020 10:09:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 00/80] 5.5.5-stable review
Message-ID: <20200219180954.GC26169@roeck-us.net>
References: <20200218190432.043414522@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 08:54:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.5 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 412 pass: 412 fail: 0

Guenter
