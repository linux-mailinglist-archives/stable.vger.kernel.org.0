Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA258EF28
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 17:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbfHOPRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 11:17:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33580 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730775AbfHOPRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 11:17:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so1443066pgn.0;
        Thu, 15 Aug 2019 08:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Capc8RSyL7Jq/nAElF45nEuLDMmShxHamk3+6H+TCxw=;
        b=uppge6BdlsuQ6OnSbTL7myTL9SpB2NduxhlK0V7hWBM0AagUp2gnt1azISlkyC+Air
         h3DEbzDGaUq7IK5RRNqPAOjXnbCusm6KEve4AvDPJUUJsgUHQfjyxFBxdW/uaKBjEAuD
         rVibezcQ1AHKLKx5fZM+9yFKdmQkfc16uMCBPyfDG8w5Psh76XyZXDHfodcT7v4oqriq
         qJaIRqPjDT3JPJ2hl9paBZBGzgpKMERvBWJ5sAxMZmeRUNUr/0cW07zJmA7+ao4fizMg
         MshhJF2IFIF9cYudHd6wF9qAcnc1f1eEScEm0oHjv7VV8DRkyl58kMdK1+eZvDdviT2b
         2pcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Capc8RSyL7Jq/nAElF45nEuLDMmShxHamk3+6H+TCxw=;
        b=lkW6M/DPdyNMH8ZcDEowXfBK7VFmcBPxNwBBLMUGh31GupvQsKqKHjxuVBYMKrD9vx
         NpXaohM2ApV8WbO4WIT8YVZMYnKlkECHCX+hfDFYTZpJbXhp56VdnwFg8keM8SHJN9K9
         YKVlriYzGvXLbhONqQzgHf0ujzHLNlXF0NC+BQ+Fwtt71/9dPg4TQHCo/22jpKxy+n9u
         KJwE6Qp49OTpbY+vPpjsIvj2BRrX1upQkeC0It0tyWX15+F+sEX0nG+D55XAOdx3J7tv
         I3hF2MbcGTrF3npCSdeK0UlG/yAUvV9S3KoaYSsQR/j+9hKQRnT7RZrB/GjzjpyWqGFc
         UEdA==
X-Gm-Message-State: APjAAAVjh2jsZZhNu384Nmoo7IXASXapWNnQFOMIPXZUGygeJ96cYvnU
        96tFzQH40dWzTjjMfPQlQhQ=
X-Google-Smtp-Source: APXvYqxhBDqa6zUSDMy1wcOj5I5HtqqSiGmTMhh4tTVqBd5B1AUSs7KlPUwyR5tbGO8nZ4NIc80eKQ==
X-Received: by 2002:a62:198d:: with SMTP id 135mr5873654pfz.169.1565882272535;
        Thu, 15 Aug 2019 08:17:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s7sm3407444pfb.138.2019.08.15.08.17.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 08:17:52 -0700 (PDT)
Date:   Thu, 15 Aug 2019 08:17:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
Message-ID: <20190815151751.GB23562@roeck-us.net>
References: <20190814165748.991235624@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 07:00:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.67 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
