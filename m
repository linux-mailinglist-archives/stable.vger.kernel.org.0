Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2F846310B
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 11:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbhK3Kgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 05:36:49 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33808 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbhK3Kgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 05:36:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DF714CE1752
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 10:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA7DC53FC1;
        Tue, 30 Nov 2021 10:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638268407;
        bh=DnucsCBdo5a8f3aY5NyX5Q/+5/7k7HxyUNgvMWw9G2c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jBXcbzhJoNdgrVt25pAcCn3JyMdx3Q2+F5KpsfelnvDnhTG7bq1ruAqT9Dh4IpswM
         ZY7W1q+u8T6Io7U+qz1CG+VsVP8bJzZXCyJIpxyx4VwX8i3It98DvGUgpO1kCOa5FP
         J8/QpXs7lWQu5yl34aWgXFIp/zUNEyMK898l53hc=
Date:   Tue, 30 Nov 2021 11:33:24 +0100
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
Message-ID: <YaX99Dc28F8t6Noo@kroah.com>
References: <1637583701164207@kroah.com>
 <20211129194914.827672-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129194914.827672-1-alexander.mikhalitsyn@virtuozzo.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 10:49:14PM +0300, Alexander Mikhalitsyn wrote:
> For 4.9.y:
> 
> Upstream commit 85b6d24646e4 ("shm: extend forced shm destroy to support objects from several IPC nses")

Now queued up, thanks.

greg k-h
