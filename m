Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29E575EE1
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 08:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfGZGS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 02:18:58 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39457 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfGZGS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 02:18:57 -0400
Received: by mail-io1-f67.google.com with SMTP id f4so102535351ioh.6;
        Thu, 25 Jul 2019 23:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b5wTnvmQe0owwasvJmkSjSTFJ8Gz+1OIVPlKvi4Zh4c=;
        b=gtWhppzwsp5YocYU2ZyowoL06vMVAdWXzoBLjYN3dPBSK1W0LsJw3ht4oW3t3yaoMI
         h3fJ3uqqsoOgamaSbvW0NFSu3p9SjXRKj2Ud/VjQae+l2UYLoaxElvNChDpIQtk+Mkun
         JYf6YUXKEh73Ke2OnPfvOJ4MIxENLt4mCJoMRJBBc6goUo3/T1kct3Ol+dQ8/pwZ/MDE
         Hb6I75LSTgouMljLoql8g6oxA2jqWLnOS6JVL/Zm9NuIVm13iRy71SrPjEb/87tL3pvS
         aqrypSQ8mQwUPHBNfP+IILMI0L029LRrXJipUt57ACECtpS4h8BfEWv2iUKsH0UGig0a
         5QzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=b5wTnvmQe0owwasvJmkSjSTFJ8Gz+1OIVPlKvi4Zh4c=;
        b=MV9rzxQweqVn5AgeYQVL9vzNUoTEcKLdGAWZQr8sUsR451SGPw3nhG75ZVf0yDqLmy
         joiGNuGg87wYhKZu6IpRlYP77yVwTh7+gufb7KynXKht7E0KlU3+YT9QFi99D0aZ6E1H
         bh6lspzlF58QYrsETVrorulLllAbHOwkKwXbM+PS7B+3hpvJw0soDjePviag1tCevLD5
         Zevg7oHJkitwlxiPjFpI7mr1gaA1bl8zjXrrkdiMwrgwKIjb/cCmDUMDsMJAhAiPrxOS
         CbLHG2826btNb9nMvva+cugCcTuiZDTyy9QTt/Ai7NzD5ydOfto0WhS5h/PXFZ8h9IB2
         w9Xg==
X-Gm-Message-State: APjAAAXwvbIOOvIGrNExyvHRu6eDAeBeUXRQIyQxvvAcllg03dMqgEhX
        ePmy5HFgcHC9sQoezKlUyShLBA5t6uOXMw==
X-Google-Smtp-Source: APXvYqxcFKoWSQzBqqzTzOFkK9EZ/emKW1tMiynSzruAU455nAJlvPKi9fqmmj+XWtUgEGMZq14L/Q==
X-Received: by 2002:a02:9a03:: with SMTP id b3mr3531029jal.0.1564121936987;
        Thu, 25 Jul 2019 23:18:56 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id r7sm37897284ioa.71.2019.07.25.23.18.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 23:18:56 -0700 (PDT)
Date:   Fri, 26 Jul 2019 00:18:54 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
Message-ID: <20190726061854.GA4075@JATN>
References: <20190724191735.096702571@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 09:14:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.3 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no regressions on my system.

Cheers,
Kelsey
