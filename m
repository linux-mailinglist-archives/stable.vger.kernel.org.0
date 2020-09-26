Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADA8279A6F
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 17:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIZPo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 11:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZPo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Sep 2020 11:44:58 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5FAC0613CE;
        Sat, 26 Sep 2020 08:44:58 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id h17so5292088otr.1;
        Sat, 26 Sep 2020 08:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MuHdzA37Qe4obG+MPXMuKUvutx3ax+Rx5eyXvGpEJEg=;
        b=h0Vr64nFd5A7hwenm9t9wnaqGOi0xO26wpQnq02PqrYLHl6pikfr3TjE+dSykE2MLK
         tYfeSf9IVY1Xep6cpjSzD7KhX5TjQJIYEaIM0lU29iyFTJf88ytF76qb9CMFAv5F0rtQ
         lj1EWX+Q+onLYWWrEgQn2UvPAGMHG5yK9J2n896RunrDCbawJwNvXgBD3rWbpXPPeOvX
         C6lrrE+fJOGDXuo3R1XDroboPjdJnuWbxWrRF7wkJVGvybZPhievUy2FH/Ogy66yv0aQ
         MibTobrbn8sRujzMNq/Qzou/wgkg/rGh+l6skpupC+/P8gZ/VL719xAYdCvAdxU1IMSw
         IkMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MuHdzA37Qe4obG+MPXMuKUvutx3ax+Rx5eyXvGpEJEg=;
        b=ONQuek6IFC7A42BjStxhulWMkH2Iy2IdM67a7/7buhaYBiTKnb5kP7tDj1nuWnfq0G
         ST1vzyaxVjTCggHcoeRzlTaIOqObl2WnkLyVCYVnCFFjRomIMDPle5ktg2BSFam7clJC
         odLyIgWha5YkJfwVcGvmtg1yfJB+91Rh4o7+WeIoSTD2OYiiKfDjqKZqZ+5laOcr1zcF
         vzgP+G1DSUaHL6/wCRBSBbOiXJjZN29vqQ3U0T7H1aEoz2bwx1DYVPn44WcJN1Q/n0cR
         p5FPEBap5pFSfR4wx1NqYoVEfUlGFZovK3s61oDTkE3VKT98RgFXaxrmJBalkJ4eqQz7
         7wgg==
X-Gm-Message-State: AOAM533JE1xJtI25wowvrHVReDKUdhvZi3TfWm49rze5kXFgfkJ0sjp+
        0Kk3TGgBVGwpc9Eu1dfJt0SLc+lg2ds=
X-Google-Smtp-Source: ABdhPJyUdMJ32MeRbdxn9Rhtii1IY1N40Pq+v6RlcFiTMwjJEOhZVVaYEQluFYaVqgIufI9gFTV1Sw==
X-Received: by 2002:a9d:65cc:: with SMTP id z12mr3649612oth.301.1601135097743;
        Sat, 26 Sep 2020 08:44:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c19sm651086ooq.35.2020.09.26.08.44.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Sep 2020 08:44:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 26 Sep 2020 08:44:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/56] 5.8.12-rc1 review
Message-ID: <20200926154456.GC233060@roeck-us.net>
References: <20200925124727.878494124@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 02:47:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.12 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 153 fail: 1
Failed builds:
	powerpc:allmodconfig
Qemu test results:
	total: 430 pass: 430 fail: 0

The powerpc failure is the usual spurious 'Inconsistent kallsyms data'.
Hopefully a fix will find its way into mainline soon.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
