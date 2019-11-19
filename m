Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D735E1024CC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfKSMpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:45:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbfKSMpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 07:45:22 -0500
Received: from localhost (unknown [89.205.130.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E32520637;
        Tue, 19 Nov 2019 12:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574167521;
        bh=xNX8kkiE7Wa+MdRM2c57Nv1tVTluxCgzJ1yIL6cN+Yc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zJTmI0X6B44V5ddCigIU2VoJbalsYmQkCxG1DNYO538qUdRwHlVyW6LBZkWORT7rC
         aZ257cJQY2hARyzQGf6AIv1sGIlgGIRs0Rs8bzCMqmc3reAbCIS79/pP76yrevqZaD
         fZnaI7P/I7FPFife1SiNc5BGfGYpeP8aTXxhdDso=
Date:   Tue, 19 Nov 2019 13:45:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/48] 5.3.12-stable review
Message-ID: <20191119124518.GD1975017@kroah.com>
References: <20191119050946.745015350@linuxfoundation.org>
 <0ca5da93-b597-acb7-169c-a75421ecbd34@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ca5da93-b597-acb7-169c-a75421ecbd34@applied-asynchrony.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 01:35:26PM +0100, Holger Hoffstätte wrote:
> Hi Greg,
> 
> On 11/19/19 6:19 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.12 release.
> > There are 48 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.12-rc1.gz
> 
> That patch has not shown up after 7 hours - is the mirroring stuck?

No idea.  What mirror are you using?
