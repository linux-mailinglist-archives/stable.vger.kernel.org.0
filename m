Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A58A212B8
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 06:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbfEQEGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 00:06:18 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:32922 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfEQEGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 00:06:18 -0400
Received: by mail-ed1-f65.google.com with SMTP id n17so8530179edb.0
        for <stable@vger.kernel.org>; Thu, 16 May 2019 21:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OtZYUE/p8vYe6qHiwMqDqxDv64Jhgs1npS0IOvEs2+Q=;
        b=UbqiWiqlXSkVhCegrWS7Rz2yE/KX4vC+sGst6g0j0ZVmrIrqQErfVxL8GiECK5DiEA
         PgOlI0ycucRjkhcqWbNehOQr63Ib0gmcMDH/g8sS0N7p7pE1wxcG5qOes51SRdroE9gR
         FCIi0570i2EayMSuHHCGk4wXqlRsZg9S62yikjIaX/usFc8wpkR1gIr/xobTtt3nTawU
         DbAjH/5I6mUwy2U2hbnzrjqKwnrd2nz6Ru17em8q4FnSZQE9iNUUQhgcvMW3dAiYhq6o
         ARA+X/0ewuV6/ii1sQKU/zSZG/690HjCBXRbO9oLh0ADeHo9EUo9U+/zBLacVUE97ihe
         DspQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OtZYUE/p8vYe6qHiwMqDqxDv64Jhgs1npS0IOvEs2+Q=;
        b=D5DJ12f9JJCb/v/txQLyJFNfDmljNracIolNSnWMRMg2xWqSx4aRVFkQmdgyJ6fIDb
         DP7zESxmrybDFRxrm/UFcpiWbpJE9vGN5CJMX/yM/GZLO4iKBj9tlxrv+MxsE3wyDgbk
         Ygdkm5trwgbrfJbuqPHKgccsN7eZfATNPSZtnwPfkLZHZa2BGtkNUi3AyHTZhMpBBVC4
         hsxry8UGP0OLwt7aU8pkrMF7Su7sn63erNmnqhHXefdZ9z/2sPCcS3MHQxks2IZ7coR/
         ZAFqsq7WpBxdHtCeBFXPNQNCvZ6xqXisgkWK3U45q8ETgMlBVn4SHM9FagmHoqVAWHvZ
         QcBQ==
X-Gm-Message-State: APjAAAV/MfMq/y3mXdBCiA2XhWfeQvO2WdP4M4bCT7akRYDzFIRMEJYj
        EbPZHgRKU6oyEfjMxbq4XC5eqZGdTA4=
X-Google-Smtp-Source: APXvYqzG38g3XJifH8TxResHMeHgwRucKkKo0wu6J/e/2jtZlyy31rNSs7r/A1rJ7+FTKlM4IskbWA==
X-Received: by 2002:a17:906:f84a:: with SMTP id ks10mr25131350ejb.65.1558065975687;
        Thu, 16 May 2019 21:06:15 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id l19sm2379044edc.84.2019.05.16.21.06.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 16 May 2019 21:06:14 -0700 (PDT)
Date:   Thu, 16 May 2019 21:06:13 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        gregkh@linuxfoundation.org, clang-built-linux@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] lkdtm: support llvm-objcopy
Message-ID: <20190517040613.GA13981@archlinux-epyc>
References: <20190515182441.30990-1-ndesaulniers@google.com>
 <20190517001002.D1A262084A@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517001002.D1A262084A@mail.kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 12:10:02AM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all

Nick, the stable tag should probably specify 4.8+ since the commit it
fixes came in during 4.8-rc1.

Cc: stable@vger.kernel.org # 4.8+

Might also help to add:

Fixes: 9a49a528dcf3 ("lkdtm: add function for testing .rodata section")

> 
> The bot has tested the following trees: v5.1.2, v5.0.16, v4.19.43, v4.14.119, v4.9.176, v4.4.179, v3.18.140.
> 
> v5.1.2: Build OK!
> v5.0.16: Build OK!
> v4.19.43: Build OK!
> v4.14.119: Failed to apply! Possible dependencies:
>     039a1c42058d ("lkdtm: Relocate code to subdirectory")

However, it will still need a manual backport because of the lack of
this commit. I've attached the current patch backported for reference,
the git am flags '-3 -p4 --directory=drivers/misc' help get it proper
then the conflict is rather easy to resolve.

Thanks,
Nathan
