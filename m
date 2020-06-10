Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EBD1F5BC9
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 21:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgFJTJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 15:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgFJTJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 15:09:36 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84864C03E96B;
        Wed, 10 Jun 2020 12:09:36 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id u5so1393569pgn.5;
        Wed, 10 Jun 2020 12:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ys71nCiDShvHcFUPLC84Yltg5t9uw2vghktvm6Q06Mw=;
        b=Xy2TcUYSvmBQbGex01dQf12us40VgKWPw3HGEK+R/HeWLrpVGVZIX9LTQxpr3TRCaN
         ZIt2nET64U+iRZUmDX49F/3vVGw+/L0GY7P13fwKBNwSCm7gYCicDM3aAhddDOzuv0mw
         1WbMTSxQSjWpVqBMteM13fPuE6uTY79EJqCFkS6xjI+8k4bqi/4jItoY1Jm9AYRetqoy
         JTQdxXLd2XTiTPR02yuxNHhKia963McCNCCWOnArwEiLmRBk/g1xMesU5TcRGfAYgJRU
         xN0lAzufuDc1B8u8t8iInSI3LgI+kM+kevAD1Irl6NZk+1ylWB25Z665P3fANz7shAza
         j1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ys71nCiDShvHcFUPLC84Yltg5t9uw2vghktvm6Q06Mw=;
        b=og8NHedtk9MuVjZNWFlgS9izenqCkcrdiHUUGqL0jqxg8RouQwQtQOwSjVT2zAaWvT
         m1HoddywLuo3TEqVh/iHnHZ7e/M99PQLC52j9EaDBtpt4fGRFPv9/+UJtADQXp7X6Y2D
         nIdTn/H5rbOYqlzrjsxvF6URvOMoAIc64MLHw+XaxaCvsF1H+onUEl0QTBJ1tj9CaXkC
         a5OlxtG0rGrFdyx/t2CiJBOCTcnAWqiYOQfRsYiQrt3yIp/AMNNKXSIx5oQ1Oe7hTNMW
         m0rpVp/x+ivcYOuI/Nbvl4s19REH7JR28hcZyhi1mIGeSWAFb51pihw9oMke++pJERFF
         3OyA==
X-Gm-Message-State: AOAM530LuUu1+3vqP1iqgvco6FtbqoAKU5FqOYPngrvY9PIkpKJw+4Ho
        7UR/66TQkdvorEUVOdfNqtY=
X-Google-Smtp-Source: ABdhPJyeXj4n5apLvDcCjtqmjyvobMc/37uaUlsfHANpwptEu7Iw3iK29jRzLjXOKhKUPAA/HL73tA==
X-Received: by 2002:a62:7547:: with SMTP id q68mr4146181pfc.202.1591816176164;
        Wed, 10 Jun 2020 12:09:36 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n11sm540728pgm.1.2020.06.10.12.09.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 12:09:35 -0700 (PDT)
Date:   Wed, 10 Jun 2020 12:09:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/42] 4.9.227-rc2 review
Message-ID: <20200610190934.GC232340@roeck-us.net>
References: <20200609190124.109610974@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609190124.109610974@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 09:18:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.227 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 19:01:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 384 pass: 384 fail: 0

Guenter
