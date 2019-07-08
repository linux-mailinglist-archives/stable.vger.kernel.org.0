Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE906626E3
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 19:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391527AbfGHRJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 13:09:45 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42841 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390830AbfGHRJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 13:09:45 -0400
Received: by mail-ot1-f66.google.com with SMTP id l15so16930387otn.9;
        Mon, 08 Jul 2019 10:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wUfx2UVYRyyiaBBC/n1c0/e3bdrU9hbSeVNQPAVlrd8=;
        b=Fj3fSYQsIRtGaJr0XxScaY/llObRbZcq6nt6iOvt+DmyrtxrWr+etMSe8eOS6enVpP
         N7NgX/PqjlwX63tHymaO0e/8XlKhsP+4uhrzGonkpI09M6+ojfTYhSy8io2VPMu2In89
         YOzha1dRI7rwCeK/zl2fcS2D5U7pMwPCsF/zJvjCP3mhNJciNA4Uet+YaY5K+OhMnnt7
         c1iTKSiJ5bm3nVgZKJ9jKcIgdJGywJJNUgEQ2tOPMms3Hv9vlvF+CE2FnqCl/Eq9nMYk
         /tdTuzewarVYKA2jwRXv/D2s54tV0J6/SK60M3/NUBGpCAp1oJDBsACjep7svA1KoVY5
         II0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wUfx2UVYRyyiaBBC/n1c0/e3bdrU9hbSeVNQPAVlrd8=;
        b=dsT7TTSkh171ozGwC1XX82NBagF3t7v33PIIZEC3mjvkvBi4XWqpVFQZ7i59BNkoYx
         u++AGCNuCOYO4ofM/ljtOtyeJ3ceI5p+qckadifn9eYIKLFYSk1qKREt2uFUeKGYpq+3
         00MkIhLXzaqlZYuyG84ZEi++dMc2DFEsXagh7fnvs2N7EO1iuRoFazTjIy/G1Co15VHX
         QSv0NpPFSyTpQEGP1W1qVpthY4p+J8f5gQi0VBv81BfH1gn85atvzJ9/aPgP0QiNqE95
         8i6Qw89Fb+UYi1VggQJBW/ymf+tfDCXxejwNxiSzDUMI1EN24FxwMGZ6yW7JcE7TV8bK
         9zFA==
X-Gm-Message-State: APjAAAX0tYzvelKJWVakno+g/xKptJlpbqe0SU2/Mmmloqd3IBKjyI6v
        eylceYeg9FULQJxk+H3kWpSmqnnuqZA=
X-Google-Smtp-Source: APXvYqyB3uXYd9q1nZP78Q/OCF3Me2+xvUQX/PiIYFAW3lBQx2nYWnXpjCzQtwdNjB3TnbqCF6u6DQ==
X-Received: by 2002:a05:6830:164e:: with SMTP id h14mr15683214otr.186.1562605784807;
        Mon, 08 Jul 2019 10:09:44 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::48])
        by smtp.gmail.com with ESMTPSA id m7sm6571985otm.5.2019.07.08.10.09.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 10:09:44 -0700 (PDT)
Date:   Mon, 8 Jul 2019 12:09:43 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
Message-ID: <20190708170942.4spgqychsymelnqt@rYz3n>
References: <20190708150526.234572443@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 05:12:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.17 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

Hello,

Compiled and booted.  No regressions on x86_64,

THX,

Jiunn
