Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FA61B89F2
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 01:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgDYXZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 19:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbgDYXZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Apr 2020 19:25:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71F6420714;
        Sat, 25 Apr 2020 23:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587857151;
        bh=wzYQRm7IiRdDFrE+EcEnnr97XrWdOZUzUeZBvDMdvuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cjl9h/1jJMUy6hrMygxNhf1SKY6BfQNILEjrUQD91ASZULABQLe86lGGsFJdw2pga
         /4+AGYW7h9MdoY9arN7QbqtK+7c5O92xyZR3q/kbp1PJvhhCD4OSOzptUFXFMWsOzZ
         NYBzyxafLMNuBfeX2RvFarch+LU1naTfJfcT5o8Q=
Date:   Sat, 25 Apr 2020 19:25:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.19-stable] Security fixes
Message-ID: <20200425232550.GI13035@sasha-vm>
References: <86f25568f14f413d3d0edf45e37166caef7374cf.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <86f25568f14f413d3d0edf45e37166caef7374cf.camel@codethink.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 25, 2020 at 10:47:20PM +0100, Ben Hutchings wrote:
>Here are some fixes that required backporting for 4.19.  All of them
>are already present in later stable branches.

Queued up, thanks Ben!

-- 
Thanks,
Sasha
