Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9051DD8FE
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 22:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgEUU7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 16:59:01 -0400
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:53474 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbgEUU7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 16:59:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jbsHK-00027G-Vj; Thu, 21 May 2020 21:58:59 +0100
Message-ID: <1d4004d71924fa2e4c422ae086166c280e5b43be.camel@codethink.co.uk>
Subject: Re: [stable] i2c: dev: Fix the race between the release of i2c_dev
 and cdev
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Date:   Thu, 21 May 2020 21:58:57 +0100
In-Reply-To: <20200521055011.GA2330588@kroah.com>
References: <0fa517f4672e45bbb11aeb57cfb2740b60f1f998.camel@codethink.co.uk>
         <20200521055011.GA2330588@kroah.com>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-05-21 at 07:50 +0200, Greg Kroah-Hartman wrote:
> On Wed, May 20, 2020 at 08:45:15PM +0100, Ben Hutchings wrote:
> > Please pick this fix for all stable branches:
> > 
> > commit 1413ef638abae4ab5621901cf4d8ef08a4a48ba6
> > Author: Kevin Hao <haokexin@gmail.com>
> > Date:   Fri Oct 11 23:00:14 2019 +0800
> > 
> >     i2c: dev: Fix the race between the release of i2c_dev and cdev
> > 
> > I don't know whether it will apply cleanly to all of them; I can deal
> > with those where it doesn't.
> 
> I applied it to 4.14, 4.19, 5.4, and 5.6.  It does apply to 4.9 but as
> the patch it depends on is not there, I don't think it will help.

It was included in 4.9.224, so both this and the similar watchdog fix
should be applicable for 4.9.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

