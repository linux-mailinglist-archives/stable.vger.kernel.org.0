Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6E949D186
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 19:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244008AbiAZSNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 13:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbiAZSNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 13:13:50 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E10C06161C;
        Wed, 26 Jan 2022 10:13:50 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id b12-20020a9d754c000000b0059eb935359eso108960otl.8;
        Wed, 26 Jan 2022 10:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cyJUcSlHkzGQIdTiVpLIZhlkWBHgn2YO+xMrJyYxG7w=;
        b=K2inkT0vfzHdmDPjKTw4GpjEONBWWElrCyBV+BXKSJHQWjZWuVBl2suASQLNIAVj8t
         KrmRmQmIxb8/t5ZRFsz3Oa1EUjc7GFcfIEcBQFPgALmKqM7qkYAKcQCea8Jeb6besuAm
         PF/31fKm0lxJYc8GQNiT0WhcyYZigRJwWEVQftzF0E7/6YljxclsKWuBQIYNwKT505oT
         cP+LYTasm5/cGJ8QAuh3USJwoTQzxiDv73I398QoB9ZZreIL7fDjCcP5dOoCl/Yx8UoY
         wc6rzNTCvWqIaCUaPyxx+4R4gPQC2HMEv5wjdyA9HKktqmbsnMkpcR2B/jU8hyZSixLT
         DQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=cyJUcSlHkzGQIdTiVpLIZhlkWBHgn2YO+xMrJyYxG7w=;
        b=J3mjw6lNR54S+0PpBQKw64NRJ6yAOkWjh+sKudRmjkpk0NNNPjahiH4MuE1aBXfqIF
         59t4hpXb2CcD0IAYH9GsWOGS5Cp50Tl74K5F9D+wJhOv2OpOJny3Oy6+B6cp5FsMNxyA
         Rw2O8TJHJ4Pzqv0LnStqDtp23ONuXSarqGd5Tqy3Wuw1NpGpIXo1lPgIg9wpZgNCMoAF
         Wr6ikHNyBGkt44rYt5NMZ4Lfw8tSHtUWlKBl2/f+gT1N/PZrhHu2j9bJaD4cJaapKZ2p
         MhD+v5OpntcaWqdMaB7h0YDqK52AGA0edlDyMBZp/vbcBGsChE0UCnr0m6dMMC5BPeFx
         KTTg==
X-Gm-Message-State: AOAM530PuRpmx4JCFu0wS4SAhqpzsL9i33Z3An6kWerfOWt7hldiq+/l
        zXoQhAB0a8N4qvgkxQf7G7EnUsN4HdI=
X-Google-Smtp-Source: ABdhPJyPDX0QRDbIzOsc52/ZmmM1rGVytUGwPzDdiWHcWC18OoS1MgggJ/RtQDEEL2OqPhKDvCxw/Q==
X-Received: by 2002:a9d:6a42:: with SMTP id h2mr20820otn.269.1643220829856;
        Wed, 26 Jan 2022 10:13:49 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v4sm4557340oou.1.2022.01.26.10.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 10:13:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 26 Jan 2022 10:13:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
Message-ID: <20220126181346.GA105372@roeck-us.net>
References: <20220125155447.179130255@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155447.179130255@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jan 25, 2022 at 05:33:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1033 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 

I wasn't copied on this announcement nor on the announcement for v5.16.3-rc1.
Linaro wasn't copied either. I managed to catch it, but it would be great
if you could add me (and Linaro) back to cc.

Thanks,
Guenter
