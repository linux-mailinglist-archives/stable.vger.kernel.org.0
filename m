Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF89794B52
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 19:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfHSRJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 13:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbfHSRJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 13:09:18 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3FA22087E;
        Mon, 19 Aug 2019 17:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566234557;
        bh=ZZAmm+0S+XXrGxFqHat3r+HNDl11o2B+//QD2hq0w7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0gkgK/CTc0eV25wfgDy7EcZuyN/glrWQj5E6rs88SpPxoqr6nzjrMhqwCmDMMV5HE
         KjUSQDUMjZOiBR5eflokd6T3FhQNkhtuyTdH3EfT4JB/ae4d4PpcjYOrc7e+357q/t
         szmkKqGz/FtDbrK0ibi9kVaS5t5pxeOkk/HbZm1g=
Date:   Mon, 19 Aug 2019 13:09:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: perf build failures in {v4.4,v4.9,v4.14}.y.queue
Message-ID: <20190819170917.GB30205@sasha-vm>
References: <7eb8b107-1fa8-9619-9608-e064c45a2c8d@roeck-us.net>
 <CA+res+Q=TMpJLTHMgWLH+DMyUp0ozFVCmtSSENukRYLGu=nroA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+res+Q=TMpJLTHMgWLH+DMyUp0ozFVCmtSSENukRYLGu=nroA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 03:49:38PM +0200, Jack Wang wrote:
>Guenter Roeck <linux@roeck-us.net> 于2019年8月19日周一 下午3:36写道：
>>
>> util/header.c: In function ‘perf_session__read_header’:
>> util/header.c:2860:10: error: ‘data’ undeclared
>>
>> Culprit is "perf header: Fix divide by zero error if f_header.attr_size==0".
>>
>> Fix might be to replace "data->file.path" with "file->path" in the affected
>> branches.
>>
>> Guenter
>I had same error on 4.14.140-rc1, and yes, replace data->file.path
>with file->path works.

I've fixed it up, thank you!

--
Thanks,
Sasha
