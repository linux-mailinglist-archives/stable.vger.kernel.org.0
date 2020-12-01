Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4382C996E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgLAI0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:26:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgLAI0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:26:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56FA720659;
        Tue,  1 Dec 2020 08:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606811131;
        bh=qCwCUff8U3pLCJcWL4RJTvS3e5f8p3sUkOKJ4emWYhA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SrL3j/Qn/+FeTYrHZ4INPpPSm1iwEo+OkhUAPcL1TGlVeQWwv7M4krkD6B4asJOlD
         HBMrfHprUhO0R5UdTx42zbxh+GiTu0/8Lmf5u9qY6F9XGlDHq1E/i8LdWIceEwan9J
         OciD1o6kXazE8v0KAhUS/A1QQbggbGvZ305YkTOg=
Date:   Tue, 1 Dec 2020 09:26:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaochen Shen <xiaochen.shen@intel.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org, bp@suse.de,
        reinette.chatre@intel.com, willemb@google.com, tony.luck@intel.com,
        fenghua.yu@intel.com, pei.p.jia@intel.com
Subject: Re: [PATCH 4.19 1/2] x86/resctrl: Remove superfluous kernfs_get()
 calls to prevent refcount leak
Message-ID: <X8X+Qk9TD6qWi1JG@kroah.com>
References: <16067252669529@kroah.com>
 <1606756754-8805-1-git-send-email-xiaochen.shen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606756754-8805-1-git-send-email-xiaochen.shen@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 01:19:14AM +0800, Xiaochen Shen wrote:
> commit fd8d9db3559a29fd737bcdb7c4fcbe1940caae34 upstream.
> 

<snip>

All backports now queued up, thanks!

greg k-h
