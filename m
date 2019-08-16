Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8052E8FB2F
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 08:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfHPGjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 02:39:24 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45113 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfHPGjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 02:39:24 -0400
Received: by mail-io1-f68.google.com with SMTP id t3so4195777ioj.12;
        Thu, 15 Aug 2019 23:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LfX+pe6KX9sYIxHfVZ6eX9dKoc6kQLPyaT3gRQ+L47U=;
        b=jSnaQIfpsRUA+Z+KFynREb/Cpq0rdaFJFDYEsEC1rY6i2vD3EOHjha55I+6MCS7uU7
         hBXUQ+944NZoj8HpvAbgTEFVxyGl9K9G9FV3e8Y4GMV1kGa77fxmG4BEhXobdYhd9kZp
         6dN9ea4NQd65GaCWmVazGH6SDjeuw39dtbbv84CNdKnhUwDdeo3fgDJUAL45jA2g2FPE
         69aDNYjrbaIxWOkkdq60aijcs+apNgZwL2Dwwf9Tq191KwXq7tC4qLf+JjW+Zsi3jnoI
         1AC0w9nVP0E+lhSKmQgaQ5fHMrLGwLpPWFp+nVYNVXPi+BymxMiAmvPgzlO7QjMN3u6A
         sXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LfX+pe6KX9sYIxHfVZ6eX9dKoc6kQLPyaT3gRQ+L47U=;
        b=g9K4G6oLoRiMX90ed2KUB4aInfaRIF/7ckl1GIwkJGjuTqHeA5y15WHSO6YTewFCR+
         4F6VxF5RDUk7MaUMnObXabgeQFiypQ2uQxYBxMta7xgPtomVG7FXiPdDyCw3Jy7f1s36
         QMlF/ygXt8S2IlgQEU5hbJKgAH4xYSbui6Ssr8n+1SXOPMnStAJyopmgvsIlsEjUv/gB
         ocpW345mheoybXKxPvZAjzsLgcQYXKrhvgwwDEZkIZljn8BgBRiVX7mFSBCZvINLxLXU
         EJnfQQ8JI5VCjQ0cfZZNj+gJ7NUVv05j11QaO3XzOcGk2J4I4F/SVjY0P/pXV/B+L2uW
         BNrw==
X-Gm-Message-State: APjAAAWNFPQ46SUwpvzAf+L5Mg235bqk1Dv/6k1QFf8Tk3G15IpnDejS
        qlevZxQCQNzCgjPsUsyAktA=
X-Google-Smtp-Source: APXvYqy8z+gWc8ebHkrdRits59r/NS4DoKa1CvuB7a9BBWBSWXp2RXbkPLYiZ21w8ojYdAZqEkxGDw==
X-Received: by 2002:a5e:8e08:: with SMTP id a8mr9260494ion.94.1565937563961;
        Thu, 15 Aug 2019 23:39:23 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id p12sm6724015ioh.72.2019.08.15.23.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 23:39:23 -0700 (PDT)
Date:   Fri, 16 Aug 2019 00:39:21 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/144] 5.2.9-stable review
Message-ID: <20190816063921.GC3058@JATN>
References: <20190814165759.466811854@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 06:59:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.9 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no dmesg regressions on my system.

Cheers,
Kelsey 
 
