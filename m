Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7DE9138BCC
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 07:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733271AbgAMG2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 01:28:30 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32798 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgAMG2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 01:28:30 -0500
Received: by mail-pf1-f196.google.com with SMTP id z16so4380190pfk.0
        for <stable@vger.kernel.org>; Sun, 12 Jan 2020 22:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I5C3nwrlmpAyk+QkEXs7euA2p6whJngz7gNkLGAB+Ws=;
        b=EQ//Ej4CuJIOHENKsDe7JOHI8zjDbtFhhHsj5YCGU3PB1YX04S4W8Bw2pFN6S9QmmZ
         QLXumgM5mJyIFQdCT1oxH5p4P7SbWmgmYf1P9QHzPDiMmWLNII38CmGqffYb3QhkrZvW
         Lil4iTXVDD/Ux4IJJIRGvNag3acWc0Ta6cMZlfG/NkPVZnRHz2BLhfDS3iTuK7H8k7nx
         4wrxfJiHYssbimlmf2G7cqAbjsF4zpo15Y2FGFD7A3v/I8e7QOMduSabuVjXegZWmKyh
         fD64SbbGcM8ScqwhOGEJbtBg6tCk9OL8IiGZd2kNqRGDNarP+mp3T1RTEddLDgxVFrue
         d2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I5C3nwrlmpAyk+QkEXs7euA2p6whJngz7gNkLGAB+Ws=;
        b=VImyfRN8Pi1Fz2X3QH7tqcwVTLE7kgUuU1C+vKKazvHNgDXw7KeTb7V8xj8mwf1vD0
         QlBkzFkJKHM/YS5D4z8hSWv3UDu/TsKWANLTaYjVwlEUkwVt0MZ+CzlQorZ8ZfJ9ygVB
         f68ICxc1hbnvNAckt37NMDl/KEUG0DCeUxni5AWCbdWAa1bQUOr1GgDod5KktuAS9e22
         U8bjQExUnhbk+cF+lYj/R2P/oWnZWolg3tKEcmfrcEdKCwE3570TxmBQFB7Rw3XSMHqg
         yBOrv/V7NogoqYdu/YLGFOlhWg/9KF0Pa/xjr9Wbb5K1UMS09wUZiSkhDuwTQU8EXoFk
         33hA==
X-Gm-Message-State: APjAAAUxCQ+6dxVtbzjaa6mE6+uQwqpr94eG32Rruj/+NDt2b1j0a5j0
        jsBZ/pHj6zOaVEc5+xHtLaG+hg==
X-Google-Smtp-Source: APXvYqwu4X6ngOi3zIhRdvZ4Miog4ASVHjmWUWWXs8oWzKVUD+5CfBDHp8WBVT0IF5H4FzeXFlcpIw==
X-Received: by 2002:a62:ab0d:: with SMTP id p13mr17955039pff.135.1578896909830;
        Sun, 12 Jan 2020 22:28:29 -0800 (PST)
Received: from debian ([122.164.106.111])
        by smtp.gmail.com with ESMTPSA id q10sm12867346pfn.5.2020.01.12.22.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 22:28:29 -0800 (PST)
Date:   Mon, 13 Jan 2020 11:58:22 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.4 000/165] 5.4.11-stable review
Message-ID: <20200113062822.GA2706@debian>
References: <20200111094921.347491861@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 11, 2020 at 10:48:39AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.11 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 

compiled and booted 5.4.11-rc1+ . no regression according to "sudo dmesg -l err"


--
software engineer
rajagiri school of engineering and technology

