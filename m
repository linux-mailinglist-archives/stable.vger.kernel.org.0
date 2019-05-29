Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016552E4CE
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 20:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfE2Svp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 14:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfE2Svp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 14:51:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9040B240B9;
        Wed, 29 May 2019 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559155904;
        bh=5VuX/GAFgFb7HOykYAm7dgMDb5AFHyTX6Y+lg+tLFf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NHo/ftvVhBCQVEblvVpCzXL8QPWeZIVf3VbTGgn/ZRrTEp7u71XGjFXaNjVLwnnPc
         S+4fPZ2Om4/VTdClc6vMtlIx6GIUL2UphDBWpMYVQmI9HOPMANhACNLKq3ENDEYrtD
         JO8DO1tXu9vYn0x5i4thef3IIV7dS3B3qKi5zbOc=
Date:   Wed, 29 May 2019 14:51:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.1 033/375] leds: avoid races with workqueue
Message-ID: <20190529185143.GH12898@sasha-vm>
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-33-sashal@kernel.org>
 <20190524225505.GA16076@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190524225505.GA16076@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 25, 2019 at 12:55:05AM +0200, Pavel Machek wrote:
>Hi!
>
>Could we hold this patch for now?

Sure, dropped. Thanks!

--
Thanks,
Sasha
