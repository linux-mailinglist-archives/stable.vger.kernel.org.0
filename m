Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A139D113561
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 20:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbfLDTEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 14:04:39 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43454 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbfLDTEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 14:04:39 -0500
Received: by mail-pl1-f196.google.com with SMTP id q16so100073plr.10;
        Wed, 04 Dec 2019 11:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=93/C6curlOLqRyWodQ4iy3j2Dr/kM4AwvdGenAfLMBQ=;
        b=fgLvlZOeb3C8aV1BToHfGusEsZJ5VeOHxlwx6vqRPjuKHsySAO2z5rNCGa2JdW+0LZ
         h3MqgJF2xTnDyn++JAG3yXNBPM8m4i9oTRpehCPJ2EK1AuySzDvUNB2W1F99SJl0ErzJ
         154oR68vMOBie8yqYe4glGc04JiEwgkGLlRip1MD00imEj+jFnQjM5KLScEC9MwSENzE
         v3SGD5aBJxyQCJy7Ck/47vfkJt80aHDTHI80OYEwVLFS7j9Dd2860RrLm3Qqk0L1VQeg
         AXqtnUfoxPmd7dfnQh4skpNpF59EMlXV6Xu6cSgaMJnhrACos8UobghaK7o8xZYBZ99J
         NSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=93/C6curlOLqRyWodQ4iy3j2Dr/kM4AwvdGenAfLMBQ=;
        b=BVmz8vwVR0nQQRUIaweuOb+vVk7xddi7WUKoBqw66Kp2bEcq1CWiM3BqHRDu7l7vI1
         0NFOwQ9OY8IthhFzupds8uGXuF2PitEAICniuhzUDAQLMVuouaI9DL5LetJRnobioEmh
         BTc2TiaXTZhy1bhX4xnuZELIBCcKCPtqt8ynUXLCxVWGGCJvn6pA0cGaHkYUCgfFgArv
         B3mPrT9Y6Ck4fNKLWZBfyJyG4sFJAwnIfJt3dJdWi0PrnoRNeRFoPEzoqCW3Q0bTe0sb
         E8cArtHaw5fcW+l1I7nxIHu8iMwJlClT1yyHCNSfmzKWdAK6n6XDkwrkxMP7bowmUCAa
         10Vg==
X-Gm-Message-State: APjAAAUx1Iqv+YvaNDZQxk1QBPKvoubV1DK1dyO1qwvpjOjDZdAx+5sE
        uoI8K/an9AVEBr7j2g/2Fos6Blgl
X-Google-Smtp-Source: APXvYqzWdkHgUjHAiqg2nq9sP39LmRlVXylbdfHMwq4cP1rqkcWHIFKA7/tNhncdq+PPwg4vPPpWCA==
X-Received: by 2002:a17:902:b68c:: with SMTP id c12mr4861370pls.126.1575486278993;
        Wed, 04 Dec 2019 11:04:38 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u18sm8526804pgi.44.2019.12.04.11.04.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Dec 2019 11:04:38 -0800 (PST)
Date:   Wed, 4 Dec 2019 11:04:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/321] 4.19.88-stable review
Message-ID: <20191204190437.GB11419@roeck-us.net>
References: <20191203223427.103571230@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 11:31:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.88 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2019 22:30:32 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
