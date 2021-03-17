Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA1933E74D
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 04:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhCQDAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 23:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhCQDAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 23:00:05 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B240C06174A;
        Tue, 16 Mar 2021 20:00:05 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id z9so131181ilb.4;
        Tue, 16 Mar 2021 20:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=silnVe9ISkW1MzdW3HoXebDGYh3xBxheNKdrdq0TAHE=;
        b=rP8ZdkFZawbfswT7Onpdqepr56qVNKTao93gvDECs8qr6vJXCQYMtWOYA3oVwCTeV3
         V9+I5MKblSUojnxBr3j+2/2pS2tcmw/hI+7Mh9xqJNBJ2mg7mCQuu8F1mMufMHQisor8
         3TVBnjGrOwet+KpAR6tA7K7Yoqyk+fH0wuNOnBZkF44sLihoQyudFmiEDdnwtHVYTXV6
         vP88TjNH3S08DutsqTMjtG1J0M0Eht3wCPTzomqQDBZ98ftAoyNm2FU73eFmL7Xi2BKO
         i4INm7DPCJQ6KyGf/lUxcKldN0JXh/oqrX9MUkgdKmmsNxlgXSnhyu/paVOFEqwQF2gD
         4TTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=silnVe9ISkW1MzdW3HoXebDGYh3xBxheNKdrdq0TAHE=;
        b=UxSefEbQnxBZOSIZYC5J/8IigRkNtEVTsO1LcDS9IY+5arI/cOyY9+541CbmAaRXHF
         ZwWWIgf6dViEQKBvSdNy374pdyGbw6idoR7FG+f7H9ra6wxK6OyZZBtAp1cmIHVXQWlm
         OCgxXmbqxb42Q9s5pytKFIR4kDllTMoWMbgL24ZE30Qjr1Crz1fOTqS6citMs9MigJTr
         9kJEmWWNmPsOZHBH8GT/9eJiXIyYaZxmGEtkRVt+0ELqkoWRVZgZ4OrL9hUBcV34A2Ne
         0RqHx1jVYSBRL/DQPWVvuBFZAfEaGroCf8dVRWsxR2jeX8rIkgUMwEWGm2n/hRlBUM6m
         lWYg==
X-Gm-Message-State: AOAM532nNXnVQJjvNKtEAsITqP+6wLv67+6Pjv6Q0L9XQjhlUWCtS7lB
        b3uLRwD7T2/p4xLtApwey2I=
X-Google-Smtp-Source: ABdhPJxRfWXJ6DCi/JauAexIp+ABW5OmcGRW79NcFDdjsxojd3CA7i7KZZ267AdCrIFFZ/le6oF3Hg==
X-Received: by 2002:a05:6e02:190a:: with SMTP id w10mr395392ilu.39.1615950004730;
        Tue, 16 Mar 2021 20:00:04 -0700 (PDT)
Received: from book ([2601:445:8200:6c90::4210])
        by smtp.gmail.com with ESMTPSA id y6sm10438122ily.50.2021.03.16.20.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 20:00:04 -0700 (PDT)
Date:   Tue, 16 Mar 2021 22:00:02 -0500
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/168] 5.4.106-rc1 review
Message-ID: <20210317030002.GB6466@book>
References: <20210315135550.333963635@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:53:52PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.4.106 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
