Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF15E461CBC
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 18:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbhK2Rcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 12:32:36 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60178 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243629AbhK2Rag (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 12:30:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3698CE131E
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62484C53FAD;
        Mon, 29 Nov 2021 17:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638206834;
        bh=9ZfxGhTpDwRBFUAga8l7wFer32KFGyEPYt07HwkL9gg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1fHb04rbTd6o/OrWOx1SaQgh/rE1McKdDomHPPXIGXalofjCgBAhr2vtz/XXvDI33
         DT0eW4ZMvm7gBGJtty0wMNv9W08fE+4GLvq47ADkMAxx+JHbOC4EbNc0W96W30PR+d
         CUJAm9BGpCsHedn7ZzrIFypXIvqhdtRN+zS2u9/k=
Date:   Mon, 29 Nov 2021 18:27:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     stable@vger.kernel.org, manfred@colorfullife.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH] shm: extend forced shm destroy to support objects from
 several IPC nses
Message-ID: <YaUNb9NyKVio+bQ6@kroah.com>
References: <163758370064179@kroah.com>
 <20211129164300.789517-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129164300.789517-1-alexander.mikhalitsyn@virtuozzo.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:43:00PM +0300, Alexander Mikhalitsyn wrote:
> For 4.4.y:
> 
> Upstream commit 85b6d24646e4 ("shm: extend forced shm destroy to support objects from several IPC nses")

We need versions of this for 4.9.y, 4.14.y, and 4.19.y before I can take
this for 4.4.y.

thanks,

greg k-h
