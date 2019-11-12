Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9270CF987A
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKLSUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:20:42 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35693 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfKLSUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 13:20:42 -0500
Received: by mail-pf1-f196.google.com with SMTP id q13so1511869pff.2;
        Tue, 12 Nov 2019 10:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hoIdYArAtXT1XAvEyhVfY/cTOR76azkKwUT965M4Uno=;
        b=WV+yjcnWPkSnd5NrSR0LgfCIFpuPXqi3ex4HJhWT4maC8gSqlX9oVzJ7V5usBNeKfq
         MOjQllK+u7tIdtC91lfoTAAtcJR8OLYlL6GwDvZfAcV7P4uDrcpcwugEU8ttu6ZkeZWi
         2NOAu6/Zx4vKXg6j9/vVEu++va69UFzkEDBmIxAgW4Po+S1Y8TRAzAef5EWCJZIyT7Ss
         K4/RHacXNI5Fs3ZbAWllZmEi0kSPTmJW+qAFpSd8esrmaUkDwIu/jtEKLEul+TPROtEs
         pgz0kJ8kDfk5A1QL9pAHCxtJiBpKE90MwHaSKdsD8DNvdWOX9H+dLz/Rcwg6bMBS0hNp
         8ogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hoIdYArAtXT1XAvEyhVfY/cTOR76azkKwUT965M4Uno=;
        b=b6IOoL5kYa5e04JjvOzzp9eeP5PvyThDDLeks2D+GfbzZ7OAxPdir/aRJI3Bcx3K1t
         PhgIaB3qkVnv+P+qjCv3IHsEx5TG99pIIPryr5sJlknHrdPDVHGhENoP8tiPOFXZ8yFB
         ru69IuSxA0pm6JJfaa/k0LBFN3/hZNxyOQy/OIvyKqOW/L5nAEyuf4BUh/EkY6k+Pibr
         HBSblJB8B38wThoNgHRTjP93ns4GJoctXrE5LL++W5rjeB3fUcpYH6ik5452ocJaJFiP
         541MNkxExFm0Ayi7p00YIcmtmXfIQ4NZCs6lVRfL7+/UES7F7Lokk55J3dnovf7v9hyq
         DrlA==
X-Gm-Message-State: APjAAAVtgOebLskYdidtmY88CuN46dO/4xdcYqqRkB9vhBfVAN0jDt7Q
        zSjcI9f++UY3cg7Et+5YfxU=
X-Google-Smtp-Source: APXvYqy1jKdYp/BF6yFEBuL+fQeGh6JfwYmJ3uUzNktUZwwZSYPjoNL+LlKMeZ5HJoJVRXT58Vvcow==
X-Received: by 2002:a17:90a:b30b:: with SMTP id d11mr8237723pjr.25.1573582841801;
        Tue, 12 Nov 2019 10:20:41 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i71sm25622070pfe.103.2019.11.12.10.20.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 10:20:41 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:20:40 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/193] 5.3.11-stable review
Message-ID: <20191112182040.GF30127@roeck-us.net>
References: <20191111181459.850623879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:26:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.11 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
