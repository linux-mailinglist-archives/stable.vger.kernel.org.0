Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7C29D858
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbgJ1Wbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387909AbgJ1Wbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:31:31 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDE3C0613D2;
        Wed, 28 Oct 2020 15:31:31 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id x7so668517ota.0;
        Wed, 28 Oct 2020 15:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ItbVqLLxaak1URBYc5TKvu5eTrGNoh/BJB0Sgch8G6s=;
        b=V4lzKPbYI7ub2gITJ2UWfkwMMyZtaGsT6uAHW70qe4uJRjlGjAjinfym8ASbVJt4gw
         B8y8XBQSofv0pkRgPjkl3yAhIiTBi36Jt7g5db9FXeBk5/ETY7zcqZg3wVj9DgIKpCvj
         y8DtjSckb7bMGqqcy0QcqSZYmYk6PWKpjwmORC+i6chQXBQ/9XsEnxo37hVUzONPmbhF
         5RrlzDFlAoV2aValE8jIhsiAef0E/amiIyrqDRXCldRvbeqzsVZJAIp6RYQ2+TbmCKN8
         Xgya66BfzLAcOz4UGXqR3tPOTfkb3nDH/JlVmAfjE6QXfARxqPVTQ6aEXZPkY5aDLVp9
         eFBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ItbVqLLxaak1URBYc5TKvu5eTrGNoh/BJB0Sgch8G6s=;
        b=qiN+A22+opHL+ncEsi1vYdTfVlaZ7cmxJEOqL/rfigye9MDzz195KII4RBUCLJrJsR
         58dI4ppitulz8UqbinJTbrqKSLU6lmZaA9hXKkrKYzkWKCA/bcUciZD2r/IrbX1Cy7gg
         K+WeyMpJwfFRvRV5bjMHx7rgKgfCK9T39SZnCEduiV46N8LV7xCLAbVmqOPcWVd/aOGW
         3LA9e1giBMy8h5wuHJf8yz6D60A7wycdnGZ/jWwsp8w8O1dtqyZdAJuFK6yHRDy+Z4rA
         FBFlJtnoXR6kQUrpOliDEdzuIVb2IFgwuJkra4M5RXS81orxbNVwe1kgdUc51n3L8PtL
         mWmQ==
X-Gm-Message-State: AOAM532iLJOy/tmVKh4gg7dQBp3sW9edS6uxBm5wOPo0FsRpW6jpnvL/
        PRLomPWxsKPoV17v+rebveRvUzDU1OA=
X-Google-Smtp-Source: ABdhPJxGK6g2IdozXEcpTZy/fRWOZocAv3upk2QM1Vj+mQu7dFHt7r3p4s6BKM2AY/2I1DD8jXNrvg==
X-Received: by 2002:a9d:5c86:: with SMTP id a6mr654604oti.298.1603914957383;
        Wed, 28 Oct 2020 12:55:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m27sm120540otr.32.2020.10.28.12.55.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Oct 2020 12:55:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 28 Oct 2020 12:55:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/139] 4.9.241-rc1 review
Message-ID: <20201028195555.GA124982@roeck-us.net>
References: <20201027134902.130312227@linuxfoundation.org>
 <20201028170653.GB118534@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028170653.GB118534@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Retry.

On Wed, Oct 28, 2020 at 10:06:53AM -0700, Guenter Roeck wrote:
> On Tue, Oct 27, 2020 at 02:48:14PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.241 release.
> > There are 139 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 168 pass: 168 fail: 0
> Qemu test results:
> 	total: 386 pass: 386 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Guenter
