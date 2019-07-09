Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAFA63A93
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 20:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfGISHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 14:07:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36730 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbfGISHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 14:07:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so5839517pgm.3;
        Tue, 09 Jul 2019 11:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B2a/rgdDQGAhNf7UNQxlkEWCp1DZGv4JFNOpBt0S4MQ=;
        b=O6rOeLt6DXckr4XHQSI2FzdY0wqzZV8/q0rJLVOX60aP7zXp7uO6EnHG1qiAcAZRmt
         /iGUfSdaW9pUvtJ1s9EeyKQ1UxHmdLwUIjAtZuxKr2ubfTyZbBqNAFpFiZnJHYZEH9Ga
         y42hchKjvBuYOCon4TeWCYo2SAIKciPLKNdFguRu7kUMYswv8CLtaVbDiXexb73SmRaZ
         ORQMBppfbQj/r0WOj3I3v3sddiGZXyXnR36IYXIj9ia50hPYn+oaTuEPvZpFTikG7sG7
         UDAvDkzkh2Q9MaN/kvWHek+t8hNWmPQsBriyc/8364KKdXqnEfNE4+l8H7MGfKPmzB5F
         WGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=B2a/rgdDQGAhNf7UNQxlkEWCp1DZGv4JFNOpBt0S4MQ=;
        b=runbWZ+Ud456EZW9FpT/TXTZnI4M3jECxj8LCdCUq8bC4qYeALe55fauP1JNr2ZwhX
         LWo5lMpBGqs/7g2Hyg5OxPlgN26xyL8/rdcTa6z6kZ/OKtlspLvqRov9HZb61Ly3b2jj
         xx2zHahldMbPK/xBwHXCBf9XXwQ0Z27IX97Mvy422Zw6PGnOPKIf6vCm7uyvpR8Xzyvk
         nguW2gOxBiaab8NZik+cB65QUxkJkS3UNQRjuEOjifW8r4E2DSiR+Muc8aTXBZMzmRpL
         p7CNj7tcFkuU9bw4c4g3fdvg4+PTmTSd3/AIPKr9xuKZhViAR2jIjYXvYjqS+LLsvhDa
         tC9g==
X-Gm-Message-State: APjAAAWarAHQ27Hzu3g9HwNTqTD8mFwSo7+thU6vgQv8DISL2N/6I4wK
        FDVz6NC7GTbFQg5JanuL0kqp6+/h
X-Google-Smtp-Source: APXvYqz22a1UUf8gU8z+MIyEJTwByzs1x/mZZlbKTSto79zKTSwr4nGD5a1Sq3s0+DRUBv2hHWjGBQ==
X-Received: by 2002:a63:7519:: with SMTP id q25mr213136pgc.13.1562695636775;
        Tue, 09 Jul 2019 11:07:16 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k8sm27341447pgm.14.2019.07.09.11.07.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 11:07:15 -0700 (PDT)
Date:   Tue, 9 Jul 2019 11:07:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 000/129] 3.16.70-rc1 review
Message-ID: <20190709180714.GA635@roeck-us.net>
References: <lsq.1562518456.876074874@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 07, 2019 at 05:54:16PM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.70 release.
> There are 129 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue Jul 09 20:00:00 UTC 2019.
> Anything received after that time might be too late.
> 

For 3.16.69-129-g91dfb9bc310a:

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 231 pass: 231 fail: 0

Guenter
