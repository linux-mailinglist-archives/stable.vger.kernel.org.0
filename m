Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43629082F
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 17:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409971AbgJPPQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 11:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409970AbgJPPQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 11:16:57 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB42C061755;
        Fri, 16 Oct 2020 08:16:56 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 32so2741895otm.3;
        Fri, 16 Oct 2020 08:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V/AXa/HkeuoOZLJYgxHQzzJo9a+rbKkCGiALxR72sxM=;
        b=uoP9uySt6+4/2UaMMCLFtlRbau8WVR61oWRx+OX2FSLMGqXI/6T5jOi+Pi7KpN4vrv
         hlLKvRPoyMYG1X07gVgqcAKwAnt9kexp9ZBCkJ/RzZ3WjBX9n0DIoL+YstcZLHU2D+YR
         d9VHyP7dl6mqQ2ieZMXOkP88KSeEGLEcenfi+8TRNIVNfGSPemLBxE2+8crXiZf9ZW6X
         dxN/R4wHbqjIOJ6yFIy/hMfkoZ0MPNXZ83CSR+nyAYvOcRw0F9eKYwbNMBQz9bLcZQzl
         LyeIkfNb5yaNnqbW6s7HjS5POjOCJrm1FNUcU58+3X0kJGHO2nibb9LjHd6x/Wtndx+g
         +Ojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=V/AXa/HkeuoOZLJYgxHQzzJo9a+rbKkCGiALxR72sxM=;
        b=uPY7ZzlCjaY/6xCHTcxc6CafW2+NqT1mOmC3gPcgMWI4ksbWtqWPIB/5fAvCFnKhMC
         oDlEXhVNHK4O5cKxjx6pVOxODc+vNA/4td9+Rk8zkc9O/uhwDE4zBkGX6rqpkGxLiiIj
         hYxzpr6PXpPhGh0YJTmm3mg52fRr5MFrq4PYT5lrDtAZGDXZptnHWds2NhnyjTQMvTyy
         CvanjnwodRb1iClwq1cmTwQhG6be+jBYlaqYkHhUpi+abd+1pTqgt4NTSI/+YU6nlpLN
         QSxjlZM4T4VCMm/Z7vMKsfB0puJ4kViezVjw53v50quJMB/b4PYrHPfmpw+gIezyqzKh
         EUGQ==
X-Gm-Message-State: AOAM531FGhDq9zgMkMxlhdhZgXdcW3Z+wBZGTUP0YWdFVtnKGCLJOeyc
        qfti1NV0/PkHiPCDvl+2S2o=
X-Google-Smtp-Source: ABdhPJzNElD1N5isgUGsNsJkZ6kpJrZmv82enZOn5BVJKtV/6tU/yOGRkk5wYreKIQXfx1VYiJ8w9w==
X-Received: by 2002:a05:6830:138f:: with SMTP id d15mr2787535otq.367.1602861414702;
        Fri, 16 Oct 2020 08:16:54 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u125sm1147503oif.21.2020.10.16.08.16.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Oct 2020 08:16:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Oct 2020 08:16:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/14] 5.8.16-rc1 review
Message-ID: <20201016151653.GB230162@roeck-us.net>
References: <20201016090437.153175229@linuxfoundation.org>
 <7138d7bce8f8da009119f0107eeb7c85f67057b9.camel@rajagiritech.edu.in>
 <20201016150021.GA1807231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016150021.GA1807231@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 05:00:21PM +0200, Greg Kroah-Hartman wrote:
> 
> > [   37.208082] uvcvideo 1-6:1.0: Entity type for entity Extension 4 was
> > not initialized!
> > [   37.208092] uvcvideo 1-6:1.0: Entity type for entity Processing 2
> > was not initialized!
> > [   37.208098] uvcvideo 1-6:1.0: Entity type for entity Camera 1 was
> > not initialized!
> 
> Crummy device :(
> 
I still have to encounter a usb video camera where I don't get at least
one of those messages. As in:

uvcvideo: Found UVC 1.00 device Logitech Webcam C925e (046d:085b)
uvcvideo 1-2.3:1.0: Entity type for entity Processing 3 was not initialized!
uvcvideo 1-2.3:1.0: Entity type for entity Extension 6 was not initialized!
uvcvideo 1-2.3:1.0: Entity type for entity Extension 12 was not initialized!
uvcvideo 1-2.3:1.0: Entity type for entity Camera 1 was not initialized!
uvcvideo 1-2.3:1.0: Entity type for entity Extension 8 was not initialized!
uvcvideo 1-2.3:1.0: Entity type for entity Extension 9 was not initialized!
uvcvideo 1-2.3:1.0: Entity type for entity Extension 10 was not initialized!
uvcvideo 1-2.3:1.0: Entity type for entity Extension 11 was not initialized!

I suspect they are all "crummy".

Guenter
