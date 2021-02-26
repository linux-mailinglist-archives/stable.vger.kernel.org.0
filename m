Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F35326207
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 12:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBZLeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 06:34:13 -0500
Received: from ciao.gmane.io ([116.202.254.214]:49950 "EHLO ciao.gmane.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhBZLeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 06:34:13 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <glks-stable4@m.gmane-mx.org>)
        id 1lFbNE-0009mo-9H
        for stable@vger.kernel.org; Fri, 26 Feb 2021 12:33:32 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     stable@vger.kernel.org
From:   =?UTF-8?Q?J=c3=b6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: Linux 5.11.2
Date:   Fri, 26 Feb 2021 12:33:26 +0100
Message-ID: <s1ama6$14dl$1@ciao.gmane.io>
References: <1614334214168@kroah.com> <s1ak0f$p2g$1@ciao.gmane.io>
 <YDjVShQyMIVWfZU7@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <YDjVShQyMIVWfZU7@kroah.com>
Content-Language: en-US
Cc:     linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH wrote on 26/02/2021 12.02:
> On Fri, Feb 26, 2021 at 11:54:07AM +0100, Jörg-Volker Peetz wrote:
>> Hi,
>>
>> thanks for the upgrade.
>> There seems to be a dangling link in the git repository:
>> `scripts/dtc/include-prefixes/c6x`
> 
> Is that new?  What commit caused it?

I think it was a removal, commit 584ce3c9b408a89f, which forgot the link.
Introduced in 5.11.2.

Regards,
Jörg.
> 
> thanks,
> 
> greg k-h
> 


