Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407E331A447
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 19:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhBLSI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 13:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhBLSIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 13:08:43 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABD8C061574;
        Fri, 12 Feb 2021 10:08:03 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id d20so516337oiw.10;
        Fri, 12 Feb 2021 10:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JGof31TeEILeik89QWvce2IYfLWNAOl4TD0h/U99yiU=;
        b=PdPYDcvQUTORWk38MnkE1lY63llvQ/kJyIS888zw6Rn9Q5/t/WEGG7RHdOHcqSSmpN
         wWiKmGaD1NGcF7to8gn9RXTxiVf6Kk8WOSH9U/Q/gJh+6pyZ78IGgdDHQtcTRsmzgGaY
         IVUxkYyEWlYEJ949J+U29nCHqTfFISPdP03HPMMXEBt5M2cqI7jR0u3FYbjiAG3c10th
         oF6+ejKi5YUcVAn2ZfR1uPXfVa6LsLj3/7Unl3QtKeE+4qnx9/srcZ73Vrt0HnHnLHVH
         /9dTSeN7ePfxDqcRdz5OqW/dI0B+/5j4pKyDArxmrGE0epiQ3ZO5u9XGWrxkBXt/++wy
         E84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=JGof31TeEILeik89QWvce2IYfLWNAOl4TD0h/U99yiU=;
        b=Huc75oXrgvGINLoWMxAYT8zpmwvnbrAq9SzxlOsCE/ciR9za12NRrnUlHu5q3gRvEZ
         SP99c+y1hostQeoLNpsqIe6iZahBnda2Zo297Ejhruc1nHLSAw03uc/xYTfo4cruKp70
         Ek+ImZleQb7ysg6aOxBXjGD3k1Q8tIwff0/hOBzHANpJjyCI0OhIAnSC7i1HOgGrxKlg
         9XDFfHfIVmrKFN4qKJkEieJzChYuxUknSSc2VlBEGwJ2PQn7qNU46kPFQQHtBDw9ObOk
         N+esWxjHFYcYufuwIVU4BnS4hP40SKn0yUM3RRua1/eunOFOCB2+rPft0nYQtqdGpWML
         UDwQ==
X-Gm-Message-State: AOAM532rpEipkiKvme7m9XVSKZOs3LA6p2PGck5wVf1nF8hzGloVXJQE
        n0vZxEkkxTmTcge9zFtTmNo=
X-Google-Smtp-Source: ABdhPJzslGl0/2DlnLk9+n+26Tmr3hiymf8WAG3jTZYRa/leHeX4C5YgF3KgyPrumSDiIcMU5w7tJQ==
X-Received: by 2002:aca:52d1:: with SMTP id g200mr489706oib.44.1613153283233;
        Fri, 12 Feb 2021 10:08:03 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g36sm1793268otb.67.2021.02.12.10.08.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Feb 2021 10:08:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 12 Feb 2021 10:08:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/24] 5.4.98-rc1 review
Message-ID: <20210212180801.GB243679@roeck-us.net>
References: <20210211150148.516371325@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 04:02:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.98 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
