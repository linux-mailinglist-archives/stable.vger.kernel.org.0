Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B71B9D5A6
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 20:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387774AbfHZSTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 14:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733229AbfHZSTo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 14:19:44 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECCD320850;
        Mon, 26 Aug 2019 18:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566843583;
        bh=0YtR6f2AE2y7KucThaJtcbzaBrsAm1p7BxHJkx1+/Iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KC9Y9lV1WQHq80vqNDbkxSUM+5XteKeFsv4Nq9+j2VftWPYAEHk8qeTdshV7dXqRd
         JBWuOtUOY/9HpDyEU0cJFf58ekcwccLlECPfH/k0EJUCji2z8jNve2JZTezmLGSR1G
         aMpKaavNNQVANmjgf86M2wbLuftMO5QJMcrV53pw=
Date:   Mon, 26 Aug 2019 14:19:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        amir73il@gmail.com
Subject: Re: [PATCH 0/6] xfs: stable fixes for v4.19.y - circa v4.19.60
Message-ID: <20190826181941.GJ5281@sasha-vm>
References: <20190724063451.26190-1-mcgrof@kernel.org>
 <20190823154459.GU16384@42.do-not-panic.com>
 <20190824143315.GK1581@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190824143315.GK1581@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 03:44:59PM +0000, Luis Chamberlain wrote:
>*poke*

I've queued them up for 4.19, thanks!

--
Thanks,
Sasha
