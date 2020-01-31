Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DABC814F153
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 18:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgAaRch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 12:32:37 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54964 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgAaRcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 12:32:36 -0500
Received: by mail-pj1-f68.google.com with SMTP id dw13so3133308pjb.4;
        Fri, 31 Jan 2020 09:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IVwypegYhpy+XpX54vtMUN7jm3q4+meqYZSBaKYGJFs=;
        b=JJjuDPyE32B8btI2tpNcVnQ/VAjiwGa2Uyo6luA6crBPZBg+wFHsmn/S4gZweZt8n0
         dN9a2D7dknn0FP5+wrokFHx4xbtpVwHNrUyeErxS/nCqRhflgX0bmcIKeODphSmg4NgX
         wyjDHwOHWTrEZxwCEzrXjPXssC0PvFeo+aBfQoyIFPwVvpiNcWUs843QGDUNW8Zwmr53
         tZ70xppBEN12XWbMGuzij1vCncRNAAACar9pBubWR0sfaatQPHcR09bihd4/OsPp4JK/
         rRTi8RyS4ezcnhBcrL+BDT10lyAR3jK0UgRGe0XuL2evZWhWvr4CFTLAcjaQcTmz+OJS
         eFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=IVwypegYhpy+XpX54vtMUN7jm3q4+meqYZSBaKYGJFs=;
        b=AZLBbuylJxT8pqPIoslz2TGLchXZBd7RpH+bZ2MTl7FL0XV5oRfslHu/W4Z1JYC2A1
         zKnlin0rkw7JpDn+c1qpI7Sp7OdcsAz+j0yqQes12k7eOXxawcQJY2w2OxAeXtuxhci+
         JwEuZvUnGMI298AaYJ95v6NL2lwAOBZ5zjdSVD+PgWZLR33QcZ0c71UUsr1oSOQ0LxYh
         eDY6yxvDQEIeomzyr+Xgk0wtcxumpMIA+g0I3AFmlVboScg9rYIz4CnyyvGj1inRznS9
         hwsY6ALc1ZwBRUuLunUpEOw4O6FDo8EGC+3KEzs6pbaHBkaGyVQyfp3XHFKi9JsQEovD
         m+/A==
X-Gm-Message-State: APjAAAWQOx9XnoWQj0/t+KRuNwZA5xooVzqQmKXzKrinmJiJKytCQAor
        IyIBzBtABliuvDd+3XnCQY8=
X-Google-Smtp-Source: APXvYqxyaioy7y3zfC4K+xSYHwIOM576jWCSQGd+aOuElwu+/VjxNsL9fOWk+EAJD8ghUqlEZXAe7A==
X-Received: by 2002:a17:90a:b008:: with SMTP id x8mr13937727pjq.106.1580491956171;
        Fri, 31 Jan 2020 09:32:36 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s7sm11093265pjk.22.2020.01.31.09.32.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Jan 2020 09:32:35 -0800 (PST)
Date:   Fri, 31 Jan 2020 09:32:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/110] 5.4.17-stable review
Message-ID: <20200131173234.GB16567@roeck-us.net>
References: <20200130183613.810054545@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 07:37:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.17 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 388 pass: 388 fail: 0

Guenter
