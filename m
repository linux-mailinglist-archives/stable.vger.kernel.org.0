Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBF170417
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 17:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbfGVPmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 11:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729726AbfGVPmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 11:42:40 -0400
Received: from localhost (unknown [167.220.2.219])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDC3921985;
        Mon, 22 Jul 2019 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563810159;
        bh=1Wneq/JraAvtf7oV8RrnfIIhUkdW3rRzFhusqSdLoLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a76U9yrCFC+ygiFXwnFXH71FCqI/hxQfI8OxVH2DR9kLp43aEZJ0Dsi4f68R2xt8e
         oC/Z1oJiyY7gqYcilOkMeuFglWmPaP6Pjt7E3knuPXO+cTvoXm9baT/73Uf1PeZjjF
         /4UGvhJUekvKIsMPGI5aWgYRUH72tHJkwiHDeEek=
Date:   Mon, 22 Jul 2019 11:42:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jack Wang <jinpuwang@gmail.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [stable-4.19 0/4] CVE-2019-3900 fixes
Message-ID: <20190722154239.GH1607@sasha-vm>
References: <20190722130313.18562-1-jinpuwang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190722130313.18562-1-jinpuwang@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 22, 2019 at 03:03:09PM +0200, Jack Wang wrote:
>Hi, Greg, hi Sasha,
>
>I noticed the fixes for CVE-2019-3900 are only backported to 4.14.133+,
>but not to 4.19, also 5.1, fixes have been included in 5.2.
>
>So I backported to 4.19, only compiles fine, no functional tests.
>
>Please review, and consider to include in next release.

Thanks Jack. It'll be great if someone can test it and confirm it fixes
the issue (and nothing else breaks).

--
Thanks,
Sasha
