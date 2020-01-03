Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB3C12FBB8
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 18:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgACRq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 12:46:27 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42973 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgACRq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 12:46:27 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so23827086pfz.9;
        Fri, 03 Jan 2020 09:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+IK4qZf1elM4GUwKbJjSh6z+cMyka7NKu36GNcjku/k=;
        b=Fio6UIQb2MMmaTOh9mYh5p/VpbOx5m81p3m0cK+rQw/aVCpCpjjwNaR1Glr3LucWTP
         1QKsmZ9Ayu5KlW16Qp54GMLVgYxVTN4cZsNtyLhSK15qxV4JRYyVpL8cM93VZ9yryQMu
         dcz6aOVAG1x0M9n5LjXbq52q5lnoM+RCEK0W/s4CbRjxUDoQT4YtopczJhD+9GZPEgOa
         M2dNkkgUqs+GqitsmnpzFAxRBXtt5hHTb9Wp5YrKYAQi7ZjlYb7CeqNCzygk4ZLhce9G
         pObynjIR0mQrtx+0N6MzOx3GADtCeSbODeIATPwidn25ujFPY9tSCizdZVM1wNuXYox4
         YlIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+IK4qZf1elM4GUwKbJjSh6z+cMyka7NKu36GNcjku/k=;
        b=GyY0uz5805qhgSJs+nE+h3wpcwL/0kv9jMsdMcLND6qQZDY4HGXXhCYqJu4loFXvND
         leBlhZKOJtn5fqpxfeHbRKCF+Gx2BmBk6d5Tjcd2VWPkrZgiMhkEr1gQw2u5tn5I5yuR
         wwjGZFbLWnWFa52APt47SSj1ElVLSEQ933AzknsQpAdY+U4Iy3haz9dwSOhnrs4H1U7N
         vXsbLJkY/s1hMC3rUskGIzLU/9jsupPssNkyGt2xErJLgwWvU3dscQCYnB1Qx4hsY75e
         0LmJoOoeKEa15y0pU47ClGnWF9jSAaiB4qoET9ymRJgA+/wPI2l2AtK/gVPVUKZmOXBx
         tPYQ==
X-Gm-Message-State: APjAAAUWUf5uvTB7/WVHKyWjc8QoffLS5aIIKbukfK3McFQ9KBY+lQVb
        8pCIm2Pz/aqVBNsVHb4Itq4=
X-Google-Smtp-Source: APXvYqy3LCa3jYiWtyUW1H8gt/TIzC9zhm49qHavyCy9nxOGgHSt4Ig6dTqOC4d1t7/ZuCFrssH/QQ==
X-Received: by 2002:a63:954f:: with SMTP id t15mr95940699pgn.137.1578073586726;
        Fri, 03 Jan 2020 09:46:26 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 73sm64484349pgc.13.2020.01.03.09.46.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Jan 2020 09:46:25 -0800 (PST)
Date:   Fri, 3 Jan 2020 09:46:24 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/114] 4.19.93-stable review
Message-ID: <20200103174624.GA27087@roeck-us.net>
References: <20200102220029.183913184@linuxfoundation.org>
 <72f41f89-bf68-d275-2f1e-d33a91b5e6cd@roeck-us.net>
 <20200103154156.GA1064304@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103154156.GA1064304@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 04:41:56PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Jan 03, 2020 at 06:27:53AM -0800, Guenter Roeck wrote:
> > On 1/2/20 2:06 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.93 release.
> > > There are 114 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat, 04 Jan 2020 21:58:48 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 156 pass: 155 fail: 1
> > Failed builds:
> > 	sparc64:allmodconfig
> > Qemu test results:
> > 	total: 381 pass: 381 fail: 0
> > 
> > ERROR: "of_irq_to_resource" [drivers/spi/spi-fsl-spi.ko] undefined!
> > 
> > Caused by 3194d2533eff ("spi: fsl: don't map irq during probe")
> > which is missing its fix, 63aa6a692595 ("spi: fsl: use platform_get_irq()
> > instead of of_irq_to_resource()")
> 
> Now added to 4.14 and 4.19 queues, thanks!
> 
sparc64:allmodconfig builds now pass in both v4.14.y and v4.19.y queues.

Guenter
