Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECF828D261
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 18:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgJMQim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 12:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbgJMQim (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 12:38:42 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D980C0613D0;
        Tue, 13 Oct 2020 09:38:42 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id q136so23532oic.8;
        Tue, 13 Oct 2020 09:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zguI0JuEU9s5bd4nz8g8SURWdDV9HHhssYu4Na5QpRQ=;
        b=E4PKskjboAsrsjOxYBeoCsodQxtM9p7s3xa3JQNpoSkzuNSYx9C9kxnZOibOdvq0lt
         sGQP/xJJw9e/kFwC6lR2SVx88L+yUTCnOkmXyQsNCnDteRKlyooV1aYzwp3MYxZPVIDu
         9IN0710QpPBMif4eV3uiiFnzGBhZT9fhCspup7vl+NUJ1XwFd2cUJNW71NGG3UQabb7f
         alyVl9ScdcwNDXOFBEfIoQSw3jKwyTigSrgSV6WQ8cUEv6WO7Oe1kkst0tNPB9ic1QEh
         BWV+dxqoICRBiyvWQhhpAsWDQ63ULZD5pb0deK/AKjTwZZLTXwPZLwUri6uqOf803zH8
         FsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=zguI0JuEU9s5bd4nz8g8SURWdDV9HHhssYu4Na5QpRQ=;
        b=WfdHrj0HJtLYsYochgw4uY5EYoYWXT7ur5Ugt4LphRVC+53E4T232BI+y3sbZuSjHQ
         wQTFWKu/rg+K8rafV4OW+g42U1zbQ6jXqTA9YKCWGo0ECVzBsVuILnbtqT9/3eUqKcJZ
         PalSOf8EWAW5jAN5rpyCS7gAAQ30w1dvXngnOvJqvgLYBLyf2zv2SPsBi9lXP8j6fV3K
         //THVMlhMjB3bINCw/MQDQXif5UUwmaM8gxPgDxr96CzStsq/jBNWGqoXHv40M8vJF5E
         B8e+hKPELT44BdH6A8R614zzCr/bQky+zcY8O6BgkUFHWAD0lqg10dI5c+W5hRdWQF4/
         vJxQ==
X-Gm-Message-State: AOAM533azYyAMW9HjBbfi5FPpBUwWVWf/1ULo6AHOgQ+oWh+e672DT8c
        ty8jtY97WtKzMmI/fwwKPAhxTr0UikM=
X-Google-Smtp-Source: ABdhPJwiKuP0R4GVi7kCUGoZ7g2vBVVB+5z67CuevxAod7zZUuQcxUFEmDym8GLKgVNbxxufBdH26Q==
X-Received: by 2002:aca:498b:: with SMTP id w133mr347171oia.138.1602607121503;
        Tue, 13 Oct 2020 09:38:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h4sm129640oot.45.2020.10.13.09.38.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Oct 2020 09:38:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 13 Oct 2020 09:38:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/39] 4.4.239-rc1 review
Message-ID: <20201013163839.GA251780@roeck-us.net>
References: <20201012132628.130632267@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 03:26:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.239 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 332 pass: 332 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
