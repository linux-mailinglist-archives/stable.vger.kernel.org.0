Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63039E627
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfH0Kvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 06:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfH0Kvi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 06:51:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBC99205C9;
        Tue, 27 Aug 2019 10:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566903098;
        bh=cL1jaC/scEKLGlyV7cYnIxW16LEp1KywNLdoVlBr2Ac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IN9cl7MLeYf9wYQ+4/PJsOXyd8JbnslcL7S+mBcsMEQTRpX0wCq6l5o6ujlisE0ZF
         eFs7DfpME+vH1GV+TASPOv3lK0BCdO975acKdfAp7W4JIe/uHBAgcTBDV+nGhZfmqB
         C74eHU/pNN8YgRGVirz7UISX6V0NSjsWpscR9wT4=
Date:   Tue, 27 Aug 2019 06:51:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     shuah <shuah@kernel.org>
Cc:     Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
Message-ID: <20190827105136.GQ5281@sasha-vm>
References: <20190822170811.13303-1-sashal@kernel.org>
 <00216731-a088-7d47-eafb-70409f876bda@kernel.org>
 <20190824023829.GE9862@kroah.com>
 <e4d5ba59-8e38-a267-8a14-3c6bc03f77bd@kernel.org>
 <20190824153348.GA27505@kroah.com>
 <93850e40-7df9-b5db-bda4-5b4354d2c3f3@kernel.org>
 <20190824181445.GA10804@kroah.com>
 <bf9b854f-0144-1260-9bab-d9d2ea455864@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bf9b854f-0144-1260-9bab-d9d2ea455864@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 24, 2019 at 03:49:30PM -0600, shuah wrote:
>On 8/24/19 12:14 PM, Greg KH wrote:
>>I have uploaded it to kernel.org now, should show up on the "public
>>side" in 15 minutes or so.
>>
>
>Great. Downloaded successfully.

Shuah, would a link such as:
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.2.y&id2=v5.2.9

Work for you in future -rc mails? It's "wgettable" patch, but I'm not
sure if there's anything else that might interfere with the workflow.

--
Thanks,
Sasha
