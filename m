Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48AE35DC98
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 12:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243413AbhDMKmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 06:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhDMKmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 06:42:49 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DFFC061574;
        Tue, 13 Apr 2021 03:42:28 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k128so8449815wmk.4;
        Tue, 13 Apr 2021 03:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hv20jSiGuWtT1pi26CojC768t5fqYwwsSEwrkHrlstI=;
        b=NnCi0HLLqKYcnzmhy1Tc0gyUBa+2T3MMfSZDJHliHF0wZlzZ6eAzzBlNRkkumdbZ5R
         L+CB87p2tTGnvJmgmoHISXlYW7c2tAxaGKOp+k2STXcO+UY2w8ktKndva7O0svxBFgbu
         wf8SRotxMZU6ks/qebI/Mj/y2hVpmIVIE7ztus8x0JanaasMOp1ACtXCYiXuqYlOu1Ke
         Xbwg3JRxtbNPz0oCC+5NAanHHvx9o0tYDCBBsNaRRBfFZHF4EXd/5dsmEakuYuEdh2c1
         BQKHFTsDhSMsx2w4tUhv4tPNQ+6v5lrmrzPJudTu5qrlOj4BjbdeQVEJ+bavZAHngsQb
         78oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hv20jSiGuWtT1pi26CojC768t5fqYwwsSEwrkHrlstI=;
        b=KZmIDq4i65QFc9PmVMP7M+0iPoIl5Wo99/T3TsIhtsqVu6DEhZdOOL8wgW/e9u35RE
         U/KNWeyJLNhdqoDu+AWjIFeogUB5uB8yb/QgOPlQWAxI3V6KEjgzY3BFW5Maf/YMZGD/
         ojyroGjLFV92V1UswUSZMBEU+aw+fgXCKjTYa70xwJcuj/LRoT4oYeols2Rc0t1IIx+w
         3L2aK6vUuYdFsPzD99+GMEMqd/rAHYxPG6lwAzO2sUxPp+DdVwEJi7WJ/c8im2a4nJrD
         Cg54ctTpD1X7K5LUJxZ8Vo0apzvzvHRWaLgY3RH3jjVn19FW1nxAt2bybV2fam3t2F4h
         V9RQ==
X-Gm-Message-State: AOAM530vouNGVaL84z6CDVcz7CCjOA0/w+/bz9EPu3na3S0PWsSc0wVn
        7mvPXL3wvvz/UpjYwcURAEc=
X-Google-Smtp-Source: ABdhPJxKzENLFKsnumjyzYzNQ2tu9L5bmKvfDiirVKmC6Bd/0qeaHniPLb9XhzIPff5TShy4cGnDQA==
X-Received: by 2002:a7b:c098:: with SMTP id r24mr3498538wmh.179.1618310547488;
        Tue, 13 Apr 2021 03:42:27 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id z15sm20382284wrw.38.2021.04.13.03.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 03:42:27 -0700 (PDT)
Date:   Tue, 13 Apr 2021 11:42:25 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/111] 5.4.112-rc1 review
Message-ID: <YHV1kftOyhfYZN9m@debian>
References: <20210412084004.200986670@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 12, 2021 at 10:39:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.112 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.

Build test: (gcc version 10.2.1 20210406)
mips: 65 configs -> no new failure
arm: 107 configs -> no new failure
x86_64: 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
