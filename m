Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3B816A90
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 20:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfEGSjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 14:39:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44797 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfEGSjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 14:39:43 -0400
Received: by mail-pg1-f193.google.com with SMTP id z16so8725965pgv.11;
        Tue, 07 May 2019 11:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C0VSQzyEfM+QQgPwqDXaT6KxXPzKgORNNSDvOkXjSMw=;
        b=Nkf/NqbcTw/Z3gorX3T/2j7LYSyV+/d2zHL/q/sqLz4jrhzejqAjH1E6Gdv30QcJFB
         DpJeJM6aBBi/ZGsGd6KSM33GZC4XgfYNMM9a+AS1xwTNtRgj1XJRXCzk5+WDkFuePGw9
         +TK4Mh5Hz8mGRmBjKlvQlHlu+LJ7AjITUfvHMLOT2uYtlCH+TuS6Y4KMslJKVIf1fUaM
         zvOrnnNKT3AoKtjQJ7O/zfDaV+ePa4lpAqUn6Vt9tIBYAx1jE17g+ssQK5RPJw2LY7Ri
         RqRM1P4C1s0ysQEl1GfAvE8usU950XrTxn4Ch6uyH62TPh18wDkllpm4+odwZnBJBi+b
         pPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=C0VSQzyEfM+QQgPwqDXaT6KxXPzKgORNNSDvOkXjSMw=;
        b=CHBNjixn0FTH7CqZcKsIcPrlugqlia3RzAgAKzNgZMhL0zN5Et/sGrU/BfAlGBT4ZM
         wCfQI2Mu2xffIXmO/8Yz3Fpx+mntPuLjfpFZKDNh1Kj325ju071m2IMJggyK7FoZIm0C
         XFZvCwNej/6m77DJwU8uB6y9Ragbg7umoDqt+9D5IQy46lJakGNWANsNSsMfTvnzUXl8
         Z8FGxXG2Btc0CeUKiM8+iOpL8A/hDBGyPeKg6/1ay1qTu6ieIK8goyhYTIVJ3gV5JTQm
         tpcUPXfjD/rRq2AK4RelEuM7vWhlaVOKwS6lSVeW8UaZwyZEG6gVXglDGqzbsOamXNeW
         nnWQ==
X-Gm-Message-State: APjAAAX7MCZ7muOiCSxKO2SxvWpTWhxjYsWeC+o2Sckxzea+hX41VFjZ
        xVA0vgMnulzVFM9KIXkVEUD7CX8P
X-Google-Smtp-Source: APXvYqzJeaUaUKiZ0IcHPFR8zXiog23GMex/XUfSefpDBZ2MATDZtFHbmF4wcqBfZLlOTVFRv1iy1Q==
X-Received: by 2002:aa7:8b83:: with SMTP id r3mr42735254pfd.248.1557254382622;
        Tue, 07 May 2019 11:39:42 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 25sm16609276pfo.145.2019.05.07.11.39.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 11:39:42 -0700 (PDT)
Date:   Tue, 7 May 2019 11:39:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.0 000/122] 5.0.14-stable review
Message-ID: <20190507183941.GD30225@roeck-us.net>
References: <20190506143054.670334917@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 04:30:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.14 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 08 May 2019 02:29:09 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
