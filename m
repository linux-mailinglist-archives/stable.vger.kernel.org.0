Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E274177468
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 11:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgCCKk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 05:40:27 -0500
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:36316 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728341AbgCCKk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 05:40:27 -0500
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id D98013C0582;
        Tue,  3 Mar 2020 11:40:24 +0100 (CET)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mWN4JewvoYkw; Tue,  3 Mar 2020 11:40:19 +0100 (CET)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id C28533C058E;
        Tue,  3 Mar 2020 11:40:08 +0100 (CET)
Received: from lxhi-065.adit-jv.com (10.72.93.66) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Tue, 3 Mar 2020
 11:40:08 +0100
Date:   Tue, 3 Mar 2020 11:40:05 +0100
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "Lee, Chiasheng" <chiasheng.lee@intel.com>,
        Mathieu Malaterre <malat@debian.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hardik Gajjar <hgajjar@de.adit-jv.com>,
        <stable@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        <scan-admin@coverity.com>, Eugeniu Rosca <erosca@de.adit-jv.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH v3 1/3] usb: core: hub: fix unhandled return by employing
 a void function
Message-ID: <20200303103921.GA13097@lxhi-065.adit-jv.com>
References: <20200226175036.14946-1-erosca@de.adit-jv.com>
 <Pine.LNX.4.44L0.2002261313390.1406-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.2002261313390.1406-100000@iolanthe.rowland.org>
X-Originating-IP: [10.72.93.66]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Feb 26, 2020 at 01:14:24PM -0500, Alan Stern wrote:
> On Wed, 26 Feb 2020, Eugeniu Rosca wrote:
> > 
> > Fixes: 1208f9e1d758c9 ("USB: hub: Fix the broken detection of USB3 device in SMSC hub")
> > Cc: Hardik Gajjar <hgajjar@de.adit-jv.com>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: stable@vger.kernel.org # v4.14+
> > Reported-by: scan-admin@coverity.com
> > Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> 
> For all three patches:
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Friendly reminder to pick up the patches, if no other comments.

-- 
Best Regards
Eugeniu Rosca
