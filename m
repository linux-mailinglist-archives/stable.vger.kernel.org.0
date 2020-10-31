Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14892A1A7A
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 21:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgJaUIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 16:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbgJaUIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 16:08:42 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5535C0617A6;
        Sat, 31 Oct 2020 13:08:41 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id 79so1435136otc.7;
        Sat, 31 Oct 2020 13:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9pe7m4dMBXYFbObd5NyGQMkG3DpDQDp+IvrFllWOgfg=;
        b=s7jyqHnH4PZXpzzHpQTOy7eu4JPVNVVrneDpLTFg4Agf0zeEB4N8lRD9Y1bim3VvrT
         X5oJFuIflN3k9i7biPhj0n0KgIVDAWU1htji6Nf0o2a/pUEetm0nSTw1tqydid51aDx+
         iSqTA4TnowYAhb18LhmCumV0+9FZJaoRGQhDjgl7TbWM/h8OX10uwAKSZSopF1nIgzJt
         CS7SKKFQ6L+EcChJzqplmRWAObp2fD44hOx3JbD/QNjFjX6sf9jF3PvwLnWk1PElVETl
         qGLA6SQL5KA7rFXU0tWXr169IFliLuadbvFEKLsNKcIFL6NbZZ9U3F+pCXkUVX/TfjUc
         E6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9pe7m4dMBXYFbObd5NyGQMkG3DpDQDp+IvrFllWOgfg=;
        b=ElkWoFY2ngIHdqxf7Yw96cQu2TdrtXz7Y2/ynLE+BYmmjoIcPQIOvPU/AjmNEBPrb/
         quYdQqn31i3wVJ8LBfW+IJy9X0dJupIrf4Tw+lXwKdrKYBiDppmGSSStNgIROKEKjLmR
         dVIxdaMXokrflzVQ0VXV78pcugIAS+LpVpp/0ntNfZUQyXPu+LDmIR6ZoUI0PWZ4a73U
         IpSogVAyd7979Yt70lwFnmzH2pknJyE436dAQsF1GbNNP87tWP44sRAEBkxpc90czqdN
         tAqaxnlXhsoISRlKja3IVlzdVl8ZZEtQGHQvoJhcB6Tup7lHoSUCoQYTu5zmmKrGVJx/
         /wVg==
X-Gm-Message-State: AOAM531pfAxVirRmSmGMfW6dpdqZEyxoTl1cmRB1JYPTThJ/Ti39RVOA
        Fi7P8EBqSVNajKQFM1QSfrc=
X-Google-Smtp-Source: ABdhPJzsrMVjb8fe15YrKVKNAQKUsn7jUq4cA3PnHXwLm02qUgE2i/c6V3BWk4dJj4MLuW+cp56Sgw==
X-Received: by 2002:a9d:6052:: with SMTP id v18mr6479578otj.33.1604174921401;
        Sat, 31 Oct 2020 13:08:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g3sm2371913oif.26.2020.10.31.13.08.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 31 Oct 2020 13:08:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 31 Oct 2020 13:08:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/70] 5.8.18-rc1 review
Message-ID: <20201031200840.GB45965@roeck-us.net>
References: <20201031113459.481803250@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 12:35:32PM +0100, Greg Kroah-Hartman wrote:
> -------------------------
> Note, this is going to be the LAST 5.8.y kernel release.  After this
> one, this branch is now end-of-life.  Please move to the 5.9.y branch at
> this point in time.
> -------------------------
> 
> This is the start of the stable review cycle for the 5.8.18 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
