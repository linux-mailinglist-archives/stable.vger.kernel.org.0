Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02EB715E349
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393449AbgBNQ2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:28:32 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36520 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387964AbgBNQ2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:28:31 -0500
Received: by mail-pl1-f195.google.com with SMTP id a6so3917526plm.3;
        Fri, 14 Feb 2020 08:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eAgJCTJ5f6zk3egmSWAraSamzC/ZpzR8Kdw/Wbb3sCs=;
        b=JaTk9oXwJE6Og8KPrlO5WLnJEI3HxauxLzODJdsLQHMWd9Q5eQQLqskypvVOItKS0O
         FrlaSiZGlQR9EjKRLg1mRUbygHtMUGyYrFtWV1C6lCx8rUG61p4x4pycjqzU7+h0sl3y
         1wLwhWFkl6VWmXftNEGneFSxopRfAIzlDTSAFgUftmAiMbVkQLDScHtr+v17tCqriXqW
         mEegW9J3jvBfEIFZFrBxNlAlQomM1fwdD9i/ZB91qfrPapgE8thLBBdWmtds2Km1nZ2W
         WS1pHAn1mEglSS1ccXts5JHEPsOdu5fvki4SZHmRqsOIn9HVpqLLEVvDOQiSh8HbOQWG
         CQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=eAgJCTJ5f6zk3egmSWAraSamzC/ZpzR8Kdw/Wbb3sCs=;
        b=JC5iTcfYOD1EQyXoBxRweDIsUz3AmBlBcprJ7YZ+aaqwa27Y2eHu0YaEG9Z7JyR3VZ
         zjRuQGy1pYEYrRtyvZPWCeuekQDZiVrWB0sC1TGav5cIPt1bVFQKhGsevqr44Fo/fKIS
         U5tUbsHsRnAIZGxvhPCKRmw7+mTE2zjrJrqlVtu+qvcF1BZL6bNQowOvyuG8Uo3GaF/5
         hCDDniJ3N/ZqPPTPABi5I+1suOIfKy+jYH8Ro728giTzE1BHEKKAllbcSd84Cxw7+2hv
         zOYXNr4lp0UYMGfjrjWOr2JffEaauhsrchEylJ5MnBTpL+dGd5ccg+mPjckivot8i3t3
         QQ/w==
X-Gm-Message-State: APjAAAUhRiOkqcGt62aditBmEjK8Bc/rx2n+zEv1qzJi9pY30vzbUp+7
        cxdPDq/rPxEha3qStrByHKs=
X-Google-Smtp-Source: APXvYqx/imr2ozqHPsQwaezlVycn2a+GeK2WtZWcjDerIWnmbGTBej1vaS0+X67OXS/l8roEWR/T8Q==
X-Received: by 2002:a17:902:8bc3:: with SMTP id r3mr4235771plo.220.1581697711199;
        Fri, 14 Feb 2020 08:28:31 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b133sm7798108pga.43.2020.02.14.08.28.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Feb 2020 08:28:30 -0800 (PST)
Date:   Fri, 14 Feb 2020 08:28:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/120] 5.5.4-stable review
Message-ID: <20200214162829.GD18488@roeck-us.net>
References: <20200213151901.039700531@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 07:19:56AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.4 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
> 

For v5.5.3-121-ged6d023a1817:

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 400 pass: 400 fail: 0

Guenter
