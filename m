Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355F33E54F9
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 10:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhHJIRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 04:17:46 -0400
Received: from ixit.cz ([94.230.151.217]:46482 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236715AbhHJIRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 04:17:43 -0400
Received: from [192.168.1.138] (ixit.cz [94.230.151.217])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 7BDDB2392F;
        Tue, 10 Aug 2021 10:17:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1628583431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nlvkSBA6n+KQ+818MnZNZMODiTyPKWT0BQmh9dkpmjQ=;
        b=XHHJQ+3QYVKCOcXudHW7FZN2JiW35NZ7LFBwXw1U2DkVFUowz/ZlyrSEpKyzC19ALZTmPh
        nqEzW8SwMQI2pGkl6qbOOiZt+CrirU7HrpgDuQJKPK9GLrFn/2NWKC5FDuB653PHgoZAmX
        gNDOjEiWRb7NgMU9kvuzoJE2660mkEc=
Date:   Tue, 10 Aug 2021 10:16:05 +0200
From:   David Heidelberg <david@ixit.cz>
Subject: Re: ARM: dts: qcom: apq8064: correct clock names
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Message-Id: <TY6MXQ.IJK15FY5IBL83@ixit.cz>
In-Reply-To: <YRIVvdoUizu1h0MY@kroah.com>
References: <LW7LXQ.P4TOHDR1NF9O1@ixit.cz> <YRIVvdoUizu1h0MY@kroah.com>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I haven't realized it's still merged only in linux-next, so I mailed 
person who commited my PATCH to add Cc for stable before it goes to the 
Linus tree, sorry for confusion :)
Best regards
David Heidelberg

On Tue, Aug 10 2021 at 07:59:25 +0200, Greg KH 
<gregkh@linuxfoundation.org> wrote:
> On Mon, Aug 09, 2021 at 09:38:45PM +0200, David Heidelberg wrote:
>>  commit 0dc6c59892ead17a9febd11202c9f6794aac1895
> 
> What commit id is that?  I do not see that in Linus's tree :(
> 
>>  Hello!
>> 
>>  since the commit b0530eb1191307e9038d75e5c83973a396137681 (just 
>> before 5.10
>>  LTS) - this fix is needed for running Linux kernel on the APQ8064 
>> and since
>>  is this fix apq8064 specific, shouldn't in worst case scenario break
>>  anything else and it's tested on the Nexus 7 2013 tablet, I'm 
>> proposing
>>  backporting it to 5.10 kernel.
> 
> What commit exactly?
> 
> confused,
> 
> greg k-h


