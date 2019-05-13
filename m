Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D451B1B9
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 10:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfEMIOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 04:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727371AbfEMIOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 04:14:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A154C208C3;
        Mon, 13 May 2019 08:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557735264;
        bh=dNA4RUmgUPTaRXLId4vdl+VumePaZKcBqYYz1aVXYc0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EFirF4XvAin4sCjsjf5gNH7jkqYCrlIfcEFtDurCd6YG4QrMGGidNjpR6oa8fjjpM
         svkPb+laR4BIvOF5rOGM5/yY/qi8PBcrV7UNu8hbM+OvW3uHx7rPVnYuVBXMMTC7eo
         653StPx+8qFxdIYlmLtwar33ZP4mR3Q5byM8f8Ic=
Date:   Mon, 13 May 2019 10:14:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     pepijn de vos <pepijndevos@gmail.com>
Cc:     mario.limonciello@dell.com, dvhart@infradead.org,
        pali.rohar@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] platform/x86: dell-laptop: fix rfkill
 functionality" failed to apply to 4.14-stable tree
Message-ID: <20190513081421.GA4169@kroah.com>
References: <155773326874172@kroah.com>
 <CANPfQguhJSokwhFsfhCCyWzCvX6PPcT4mzXSCh3gC9nGc+_0Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANPfQguhJSokwhFsfhCCyWzCvX6PPcT4mzXSCh3gC9nGc+_0Zg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 09:56:43AM +0200, pepijn de vos wrote:
> I attached a 4.15 patch to the bugzilla issue
> https://bugzilla.kernel.org/show_bug.cgi?id=201427 which might also apply
> to earlier branches. Please let me know if any further action is needed to
> format this correctly for inclusion to the kernel.
> 
> Regards,
> Pepijn de Vos
> 
> On Mon, May 13, 2019 at 9:41 AM <gregkh@linuxfoundation.org> wrote:
> 
> >
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > From 6cc13c28da5beee0f706db6450e190709700b34a Mon Sep 17 00:00:00 2001
> > From: Mario Limonciello <mario.limonciello@dell.com>
> > Date: Wed, 27 Mar 2019 09:25:34 -0500
> > Subject: [PATCH] platform/x86: dell-laptop: fix rfkill functionality
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> >
> > When converting the driver two arguments were transposed leading
> > to rfkill not working.
> >
> > BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=201427
> > Reported-by: Pepijn de Vos <pepijndevos@gmail.com>
> > Fixes: 549b49 ("platform/x86: dell-smbios: Introduce dispatcher for SMM
> > calls")
> > Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
> > Acked-by: Pali Rohár <pali.rohar@gmail.com>
> > Cc: <stable@vger.kernel.org> # 4.14.x

The problem is this says "4.14.x", yet 549b4930f057 ("platform/x86:
dell-smbios: Introduce dispatcher for SMM calls") was not in the tree
until 4.15, so I don't see how this would work on 4.14.

Daren?

