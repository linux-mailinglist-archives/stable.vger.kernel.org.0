Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1683B53AE
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhF0OZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229922AbhF0OZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 10:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CFDA61C20;
        Sun, 27 Jun 2021 14:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624803764;
        bh=BL5X+fM/LTEvN7ymmxMmbp9ofeRlCUSQ6wwd0bnY7CQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l3RXeLLyv/bTuv2dmZ42BY/l96yKbU4anIsig/2EkgIVBehHpR/NcHeYJtmzo6epy
         Ra5Qfc8ss9ieTn2HaW4O8SYFyHCFIFalXcG7hTHMKPv65ihXDiyq1/pM3Ux1/LXQel
         e5mdMUfPwmuYoICfpxlpAbpICOmI922X54ieAfLE=
Date:   Sun, 27 Jun 2021 16:22:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     stable@vger.kernel.org, dhowells@redhat.com,
        Matthew Wilcox <willy@infradead.org>,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] ceph: fix test for whether we can skip read when writing
 beyond EOF
Message-ID: <YNiJsmqZRDlFdnIa@kroah.com>
References: <20210625175951.90347-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625175951.90347-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 25, 2021 at 01:59:51PM -0400, Jeff Layton wrote:
> commit 827a746f405d upstream.

No it is not :(

Please fix this up and resend it with the correct git id.

thanks,

greg k-h
