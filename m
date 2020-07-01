Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC904210CED
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 15:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbgGAN50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 09:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730958AbgGAN5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 09:57:25 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7A54206BE;
        Wed,  1 Jul 2020 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593611845;
        bh=K+W5r37zu3fWyvbfeBMEA4GcLF5jdRWhxkCwE6BQ/dE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NM3ILmg0fc73ZBx7JnmcK3wRb7+d4fx3yuLt2lkKizQLw+VDnfZp80Ya8QWU3xIRX
         a6U4y/kI3B7uYgELwN/cDBtBh3/XMUwKTPsmcj2fQNyVg/5LAmpISDWyfVZBMEheAH
         S/PYI62MshXoSVhCnKSybFBVlWgcXedVtdqgRiSw=
Date:   Wed, 1 Jul 2020 09:57:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Re: Linux 5.7.7
Message-ID: <20200701135723.GA2687961@sasha-vm>
References: <20200701134953.2688293-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200701134953.2688293-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 01, 2020 at 09:49:52AM -0400, Sasha Levin wrote:
>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA512
>
>I'm announcing the release of the 5.7.7 kernel.

Please ignore this mail for 5.7.7, a new announcement will follow.

-- 
Thanks,
Sasha
