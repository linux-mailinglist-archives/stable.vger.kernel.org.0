Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236822F00FF
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 16:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbhAIPu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 10:50:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbhAIPu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 10:50:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 269E423A04;
        Sat,  9 Jan 2021 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610207417;
        bh=iCv8P94Ryj5BbeEieKbXfs4lYtivVzoVqOrJXf9G2IU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YsWUZtG94R/ouB6Rbuz0Efg3//bJkG10+DLI7ME/8dykqiaUko6QxGUbHvbflUCQa
         xLOC1e6yFRSCHuUB+Alv2GxmJURhxEffdEpnKbJW/x8SRar9wRfZsFQXOwUfdRw8s1
         IyOrdTz9JYXqXsF1uD9OEPpJGY8mn7xjz3xDPb6aPrzMYDO4IDv2bIeFbfRbrDB7+G
         dD6pIZok/IHYY+VqOmmwx/t+IdHZqeqKffGXBX3a5x0ErHTrbuq7e6y46WJCaPfos2
         bCyjdz7y+xHrMC+RJvKMRpiSRDRzhYo8dUQMom/u41l1v/0gsQ+g88xTV7sDFT47Lp
         8qpnDDcw7Rxww==
Date:   Sat, 9 Jan 2021 10:50:16 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>
Subject: Re: LTS: proc: fix lookup in /proc/net subdirectories after setns(2)
Message-ID: <20210109155016.GF4035784@sasha-vm>
References: <935692185a18ab86667e66a85aaed382aa34c3bd.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <935692185a18ab86667e66a85aaed382aa34c3bd.camel@nokia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 08, 2021 at 07:47:17AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
>Hi Greg,
>
>Can you cherry-pick these to 4.19.y & 5.4.y:
>
>commit e06689bf57017ac022ccf0f2a5071f760821ce0f
>Author: Alexey Dobriyan <adobriyan@gmail.com>
>Date:   Wed Dec 4 16:49:59 2019 -0800
>
>    proc: change ->nlink under proc_subdir_lock
>
>commit c6c75deda81344c3a95d1d1f606d5cee109e5d54
>Author: Alexey Dobriyan <adobriyan@gmail.com>
>Date:   Tue Dec 15 20:42:39 2020 -0800
>
>    proc: fix lookup in /proc/net subdirectories after setns(2)

I'll grab it, thanks!

-- 
Thanks,
Sasha
