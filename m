Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5BC13B1D1
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 19:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgANSPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 13:15:32 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34854 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbgANSPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 13:15:32 -0500
Received: by mail-pf1-f195.google.com with SMTP id i23so6967658pfo.2;
        Tue, 14 Jan 2020 10:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g5liutGVodCeMPrPRgXIgzO9PdXNpl/iPD6hzc+IzBk=;
        b=rxLTNQpBwAntwITIdv29qfbVB6ItlM+fPmNpDwDe3kzjhHz9jWz6CBTVSR1TX5DyL9
         Km3Jv3fyTaFDtPhPythZLFiaFu/VLz83ICQjcmZtCZAmzmLuh6NvYabjUhOkHPl7CvT+
         QvFPJsN2+traNNhy5pKTuS1/0fbpAXUD21kpzdtrfdqU3VeJOILgDoeQngjYYEpzALdn
         8m7YH6e9zPNVUi6BCh4vv1n/oIg6LOAYKCZjdCYtBqzbpZB7G05l//8CPw2Q9KIZHOVj
         VsGYDxDinyQ67BGysOCYK1YGbGG8/sYRHujQr7EKQhQV64uw27MA4jfqPMJWXlrdJIW4
         wrHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=g5liutGVodCeMPrPRgXIgzO9PdXNpl/iPD6hzc+IzBk=;
        b=UzWmCH7trZyKWXZTsccSx0e5mC4bYKAE9BvKH61oaUzi5LbUT3r6Q7I3qd278cKR5k
         Yx296PFzZ8u2cJeUuMljkXWom/bB8XJxOBEVviXmHcOBo2ZsTGh9BKb8LSb+ANpiZve0
         7RzVSdL3Hb5bRwhn091H995pllrn3KaHlAipnrsy9D0uApS08FJ8yn1Xe+LczXa64Hta
         jzrpO4aGhhipfkoqI7OqbOBCou11VxS+TX7U5dy9yAo9QxgD8QnEelDUP67eCtN223q0
         FoN8m6CbmdX91rmP/E2pdLY2ZtLUyrP+vCd28FFYTzKnKiIzjiqu68Lm7YnVkR2w0QvY
         QN4g==
X-Gm-Message-State: APjAAAWUJ7btSfgLt75pUEVqZE15qSob0IYEp/EBTYRXgFlgzSkwGG2c
        aJwHuGViXepkIgw4xhlx2a8fGjzZ
X-Google-Smtp-Source: APXvYqzGqYreTjMh4VWTeRrPhmkFs+Y51jhON4biFaKxpgLbutpjV8+eHnqhKdTsSCqXvSwuTmEy5w==
X-Received: by 2002:a62:be09:: with SMTP id l9mr26074494pff.57.1579025731545;
        Tue, 14 Jan 2020 10:15:31 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v13sm19592436pgc.54.2020.01.14.10.15.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jan 2020 10:15:31 -0800 (PST)
Date:   Tue, 14 Jan 2020 10:15:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/39] 4.14.165-stable review
Message-ID: <20200114181530.GB18872@roeck-us.net>
References: <20200114094336.210038037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114094336.210038037@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 11:01:34AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.165 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 375 pass: 375 fail: 0

Guenter
