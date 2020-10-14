Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070B828DF46
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 12:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgJNKol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 06:44:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:55934 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgJNKol (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 06:44:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602672280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hRWygM0WGLuvexCJ8PqSBNUs0ZGb7bWhayFOwOQ+CDM=;
        b=aBPqDNr5nZwphwFLCf7yilItBVMD1R0mpikV7rGQI5UJTHVLnaHu6Dy1dzoeJ/ZFtuQ+T0
        soeaaVRzxlZ2FqdE9f5FXTTIZh579UUUhlw1Xs509YOC1BMeM60wf+2OS4WnqofzYrkFYN
        /OQvxm6XC2jP0va2kCEe6UKIbBUcFSQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0495CACDB;
        Wed, 14 Oct 2020 10:44:40 +0000 (UTC)
Subject: Re: [PATCH] xen/events: don't use chip_data for legacy IRQs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Stefan Bader <stefan.bader@canonical.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20201005061957.13509-1-jgross@suse.com>
 <f0b0b56e-512a-84ed-f03f-86ef54c10e96@suse.com>
 <20201014095108.GB3597464@kroah.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <8c0a8ad7-df8d-47cf-5ad1-43715e903757@suse.com>
Date:   Wed, 14 Oct 2020 12:44:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201014095108.GB3597464@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.10.20 11:51, Greg KH wrote:
> On Wed, Oct 14, 2020 at 11:31:33AM +0200, Jürgen Groß wrote:
>> Any reason this has not made it into 5.4.y and older by now?
>>
>> This patch is fixing a real problem...
> 
> What is the git commit id of this patch in Linus's tree?

0891fb39ba67bd7ae023ea0d367297ffff010781


Juergen
