Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7403C2E25AF
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 10:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgLXJj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Dec 2020 04:39:27 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10078 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgLXJj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Dec 2020 04:39:27 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D1lNr2hGlzM8gZ;
        Thu, 24 Dec 2020 17:37:48 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.205) with Microsoft SMTP Server (TLS) id 14.3.498.0; Thu, 24 Dec
 2020 17:38:42 +0800
Subject: Re: [PATCH 5.10 24/40] f2fs: fix to seek incorrect data offset in
 inline data file
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        kitestramuort <kitestramuort@autistici.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20201223150515.553836647@linuxfoundation.org>
 <20201223150516.715040953@linuxfoundation.org>
 <962b2db7-383f-b4da-5221-2004235d19c1@huawei.com>
 <X+RIq1wk1ZBPIxsX@kroah.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <8a04d425-78bb-5d8f-c922-5e45ff145ca9@huawei.com>
Date:   Thu, 24 Dec 2020 17:38:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <X+RIq1wk1ZBPIxsX@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/12/24 15:52, Greg Kroah-Hartman wrote:
> On Thu, Dec 24, 2020 at 09:11:53AM +0800, Chao Yu wrote:
>> Hi Greg,
>>
>> Thanks a lot for helping to resend and merge the patch. :)
> 
> Not a problem, glad to help out.  In the future, all you need to do is
> give us the git commit id that needs to be backported if it applies
> cleanly, no need to send the whole patch!

I will keep this in mind, thanks for your reminder.

Thanks,

> 
> thanks,
> 
> greg k-h
> .
> 
