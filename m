Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F5811BBA2
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 19:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfLKS0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 13:26:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfLKS0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 13:26:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45302222C4;
        Wed, 11 Dec 2019 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576088763;
        bh=0XnBs9GJ5ZHQlJiYoWtzbdD949ZBHNDLbnEUlB3SDu0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vTsfyOxQBC/Yi6r8JK5pXl/XKBlb2QTfJp2yeyl0zKm9CqXGEnKrcLNmjD5oBGdls
         Ck2jyMU5qWJ9L5XFkRZyi8vhltzHUV7KX/LAa++pL5woH5bINj54wWW8TQpWBgFGNw
         FjgUcIk8LkTZExEWcAj6E2ZJxdfGAdZsXsrIg0PE=
Date:   Wed, 11 Dec 2019 19:26:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
Message-ID: <20191211182601.GC715013@kroah.com>
References: <20191211150339.185439726@linuxfoundation.org>
 <TYAPR01MB2285255A7763F2053C059F91B75A0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB2285255A7763F2053C059F91B75A0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 04:25:19PM +0000, Chris Paterson wrote:
> Hi Greg,
> 
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 11 December 2019 15:03
> > 
> > This is the start of the stable review cycle for the 4.19.89 release.
> > There are 243 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> All the issues I was reporting before have gone. No new ones either.

Wonderful, thanks for letting me know.

greg k-h
