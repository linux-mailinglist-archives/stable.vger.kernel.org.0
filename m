Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFC32E7F5E
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 11:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgLaKWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 05:22:08 -0500
Received: from www381.your-server.de ([78.46.137.84]:46578 "EHLO
        www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgLaKWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Dec 2020 05:22:08 -0500
X-Greylist: delayed 992 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Dec 2020 05:22:08 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
         s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=U8meFnagSx5UoL6OkuHCQ1qYQXyfGOujKQn9JkRkgxw=; b=CR0YduAIqGTPqs/+Eg6L34JJbN
        lOFf8cyjDV/koo3PRttFyvepYh0Tb5/tJC4rWs5ER/UYsh4EXSdN7b4eDlHjGHwYh7lBs5lViZkhQ
        jmFWTfsmjmphTQ3I3XByjIHE4ouiKbCw5ZOxhVUfzkXB0Ee0khLgMS9jb6wC5B1nbybqH/0Zm96Au
        vdUfMHKdokQkhRFtn2XZKxTRYyGHWjRJs0qvcHDoEHtxyN8uuWabZafwp/30AD5qLQ9euBrnzqErh
        wk0uk22x0spmdfOdKPOzJYsv8kypz3nbAKfEqKZgIeH9Ud0QpPKAwIJJc92TyatwNmNuChB8DBFqn
        9TpqE4LQ==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www381.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <lars@metafoo.de>)
        id 1kuupB-0006d6-Af; Thu, 31 Dec 2020 11:04:53 +0100
Received: from [2001:a61:2af4:a201:9e5c:8eff:fe01:8578]
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1kuupB-0007li-3g; Thu, 31 Dec 2020 11:04:53 +0100
Subject: Re: Haswell audio no longer working with new Catpt driver (was:
 sound)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Labisch <clnetbox@gmail.com>
Cc:     Greg Kroah-Hartman <stable@vger.kernel.org>,
        Greg Kroah-Hartman <linux-kernel@vger.kernel.org>,
        Akemi Yagi <toracat@elrepo.org>,
        Justin Forbes <jforbes@redhat.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>
References: <2f0acfa1330ca6b40bff564fd317c8029eb23453.camel@gmail.com>
 <efc6d5e8abc1da3cac754cb760fff08a1887013b.camel@gmail.com>
 <X+2MzJ7bKCQTRCd/@kroah.com>
From:   Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <a194639e-f444-da95-095d-38e07e34f72f@metafoo.de>
Date:   Thu, 31 Dec 2020 11:04:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X+2MzJ7bKCQTRCd/@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.102.4/26033/Wed Dec 30 13:42:10 2020)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/31/20 9:33 AM, Greg Kroah-Hartman wrote:
> On Wed, Dec 30, 2020 at 07:10:16PM +0100, Christian Labisch wrote:
>> Update :
>>
>> I've just tested the kernel 5.10.4 from ELRepo.
>> Unfortunately nothing changed - still no sound.
> Ah, sad.  Can you run 'git bisect' between 5.9 and 5.10 to determine the
> commit that caused the problem?

The problem is that one driver was replaced with another driver. git 
bisect wont really help to narrow down why the new driver does not work.

Christian can you run the alsa-info.sh[1] script on your system and send 
back the result?

You say sound is not working, can you clarify that a bit? Is no sound 
card registered? Is it registered but output stays silent?

- Lars

[1] https://www.alsa-project.org/wiki/AlsaInfo 
<https://www.alsa-project.org/wiki/AlsaInfo>


