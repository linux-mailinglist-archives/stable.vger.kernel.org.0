Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD874129C03
	for <lists+stable@lfdr.de>; Tue, 24 Dec 2019 01:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLXAQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 19:16:09 -0500
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:47312 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfLXAQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 19:16:09 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id xBO0G5go009874; Tue, 24 Dec 2019 09:16:05 +0900
X-Iguazu-Qid: 2wHHCQuRS17L5VPBpr
X-Iguazu-QSIG: v=2; s=0; t=1577146565; q=2wHHCQuRS17L5VPBpr; m=4Mgqq+EOfZPARHrHogskPrF+IGD13EmtQ3n68MCBya4=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1113) id xBO0G5FJ037723;
        Tue, 24 Dec 2019 09:16:05 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xBO0G4KU004906;
        Tue, 24 Dec 2019 09:16:04 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xBO0G4k3022479;
        Tue, 24 Dec 2019 09:16:04 +0900
Date:   Tue, 24 Dec 2019 09:16:03 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH for 4.4, 4.9, 4.14, 4.19] uio: make symbol
 'uio_class_registered' static
X-TSB-HOP: ON
Message-ID: <20191224001603.pckj4oszyno4kfij@toshiba.co.jp>
References: <20191223235210.2312-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20191224000906.GB282927@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224000906.GB282927@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 23, 2019 at 07:09:06PM -0500, Greg KH wrote:
> On Tue, Dec 24, 2019 at 08:52:10AM +0900, Nobuhiro Iwamatsu wrote:
> > From: Wei Yongjun <weiyongjun1@huawei.com>
> > 
> > commit 6011002c1584d29c317e0895b9667d57f254537a upstream.
> > 
> > Fixes the following sparse warning:
> > 
> > drivers/uio/uio.c:277:6: warning:
> >  symbol 'uio_class_registered' was not declared. Should it be static?
> > 
> > Fixes: ae61cf5b9913 ("uio: ensure class is registered before devices")
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> > ---
> >  drivers/uio/uio.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Why is this a valid patch for the stable trees?
> 
> Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> 
> for the rules.

Sorry, my bad.

Nobuhiro
