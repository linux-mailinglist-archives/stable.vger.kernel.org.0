Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F5A2AAA30
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 10:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgKHJMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 04:12:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgKHJMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Nov 2020 04:12:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5689C206E3;
        Sun,  8 Nov 2020 09:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604826737;
        bh=l5TH/IiB4ZMtGMDD17XZfvw1OarDp6XUrNGO5YDQnUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H9uYxRHIU9bBs1NCbZGwfxzYhsLo6PNxyYJiXIInHSfjwYFEJbp3Qz1Q4g2AgxpD/
         Aswnln9PcOQdR+BmdclH5R1pqO+BWus8tRfFRgvmJtT/hAKd/c4Xlf+vhhwKq6Kd+7
         pzuadumsk2MZrFeT35UnAEYdEfq8jEjcwVztaXII=
Date:   Sun, 8 Nov 2020 10:12:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [4.14] Security fixes (blktrace, i40e)
Message-ID: <20201108091214.GB44749@kroah.com>
References: <c21d1ef1ddb071eed868a96649b4edf0b61b4247.camel@codethink.co.uk>
 <20201107152827.GA90705@kroah.com>
 <CAB=NE6U=kTw_R+OkqLf0iT0Bwti8w=7RWjWgeQmVQssbZ4OL3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6U=kTw_R+OkqLf0iT0Bwti8w=7RWjWgeQmVQssbZ4OL3w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 08, 2020 at 03:04:14AM -0600, Luis Chamberlain wrote:
> I'd like some more time for this, to review on older kernels. Don't think
> it's the best yet

What is "this" and what is "the best yet"?  Which patch(s) here are you
referring to in your context-less top-post?  :)

thanks,

gre gk-h
