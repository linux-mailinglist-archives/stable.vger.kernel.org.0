Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C002B326197
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 11:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhBZKyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 05:54:54 -0500
Received: from ciao.gmane.io ([116.202.254.214]:49474 "EHLO ciao.gmane.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhBZKyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 05:54:53 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <glks-stable4@m.gmane-mx.org>)
        id 1lFal9-0006mU-UO
        for stable@vger.kernel.org; Fri, 26 Feb 2021 11:54:11 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     stable@vger.kernel.org
From:   =?UTF-8?Q?J=c3=b6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: Linux 5.11.2
Date:   Fri, 26 Feb 2021 11:54:07 +0100
Message-ID: <s1ak0f$p2g$1@ciao.gmane.io>
References: <1614334214168@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <1614334214168@kroah.com>
Content-Language: en-US
Cc:     linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

thanks for the upgrade.
There seems to be a dangling link in the git repository:
`scripts/dtc/include-prefixes/c6x`

Regards,
Jörg.


Greg Kroah-Hartman wrote on 26/02/2021 11.10:
> I'm announcing the release of the 5.11.2 kernel.
> 
> All users of the 5.11 kernel series must upgrade.
> 
> The updated 5.11.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
<snip>

