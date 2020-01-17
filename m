Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF48140E75
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 17:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAQQAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 11:00:24 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35954 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgAQQAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 11:00:24 -0500
Received: by mail-yb1-f196.google.com with SMTP id w9so5777850ybs.3;
        Fri, 17 Jan 2020 08:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=R6gBWA7SJp0IcPVqVM3hwE72NvzIgdBdGK4yP72/Gwo=;
        b=ruUfKV6bHwzTOS5F8ooHLNOmfdUm48sa+7jU399UnMsKjYXNBXtZHGwtMpflzRuSr8
         WXMKeqPFsfFDE54N/H5z7YuaiJedtzWvS5sKwnpBjgHFEhAgH/+5dtZH+OnTvDGhIfkz
         qzDneArYZPr5nULzpyKcHnQ3Dh3DKNvFc3dB2wTz9FOA3ESOyunDdYonVtEj9GQRWqK+
         VGzPHJIUkfSh//RmDwGo5+SQdIxTM6UpyXcbDIgiBr97mNQrnLgLRfZYwwWieMk3jeE5
         lYmEv6A2F4qX8bKOmd78SJKjK8Nh4YhXzLae5Usw/XbsSch14dJZe2C3oRkFyw4dNYCL
         Azmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=R6gBWA7SJp0IcPVqVM3hwE72NvzIgdBdGK4yP72/Gwo=;
        b=fnlKM1MA97soE7Ons/aGjKckyuVseiq6yNTV96ZTZlZn7X9ApC2nEG0ypcg8R8mRYZ
         bZF6ispOPbhJz3XBUCwqf7622cVL4ZV4wowAjuZEwp0ZXkRACZD08ux/kkIt0Qf96kdD
         b4xbxAstwq7HGmMpmrYEoM/GOVHlUWX7a8b39leuvJbnPyIwSNtlhcPzL4pc5TYizOYw
         zrbNHSzD5Z2IBUSV/G3L32qeABkN09IHfQGNdLbRMk1rPbCDezFlhYidqvO4qdTl1qd2
         Antfk5at6d7bxYwD9BC1E7e9xDb7Ch8ZMHrjFBd9IomlJXfobJTL+4CMtRQKW7w2KYW7
         db8A==
X-Gm-Message-State: APjAAAU6Li+6gvSHE8GEc7XiZVYM1EQVny3X8yn/j3QBDs/iGXEX4MYR
        +RbhntI5MpgF8LG6pxzNfTxq6Qqb
X-Google-Smtp-Source: APXvYqz5wH0WCn9zkrIzZPKEQq5O51Es8+lkzehbJ4+QO5ND36pLlkfc6zOX1ZqfACeo0xTCAZjCFA==
X-Received: by 2002:a5b:7c3:: with SMTP id t3mr25264044ybq.261.1579276823950;
        Fri, 17 Jan 2020 08:00:23 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g190sm11083367ywd.85.2020.01.17.08.00.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 Jan 2020 08:00:23 -0800 (PST)
Date:   Fri, 17 Jan 2020 08:00:22 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/71] 4.14.166-stable review
Message-ID: <20200117160022.GA25706@roeck-us.net>
References: <20200116231709.377772748@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 12:17:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.166 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 375 pass: 375 fail: 0

Guenter
