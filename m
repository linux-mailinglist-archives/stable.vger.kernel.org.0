Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1DA913B1DE
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 19:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgANSRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 13:17:48 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43440 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANSRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 13:17:47 -0500
Received: by mail-pl1-f195.google.com with SMTP id p27so5539296pli.10;
        Tue, 14 Jan 2020 10:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pTDm6uj7nXPZqYgCReR2qesU7OAfZp8TW1KIkVsDtsg=;
        b=TDtpxNdsmrScmiMRJHH/FVuHnOx9oBrr0lHnJy4J+VHYHVhYSlOiLQxvhQSVhFzkke
         KHtRQkUBlNqfU+DKKrxNo3R0GA5e2wpe5OFv19B9GNj2VQR3moju1ibBmNLgtFxEYrbm
         GvUH8L0M1YwWbaTr2NmjdO9udFhfriYHVlFg0pJIzftkFZ805vLmU7QP/2kvv5QjULKS
         PbSKTcsNhdL4Chxygp0OOTZN6HUFwAdt2yDP4ATCDvk5Mks7AL3tbTOevOojp6RFjT0s
         HBNnJVzwgHRmrzRlo+z4sriA8rJAKWl1aAs2pVTWAaciezvmqmthew4FkrmBoUuOtvPM
         7vfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=pTDm6uj7nXPZqYgCReR2qesU7OAfZp8TW1KIkVsDtsg=;
        b=Yd6q0oeobBJliWVg1okbh5jvQK3GK4QBO6ZLG74Mz81tct4D7twvH53OgdJZMsD+E3
         QfF31biHSRUYRytRyYkYoHuuP3t0O3WDrISRbG5xVXlyPEDrRyOF8bxT1CDvNBmYXtz9
         +Dgn7yCYeSJEQMvZ+Cy+LVJWABvs6ppySvhx6EBNi+OL113CVYrv6OzdC3URAzPOsz9H
         s7V/LJzEnkkmeAi31iCHWlIJYbw1DXHercIYCAE4/TzNnKqidZN5EBvjP30cUVXzxZPA
         G7iG9J34N7WbZY+p7rTOr2yujR9jIBk4xizVb+AXJMnOIcXeHVc9rOfb2oDS9O/FMBNV
         5MaQ==
X-Gm-Message-State: APjAAAWq55AlQ7NpvcVpUqYLh121t9hlh+ZV8pzntrrMdlS2M6ER7q/q
        zVqh43nX9ye0RWTBBTF8KJs=
X-Google-Smtp-Source: APXvYqyEwNUVk4bb3HJz1Xqyz5CcuVz21L8us0zxIA63STCvqg6FpWv+rGvZjJYsxlGv7aVmB32mNw==
X-Received: by 2002:a17:902:aa85:: with SMTP id d5mr28350689plr.16.1579025866843;
        Tue, 14 Jan 2020 10:17:46 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r3sm19490818pfg.145.2020.01.14.10.17.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jan 2020 10:17:46 -0800 (PST)
Date:   Tue, 14 Jan 2020 10:17:45 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/78] 5.4.12-stable review
Message-ID: <20200114181745.GD18872@roeck-us.net>
References: <20200114094352.428808181@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 11:00:34AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.12 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 389 pass: 389 fail: 0

Guenter
