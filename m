Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8B52F223F
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 22:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbhAKVxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 16:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKVxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 16:53:45 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC31CC061786;
        Mon, 11 Jan 2021 13:53:04 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id l207so202187oib.4;
        Mon, 11 Jan 2021 13:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lRLHQrBsmM8y3UPFfn8A5mGgRAeHeudJ0ok0r7JIYRc=;
        b=nkgX4eWDomJAgKubpjuxOxx5kW361fJ80n9wlBS2fyvnjkBvTxkmP7L9c/fk+QzkRE
         Q3YZHsy8w+plXr9HSoG0SjDDGogER8mCq6rVQ8N14eIrE8hR+rEGTMQSBdkphZP0NEvg
         uJ3ScHw2bmLM+k55x2+xblJQd8WSNOyU3HLESYpCRecjAGlnB8YCj4XRpPWhyUvOJdoT
         5aGrLTpoGGeam94f1e1HCrVL7e2TtK6iVOvGQyDeVZlPRwbjySVFxa2xEENFmlzeUqc6
         HcuWQ7P2xP0fEWvMX/EItF2AZRr5yHsp+aOFywgnSKJs9r+PcFNsSb02GENxdAoyurl7
         B5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=lRLHQrBsmM8y3UPFfn8A5mGgRAeHeudJ0ok0r7JIYRc=;
        b=umA9OnKGJVuNxntNtGRrAYiGjacXbluFb04bZB78da4amx3g9NaFEdg6OdVVcQw0IT
         LYOwjNkf0JZWT5hZVovxZ1B7KWsNUUWXB7j8IcwGCFxCAXV1QC//PGZSk4KMGfT11sRw
         1WKFl9lzkj71V4nanIUCOfW6/2p8Q9rLZZfJqAxLou3/fFxMbpkQ9+ieqHcEcdfSDcWf
         ywR1HlG1RqMBKxI3uCOzX1G+/Fzu29hQtIHIAjCKLP7+zH12VgTaFjHG5Ddt68qEWdtf
         65F7WatZCrlbXgy8pROpEI4c82A9dyu8i4zmKlxL6QwcgnSRNqMZTlYPc5e5jQN4xTEK
         J3Pw==
X-Gm-Message-State: AOAM533JXuZLJyQWfxlj8g19SiZJFrp921FwvM74X5wIUnMqnPNkJPFG
        4mRuD+dbsrJDUwgp/+pxj386EVt+a9o=
X-Google-Smtp-Source: ABdhPJztiRRlLra+clXEXJvx43kK11N+Bzi99hvttBzq4v+mkHQPVaY6Vpx8oiZUU43KZxUKaYYBGw==
X-Received: by 2002:aca:fcd7:: with SMTP id a206mr509762oii.134.1610401984267;
        Mon, 11 Jan 2021 13:53:04 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c18sm229867oib.31.2021.01.11.13.53.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 13:53:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jan 2021 13:53:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/57] 4.14.215-rc1 review
Message-ID: <20210111215302.GC56906@roeck-us.net>
References: <20210111130033.715773309@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 02:01:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.215 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
