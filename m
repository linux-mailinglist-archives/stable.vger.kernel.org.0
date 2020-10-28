Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D3229D51A
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgJ1V6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729225AbgJ1V6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:58:44 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B37BC0613CF;
        Wed, 28 Oct 2020 14:58:44 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 9so1167372oir.5;
        Wed, 28 Oct 2020 14:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YKydGy1ZChTdrs/3ABjjoVXybTsJ9OwC3vjbXU0OSVU=;
        b=aAdnS77b6JZAbIDJv1P2HqZYQTlpNXaTSiMwTQPtClQ0EXkp/0eJ4kpC3A5Mtihwnr
         vVyGGK+g0CmKYofBq+iUh07+NkRZHG/DQrNHNTNhjuVmT9gM5aYULx2CupjkI8h4lCtQ
         uFCsrej1oPqf/+ch4FMC5N0R3t8s1aLf9Ga6dX1VkvnGD1Jd/2cNaq/UqaX9v5raNK0G
         Y0/07NTKTJZMVfsFpnzicKhj+g/4Pjv2vnWOowqrimqZU59x4Jh2Xdq3RNaDePXvwjbu
         D7atBn3zZ1g9Aphp+wkI5OZCZ2PmZW/42sjoEtRxVBRQMi5gecOIBzXDG/1QPeTyI/cL
         G19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=YKydGy1ZChTdrs/3ABjjoVXybTsJ9OwC3vjbXU0OSVU=;
        b=O8hShkUcM3A2Y7zEyUmYcSu08r/YnvATpJ7EmGa+/jWedWNrfzdWbrhogEYH9jz7q8
         bsDqCFXya7SpckJVpZPBTxS0ILxpQISgh0/Ei90FrhoosS87T+b1KBcRWDlL6HxjDbwS
         WhUNy08Z4KdXP/NY56uXdVotxzo8pz69j6xbJ6RAGVJahr5Q6Yz2S1CI61IrIvOLpY7x
         6DO7npjdNDSXDEW36fTYMLTrz3AQBd2kAeC0O4ScwSn76cnxxZSNL2sEhxaqCMStFShB
         yLSt5bX7ehWsyAgSOaSCF8qLLLm3nG7qGCqKPtVXO6X10x/Xzx9AuCybYLUeYrbjJqOt
         5Taw==
X-Gm-Message-State: AOAM532PyNNFzjuFNnhUI9QiRHGGzpUpx64EXgzd0QQsm9sIyfC0rAfo
        0zugduXxtnNO1UFJC+ecKvKzr9VopEc=
X-Google-Smtp-Source: ABdhPJz65YxXwfYV67+cAkZRGN/SVBt9fVHNv+Hnwd+jtMJ3X9k7W0oyDRhJQnUbVvaXA2I5j9tLng==
X-Received: by 2002:aca:2310:: with SMTP id e16mr440106oie.47.1603915010441;
        Wed, 28 Oct 2020 12:56:50 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q10sm112893oih.56.2020.10.28.12.56.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Oct 2020 12:56:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 28 Oct 2020 12:56:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/757] 5.9.2-rc1 review
Message-ID: <20201028195648.GF124982@roeck-us.net>
References: <20201027135450.497324313@linuxfoundation.org>
 <20201028171208.GG118534@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028171208.GG118534@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Retry

On Wed, Oct 28, 2020 at 10:12:08AM -0700, Guenter Roeck wrote:
> On Tue, Oct 27, 2020 at 02:44:10PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.2 release.
> > There are 757 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Oct 2020 13:52:54 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 426 pass: 426 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Guenter
