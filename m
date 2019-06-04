Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007D8340B8
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfFDHwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfFDHwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 03:52:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39F38248E7;
        Tue,  4 Jun 2019 07:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559634757;
        bh=t4hh0ZYbPXADhoKnK97lXTl1L9/uoS+jkawQ1M+S5+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aIOqHSiVTsxTwEiJDQC2VlrGeSDLkPR5TjHiU4hpGWbmizikkJ4MzhSJGKcosQJ51
         IBmLLiB4EYxOD1ahvK3ZFpvGEjJ746USsIw0IFi5Gjgx4JdSl4yU6q2lOT4Z473NZf
         Fkqk7tOJsvtMxiq9re0GUDnyvBFkSCIBmj1pTUGA=
Date:   Tue, 4 Jun 2019 09:52:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        blackgod016574@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: 95baa60a0da8 ("ipv6_sockglue: Fix a missing-check bug in
 ip6_ra_control()")
Message-ID: <20190604075235.GD6840@kroah.com>
References: <20190603173114.GA126543@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603173114.GA126543@google.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 10:31:15AM -0700, Zubin Mithra wrote:
> Hello,
> 
> CVE-2019-12378 was fixed in the upstream linux kernel with the following commit.
> * 95baa60a0da8 ("ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()")

A CVE was created for that tiny thing?

Hah, no, I think I'll refuse to apply it just for the very point of it.
That's something that can not be triggered by normal operations, right?
It's a bugfix-for-the-theoritical from what I can see...

> Could the patch be applied to v4.19.y, v4.14.y, v4.9.y and v4.4.y?

Why are you ignoring 5.1?

thanks,

greg k-h
