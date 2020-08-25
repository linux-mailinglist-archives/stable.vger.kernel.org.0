Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89BD251FBC
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 21:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgHYTUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 15:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYTUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 15:20:34 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E603FC061574;
        Tue, 25 Aug 2020 12:20:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w186so5402793pgb.8;
        Tue, 25 Aug 2020 12:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OBnsHqeoq1ssCskNolek0/pdvDvXdSwEEbO8sifQsUA=;
        b=svfRqNDyRcm6xGk8bZI7Kkul268lNf8ZbJHt7MohOnW1jPue2R729mm1vbdR7PVNNE
         uDsiE3ApHnFnhTpl90mLHxX+ZhCGeBCzjTIt2r59FKElwbuaCXWCQSRpjY8qS4yWIkWy
         6jJASRRW2ae0l5my2hSqD7flSd1l9ez5628eY1aKcK1V+WI0QiJiM/fDHhygEEih/+8u
         1lB2scfwQiHZWFpOcRWghb600F8iE2jIAmH/U91fuG0AaXO5r7f1aE9NWswUEf8oYD/W
         BxMp/0zpwSfOiholnjbttHzgNE00ODzxv9LcdH+lJGiOZHEaHlBcIJjDsaNwCDZaIrca
         Cohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=OBnsHqeoq1ssCskNolek0/pdvDvXdSwEEbO8sifQsUA=;
        b=SqaLAHEXlDSvEbGVbIw0Ky1Dw0cJqM98EipKLoGWCvd9m5zZ4Tcgs0MNn5v42Jo2JS
         HQI1mTxD1T8gCrgiFdkfm4ZWLiON1/V+CwhmujdWHnZJjKSzeuT4FDTzEzDwRcZhJ5GG
         2YSATorxV0ViHIdZWjHC3VVjrQ7qx3GSNHgMk7pX1aK+qYxuMUT/BUAPsGvwRjeRkZKp
         h0zN5SfbP6FvBETL9EusFlWIQzQWC9ZmnmiStwjcCCLqZ5zqfGH8RNSeTQECxTglWO8s
         gKtAjNRkezw8SZwGapHifRalSPo+zvU1Qk9cipLTP8dlpcFWIX/v3rCYXp2jSrDHm0nd
         yiAw==
X-Gm-Message-State: AOAM531CSV+SE6lRexQ1ojPd5aG63zJcp1XmluotUYcGinUWjX3/YWt+
        WaIEF2qrFKQWQ8QSbroIAoA=
X-Google-Smtp-Source: ABdhPJzF1+LkAECs4fZR8ut2D6tJ9/vVFixdd2y1jZ32j9DAzQVY1q1OriBQ6yeHG5dfxUXmhsGx+w==
X-Received: by 2002:a62:ed1a:: with SMTP id u26mr9221638pfh.121.1598383233555;
        Tue, 25 Aug 2020 12:20:33 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g11sm3345pfo.70.2020.08.25.12.20.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Aug 2020 12:20:33 -0700 (PDT)
Date:   Tue, 25 Aug 2020 12:20:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/73] 4.19.142-rc2 review
Message-ID: <20200825192032.GD36661@roeck-us.net>
References: <20200824164729.443078729@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824164729.443078729@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 06:49:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.142 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 335 pass: 335 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
