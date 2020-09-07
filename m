Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A33B2602A7
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgIGRbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgIGRbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 13:31:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7991D206E6;
        Mon,  7 Sep 2020 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599499901;
        bh=mwexkwbu4CTktJhC9cDAVanECy8APgLsoGc6mNBVhhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FOau6S9WyHWjOA2qv4sSRFsnFU6xGjHhDV8O+nUxKXGOxtzoNPsJTUE7YAF+FCjQo
         O56ArRmlgWZvgbTnc14IfhH5HHT/2rhiezn1yWeYxsECQuGwo/rSnYfQcswm5Ok+0k
         jLjkVWofN8/aQerz/pMYq6zo64W8+/N4yliV0TAU=
Date:   Mon, 7 Sep 2020 19:31:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Codrin.Ciubotariu@microchip.com
Cc:     havasiefr@gmail.com, stable@vger.kernel.org
Subject: Re: duplicated patch in 5.4
Message-ID: <20200907173154.GA1016021@kroah.com>
References: <CADBnMvh6gODocz8=fNE0wVcv71SdHKNtee7hAZev6OdZ7EZcAw@mail.gmail.com>
 <788f9aa0-f03d-c736-a8a1-9a989f2e9c6e@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <788f9aa0-f03d-c736-a8a1-9a989f2e9c6e@microchip.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 07, 2020 at 05:15:49PM +0000, Codrin.Ciubotariu@microchip.com wrote:
> On 07.09.2020 17:24, Kristof Havasi wrote:
> > Dear Ciubatariu,
> > 
> > as I am not familiar with the linux development workflow, I am
> > contacting you directly as the author of the upstream patch:
> > af199a1a9cb02ec0194804bd46c174b6db262075
> > 
> > I noticed that your addition there was applied twice into 5.4 [1]
> > 
> > d9b8206e5323ae3c9b5b4177478a1224108642f7    v5.4.51-45-gd9b8206e5323
> > d55dad8b1d893fae0c4e778abf2ace048bcbad86     v5.4.52-13-gd55dad8b1d89
> > 
> > resulting in a non-harmful, but unnecessary double setting of the variable.
> > 
> > /* set the real number of ports */
> > dev->ds->num_ports = dev->port_cnt;
> > 
> > /* set the real number of ports */
> > dev->ds->num_ports = dev->port_cnt;
> > 
> > return 0;
> > 
> > Could you notify the stable maintainers to apply your patch correctly?
> > 
> > Best regards,
> > Kristóf Havasi
> > 
> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/net/dsa/microchip/ksz8795.c?h=v5.4.63#n1274
> > 
> 
> Hello,
> 
> Kristóf discovered that one patch of mine was applied twice. What is the 
> best way to address this?

Send us a revert would be best.

thanks,

greg k-h
