Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5945935A7B1
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbhDIUNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhDIUNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:13:47 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2FEC061762;
        Fri,  9 Apr 2021 13:13:34 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so6859668otk.5;
        Fri, 09 Apr 2021 13:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mTfXj4pXrHkIi5SAJ4XM2fuUbjeXrw0C0nZgi5UUh1c=;
        b=LzH9cDYA/iEDcproxGHdzZVIFd6TlBiYHX3VUFVam/Wb9/6C0TXG7Z0hMICKeKmkDw
         dMRs4BlKKTTUa19yg0022cKqFBJoSfJ8FgK4DUfL4KdD+uboZ5hcxPfIcSGMosGpDCea
         0F7CG3iR+cAhJESNi2sN4Uc1dQ7OodUieAh9OCIzGuvff4miTvhoAHks4LOHPpvMs4MV
         xaang1DoVGHiA0n3bjEptjdwYJ4JNo7hVln/qUdA8JHUCQOsX0+FYz9u0Vluo/m4HOyq
         v0tuZ9Y+wFN+usvJdvM5q2V4rq7b6IrVs83bbHHv8YhDJUjTO1Vnmjac6wl9nUBVp2vo
         mxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mTfXj4pXrHkIi5SAJ4XM2fuUbjeXrw0C0nZgi5UUh1c=;
        b=G+SiDdG3Ux/ICt+C0EAWI+Stg30nFGUaLm28S8O/m4Nnt5PlUQKd1/5cSsZjyFBtm2
         zQpgP8Yy7sI0PAWQO5dKBK/+UUarB5/EM9eOzxYoSPWWH++S9ns6jGR5ZgpmIr+FPbvl
         nIb07YXcOt6XPfKlM5+ZP61qpxZBiGrZgJFYe9MM+8O7JHu6OdkbubRFNcXZCgnNDKzM
         jhxcQONxofctIgvZflo4bmaJPERvaFyPzgCmdCLq6qHeQhadgawSWdLwMKB92n2udjlr
         OhXTQXifrzrLfn9+dFqOzJBTEHj2FJaz8SZz9RDwjQ1QVec51BV3eKjKGwspouGNkI8Z
         lvoA==
X-Gm-Message-State: AOAM531r/CkqPVgsYU/OGa4JZ3XfikxAcMKD2MvGM5+GGQnrP7y6/2Tx
        5sqjvRvNUn37M7TEllE1CHY=
X-Google-Smtp-Source: ABdhPJw6ggpL/lLgROJYOk0bt0HVGNE96pb/3jmiz256IJ0YzAI1uIIqbtAsPwQ8JNuDVKwP/z9W0Q==
X-Received: by 2002:a9d:4b8d:: with SMTP id k13mr13371392otf.354.1617999214023;
        Fri, 09 Apr 2021 13:13:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o23sm823990otp.45.2021.04.09.13.13.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Apr 2021 13:13:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 9 Apr 2021 13:13:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/18] 4.19.186-rc1 review
Message-ID: <20210409201332.GD227412@roeck-us.net>
References: <20210409095301.525783608@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095301.525783608@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 11:53:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.186 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
