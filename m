Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57AB1190D74
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 13:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgCXMbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 08:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbgCXMbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 08:31:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3C652070A;
        Tue, 24 Mar 2020 12:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585053095;
        bh=SY8HQsZBY3j7KmBrYQTtTUid1DfEQiXmUOvITh6fB3U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hKfKVG6L8tYQTsNSsJIOF0p1nf1bHoM/XucrfuRA9ML32eGYH4iinBDC9xgQCsA1g
         rfeoBsarH7keVppFhCPfCcF/XjCeuVyDLvt9temX+IPYQwxRZL/e1MVflDfs+yxDUq
         VmjQ7PY/IDFJxrcD9Xs/bnly7U/84AThcUewDZMA=
Date:   Tue, 24 Mar 2020 13:31:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jslaby@suse.com>
Cc:     yebin10@huawei.com, stable@vger.kernel.org
Subject: Re: patch "vt: fix use after free in function "vc_do_resize"" added
 to tty-testing
Message-ID: <20200324123133.GC2348009@kroah.com>
References: <1585049515157141@kroah.com>
 <2770bbb6-f49b-f0a4-b7ee-7615609f3724@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2770bbb6-f49b-f0a4-b7ee-7615609f3724@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 12:47:19PM +0100, Jiri Slaby wrote:
> On 24. 03. 20, 12:31, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     vt: fix use after free in function "vc_do_resize"
> 
> I lost track about this one, but isn't this the patch which was
> withdrawn in favor of another patch really fixing the problem?

Was it?  I didn't think so.  But I have no idea.  I'll go drop this now
and wait for confirmation from Ye.

thanks,

greg k-h
