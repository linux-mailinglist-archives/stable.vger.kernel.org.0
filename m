Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20162226ECE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 21:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgGTTPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 15:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgGTTPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 15:15:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FEAE2176B;
        Mon, 20 Jul 2020 19:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595272545;
        bh=9krAQF9sYz+HpU7MAOk/PbdciQNSUovCauf4PC+UhjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nz9ZtIr8gsZe8EirN8PepPNeOVJ/2q0dGSkeVkhSMPlr20GQqPONjGFEA9SQv3+ba
         pvrTmsef5+pj03+tA6TkQDl4Y+iqlo/6kFDVpVN6M9rHOkgH0/+OaKptgX4y6dhAx8
         b7gQlYwN9+RbphkaklS+l/iEs3qY06lSBh/JPwn8=
Date:   Mon, 20 Jul 2020 21:15:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.7 021/244] cgroup: fix cgroup_sk_alloc() for
 sk_clone_lock()
Message-ID: <20200720191554.GC1529125@kroah.com>
References: <20200720152825.863040590@linuxfoundation.org>
 <20200720152826.873682902@linuxfoundation.org>
 <20200720164541.GA139672@carbon.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720164541.GA139672@carbon.dhcp.thefacebook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 09:46:10AM -0700, Roman Gushchin wrote:
> On Mon, Jul 20, 2020 at 05:34:52PM +0200, Greg Kroah-Hartman wrote:
> > From: Cong Wang <xiyou.wangcong@gmail.com>
> > 
> > [ Upstream commit ad0f75e5f57ccbceec13274e1e242f2b5a6397ed ]
> 
> Hi Greg!
> 
> There is a fix for this commit:
> 14b032b8f8fc ("cgroup: Fix sock_cgroup_data on big-endian.")
> 
> Can you, please, grab it too?

It is already queued up in this series :)

thanks,

greg k-h
