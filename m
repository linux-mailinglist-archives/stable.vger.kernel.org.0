Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301A81D4F48
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 15:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgEONcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 09:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgEONcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 09:32:01 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05AAB20758;
        Fri, 15 May 2020 13:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589549521;
        bh=1VGgGpfqqZJljLilwJ7Cn2+NNUu5ld5MfuuGKvLl62U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cmSR2xC22q9HpGs5X9a3xs5CsLMgJnx8txXJriD4VtrHdSCXjvGl+cFYaSVkeiC6m
         Zar4Yqhamkw2yYoA0e5QO4Sv+tok0bZWTY4PqxKfZqoU5VIbf9TjyQhMQllCLoFHNd
         EA4D8J+ZaFoad7dZvW2VnSLzeA2JeSVggV6P03WU=
Date:   Fri, 15 May 2020 09:31:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Henning Schild <henning.schild@siemens.com>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: backport of cifs patch to 4.4.x and 4.9.x
Message-ID: <20200515133159.GE29995@sasha-vm>
References: <20200515134420.50480bb7@md1za8fc.ad001.siemens.net>
 <20200515125748.GA1936050@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200515125748.GA1936050@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 02:57:48PM +0200, Greg KH wrote:
>On Fri, May 15, 2020 at 01:44:20PM +0200, Henning Schild wrote:
>> Hi,
>>
>> please backport the following path to 4.4.x and 4.9.x
>>
>> subject: cifs: Fix a race condition with cifs_echo_request
>> hash: f2caf901c1b7ce65f9e6aef4217e3241039db768
>
>It does not apply cleanly, can you provide a working backport so that we
>can queue it up properly?

I've queued these two for 4.9 and 4.4:

f2caf901c1b7 ("cifs: Fix a race condition with cifs_echo_request")
76e752701a8a ("cifs: Check for timeout on Negotiate stage")

-- 
Thanks,
Sasha
