Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A45712349B
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 19:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfLQSTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 13:19:48 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36747 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfLQSTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 13:19:48 -0500
Received: by mail-pl1-f193.google.com with SMTP id d15so6475145pll.3;
        Tue, 17 Dec 2019 10:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QRUrnV2ctBufc3vuwyVJBVAmGIwqGwXjIHIDG3EICUM=;
        b=QtFjKy0kWS0vx57233gzf3B0ZK8Po5jhkVGNtZmgnVv1gsjHhzXiO5ZC/MdVgtkZPe
         BFaFJ0f6DVNnAsIK2jrOPOPwqDBMCMzokeCnpd1RNfIOzUA7743R+eDtjCKgJfZI7ajr
         7CtcAddbY2qXzN83cNTlpBD4kHx2M8m5fHr9Ebnwh90ttyCy5vYBRW04WEW1rlfkok64
         rM9KOPrQN/WuR2sX162gOJCsQ6oiLg5tvOuksNtB3KkOulTWE8ZsshH7a4J0zPs9F67F
         j2EwpYduZaRtsc0AGdI3G1QlSzXmA+x99B9xMYNosnlTZa6SFJFHU15xh5oAZchFvD5a
         B6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=QRUrnV2ctBufc3vuwyVJBVAmGIwqGwXjIHIDG3EICUM=;
        b=TBQSVX6UosquXBNMo8Wj+yvF3dnkxFuKii2G5LiIQo++625c9SicflkKfvBRb+bHEf
         o8vd76HFErcn4K5MaTGh6RdSiy8VzKWVwIwAEZRYQeIYQwCnJQ2qHpeYDFVsHDoehZIt
         oYJr37ZYGUsy1e9bBMbCkfK77+Cy3WqfvlCrF/YblRDcs9ae7VcgeeFg8Y5aQ1cDEbwn
         Dw4hllGlfygDjS7ha8w+lHAu/Tfq8U2Rtf9hR6C4gnxeQ+jJT50+8+E0VnQNbDfQfDpp
         GYX0uHE/eSbxLCcocqJlmolUQObdQHveBGGWbgBg0kmLkLa/qVXIekT+SaQFKxgHDhRL
         /5Jg==
X-Gm-Message-State: APjAAAVNrg+2Zay4/S8vWG/zSj6zkIsBZLXL5XdTZkq6RPdXDG1lCieH
        ScynKSsn+ekiTeXnUa6DgMQ=
X-Google-Smtp-Source: APXvYqxuZnB94ggYFTGdl0RWNmew9UtbgnQusQqfXFSpBobiK1iodJq/8HkTviOF+9qtPrLlavnfEw==
X-Received: by 2002:a17:90a:9bc6:: with SMTP id b6mr7822924pjw.77.1576606787719;
        Tue, 17 Dec 2019 10:19:47 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t23sm2709062pfq.106.2019.12.17.10.19.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Dec 2019 10:19:47 -0800 (PST)
Date:   Tue, 17 Dec 2019 10:19:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 000/136] 3.16.80-rc1 review
Message-ID: <20191217181946.GD6047@roeck-us.net>
References: <lsq.1576543534.33060804@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 12:45:34AM +0000, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.80 release.
> There are 136 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Dec 19 12:00:00 UTC 2019.
> Anything received after that time might be too late.
> 

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 229 pass: 229 fail: 0

Guenter
